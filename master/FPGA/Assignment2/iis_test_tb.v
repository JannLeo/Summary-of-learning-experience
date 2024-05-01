// iis_test_tb.v

/*
 * iis test bench
 * ---------------------
 * For: University of Leeds
 * Date: 27/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for test the iis code.
 * 
 *
 */
 
`timescale 1 ns/100 ps
 
module iis_test_tb;
//
// Parameter Declarations
//
localparam NUM_CYCLES = 100000;       //Simulate this many clock cycles. Max. 1 billion
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.
//
// Test Bench Generated Signals
//
reg  clock;
reg  reset;
//
// Device Under Test
//
wire aud_bclk;
wire aud_daclrck;
wire aud_dacdat;
wire [15:0] data;
wire [7:0] LRC_CLK_Count;
wire			[4:0]	SEL_Cont;
wire					write_en;
wire					read_en;
wire		[15:0]	read_data;
wire AUD_DACLRCK_reg;
iis_test iis_dut (
	.clk_in (clock),
	.rst_n (reset),
	.data	 (data),
	.AUD_BCLK (aud_bclk),
	.AUD_DACLRCK (aud_daclrck),
	.AUD_DACDAT (aud_dacdat),
	//.LRC_CLK_Count	(LRC_CLK_Count),
	//.write_en(write_en),
	//.read_en(read_en),
	//.read_data(read_data),
	//.SEL_Cont(SEL_Cont),
	.AUD_DACLRCK_reg(AUD_DACLRCK_reg)
);

wire [17:0] Count;
//
// Test Bench Logic
CounterNBit#(
	.WIDTH(18),
	.INCREMENT(1)
) dut_counter
(
	.clock		(clock),
	.reset 		(reset),
	.enable 	(AUD_DACLRCK_reg),
	.countValue	(Count)
);

gameover_rom audio1_test1(
	.address (Count),
	.clock (clock),
	.q ( data )
);
// initial begin
   // //print to console that the simulation has started. $time is the current sim time.
   // $display("%d ns\tsimulation started",$time);  
   // //monitor changes to any values listed, and automatically print to the console 
   // //when they change. there can only be one $monitor per simulation.
   // $monitor("%b ns\tclock=%b\t",$time,clock);
   
   // $display("%d ns\tsimulation finished",$time); //finished
   // //there are no other processes running in this testbench, so "run -all" in 
   // //modelsim will finish the simulation automatically now.
   // //we can also use $stop(); to finish the simulation whenever we want.
// end

//
// Reset Logic
//
initial begin
    reset = 1'b1;                        //Start in reset.
    repeat(RST_CYCLES) @(posedge clock); //Wait for a couple of clocks
    reset = 1'b0;                        //Then clear the reset signal.
end
//
//Clock generator + simulation time limit.
//
initial begin
    clock = 1'b0; //Initialise the clock to zero.
end
//Next we convert our clock period to nanoseconds and half it
//to work out how long we must delay for each half clock cycle
//Note how we convert the integer CLOCK_FREQ parameter it a real
real HALF_CLOCK_PERIOD = (1e9 / $itor(CLOCK_FREQ)) / 2.0;

//Now generate the clock
integer half_cycles = 0;
always begin
    //Generate the next half cycle of clock
    #(HALF_CLOCK_PERIOD);          //Delay for half a clock period.
    clock = ~clock;                //Toggle the clock
    half_cycles = half_cycles + 1; //Increment the counter
    //Check if we have simulated enough half clock cycles
    if (half_cycles == (2*NUM_CYCLES)) begin 
        //Once the number of cycles has been reached
		half_cycles = 0; 		   //Reset half cycles
        $stop;                     //Break the simulation
        //Note: We can continue the simualation after this breakpoint using 
        //"run -all", "run -continue" or "run ### ns" in modelsim.
    end
end

endmodule