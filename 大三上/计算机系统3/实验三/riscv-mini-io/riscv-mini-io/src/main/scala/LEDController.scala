package mini

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.Parameters

// 0x10010000
class LEDControllerIO(implicit val p: Parameters) extends Bundle {
  val cpu = new CacheIO
  val leds = Output(UInt(4.W))
}

class LEDController(implicit val p: Parameters) extends Module{
  val io = IO(new LEDControllerIO())

  val ledState = RegInit(0.U(4.W))

  io.cpu.resp.valid := true.B
  io.cpu.resp.bits.data := 0.U

  when(io.cpu.req.valid){
    ledState:= io.cpu.req.bits.data(3,0)
  }

  io.leds := ledState(3,0)
}