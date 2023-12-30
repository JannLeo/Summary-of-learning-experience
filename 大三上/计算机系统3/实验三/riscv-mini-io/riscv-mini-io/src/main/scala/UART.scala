package mini

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.Parameters

//map：
//read valid   0x10000000
//read data    0x10000004
//write valid  0x10000008
//write data   0x1000000C
object Uart{
  val readValid  = "x10000000".U
  val readData   = "x10000004".U
  val writeValid = "x10000008".U
  val writeData  = "x1000000C".U
}

//IO 一个八位的输入,配合valid/ready握手信号
class ChannelIO extends DecoupledIO(UInt(8.W)) {
  override def cloneType: this.type = new ChannelIO().asInstanceOf[this.type]
}

class Tx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = Flipped(new ChannelIO())
  })
  //state
  val s_IDLE :: s_SEND :: Nil = Enum(2)
  val state = RegInit(s_IDLE)

  val baudCnt = (frequency / baudRate) - 1 //分频
  val bitCnt = 11 //每个数据包11位
  val shiftReg = RegInit(0x7ff.U)

  //counter
  val (baud_count, baud_wrap_out) = Counter(state === s_SEND, baudCnt)
  val (bit_count, bit_wrap_out) = Counter(baud_wrap_out, bitCnt)

  //控制&输出信号
  io.channel.ready := state === s_IDLE
  io.txd := shiftReg(0)

  //发送操作
  when(io.channel.fire()) {
    shiftReg := Cat(Cat(3.U, io.channel.bits), 0.U) // two stop bits, data, one start bit
  }
  when(state === s_SEND) {
    when(baud_wrap_out) {
      val shift = shiftReg >> 1
      shiftReg := Cat(1.U, shift(9, 0))
    }
  }

  //FSM
  switch(state) {
    is(s_IDLE) {
      when(io.channel.fire()) {
        state := s_SEND
      }
    }
    is(s_SEND) {
      when(bit_wrap_out) {
        state := s_IDLE
      }
    }
  }
}

class Buffer extends Module {
  val io = IO(new Bundle {
    val in = Flipped(new ChannelIO())
    val out = new ChannelIO()
  })

  val s_EMPTY :: s_FULL :: Nil = Enum(2)
  val state = RegInit(s_EMPTY)
  val data = RegInit(0.U(8.W))

  io.in.ready := state === s_EMPTY
  io.out.valid := state === s_FULL
  io.out.bits := data

  switch(state) {
    is(s_EMPTY) {
      when(io.in.fire()) {
        data := io.in.bits
        state := s_FULL
      }
    }
    is(s_FULL) {
      when(io.out.fire()) {
        state := s_EMPTY
      }
    }
  }
}

class BufferedTx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = Flipped(new ChannelIO())
  })
  val tx = Module(new Tx(frequency, baudRate))
  val buf = Module(new Buffer())

  buf.io.in <> io.channel
  tx.io.channel <> buf.io.out
  io.txd <> tx.io.txd
}

class Rx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(UInt(1.W))
    val channel = new ChannelIO()
  })

  val shiftReg = RegInit(0.U(8.W))
  val s_IDLE :: s_FIRST :: s_RECEIVE :: s_END :: Nil = Enum(4)
  val state = RegInit(s_IDLE)
  val baudCnt = (frequency / baudRate) - 1
  val firstCnt = (3 * frequency / 2) / baudRate - 1
  val bitCnt = 8 //每个数据包包含8位数据

  //counter
  val (first_count, first_wrap_out) = Counter(state === s_FIRST, firstCnt)
  val (baud_count, baud_wrap_out) = Counter(state === s_RECEIVE || state === s_END, baudCnt)
  val (bit_count, bit_wrap_out) = Counter((baud_wrap_out || first_wrap_out) && state =/= s_END, bitCnt)

  //每接收一次数据移位寄存器右移一位
  when(baud_wrap_out || first_wrap_out) {
    shiftReg := Cat(io.rxd, shiftReg >> 1)
  }

  //输出数据&控制信号
  io.channel.bits := shiftReg
  io.channel.valid := RegNext(bit_wrap_out)

  //FSM
  switch(state) {
    is(s_IDLE) {
      when(io.rxd === 0.U) {
        state := s_FIRST
      }
    }
    is(s_FIRST) {
      when(first_wrap_out) {
        state := s_RECEIVE
      }
    }
    is(s_RECEIVE) {
      when(bit_wrap_out) {
        state := s_END
      }
    }
    is(s_END) {
      when(baud_wrap_out) {
        state := s_IDLE
      }
    }
  }
}

class BufferedRx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(UInt(1.W))
    val channel = new ChannelIO()
  })

  val rx = Module(new Rx(frequency, baudRate))
  val buf = Module(new Buffer())

  io.rxd <> rx.io.rxd
  buf.io.in <> rx.io.channel
  buf.io.out <> io.channel

}

class UartController(frequency: Int, baudRate: Int, implicit val p: Parameters) extends Module {
  val io = IO(new Bundle {
    val cpu = new CacheIO
    val rxChannel = Flipped(new ChannelIO())
    val txChannel = new ChannelIO()
  })

  val s_IDLE :: s_READ_READ_STATE :: s_READ_WRITE_STATE :: s_READ_DATA :: s_WRITE_DATA :: Nil = Enum(5)
  val state = RegInit(s_IDLE)

  val is_READ_READ_STATE = state === s_READ_READ_STATE
  val is_READ_WRITE_STATE = state === s_READ_WRITE_STATE
  val is_READ_DATA = state === s_READ_DATA

  val addr = RegInit(0.U(32.W))
  val rdata = RegEnable(io.cpu.resp.bits.data,is_READ_READ_STATE || is_READ_WRITE_STATE || is_READ_DATA )
  val wdata = RegInit(0.U(32.W))

  io.rxChannel.ready := false.B
  io.cpu.resp.valid := false.B
  io.cpu.resp.bits.data := rdata
  io.txChannel.bits := 0.U
  io.txChannel.valid := false.B

  switch(state) {
    is(s_IDLE) {
      io.cpu.resp.valid := true.B
      when(io.cpu.req.fire()) {
        addr := io.cpu.req.bits.addr
        wdata := io.cpu.req.bits.data
        //reg mapping
        state := MuxLookup(io.cpu.req.bits.addr, s_IDLE,
          Array(Uart.readValid  -> s_READ_READ_STATE,
            Uart.readData   -> s_READ_DATA,
            Uart.writeValid -> s_READ_WRITE_STATE,
            Uart.writeData  -> s_WRITE_DATA))
      }
    }
    is(s_READ_READ_STATE) {
      io.cpu.resp.bits.data := Mux(io.rxChannel.valid === true.B, 1.U, 0.U)
      io.cpu.resp.valid := true.B
      state := s_IDLE
    }
    is(s_READ_WRITE_STATE) {
      io.cpu.resp.bits.data := Mux(io.txChannel.ready === true.B, 1.U, 0.U)
      io.cpu.resp.valid := true.B
      state := s_IDLE
    }
    is(s_READ_DATA) {
      io.rxChannel.ready := true.B
      when(io.rxChannel.fire()) {
        io.cpu.resp.bits.data := io.rxChannel.bits
        io.cpu.resp.valid := true.B
        state := s_IDLE
        //打印出读取到的字符以便仿真测试
        printf("core received: %c\n", io.cpu.resp.bits.data(7, 0))
      }
    }
    is(s_WRITE_DATA) {
      io.txChannel.bits := wdata(7, 0)
      io.txChannel.valid := true.B
      when(io.txChannel.fire()) {
        state := s_IDLE
      }
    }
  }
}

class Uart(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(UInt(1.W))
    val txd = Output(UInt(1.W))
    val rxChannel = new ChannelIO()
    val txChannel = Flipped(new ChannelIO())
  })

  val tx = Module(new BufferedTx(frequency, baudRate))
  val rx = Module(new BufferedRx(frequency, baudRate))

  tx.io.channel <> io.txChannel
  rx.io.channel <> io.rxChannel
  tx.io.txd <> io.txd
  rx.io.rxd <> io.rxd
}

//test Module
/**
 * Send a string.
 */
class Sender(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
  })

  val tx = Module(new BufferedTx(frequency, baudRate))

  io.txd := tx.io.txd

  val msg = "1234"
  val text = VecInit(msg.map(_.U))
  val len = msg.length.U

  val cntReg = RegInit(0.U(8.W))

  tx.io.channel.bits := text(cntReg)
  tx.io.channel.valid := cntReg =/= len

  when(tx.io.channel.ready && cntReg =/= len) {
    cntReg := cntReg + 1.U
  }
}
