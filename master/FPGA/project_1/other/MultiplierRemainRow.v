
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
        .cin (cIn),
        .a   (a),
        .b   (pp),
        .sum (s),
        .cout(cOut)
);



endmodule
