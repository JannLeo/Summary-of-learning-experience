 // fifo_ctrl.v

/*
 * fifo ctrl file
 * ---------------------
 * For: University of Leeds
 * Date: 24/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is witten for the FIFO control.
 * 122
 *
 */
 
//============================================================================
//                              Module definition
//============================================================================

module fifo_ctrl
	#(parameter ADDR_WIDTH = 4) // address width
(
	// clock and reset
	input 	wire clk, 	reset,
	// read or write
	input 	wire read, 	write,
	// empty or full
	output 	wire empty, full,
	// writeite address
	output 	wire [ADDR_WIDTH-1:0] write_add,
	// read address and read next address
	output 	wire [ADDR_WIDTH-1:0] read_add, read_add_next
);

//============================================================================
//                              Variable Definition
//============================================================================
	// signal declaration
	// 保存当前写/读指针，下一写/读指针，以及下一个写/读指针的后继指针
	reg [ADDR_WIDTH-1:0] write_ptr_reg , write_ptr_next, write_ptr_succ;
	reg [ADDR_WIDTH-1:0] read_ptr_reg, read_ptr_next, read_ptr_succ;
	// 当前的满标志和空标志以及对应的下一个值
	reg full_reg, empty_reg, full_next, empty_next;
	
	
//============================================================================
//                              State Machine
//============================================================================

	// body
	// fifo control logic
	// registers for status and read and write pointers
	// 状态转移块
	always @(posedge clk, posedge reset) begin
		if(reset) begin
			write_ptr_reg 	<= 0;
			read_ptr_reg 	<= 0;
			full_reg 		<= 1'b0;
			empty_reg 		<= 1'b1;
		end else begin
			write_ptr_reg 	<= write_ptr_next;
			read_ptr_reg 	<= read_ptr_next;
			full_reg 		<= full_next;
			empty_reg 		<= empty_next;
		end
	end
	
	// next_state logic for read and write pointers
	// 状态对应逻辑块
	always  @* begin
		// successive pointer values
		// 成功的话就是对应寄存器值加1
		write_ptr_succ 	= write_ptr_reg + 1;
		read_ptr_succ 	= read_ptr_reg + 1;
		// default: keep old values
		write_ptr_next 	= write_ptr_reg;
		read_ptr_next 	= read_ptr_reg;
		full_next 		= full_reg;
		empty_next 		= empty_reg;
		case ({write,read}) 
			//只读不写
			2'b01: begin
				// 如果FIFO不空，就开始读
				if(!empty_reg) begin
					// 读指针下一位=已成功数，并且不为满
					read_ptr_next 		= read_ptr_succ;
					full_next 			= 1'b0;
					// 如果已读值与已写值相等，则说明下一个可读值为空
					if(read_ptr_succ   == write_ptr_reg) begin
						empty_next 		= 1'b1;
					end
				end
			end
			// 只写不读
			2'b10: begin
				// 如果寄存器没有满则可以写
				if(!full_reg) begin
					// 下一个可写寄存器为成功写入寄存器+1
					write_ptr_next 		= write_ptr_succ;
					// 不为空
					empty_next 			= 1'b0;
					// 如果下一个位置与读指针当前位置相同，说明满了
					if(write_ptr_succ  == read_ptr_reg) begin
						full_next 		= 1'b1;
					end
				end
			end
			// 又读又写
			2'b11: begin
				// 写指针下一个位置就是当前成功写入的位置
				write_ptr_next 	= write_ptr_succ;
				// 空状态被设置为读指针的成功位置
				empty_next 		= read_ptr_succ;
			end
		endcase
	end

//============================================================================
//                              Output Definition
//============================================================================

	
	// output
	// 输出下一位的写入位置
	assign write_add 		= write_ptr_reg;
	// 输出下一位的读取位置
	assign read_add 		= read_ptr_reg;
	// 将下一个要读取的位置赋给模块的读下一个地址输出端口
	assign read_add_next 	= read_ptr_next;
	// 当前满状态暴露给外部
	assign full 			= full_reg;
	// 当前空状态暴露给外部
	assign empty 			= empty_reg;
endmodule