module iis_test
(
	//input
	clk_in,			//输入时钟50MHz
	rst_n,			//复位信号输入
	data,
	
	//output
	AUD_BCLK,		//位同步时钟
	AUD_DACLRCK,	//输出左右声道时钟
	AUD_DACDAT,		//输出数据线
	AUD_DACLRCK_reg,
	// test
	// LRC_CLK_Count,
	// write_en,
	// read_en,
	// read_data,
	// SEL_Cont
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

input wire			clk_in;
input wire			rst_n;
input wire	[15:0]	data;

output reg			AUD_BCLK 		= 1'b0;

output reg			AUD_DACLRCK		= 1'b0;
output wire			AUD_DACDAT;
output wire 		AUD_DACLRCK_reg;

 reg 		[7:0]	BIT_CLK_Count 	= 8'd0;
// output reg 		[7:0]	LRC_CLK_Count 	= 8'd0;
 reg 		[7:0]	LRC_CLK_Count 	= 8'd0;

reg 		[31:0] 	Send_Data_Buff 	= 32'd0;
wire 		[31:0]  Send_Data_Buff2 = Send_Data_Buff<<15;
// output reg					write_en;
reg					write_en;
// output reg					read_en;
reg					read_en;
wire				empty;
wire				full;
// output wire		[15:0]	read_data;
wire		[15:0]	read_data;
reg 		[5:0]	SIN_Cont 		= 6'd0;
assign full = 1'b0;
// output reg			[4:0]	SEL_Cont;
reg			[4:0]	SEL_Cont;

//-------------------------------------------------------
//				Structural coding
//-------------------------------------------------------

/*
	产生位时钟
*/
always @ ( posedge clk_in or posedge rst_n ) begin
	if(rst_n) begin
		BIT_CLK_Count <= 8'd0;
		AUD_BCLK <= 1'b0;
	end
	else begin
		if( BIT_CLK_Count >= `BIT_CLK_NUM ) begin
			BIT_CLK_Count <= 8'd0;
			AUD_BCLK <= ~AUD_BCLK;
		end
		else
			BIT_CLK_Count <= BIT_CLK_Count + 8'd1;
	end
end
initial begin
	
	write_en = 1'b1;
	read_en = 1'b1;
end
/*
	产生LRCK的时钟,AUD_BCLK的32分频
*/
always @ ( posedge AUD_BCLK or posedge rst_n ) begin
	if(rst_n) begin
		LRC_CLK_Count <= 8'd0;
		AUD_DACLRCK <= 1'b0;
	end
	else begin
		if( LRC_CLK_Count >= `LRC_CLK_NUM ) begin
			LRC_CLK_Count <= 8'd0;
			AUD_DACLRCK <= ~ AUD_DACLRCK;
		end
		else
			LRC_CLK_Count <= LRC_CLK_Count + 8'd1;
	end
end

reg		AUD_DACLRCK_buf;
always @ ( posedge AUD_BCLK or posedge rst_n ) begin
	if(rst_n) begin
		AUD_DACLRCK_buf		<= 0;
	end
	else begin
		AUD_DACLRCK_buf		<= AUD_DACLRCK;
	end
end

assign AUD_DACLRCK_reg = (AUD_DACLRCK_buf && !AUD_DACLRCK);			//上一个是高，这一个是低，所以判断是下降沿
/*
	缓存数据的buff
*/
// fifo #(
	// .DATA_WIDTH(16), 
	// .ADDR_WIDTH(32)) f_unit1
	// (
	// // input
	// .clk		(clk_in), 
	// .reset		(rst_n), 
	// .read		(read_en), 
	// .write		(write_en), 
	// .write_data	(data), 
	// .empty		(empty),
	// // output
	// .full		(full), 
	// .read_data	(read_data));
// always@(posedge AUD_DACLRCK or posedge rst_n)
// begin
	// if(rst_n)begin
		// write_en = 1'b1;
		// read_en = 1'b0;
	// end else	if(empty) begin
		// write_en = 1'b1;
		// read_en = 1'b0;
	// end else if (!empty) begin
		// write_en = 1'b1;
		// read_en = 1'b1;
		// Send_Data_Buff       <= read_data[15:0];
	// end else if (full) begin
		// read_en = 1'b1;
		// write_en = 1'b0;
		// Send_Data_Buff       <= read_data[15:0];
	// end
	
// end
always@(posedge AUD_BCLK or posedge rst_n)
begin
	if(rst_n)
		Send_Data_Buff       <= 0;
	else if(AUD_DACLRCK_reg)
		Send_Data_Buff       <= data[15:0];
	else
		Send_Data_Buff			<= Send_Data_Buff;
end

/*
	数据位输出
*/
always@(posedge AUD_BCLK or posedge rst_n)
begin
	if(rst_n)
	SEL_Cont	<=	0;
	else begin
		if(SEL_Cont >= `DATA_WIDTH)
			SEL_Cont <= 0;
		else
			SEL_Cont	<=	SEL_Cont+1;
	end
end

assign AUD_DACDAT = Send_Data_Buff2[ ~ SEL_Cont ];



endmodule