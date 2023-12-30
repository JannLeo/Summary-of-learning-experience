module Multiplier(
  input        clock,
  input        reset,
  input  [3:0] io_multiplier,
  input  [3:0] io_multiplicand,
  output [7:0] io_product,
  input        io_inputValid,
  output       io_outputValid
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] multiplierReg; // @[Multiplier.scala 24:32]
  reg [7:0] multiplicandReg; // @[Multiplier.scala 25:32]
  reg [7:0] productReg; // @[Multiplier.scala 26:32]
  reg [2:0] cntReg; // @[Multiplier.scala 27:32]
  wire [7:0] _productReg_T_1 = productReg + multiplicandReg; // @[Multiplier.scala 31:32]
  wire [3:0] _multiplierReg_T = {{1'd0}, multiplierReg[3:1]}; // @[Multiplier.scala 33:44]
  wire [8:0] _multiplicandReg_T = {multiplicandReg, 1'h0}; // @[Multiplier.scala 34:40]
  wire [2:0] _cntReg_T_1 = cntReg - 3'h1; // @[Multiplier.scala 35:35]
  wire [7:0] _multiplicandReg_T_1 = {4'h0,io_multiplicand}; // @[Cat.scala 30:58]
  wire [7:0] _GEN_1 = io_inputValid ? _multiplicandReg_T_1 : multiplicandReg; // @[Multiplier.scala 37:24 Multiplier.scala 38:23 Multiplier.scala 25:32]
  wire [7:0] _GEN_5 = cntReg == 3'h0 ? _GEN_1 : multiplicandReg; // @[Multiplier.scala 36:29 Multiplier.scala 25:32]
  wire [8:0] _GEN_11 = cntReg != 3'h0 ? _multiplicandReg_T : {{1'd0}, _GEN_5}; // @[Multiplier.scala 29:23 Multiplier.scala 34:21]
  assign io_product = productReg; // @[Multiplier.scala 46:19]
  assign io_outputValid = cntReg == 3'h0; // @[Multiplier.scala 45:30]
  always @(posedge clock) begin
    if (reset) begin // @[Multiplier.scala 24:32]
      multiplierReg <= 4'h0; // @[Multiplier.scala 24:32]
    end else if (cntReg != 3'h0) begin // @[Multiplier.scala 29:23]
      multiplierReg <= _multiplierReg_T; // @[Multiplier.scala 33:25]
    end else if (cntReg == 3'h0) begin // @[Multiplier.scala 36:29]
      if (io_inputValid) begin // @[Multiplier.scala 37:24]
        multiplierReg <= io_multiplier; // @[Multiplier.scala 39:23]
      end
    end
    if (reset) begin // @[Multiplier.scala 25:32]
      multiplicandReg <= 8'h0; // @[Multiplier.scala 25:32]
    end else begin
      multiplicandReg <= _GEN_11[7:0];
    end
    if (reset) begin // @[Multiplier.scala 26:32]
      productReg <= 8'h0; // @[Multiplier.scala 26:32]
    end else if (cntReg != 3'h0) begin // @[Multiplier.scala 29:23]
      if (multiplierReg[0]) begin // @[Multiplier.scala 30:35]
        productReg <= _productReg_T_1; // @[Multiplier.scala 31:18]
      end
    end else if (cntReg == 3'h0) begin // @[Multiplier.scala 36:29]
      if (io_inputValid) begin // @[Multiplier.scala 37:24]
        productReg <= 8'h0; // @[Multiplier.scala 40:23]
      end
    end
    if (reset) begin // @[Multiplier.scala 27:32]
      cntReg <= 3'h0; // @[Multiplier.scala 27:32]
    end else if (cntReg != 3'h0) begin // @[Multiplier.scala 29:23]
      cntReg <= _cntReg_T_1; // @[Multiplier.scala 35:25]
    end else if (cntReg == 3'h0) begin // @[Multiplier.scala 36:29]
      if (io_inputValid) begin // @[Multiplier.scala 37:24]
        cntReg <= 3'h4; // @[Multiplier.scala 41:23]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  multiplierReg = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  multiplicandReg = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  productReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  cntReg = _RAND_3[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
