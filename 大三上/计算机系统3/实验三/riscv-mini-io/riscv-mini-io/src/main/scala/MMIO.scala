package mini

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.Parameters

class SelectorIO(implicit val p: Parameters) extends Bundle {
  val cpu = new CacheIO
  val dcache = Flipped(new CacheIO)
  val devices = Flipped(new CacheIO)
}

object Selector{
  def devices = BitPat("b0001????????????????????????????")
}

class Selector(implicit p: Parameters) extends Module {
  val io = IO(new SelectorIO())
  val addr = RegInit(0.U(32.W))

  when(io.cpu.req.fire()) {
    addr := io.cpu.req.bits.addr
  }

  //req(master to slave)
  io.dcache.req.bits.addr := io.cpu.req.bits.addr
  io.dcache.req.bits.data := io.cpu.req.bits.data
  io.dcache.req.bits.mask := io.cpu.req.bits.mask
  io.dcache.req.valid := (io.cpu.req.bits.addr =/= Selector.devices) && io.cpu.req.fire()

  io.devices.req.bits.addr := io.cpu.req.bits.addr
  io.devices.req.bits.data := io.cpu.req.bits.data
  io.devices.req.bits.mask := io.cpu.req.bits.mask
  io.devices.req.valid := (io.cpu.req.bits.addr === Selector.devices) && io.cpu.req.fire()

  io.cpu.resp.bits.data := MuxCase(io.dcache.resp.bits.data,Seq(
    (addr === Selector.devices) -> io.devices.resp.bits.data,
  ))
  io.cpu.resp.valid := MuxCase(io.dcache.resp.valid,Seq(
    (addr === Selector.devices) -> io.devices.resp.valid,
  ))
  //abort
  io.dcache.abort := io.cpu.abort
  io.devices.abort := io.cpu.abort
}

class RegMapperIO(implicit val p: Parameters) extends Bundle {
  val selector = new CacheIO
  val uart = Flipped(new CacheIO)
  val ledController = Flipped(new CacheIO)
}

object RegMapper{
  def UART = BitPat("b0001000000000000000000000000????")
  def LED  = BitPat("b00010000000000010000000000000000")
}

class RegMapper(implicit p: Parameters) extends Module {
  val io = IO(new RegMapperIO)
  val addr = RegEnable(io.selector.req.bits.addr,io.selector.req.fire())

  //req(master to slave)
  io.uart.req.bits := io.selector.req.bits
  io.uart.req.valid := (io.selector.req.bits.addr === RegMapper.UART) && io.selector.req.fire()
  io.ledController.req.bits := io.selector.req.bits
  io.ledController.req.valid := (io.selector.req.bits.addr === RegMapper.LED) && io.selector.req.fire()

  //resp(slave to master)
  val respData = MuxCase(0.U,Seq(
    (addr === RegMapper.UART) -> io.uart.resp.bits.data,
    (addr === RegMapper.LED) -> io.ledController.resp.bits.data,
  ))
  val respValid = MuxCase(false.B,Seq(
    (addr === RegMapper.UART) -> io.uart.resp.valid,
    (addr === RegMapper.LED) -> io.ledController.resp.valid,
  ))

  io.selector.resp.bits.data := respData
  io.selector.resp.valid := respValid

  //abort
  io.uart.abort := io.selector.abort
  io.ledController.abort := io.selector.abort
}

class MMIO(implicit p: Parameters) extends Module {
  val io = IO(new Bundle{
    val cpu = new CacheIO
    val dcache = Flipped(new CacheIO)
    val uart = Flipped(new CacheIO)
    val ledController = Flipped(new CacheIO)
  })

  val selector = Module(new Selector())
  val regMapper = Module(new RegMapper())

  selector.io.cpu <> io.cpu
  selector.io.dcache <> io.dcache
  selector.io.devices <> regMapper.io.selector
  regMapper.io.uart <> io.uart
  regMapper.io.ledController <> io.ledController

}