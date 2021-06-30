module ex5_3(KEY, SW, HEX0, HEX1, HEX2, HEX3);
    input [3:0] KEY;
    input [1:0] SW;
    output [6:0] HEX0, HEX1, HEX2, HEX3;

    wire [15:0] Q;
    counter c0(KEY[0], SW[1], ~SW[0], Q);

    display_4bits d0(HEX0, Q[3:0]);
    display_4bits d1(HEX1, Q[7:4]);
    display_4bits d2(HEX2, Q[11:8]);
    display_4bits d3(HEX3, Q[15:12]);
endmodule

module display_4bits(disp, c);
    input [3:0] c;
    output reg [6:0] disp;
    always @ (c)
    begin
        case (c)
            0: disp = 7'b1000000;
            1: disp = 7'b1111001;
            2: disp = 7'b0100100;
            3: disp = 7'b0110000;
            4: disp = 7'b0011001;
            5: disp = 7'b0010010;
            6: disp = 7'b0000010;
            7: disp = 7'b1111000;
            8: disp = 7'b0000000;
            9: disp = 7'b0010000;
            10: disp = 7'b0001000;
            11: disp = 7'b0000011;
            12: disp = 7'b1000110;
            13: disp = 7'b0100001;
            14: disp = 7'b0000110;
            15: disp = 7'b0001110;
        endcase
    end
endmodule