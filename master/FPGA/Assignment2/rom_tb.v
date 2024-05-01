  // rom_tb.v

/*
 * rom test bench
 * ---------------------
 * For: University of Leeds
 * Date: 27/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for test the rom code.
 * 
 *
 */
 
`timescale 1 ns/100 ps
 
module rom_tb;
//
// Parameter Declarations
//
localparam NUM_CYCLES = 100;       //Simulate this many clock cycles. Max. 1 billion
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.
//
// Test Bench Generated Signals
//
reg  clock;
reg  reset;
reg  enable;
parameter WIDTH = 17;
wire [(WIDTH-1):0]countValue;
wire	[15:0]  q;
//
// Device Under Test
//
gameover_rom ROM_test11(
	.address(countValue),
	.clock(clock),
	.q(q)
);
CounterNBit#(
	.WIDTH(WIDTH),
	.INCREMENT(1)
) dut11
(
	.clock		(clock),
	.reset 		(reset),
	.enable 		(enable),
	.countValue	(countValue)
);


//
// Test Bench Logic

//
// Reset Logic
//
initial begin
    reset = 1'b1;                        //Start in reset.
	 #100 reset = 1;
    repeat(RST_CYCLES) @(posedge clock); //Wait for a couple of clocks
    reset = 1'b0;                        //Then clear the reset signal.
end
//
//Clock generator + simulation time limit.
//
initial begin
   clock = 1'b0; //Initialise the clock to zero.
	enable = 1'b1;
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