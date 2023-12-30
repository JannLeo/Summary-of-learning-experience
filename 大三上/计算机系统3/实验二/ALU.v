module ALU(
  input         clock,
  input         reset,
  input  [31:0] io_A,
  input  [31:0] io_B,
  input  [1:0]  io_alu_op,
  output [31:0] io_out
);
  wire [31:0] _io_out_T_1 = io_A + io_B; // @[ALU.scala 26:24]
  wire [31:0] _io_out_T_3 = io_A - io_B; // @[ALU.scala 27:24]
  wire [63:0] _io_out_T_4 = io_A * io_B; // @[ALU.scala 28:24]
  wire [31:0] _io_out_T_6 = 2'h0 == io_alu_op ? _io_out_T_1 : 32'h0; // @[Mux.scala 80:57]
  wire [31:0] _io_out_T_8 = 2'h1 == io_alu_op ? _io_out_T_3 : _io_out_T_6; // @[Mux.scala 80:57]
  wire [63:0] _io_out_T_10 = 2'h2 == io_alu_op ? _io_out_T_4 : {{32'd0}, _io_out_T_8}; // @[Mux.scala 80:57]
  assign io_out = _io_out_T_10[31:0]; // @[ALU.scala 25:12]
endmodule
