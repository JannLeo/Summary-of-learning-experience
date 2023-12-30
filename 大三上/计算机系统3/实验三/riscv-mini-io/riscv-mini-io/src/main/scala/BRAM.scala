package mini

import chisel3._

class BRAM extends BlackBox {
  val io = IO(new Bundle {
    val s_aclk = Input(Clock())               // input wire s_aclk
    val s_aresetn = Input(Bool())             // input wire s_aresetn
    val s_axi_awid = Input(UInt(4.W))         // input wire [3 : 0] s_axi_awid
    val s_axi_awaddr = Input(UInt(32.W))      // input wire [31 : 0] s_axi_awaddr
    val s_axi_awlen = Input(UInt(8.W))        // input wire [7 : 0] s_axi_awlen
    val s_axi_awsize = Input(UInt(3.W))       // input wire [2 : 0] s_axi_awsize
    val s_axi_awburst = Input(UInt(2.W))      // input wire [1 : 0] s_axi_awburs
    val s_axi_awvalid = Input(Bool())         // input wire s_axi_awvalid
    val s_axi_awready = Output(Bool())        // output wire s_axi_awready
    val s_axi_wdata = Input(UInt(64.W))       // input wire [63 : 0] s_axi_wdata
    val s_axi_wstrb = Input(UInt(8.W))        // input wire [7 : 0] s_axi_wstrb
    val s_axi_wlast = Input(Bool())           // input wire s_axi_wlast
    val s_axi_wvalid = Input(Bool())          // input wire s_axi_wvalid
    val s_axi_wready = Output(Bool())         // output wire s_axi_wready
    val s_axi_bid = Output(UInt(4.W))         // output wire [3 : 0] s_axi_bid
    val s_axi_bresp = Output(UInt(2.W))       // output wire [1 : 0] s_axi_bresp
    val s_axi_bvalid = Output(Bool())         // output wire s_axi_bvalid
    val s_axi_bready = Input(Bool())          // input wire s_axi_bready
    val s_axi_arid = Input(UInt(4.W))         // input wire [3 : 0] s_axi_arid
    val s_axi_araddr = Input(UInt(32.W))      // input wire [31 : 0] s_axi_araddr
    val s_axi_arlen = Input(UInt(8.W))        // input wire [7 : 0] s_axi_arlen
    val s_axi_arsize = Input(UInt(3.W))       // input wire [2 : 0] s_axi_arsize
    val s_axi_arburst = Input(UInt(2.W))       // input wire [1 : 0] s_axi_arburs
    val s_axi_arvalid = Input(Bool())         // input wire s_axi_arvalid
    val s_axi_arready = Output(Bool())        // output wire s_axi_arready
    val s_axi_rid = Output(UInt(4.W))         // output wire [3 : 0] s_axi_rid
    val s_axi_rdata = Output(UInt(64.W))       // output wire [63 : 0] s_axi_rdata
    val s_axi_rresp = Output(UInt(2.W))       // output wire [1 : 0] s_axi_rresp
    val s_axi_rlast = Output(Bool())          // output wire s_axi_rlast
    val s_axi_rvalid = Output(Bool())         // output wire s_axi_rvalid
    val s_axi_rready = Input(Bool())          // input wire s_axi_rready
  })
}