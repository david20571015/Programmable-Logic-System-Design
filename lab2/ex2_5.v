module ex2_5 (SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [2:0] SW;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [2:0] o0, o1, o2, o3, o4, o5;
    wire [2:0] h=3'b000, e=3'b001, l=3'b010, o=3'b011, blk=3'b100;

    mux_3bit_6to1 m5(SW, blk, h, e, l, l, o, o5);
    char_7seg c5(o5, HEX5);
    mux_3bit_6to1 m4(SW, h, e, l, l, o, blk, o4);
    char_7seg c4(o4, HEX4);
    mux_3bit_6to1 m3(SW, e, l, l, o, blk, h, o3);
    char_7seg c3(o3, HEX3); 
    mux_3bit_6to1 m2(SW, l, l, o, blk, h, e, o2);
    char_7seg c2(o2, HEX2);    
    mux_3bit_6to1 m1(SW, l, o, blk, h, e, l, o1);
    char_7seg c1(o1, HEX1);    
    mux_3bit_6to1 m0(SW, o, blk, h, e, l, l, o0);
    char_7seg c0(o0, HEX0);
endmodule


// 000 => H
// 001 => E
// 010 => L
// 011 => O
// 100 => blank
module char_7seg(c, display);
    input [2:0] c;
    output [6:0] display;

    assign display[0] = c[2] | !c[0];
    assign display[1] = c[2] | c[1] ^ c[0];
    assign display[2] = c[2] | c[1] ^ c[0];
    assign display[3] = c[2] | ~c[1] & ~c[0];
    assign display[4] = c[2];
    assign display[5] = c[2];
    assign display[6] = c[2] | c[1];
endmodule

// s   => m
// 000 => u
// 001 => v
// 010 => w
// 011 => x
// 100 => y
// 101 => z
module mux_3bit_6to1(s, u, v, w, x, y, z, m);
    input [2:0] s;
    input [2:0] u, v, w, x, y, z;
    output [2:0] m;

    wire [2:0] o0, o1, o2 ,o3;
    mux_3bit_2to1 m0(s[0], u, v, o0);
    mux_3bit_2to1 m1(s[0], w, x, o1);
    mux_3bit_2to1 m2(s[0], y, z, o2);
    mux_3bit_2to1 m3(s[1], o0, o1, o3);
    mux_3bit_2to1 m4(s[2], o3, o2, m);
endmodule

// s => m
// 0 => x
// 1 => y
module mux_3bit_2to1(s, x, y, m);
    input s;
    input [2:0] x, y;
    output [2:0] m;
    assign m = ({3{~s}} & x) | ({3{s}} & y);
endmodule