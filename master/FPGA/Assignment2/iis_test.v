// iis_test.v

/*
 * iis code
 * ---------------------
 * For: University of Leeds
 * Date: 27/04/2024
 * Author: ffxx283
 * Developer: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is written for the IIS code.
 * 
 *
 */
 
module iis_test
(
	//input
	clk_in,			// Input clock 50MHz
	reset,			// Reset signal input
	data,
	
	//output
	AUD_BCLK,		// Bit clock output
	AUD_DACLRCK,	// Output left and right channel clock
	AUD_DACDAT,		// Output data line
	AUD_DACLRCK_reg,
);

//-------------------------------------------------------
//				`define definition
//-------------------------------------------------------

`define MCLK			18432000
`define DATA_WIDTH 		32
`define SAMPLE_RATE		48000
`define CHANNEL_NUM		2

`define BIT_CLK_NUM 	`MCLK/(`SAMPLE_RATE*`DATA_WIDTH*`CHANNEL_NUM*2)-1
`define LRC_CLK_NUM 	`DATA_WIDTH-1

//-------------------------------------------------------
//				reg / wire definition
//-------------------------------------------------------
// Input clock 50MHz
input wire			clk_in;        
// Reset signal input  
input wire			reset;           
input wire	[15:0]	data;
 // Bit clock output
output reg			AUD_BCLK 		= 1'b0;  
// Output left and right channel clock
output reg			AUD_DACLRCK		= 1'b0;   
// Output data line
output wire			AUD_DACDAT;             
output wire 		AUD_DACLRCK_reg;
// Bit clock count
 reg 		[7:0]	BIT_CLK_Count 	= 8'd0;  
 // Left-right channel clock count
 reg 		[7:0]	LRC_CLK_Count 	= 8'd0;  
// Data buffer for sending
reg 		[31:0] 	Send_Data_Buff 	= 32'd0;  
// Buffered data shifted left by 15 bits
wire 		[31:0]  Send_Data_Buff2 = Send_Data_Buff<<15;  
reg					write_en;  // Write enable
reg					read_en;   // Read enable
wire				empty;     // FIFO empty flag
wire				full;      // FIFO full flag
wire		[15:0]	read_data; // Data read from FIFO
reg 		[5:0]	SIN_Cont 		= 6'd0;  // SIN control
assign full = 1'b0;    // Always set full to 0
reg			[4:0]	SEL_Cont;   // Select control

//-------------------------------------------------------
//				Structural coding
//-------------------------------------------------------

/*
	Generate bit clock
*/
always @ ( posedge clk_in or posedge reset ) begin
	if(reset) begin
		BIT_CLK_Count <= 8'd0;    // Reset bit clock count
		AUD_BCLK <= 1'b0;         // Reset bit clock
	end
	else begin
		if( BIT_CLK_Count >= `BIT_CLK_NUM ) begin
			BIT_CLK_Count <= 8'd0;     // Reset bit clock count
			AUD_BCLK <= ~AUD_BCLK;     // Toggle bit clock
		end
		else
			// Increment bit clock count
			BIT_CLK_Count <= BIT_CLK_Count + 8'd1;  
	end
end
initial begin
	
	write_en = 1'b1;   // Initialize write enable
	read_en = 1'b1;    // Initialize read enable
end
/*
	Generate LRCK clock, 32 division of AUD_BCLK
*/
always @ ( posedge AUD_BCLK or posedge reset ) begin
	if(reset) begin
		LRC_CLK_Count <= 8'd0;   // Reset left-right channel clock count
		AUD_DACLRCK <= 1'b0;     // Reset left-right channel clock
	end
	else begin
		if( LRC_CLK_Count >= `LRC_CLK_NUM ) begin
			LRC_CLK_Count <= 8'd0;         // Reset left-right channel clock count
			AUD_DACLRCK <= ~ AUD_DACLRCK;  // Toggle left-right channel clock
		end
		else begin
			// Increment left-right channel clock count
			LRC_CLK_Count <= LRC_CLK_Count + 8'd1;  
		end
	end
end

reg		AUD_DACLRCK_buf;
always @ ( posedge AUD_BCLK or posedge reset ) begin
	if(reset) begin
		AUD_DACLRCK_buf		<= 0;   // Reset left-right channel clock buffer
	end
	else begin
		// Update left-right channel clock buffer
		AUD_DACLRCK_buf		<= AUD_DACLRCK;   
	end
end
// High in the last cycle, low in this one, so it is falling edge
// Generate left-right channel clock register
assign AUD_DACLRCK_reg = (AUD_DACLRCK_buf && !AUD_DACLRCK);  


always@(posedge AUD_BCLK or posedge reset)
begin
	if(reset)
		Send_Data_Buff       <= 0;   // Reset data buffer
	else if(AUD_DACLRCK_reg)begin
		// Load data into buffer on LRCK rising edge
		Send_Data_Buff       <= data[15:0];  
	end	else begin
		// Keep data buffer unchanged
		Send_Data_Buff			<= Send_Data_Buff;  
	end
end

/*
	Output data
*/
always@(posedge AUD_BCLK or posedge reset)
begin
	if(reset)
	SEL_Cont	<=	0;   // Reset select control
	else begin
		if(SEL_Cont >= `DATA_WIDTH)
			SEL_Cont <= 0;   // Reset select control if exceeds data width
		else
			SEL_Cont	<=	SEL_Cont+1;  // Increment select control
	end
end
// Output data based on select control
assign AUD_DACDAT = Send_Data_Buff2[ ~ SEL_Cont ];  


endmodule
