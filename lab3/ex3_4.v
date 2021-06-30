module ex3_4 (SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [8:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    assign LEDR[8:0] = SW[8:0];
    wire [3:0] a = SW[7:4], b = SW[3:0];
    wire cin = SW[8];
    wire cout;
    wire [3:0] result;

    bin_to_dec m0(a, 1'b0, HEX3, HEX2);
    bin_to_dec m1(b, 1'b0, HEX1, HEX0);
    
    full_adder_4bits f0(a, b, cin, result, cout);

    bin_to_dec m2(result, cout, HEX5, HEX4);

    //error led
    wire a_cmp, b_cmp;
    comparator c0({1'b0, a}, a_cmp);
    comparator c1({1'b0, b}, b_cmp);
    assign LEDR[9] = a_cmp | b_cmp;

endmodule

module full_adder_4bits (a, b, cin, o, cout);
    input [3:0] a, b;
    input cin;
    output [4:0] o;
    output cout;

    wire c1, c2, c3;
    full_adder fa0(a[0], b[0], cin, o[0], c1);
    full_adder fa1(a[1], b[1], c1, o[1], c2);
    full_adder fa2(a[2], b[2], c2, o[2], c3);
    full_adder fa3(a[3], b[3], c3, o[3], cout);    
endmodule

module full_adder(a, b, ci, s, co);
    input a, b, ci;
    output s, co;
    assign s = a ^ b ^ ci;
    assign co = a&b | b&ci | ci&a;    
endmodule

module bin_to_dec(b, carry, d1, d0);
    input [3:0] b;
	input carry;
    output [6:0] d0, d1;
    
    wire cmp;
    comparator m0({carry, b[3:0]}, cmp);

    wire [3:0] a;
    ckt_a m1({carry, b[3:0]}, a[3:0]);

    wire o0, o1, o2, o3;

    mux_1bit_2to1 m2(cmp, b[0], a[0], o0);
    mux_1bit_2to1 m3(cmp, b[1], a[1], o1);
    mux_1bit_2to1 m4(cmp, b[2], a[2], o2);
    mux_1bit_2to1 m5(cmp, b[3], a[3], o3);

    ckt_b m6(cmp, d1);
    bcd_7seg m7({o3, o2, o1, o0}, d0);
endmodule

// m = c - 10
module ckt_a (c, m);
    input [4:0] c;
    output [3:0] m;

    assign m[0] = c[0];
    assign m[1] = ~c[1];
    assign m[2] = c[2] & c[1] | c[4] & ~c[1];
    assign m[3] = c[4] & c[1];
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
    input [4:0] c;
    output o;
    assign o = c[3] & (c[2] | c[1]) | c[4];
endmodule