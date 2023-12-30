// See LICENSE for license details.

package mini

import chisel3._
import chisel3.util._
import junctions._
import freechips.rocketchip.config.Parameters

class MemArbiterIO(implicit val p: Parameters) extends Bundle {
  val icache = Flipped(new NastiIO)
  val dcache = Flipped(new NastiIO)
  val nasti  = new NastiIO
}

class MemArbiter(implicit p: Parameters) extends Module {
  val io = IO(new MemArbiterIO)

  val s_IDLE :: s_ICACHE_READ :: s_DCACHE_READ :: s_DCACHE_WRITE :: s_DCACHE_ACK :: Nil = Enum(5)
  val state = RegInit(s_IDLE)

  // Write Address
  io.nasti.aw.bits := io.dcache.aw.bits
  io.nasti.aw.valid := io.dcache.aw.valid && state === s_IDLE
  io.dcache.aw.ready := io.nasti.aw.ready && state === s_IDLE
  io.icache.aw := DontCare

  // Write Data 
  io.nasti.w.bits  := io.dcache.w.bits
  io.nasti.w.valid := io.dcache.w.valid && state === s_DCACHE_WRITE
  io.dcache.w.ready := io.nasti.w.ready && state === s_DCACHE_WRITE
  io.icache.w := DontCare

  // Write Ack
  io.dcache.b.bits := io.nasti.b.bits
  io.dcache.b.valid := io.nasti.b.valid && state === s_DCACHE_ACK
  io.nasti.b.ready := io.dcache.b.ready && state === s_DCACHE_ACK
  io.icache.b := DontCare

  // Read Address
  io.nasti.ar.bits := NastiReadAddressChannel(
    Mux(io.dcache.ar.valid, io.dcache.ar.bits.id,   io.icache.ar.bits.id),
    Mux(io.dcache.ar.valid, io.dcache.ar.bits.addr, io.icache.ar.bits.addr),
    Mux(io.dcache.ar.valid, io.dcache.ar.bits.size, io.icache.ar.bits.size),
    Mux(io.dcache.ar.valid, io.dcache.ar.bits.len,  io.icache.ar.bits.len))
  io.nasti.ar.valid := (io.icache.ar.valid || io.dcache.ar.valid) && 
    !io.nasti.aw.valid && state === s_IDLE
  io.dcache.ar.ready := io.nasti.ar.ready && !io.nasti.aw.valid && state === s_IDLE
  io.icache.ar.ready := io.dcache.ar.ready && !io.dcache.ar.valid

  // Read Data
  io.icache.r.bits  := io.nasti.r.bits
  io.dcache.r.bits  := io.nasti.r.bits
  io.icache.r.valid := io.nasti.r.valid && state === s_ICACHE_READ
  io.dcache.r.valid := io.nasti.r.valid && state === s_DCACHE_READ
  io.nasti.r.ready := io.icache.r.ready && state === s_ICACHE_READ || 
                      io.dcache.r.ready && state === s_DCACHE_READ

  switch(state) {
    is(s_IDLE) {
      when(io.dcache.aw.fire()) {
        state := s_DCACHE_WRITE
      }.elsewhen(io.dcache.ar.fire()) {
        state := s_DCACHE_READ
      }.elsewhen(io.icache.ar.fire()) {
        state := s_ICACHE_READ
      }
    }
    is(s_ICACHE_READ) {
      when(io.nasti.r.fire() && io.nasti.r.bits.last) {
        state := s_IDLE
      }
    }
    is(s_DCACHE_READ) {
      when(io.nasti.r.fire() && io.nasti.r.bits.last) {
        state := s_IDLE
      }
    }
    is(s_DCACHE_WRITE) {
      when(io.dcache.w.fire() && io.dcache.w.bits.last) {
        state := s_DCACHE_ACK
      }
    }
    is(s_DCACHE_ACK) {
      when(io.nasti.b.fire()) {
        state := s_IDLE
      }
    }
  }
}

class TileIO(implicit val p: Parameters) extends Bundle {
//  val host  = new HostIO
//  val nasti = new NastiIO

  val txd = Output(UInt(1.W))
  val rxd = Input(UInt(1.W))
  val ledState = Output(UInt(4.W))
}

trait TileBase extends core.BaseModule {
  def io: TileIO
  def clock: Clock
  def reset: core.Reset
}

class Tile(tileParams: Parameters) extends Module with TileBase {
  implicit val p = tileParams
  val io              = IO(new TileIO)
  val core            = Module(new Core)
  val icache          = Module(new Cache)
  val dcache          = Module(new Cache)
  val arb             = Module(new MemArbiter)
  val mmio            = Module(new MMIO)
  val bram            = Module(new BRAM)
//  val sender = Module(new Sender(100000000, 57600))

  val uart            = Module(new Uart(125000000,57600))
  val ledController   = Module(new LEDController)
  val uartController  = Module(new UartController(125000000,57600,p))

  //处理暂未使用的接口，便于烧板
  core.io.host.fromhost.valid := 0.U
  core.io.host.fromhost.bits := 0.U

  core.io.icache <> icache.io.cpu
  core.io.dcache <> mmio.io.cpu
  mmio.io.dcache <> dcache.io.cpu
  mmio.io.ledController <> ledController.io.cpu
  mmio.io.uart <> uartController.io.cpu
  arb.io.icache <> icache.io.nasti
  arb.io.dcache <> dcache.io.nasti
  uartController.io.txChannel <> uart.io.txChannel
  uartController.io.rxChannel <> uart.io.rxChannel
  uart.io.rxd <> io.rxd
//  uart.io.rxd <> sender.io.txd
  uart.io.txd <> io.txd
  io.ledState := ledController.io.leds

////sim
//  io.host <> core.io.host
//  io.nasti <> arb.io.nasti

  //-------------------BRAM CONNECT--------------------------
  bram.io.s_aclk := clock
  bram.io.s_aresetn := !reset.toBool()
  bram.io.s_axi_awid := arb.io.nasti.aw.bits.id
  bram.io.s_axi_awaddr := arb.io.nasti.aw.bits.addr
  bram.io.s_axi_awlen := arb.io.nasti.aw.bits.len
  bram.io.s_axi_awsize := arb.io.nasti.aw.bits.size
  bram.io.s_axi_awburst := arb.io.nasti.aw.bits.burst
  bram.io.s_axi_awvalid := arb.io.nasti.aw.valid
  arb.io.nasti.aw.ready := bram.io.s_axi_awready
  bram.io.s_axi_wdata := arb.io.nasti.w.bits.data
  bram.io.s_axi_wstrb := arb.io.nasti.w.bits.strb
  bram.io.s_axi_wlast := arb.io.nasti.w.bits.last
  bram.io.s_axi_wvalid := arb.io.nasti.w.valid
  arb.io.nasti.w.ready := bram.io.s_axi_wready
  arb.io.nasti.b.bits.id := bram.io.s_axi_bid
  arb.io.nasti.b.bits.resp := bram.io.s_axi_bresp
  arb.io.nasti.b.valid := bram.io.s_axi_bvalid
  bram.io.s_axi_bready := arb.io.nasti.b.ready
  bram.io.s_axi_arid := arb.io.nasti.ar.bits.id
  bram.io.s_axi_araddr := arb.io.nasti.ar.bits.addr
  bram.io.s_axi_arlen := arb.io.nasti.ar.bits.len
  bram.io.s_axi_arsize := arb.io.nasti.ar.bits.size
  bram.io.s_axi_arburst := arb.io.nasti.ar.bits.burst
  bram.io.s_axi_arvalid := arb.io.nasti.ar.valid
  arb.io.nasti.ar.ready := bram.io.s_axi_arready
  arb.io.nasti.r.bits.id := bram.io.s_axi_rid
  arb.io.nasti.r.bits.data := bram.io.s_axi_rdata
  arb.io.nasti.r.bits.resp := bram.io.s_axi_rresp
  arb.io.nasti.r.bits.last := bram.io.s_axi_rlast
  arb.io.nasti.r.valid := bram.io.s_axi_rvalid
  bram.io.s_axi_rready := arb.io.nasti.r.ready
  //unused signal
  arb.io.nasti.b.bits.user := 0.U
  arb.io.nasti.r.bits.user := 0.U
}
