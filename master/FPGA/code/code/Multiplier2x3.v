
module Multiplier2x3 (
    input  [1:0] m,
    input  [2:0] q,
    
    output [4:0] p
);

wire [1:0] q1;//可以改
wire q3,m1,m2,t0,t1,t2,t3;//可以改
wire [4:0] bin;//可以改，这里是垃圾存放

and (p[0],q[0],m[0]);

MultiplierFirstRow top1(
    .m   ( m[1:0]   ),
    .q   ( q[1:0] ),
    .cIn ( 1'b0   ),
    
    .qOut ( q1[1:0] ),
    .cOut ( q3  ),
    .mOut ( t0   ),
    .s    ( p[1]     )
);


MultiplierFirstRow top2(
    .m   ( {1'b0,m[1]}),
    .q   ( q[1:0] ),
    .cIn ( q3 ),
    
	 .qOut (bin[1:0]),
    .cOut ( t3   ),
    .mOut ( t2    ),
    .s    ( t1    )
);

MultiplierRemainRow down1(
    .pp ( t1 ),
    .m  ( t0 ),
    .q  ( q[2]   ),
    .cIn( 1'b0   ),
    
    .qOut ( m1     ),
    .cOut ( m2     ),
	 .mOut ( bin[2] ),
    .s    ( p[2]   )
);

MultiplierRemainRow fown2(
    .pp ( t3 ),
    .m  ( t2 ),
    .q  ( m1),
    .cIn( m2 ),
    
    .qOut ( bin[3]  ),
	 .mOut ( bin[4] ),
    .cOut ( p[4]       ),
    .s    ( p[3]       )
);

endmodule

