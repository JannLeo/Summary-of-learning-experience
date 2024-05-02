// ADC 2 DAC

/*
 * adc_dac.v
 * ---------------------
 * For: University of Leeds
 * Date: 24/04/2024
 * Author: Junnan Liu
 * ID: 201715540
 *
 * Description
 * ------------
 * The module is to achieve the function of the ADC and DAC to WM8731.
 * 
 *
 */
 
//============================================================================
//                              Module definition
//============================================================================

module adc_dac (
    // clock
    input wire clk,
    // reset signal
    input wire reset,
    // dac input data
    input wire [31:0] dac_data_in,
    // // adc output data
    // output wire [31:0] adc_data_out,
    // main clock
    output wire m_clk,
    // bit clock
    output wire b_clk,
    // dac left tunnel clock
    output wire dac_lr_clk,
    // // adc left tunnel clock
    // output wire adc_lr_clk,
    // dac clock
    output wire dacdat,
    // // adc clock
    // input wire adcdat,
    // whether the load is finished.
    output wire load_done_tick
);

//============================================================================
//                              Variable Definition
//============================================================================

// 2-bit indicates a 50/4 = 12.5MHz clock, 
// because the mclk frequency should be 12.288MHz, 
// with a tolerance of 1.7% error.
localparam M_DVSR 	= 2;
// Dual channel, 16-bit resolution, under 48K sampling rate configuration
// Transferring 2*16*48K bits per second, which is 1.536M bits
// Corresponding to mclk's one-eighth, 
// so take 3 bits as the divisor corresponding to bitclock.
localparam B_DVSR 	= 3;
// Each stereo sample has 32 bits, 
// so we use 5 bits to obtain the alignment clock.
localparam LR_DVSR 	= 5;


// main clock period 12.5MHz count
reg 	[M_DVSR-1:0] 	m_reg;
wire 	[M_DVSR-1:0] 	m_next;
// bit clock period count
reg 	[B_DVSR-1:0] 	b_reg;
wire 	[B_DVSR-1:0] 	b_next;
// lr_reg, when rising edge, load-tick signal is set to 1 
// to indicate the completion of data sample processing
reg 	[LR_DVSR-1:0] 	lr_reg;
wire	[LR_DVSR-1:0] 	lr_next;
// 32-bit shift register, buffer register for storing dac and adc data
reg 	[31:0] dac_buf_reg;
wire 	[31:0] dac_buf_next;
reg 	lr_delayed_reg, 		b_delayed_reg;
// Create multiple status signals to facilitate data processing
// b_neg_tick and b_pos_tick will change 
// when b_clk signal appears at the falling or rising edge.
wire 	m_12_5m_tick, load_tick,b_neg_tick,b_pos_tick;

// body
//============================================================================
//                              State Transfer
//============================================================================

always @(posedge clk, posedge reset) begin
    if(reset) begin
        m_reg 			<=0;
        b_reg 			<= 0;
        lr_reg 			<= 0;
        dac_buf_reg 	<= 0;
        adc_buf_reg 	<= 0;
        b_delayed_reg 	<= 1'b0;
        lr_delayed_reg 	<= 1'b0;
        
    end else begin
        m_reg 				<= m_next;
        b_reg 				<= b_next;
        lr_reg 				<= lr_next;
        dac_buf_reg 		<= dac_buf_next;
        adc_buf_reg		    <= adc_buf_next;
        // Delayed trigger, take the highest bit of b_reg and lr_reg
        b_delayed_reg 		<= b_reg[B_DVSR-1];
        lr_delayed_reg 		<= lr_reg[LR_DVSR-1];
    end
end
    // Take modulo 4 count
    assign m_next 			= m_reg + 1;
    // Assign the highest bit to the main clock
    assign m_clk 			= m_reg[M_DVSR-1];
    // Count 12.5MHz clock cycles
    assign m_12_5m_tick 	= (m_reg == 0)? 1'b1:1'b0;
    // Take modulo 8 counter
    assign b_next 			= m_12_5m_tick ? b_reg + 1 : b_reg;
    assign b_clk 			= b_reg[B_DVSR-1];
    // 1 at the falling edge
    assign b_neg_tick 		= b_delayed_reg & !b_reg[B_DVSR-1];
    // 1 at the rising edge
    assign b_pos_tick 		= !b_delayed_reg & b_reg[B_DVSR-1];
    
    // State transfer
    assign lr_next 			= b_neg_tick? lr_reg + 1 : lr_reg;
    // dac and adc left channel clock level
    assign dac_lr_clk 		= lr_reg[LR_DVSR-1];
    
    // Record the completion of stereo processing
    assign load_tick 		= !lr_delayed_reg & lr_reg[LR_DVSR-1];
    assign load_done_tick 	= load_tick;
//============================================================================
//                               DAC Buffer logic
//============================================================================

    // Determine whether the sound data processing is completed 
	// or only one bit of data is processed, otherwise, keep unchanged
    assign dac_buf_next = load_tick? dac_data_in:
                        b_neg_tick ? {dac_buf_reg[30:0],1'b0} : 
                                    dac_buf_reg;
    // Assign the highest bit to drive the DAC chip
    assign dacdat 		= dac_buf_reg[31];
//============================================================================
//                              ADC Buffer logic
//============================================================================
    
    // // ADC shift register determines whether the data reception is completed
    // assign adc_buf_next = b_pos_tick ? {adc_buf_reg[30:0], adcdat}:
                                        // adc_buf_reg;
    // // Assign the received data to the output
    // assign adc_data_out = adc_buf_reg;

endmodule
