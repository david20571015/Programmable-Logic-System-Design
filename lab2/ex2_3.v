module ex2_3 (SW, HEX0);
    input [2:0] SW;
    output [6:0] HEX0;
    char_7seg m0(SW[2:0], HEX0[6:0]);
endmodule

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
