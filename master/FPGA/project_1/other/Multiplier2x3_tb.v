`timescale 1 ns/100 ps

module Multiplier2x3_tb;

reg [1:0] m;
reg [2:0] q;
wire  [4:0] p;

Multiplier2x3 Multiplier2x3_dut(//Multiplier2x3_dut可以改
    .m    (m),
    .q    (q),
	 .p    (p)
);

wire expected;//可以改
integer a,b;//可以改
assign expected = m*q;//expected改了记得改这里
initial begin
   $display("%d ns\tSimulation Started",$time); 
	
	for (a = 0; a < 7; a = a + 1)begin
		for( b = 0; b < 4; b = b + 1)begin
			q = a;
			m = b;
			#10;
		end
	end

end
endmodule
