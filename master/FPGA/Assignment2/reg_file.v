 // reg_file.v

/*
 * reg file
 * ---------------------
 * For: University of Leeds
 * Date: 24/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for the regfile.
 * 
 *
 */
 
//============================================================================
//                              Module definition
//============================================================================

// 管理FIFO中的数据的存取
module reg_file
	#( parameter 	DATA_WIDTH = 8, // 数据的宽度
					ADDR_WIDTH = 2) // 地址的宽度
(
	// 时钟
	input 	wire 	clk, 
	// 写使能位
	input 	wire 	write_enable,
	// 写地址和读地址
	input 	wire 	[ADDR_WIDTH-1:0] write_addr, read_addr,
	// 写数据
	input 	wire 	[DATA_WIDTH-1:0] write_data,
	// 读数据
	output 	wire 	[DATA_WIDTH-1:0] read_data
);
	// 地址寄存器
	reg 	[DATA_WIDTH-1:0] array_reg [2**ADDR_WIDTH-1 : 0];
	
	// body
	// write operation
	always @(posedge clk) begin
		// 如果写使能的话
		if(write_enable) 	begin
			// 对应寄存器写上对应值
			array_reg[write_addr] <= write_data;
		end
	end
	// read operation
	// 读取寄存器的值
	assign 	read_data 			   = array_reg[read_addr];
endmodule