module ex3_1(SW, HEX0);
    input [3:0] SW;
    output [6:0] HEX0;
    bcd_7seg m0(SW, HEX0);
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