//
//------------------------------------------------------------------------------
//  公司    ：航天新源
//  模块名称: I2C_DRI;
//  描述    ：
//------------------------------------------------------------------------------
//
module i2c_dri(
    input              clk         ,
    input              rst_n       ,
    input              i2c_exec    ,		//1
    input              i2c_rh_wl   ,   		//0	0写1读
    //input              bit_ctrl    ,		//0	地址字节控制
	input  [6 :0]      SLAVE_ADDR  ,		//芯片地址
    input  [15:0]      i2c_addr    ,		//写入地址 
    input  [7 :0]      i2c_data_w  ,		//写入数据
    output reg [7:0]   i2c_data_r  ,		//读取数据
    output reg         i2c_done    ,
    output reg         i2c_ack     ,
    output reg         scl         ,
    inout              sda         ,
    output reg         dri_clk     
	);
   
    //localparam [6 :0]	SLAVE_ADDR 	= 7'b0100_000;		//芯片地址
    localparam [25:0]	CLK_FREQ   	= 26'd40_000_000;	//输入时钟
    localparam [25:0]	I2C_FREQ   	= 26'd400_000;		//输出时钟
	//这里定义状态机
	localparam [8 :0] 	st_idle     = 8'b0000_0001, //空闲状态
						st_sladdr   = 8'b0000_0010, //发送器件地址
						st_addr16   = 8'b0000_0100, //发送16位地址
						st_addr8    = 8'b0000_1000, //发送8位地址
						st_data_wr  = 8'b0001_0000, //写数据
						st_addr_rd  = 8'b0010_0000, //读地址
						st_data_rd  = 8'b0100_0000, //读数据
						st_stop     = 8'b1000_0000; //结束i2c操作
 
	reg             sda_dir     ;
	reg             sda_out     ;
	reg             st_done     ;//状态结束
	reg             wr_flag     ;//写标志
	reg   [6:0]     cnt         ;
	reg   [7:0]     cur_state   ;
	reg   [7:0]     next_state  ;
	reg   [15:0]    addr_t      ;
	reg   [7:0]     data_r      ;
	reg   [7:0]     data_wr_t   ;
	reg   [9:0]     clk_cnt     ;
	
	wire        sda_in          ;
	wire  [8:0] clk_divide      ;
	reg				i2c_exec1	;
	reg				i2c_exec2	;
 
	//test 	
	wire bit_ctrl	= 1'b0;
 
	assign  sda        = sda_dir ? sda_out : 1'bz;
	assign  sda_in     = sda;
	assign  clk_divide = (CLK_FREQ/I2C_FREQ) >> 2'd2;
	//I2C的SCL四倍频
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			dri_clk <=  1'b0;
			clk_cnt <= 10'd0;  
		end
		else if(clk_cnt == clk_divide[8:1] - 1'd1)begin
			clk_cnt <= 10'd0;
			dri_clk <= ~dri_clk;
		end
	else
			clk_cnt <= clk_cnt + 1'd1;
	end
	
	//异步数据同步化
	
	always@(posedge dri_clk or negedge rst_n)
		if(!rst_n)begin
			i2c_exec1 	<= 1'b0;
			i2c_exec2 	<= 1'b0;
			//SLAVE_ADDR	<= 7'd0;
			//SLAVE_ADDR	<= 7'd0;
			//i2c_addr1	<= 16'd0;
			//i2c_addr2	<= 16'd0;
			//i2c_data_w1	<= 8'd0;
			//i2c_data_w2	<= 8'd0;
			end
		else begin
			i2c_exec1 	<= i2c_exec;
			i2c_exec2 	<= i2c_exec1;
			//SLAVE_ADDR1	<= SLAVE_ADDR;
			//SLAVE_ADDR2	<= SLAVE_ADDR1;
			//i2c_addr1	<= i2c_addr;
			//i2c_addr2	<= i2c_addr1;
			//i2c_data_w1	<= i2c_data_w;
			//i2c_data_w2	<= i2c_data_w1;
			end
	
	
	
	
	
	//状态机状态转移
	always@(posedge dri_clk or negedge rst_n)begin
		if(!rst_n)
			cur_state <= st_idle;
		else
			cur_state <= next_state;
	end
 
	//状态机状态转移条件
	always@(*)begin
		next_state = st_idle;
		case(cur_state)
			st_idle: begin
				if(i2c_exec1 == 1'b1 & i2c_exec2 == 1'b0)		
					next_state = st_sladdr;
				else
					next_state = st_idle;
			end  
			st_sladdr:begin
				if(st_done)begin
					if(bit_ctrl)
						next_state = st_addr16;
					else
						next_state = st_addr8;
				end
				else
				next_state = st_sladdr;
			end    
			st_addr16:begin
				if(st_done)begin
					next_state = st_addr8;
				end
				else begin
					next_state = st_addr16;
				end    
			end
			st_addr8:begin 
				if(st_done)begin
					if(wr_flag == 1'b0)
						next_state = st_data_wr;
					else
						next_state = st_addr_rd;
				end
				else begin
					next_state = st_addr8;
				end
			end    
			st_data_wr:begin
				if(st_done)
					next_state = st_stop;
				else
					next_state = st_data_wr;    
			end
			st_addr_rd:begin
				if(st_done)begin
					next_state = st_data_rd;
				end
				else begin
					next_state = st_addr_rd;
				end
			end
			st_data_rd:begin
				if(st_done)
					next_state = st_stop;
				else
					next_state = st_data_rd;
			end
			st_stop:begin
				if(st_done)
					next_state = st_idle;
				else
					next_state = st_stop;
			end
			default:next_state = st_idle;        
		endcase
	end              
	
	//时序电路描述状态输出
	always@(posedge dri_clk or negedge rst_n)begin
		if(!rst_n)begin
			scl         <= 1'b1;
			sda_out     <= 1'b1;
			sda_dir     <= 1'b1;
			i2c_done    <= 1'b0;
			i2c_ack     <= 1'b0;
			cnt         <= 1'b0;
			st_done     <= 1'b0;
			data_r      <= 1'b0;
			i2c_data_r  <= 1'b0;
			wr_flag     <= 1'b0;
			addr_t      <= 1'b0;
			data_wr_t   <= 1'b0;
		end
		else begin    
			st_done <=1'b0;
			cnt		<= cnt+1'b1;
			case(cur_state)
				st_idle:begin
					scl     <= 1'b1;
					sda_out <= 1'b1;
					sda_dir <= 1'b1;
					i2c_done<= 1'b0;
					cnt     <= 1'b0;
					if(i2c_exec1 == 1'b1 && i2c_exec2 == 1'b0)begin
						wr_flag     <= i2c_rh_wl;
						addr_t      <= i2c_addr;
						data_wr_t   <= i2c_data_w;
						i2c_ack     <= 1'b0;
					end
				end
				st_sladdr:begin
					case(cnt)
						7'd1 : sda_out <= 1'b0;
						7'd3 : scl <= 1'b0;
						7'd4 : sda_out <= SLAVE_ADDR[6];
						7'd5 : scl  <=1'b1;
						7'd7 : scl  <=1'b0;
						7'd8 : sda_out <= SLAVE_ADDR[5];
						7'd9 : scl <= 1'b1;
						7'd11: scl <= 1'b0;
						7'd12: sda_out <= SLAVE_ADDR[4];
						7'd13: scl <= 1'b1;
						7'd15: scl <= 1'b0;
						7'd16: sda_out <= SLAVE_ADDR[3];
						7'd17: scl <= 1'b1;
						7'd19: scl <= 1'b0;
						7'd20: sda_out <= SLAVE_ADDR[2];
						7'd21: scl <= 1'b1;
						7'd23: scl <= 1'b0;
						7'd24: sda_out <= SLAVE_ADDR[1];
						7'd25: scl <= 1'b1;
						7'd27: scl <= 1'b0;
						7'd28: sda_out <= SLAVE_ADDR[0];
						7'd29: scl <= 1'b1;
						7'd31: scl <= 1'b0;
						7'd32: sda_out <= 1'b0;          //0:写
						7'd33: scl <= 1'b1;              
						7'd35: scl <= 1'b0; 
						7'd36: begin
							sda_dir <= 1'b0;
							sda_out <= 1'b1;
						end
						7'd37: scl <= 1'b1; 
						7'd38: begin
							st_done <= 1'b1;
							if(sda_in==1'b1)
								i2c_ack <= 1'b1;
						end
						7'd39:begin
							scl <= 1'b0;
							cnt <= 1'b0;
						end
						default : ;    
					endcase
				end
				st_addr16:begin
					case(cnt)
						7'd0:begin
							sda_dir <= 1'b1;
							sda_out <= addr_t[15];
						end    
						7'd1: scl        <= 1'b1;
						7'd3: scl        <= 1'b0;
						7'd4: sda_out    <= addr_t[14];
						7'd5: scl        <= 1'b1;
						7'd7: scl        <= 1'b0;
						7'd8: sda_out    <= addr_t[13];
						7'd9: scl        <= 1'b1;
						7'd11:scl        <= 1'b0;
						7'd12:sda_out    <= addr_t[12];
						7'd13:scl        <= 1'b1;
						7'd15:scl        <= 1'b0;
						7'd16:sda_out    <= addr_t[11];
						7'd17:scl        <= 1'b1;
						7'd19:scl        <= 1'b0;
						7'd20:sda_out    <= addr_t[10];    
						7'd21:scl        <= 1'b1;              
						7'd23:scl        <= 1'b0;              
						7'd24:sda_out    <= addr_t[9];     
						7'd25:scl        <= 1'b1;              
						7'd27:scl        <= 1'b0;              
						7'd28:sda_out    <= addr_t[8];     
						7'd29:scl        <= 1'b1;              
						7'd31:scl        <= 1'b0;   
						7'd32:begin
							sda_dir <= 1'b0;
							sda_out <= 1'b1;
						end
						7'd34:begin
							st_done <= 1'b1;
							if(sda_in == 1'b1)
								i2c_ack <= 1'b1;
						end
						7'd35:begin
							scl <= 1'b0;
							cnt <= 1'b0;
						end
						default: ;          
					endcase
				end
				st_addr8:begin
					case(cnt)
						7'd0:begin
							sda_dir <= 1'b1;
							sda_out <= addr_t[7];
						end    
						7'd1: scl        <= 1'b1;
						7'd3: scl        <= 1'b0;
						7'd4: sda_out    <= addr_t[6];
						7'd5: scl        <= 1'b1;
						7'd7: scl        <= 1'b0;
						7'd8: sda_out    <= addr_t[5];
						7'd9: scl        <= 1'b1;
						7'd11:scl        <= 1'b0;
						7'd12:sda_out    <= addr_t[4];
						7'd13:scl        <= 1'b1;
						7'd15:scl        <= 1'b0;
						7'd16:sda_out    <= addr_t[3];
						7'd17:scl        <= 1'b1;
						7'd19:scl        <= 1'b0;
						7'd20:sda_out    <= addr_t[2];    
						7'd21:scl        <= 1'b1;              
						7'd23:scl        <= 1'b0;              
						7'd24:sda_out    <= addr_t[1];     
						7'd25:scl        <= 1'b1;              
						7'd27:scl        <= 1'b0;              
						7'd28:sda_out    <= addr_t[0];     
						7'd29:scl        <= 1'b1;              
						7'd31:scl        <= 1'b0;   
						7'd32:begin
							sda_dir <= 1'b0;
							sda_out <= 1'b1;
						end
						7'd34:begin
							st_done <= 1'b1;
							if(sda_in == 1'b1)
								i2c_ack <= 1'b1;
						end
						7'd35:begin
							scl <= 1'b0;
							cnt <= 1'b0;
						end
						default: ;
					endcase
				end 
				st_data_wr:begin
					case(cnt)
						7'd0:begin
							sda_out <= data_wr_t[7];
							sda_dir <= 1'b1;
						end
						7'd1:   scl     <= 1'b1;
						7'd3:   scl     <= 1'b0;
						7'd4:   sda_out <= data_wr_t[6];
						7'd5 : scl <= 1'b1;              
						7'd7 : scl <= 1'b0;              
						7'd8 : sda_out <= data_wr_t[5];  
						7'd9 : scl <= 1'b1;              
						7'd11: scl <= 1'b0;              
						7'd12: sda_out <= data_wr_t[4];  
						7'd13: scl <= 1'b1;              
						7'd15: scl <= 1'b0;              
						7'd16: sda_out <= data_wr_t[3];  
						7'd17: scl <= 1'b1;              
						7'd19: scl <= 1'b0;              
						7'd20: sda_out <= data_wr_t[2];  
						7'd21: scl <= 1'b1;              
						7'd23: scl <= 1'b0;              
						7'd24: sda_out <= data_wr_t[1];  
						7'd25: scl <= 1'b1;              
						7'd27: scl <= 1'b0;              
						7'd28: sda_out <= data_wr_t[0];  
						7'd29: scl <= 1'b1;              
						7'd31: scl <= 1'b0;              
						7'd32: begin                     
							sda_dir <= 1'b0;           
							sda_out <= 1'b1;                              
						end                              
						7'd33: scl <= 1'b1;              
						7'd34: begin                     //从机应答
							st_done <= 1'b1;     
							if(sda_in == 1'b1)           //高电平表示未应答
								i2c_ack <= 1'b1;         //拉高应答标志位    
						end          
						7'd35: begin                     
							scl  <= 1'b0;                
							cnt  <= 1'b0;                
						end                              
						default  :  ;                    
					endcase
				end      
				st_addr_rd: begin
					case(cnt)
						7'd0 : begin
							sda_dir <= 1'b1;
							sda_out <= 1'b1;
						end         
						7'd1 : scl      <= 1'b1;
						7'd2 : sda_out  <= 1'b0;
						7'd3 : scl      <= 1'b0;
						7'd4 : sda_out  <= SLAVE_ADDR[6];
						7'd5 : scl <= 1'b1;              
						7'd7 : scl <= 1'b0;              
						7'd8 : sda_out <= SLAVE_ADDR[5]; 
						7'd9 : scl <= 1'b1;              
						7'd11: scl <= 1'b0;              
						7'd12: sda_out <= SLAVE_ADDR[4]; 
						7'd13: scl <= 1'b1;              
						7'd15: scl <= 1'b0;              
						7'd16: sda_out <= SLAVE_ADDR[3]; 
						7'd17: scl <= 1'b1;              
						7'd19: scl <= 1'b0;              
						7'd20: sda_out <= SLAVE_ADDR[2]; 
						7'd21: scl <= 1'b1;              
						7'd23: scl <= 1'b0;              
						7'd24: sda_out <= SLAVE_ADDR[1]; 
						7'd25: scl <= 1'b1;              
						7'd27: scl <= 1'b0;              
						7'd28: sda_out <= SLAVE_ADDR[0];
						7'd29: scl  <= 1'b1;
						7'd31: scl  <= 1'b0;
						7'd32: sda_out <= 1'b1;
						7'd33: scl  <= 1'b1;
						7'd35: scl  <= 1'b0;
						7'd36: begin
							sda_dir <= 1'b0;
							sda_out <= 1'b1;
						end
						7'd37: scl  <=1'b1;
						7'd38: begin
							st_done <= 1'b1;
							if(sda_in == 1'b1)
								i2c_ack <= 1'b1;    
						end
						7'd39: begin
							scl <= 1'b0;
							cnt <= 1'b0;
						end
						default : ;
					endcase
				end
				st_data_rd:begin
					case(cnt)
						7'd0:   sda_dir <= 1'b0;
						7'd1:   begin
							data_r[7]   <= sda_in;
							scl         <= 1'b1;
						end    
						7'd3:   scl     <= 1'b0;
						7'd5:   begin
							data_r[6]   <= sda_in;
							scl         <= 1'b1;
						end
						7'd7:   scl     <= 1'b0;
						7'd9:   begin
							data_r[5]   <= sda_in;
							scl         <= 1'b1;
						end
						7'd11: scl  <= 1'b0;
						7'd13: begin
							data_r[4] <= sda_in;
							scl       <= 1'b1  ;
						end
						7'd15: scl  <= 1'b0;
						7'd17: begin
							data_r[3] <= sda_in;
							scl       <= 1'b1  ;
						end
						7'd19: scl  <= 1'b0;
						7'd21: begin
							data_r[2] <= sda_in;
							scl       <= 1'b1  ;
						end
						7'd23: scl  <= 1'b0;
						7'd25: begin
							data_r[1] <= sda_in;
							scl       <= 1'b1  ;
						end
						7'd27: scl  <= 1'b0;
						7'd29: begin
							data_r[0] <= sda_in;
							scl       <= 1'b1  ;
						end
						7'd31: scl  <= 1'b0;
						7'd32: begin
							sda_dir <= 1'b1;
							sda_out <= 1'b1;
						end
						7'd33: scl <= 1'b1;
						7'd34: st_done <= 1'b1; 
						7'd35:begin
							scl <= 1'b0;
							cnt <= 1'b0;
							i2c_data_r <= data_r;
						end    
						default : ;
					endcase
				end
				st_stop:begin
					case(cnt)
						7'd0:begin
							sda_dir <= 1'b1;
							sda_out <= 1'b0;
						end
						7'd1: scl <= 1'b1;
						7'd3: sda_out <= 1'b1;
						7'd15: st_done <= 1'b1;
						7'd16:begin
							cnt     <=1'b0;
							i2c_done<=1'b1;
						end
						default : ;
					endcase    
				end        
		
		
		endcase    
		end
	end      
			
	endmodule