module ex3_2(SW, HEX0, HEX1);
    input [3:0] SW;
    output [6:0] HEX0, HEX1;
    
    wire cmp;
    comparator m0(SW[3:0], cmp);

    wire [2:0] a;
    ckt_a m1(SW[2:0], a);

    wire o0, o1, o2, o3;

    mux_1bit_2to1 m2(cmp, SW[0], a[0], o0);
    mux_1bit_2to1 m3(cmp, SW[1], a[1], o1);
    mux_1bit_2to1 m4(cmp, SW[2], a[2], o2);
    mux_1bit_2to1 m5(cmp, SW[3], 1'b0, o3);

    ckt_b m6(cmp, HEX1);
    bcd_7seg m7({o3, o2, o1, o0}, HEX0);
endmodule

// m = c - 10
module ckt_a (c, m);
    input [2:0] c;
    output [2:0] m;

    assign m[0] = c[0];
    assign m[1] = ~c[1];
    assign m[2] = c[2] & c[1];
endmodule


module  ckt_b (c, display);
    input c;
    output [6:0] display;
    wire [6:0] one = 7'b1111001, zero = 7'b1000000;
    assign display = ({7{~c}} & zero) | ({7{c}} & one);  
endmodule

module bcd_7seg(c, display);
    input [3:0] c;
    output [6:0] display;

    assign display[0] = ~c[3]&~c[2]&~c[1]&c[0] | c[2]&~c[1]&~c[0];
    assign display[1] = c[2]&~c[1]&c[0] | c[2]&c[1]&~c[0];
    assign display[2] = ~c[2]&c[1]&~c[0];
    assign display[3] = ~c[3]&~c[2]&~c[1]&c[0] | c[2]&~c[1]&~c[0] | c[2]&c[1]&c[0];
    assign display[4] = c[0] | c[2]&~c[1];
    assign display[5] = ~c[3]&~c[2]&c[0] | ~c[2]&c[1] | c[1]&c[0];
    assign display[6] = ~c[3]&~c[2]&~c[1] | c[2]&c[1]&c[0];
endmodule

module mux_1bit_2to1(s, x, y, m);
    input s;
    input x, y;
    output m;
    assign m = (~s & x) | (s & y);
endmodule

// c > 9 => 1
// c <= 9 => 0
module comparator (c, o);
    input [3:0] c;
    output o;
    assign o = c[3] & (c[2] | c[1]);
endmodule