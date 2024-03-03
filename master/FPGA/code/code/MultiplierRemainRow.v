
module MultiplierRemainRow (
    input  pp,
    input  m,
    input  q,
    input  cIn,
    
    output qOut,
    output cOut,
    output mOut,
    output s
);
wire a;//a可以改


assign mOut = m;
assign qOut = q;

and(a,m,q);

Adder1Bit adder (//adder是名字可以改
        .a   (a),
        .b   (pp),
		  .cin (cIn),
        .cout(cOut),
        .s (s)

);



endmodule
