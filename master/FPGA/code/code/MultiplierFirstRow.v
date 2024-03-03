
module MultiplierFirstRow (
    input  [1:0] m,
    input  [1:0] q,
    input        cIn,
    
    output [1:0] qOut,
    output       cOut,
    output       mOut,
    output       s
);
wire a,b;//a和b是名字可以改

and(a,m[0],q[1]);
and(b,m[1],q[0]);
assign qOut[0] = 1'b0;
assign qOut[1] = q[1];
assign mOut = m[0];
    
Adder1Bit adder (//adder是名字可以改

        .a   (a),
        .b   (b),
		  .cin (cIn),
        .cout(cOut),
        .s (s)
);




endmodule
