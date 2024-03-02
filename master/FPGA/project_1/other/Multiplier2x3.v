
module Multiplier2x3 (
    input  [1:0] m,
    input  [2:0] q,
    
    output [4:0] p
);

wire [1:0] q1;//可以改
wire q3,m1,m2，t0,t1,t2,t3;//可以改
wire [3:0] ftr;//可以改
wire [1:0] addfirstrow;//可以改

assign add[0] = m[1];//add可以改
assign add[1] = 1'b0;//改


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
    .m   ( add[1:0] ),
    .q   ( q[1:0] ),
    .cIn ( q3 ),
    

    .cOut ( t3   ),
    .mOut ( t2    ),
    .s    ( t1    )
);

MultiplierRemainingRow down1(
    .pp ( t1 ),
    .m  ( t0 ),
    .q  ( q[2]   ),
    .cIn( 1'b0   ),
    
    .qOut ( m1     ),
    .cOut ( m2     ),
    .s    ( p[2]   )
);

MultiplierRemainingRow fown2(
    .pp ( t3 ),
    .m  ( t2 ),
    .q  ( m1),
    .cIn( m2 ),
    

    .cOut ( p[4]       ),
    .s    ( p[3]       )
);

endmodule

