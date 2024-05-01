 // fifo_ctrl_tb.v

/*
 * fifo_ctrl test bench
 * ---------------------
 * For: University of Leeds
 * Date: 27/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for test the fifo_ctrl code.
 * 
 *
 */
 
`timescale 1 ns/100 ps
 
module fifo_ctrl_tb;
//
// Parameter Declarations
//
localparam NUM_CYCLES = 50;       //Simulate this many clock cycles. Max. 1 billion
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
parameter WIDTH = 16;
wire [(WIDTH-1):0]countValue;
// Avalon MM interface
wire [1:0] 	audio_address;
wire audio_chipselect,audio_write, audio_read;
wire [31:0] audio_writedata;
wire [31:0] audio_readdata;
// conduit interface to codec chip
wire m_clk, b_clk, dac_lr_clk;
wire dacdat;
wire i2c_sclk;
wire i2c_sdat;
// conduit interface to other systems in FPGA
wire codec_adc_rd, codec_dac_wr;
wire codec_sample_tick;
wire [31:0] codec_dac_data_in;

avalon_audio #( .FIFO_SIZE(3)) test (
	.clk  ( clock  ),
	.reset  (reset),
	.audio_address      ( audio_address     ),
	.audio_chipselect      ( audio_chipselect     ),
	.audio_write      ( audio_write     ),
	.audio_read      ( audio_read     ),
	.audio_writedata      ( audio_writedata     ),
	.audio_readdata      ( audio_readdata     ),
	.m_clk      ( m_clk     ),
	.b_clk      ( b_clk     ),
	.dac_lr_clk      ( dac_lr_clk     ),
	.dacdat      ( dacdat     ),
	.i2c_sclk      ( i2c_sclk     ),
	.i2c_sdat      ( i2c_sdat     ),
	.codec_dac_wr      ( codec_dac_wr     ),
	.codec_sample_tick      ( codec_sample_tick     ),
	.codec_dac_data_in      ( codec_dac_data_in     ),
	.count						(countValue)
	
);


//
// Test Bench Logic

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