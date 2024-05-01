 // fifo.v

/*
 * fifo file
 * ---------------------
 * For: University of Leeds
 * Date: 24/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for the FIFO.
 * 
 *
 */
 
//============================================================================
//                              Module definition
//============================================================================
module fifo
	#(parameter 	DATA_WIDTH = 8, 	ADDR_WIDTH = 4)
(
	// clock and reset signal
	input 	wire 	clk, 				reset,
	// read and write signal
	input 	wire 	read,write,
	// write DATA
	input 	wire 	[DATA_WIDTH-1:0] 	write_data,
	// Indicate whether empty or full
	output 	wire 	empty, 				full,
	// read DATA
	output 	wire 	[DATA_WIDTH-1:0] 	read_data
);

//============================================================================
//                              Variable Definition
//============================================================================

// the addresses of the write and read
wire [ADDR_WIDTH-1:0] write_addr, read_addr;
// Write empty signal and full buffer signal.
wire write_enable, full_temp;

// body
// write enable only when FIFO is not full
assign write_enable = write & !full_temp;
assign full = full_temp;


//============================================================================
//                              Module Instantiation
//============================================================================

// instantiate fifo control unit
// 控制FIFO的写入和读取功能， 管理FIFO的状态
fifo_ctrl 
#(	.ADDR_WIDTH	(ADDR_WIDTH)) c_unit
(	
	// input
	.clk			(clk), 
	.reset			(reset), 
	.read			(read),
	.write			(write),
	
	// output
	.empty			(empty), 
	.full			(full_temp),
	.write_add		(write_addr), 
	.read_add		(read_addr),
	.read_add_next	()
);
	
// instantiate register file
// 管理FIFO中的数据的存取
reg_file 
#(	.DATA_WIDTH	(DATA_WIDTH), 
	.ADDR_WIDTH	(ADDR_WIDTH)) r_unit
(
	// input
	.clk			(clk), 
	.write_enable	(write_enable),
	.write_addr		(write_addr), 
	.read_addr		(read_addr),
	.write_data		(write_data), 
	
	// output
	.read_data		(read_data)
);
endmodule