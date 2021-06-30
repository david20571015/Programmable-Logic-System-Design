module ex5_1(KEY, SW, HEX0, HEX1, HEX2, HEX3);
    input [3:0] KEY;
    input [1:0] SW;
    output [6:0] HEX0, HEX1, HEX2, HEX3;

    wire [15:0] Q;

    counter_16bits c0(Q, KEY[0], SW[1], SW[0]);

    display_4bits d0(HEX0, Q[3:0]);
    display_4bits d1(HEX1, Q[7:4]);
    display_4bits d2(HEX2, Q[11:8]);
    display_4bits d3(HEX3, Q[15:12]);
endmodule

module counter_16bits(Q, Clk, En, Res);
    input Clk, En, Res;
    output [15:0] Q;

    wire [3:0] Trig;

    counter_4bits c0(Q[3:0], Clk, En, Res, Trig[0]);
    counter_4bits c1(Q[7:4], Clk, En & Trig[0], Res, Trig[1]);
    counter_4bits c2(Q[11:8], Clk, En & Trig[1], Res, Trig[2]);
    counter_4bits c3(Q[15:12], Clk, En & Trig[2], Res, Trig[3]);
endmodule

module counter_4bits(Q, Clk, En, Res, Trig);
    input Clk, En, Res;
    output [3:0] Q;
    output Trig;

    T_flip_flop t0(Q[0], Clk, En, Res);
    T_flip_flop t1(Q[1], Clk, En & Q[0], Res);
    T_flip_flop t2(Q[2], Clk, En & Q[0] & Q[1], Res);
    T_flip_flop t3(Q[3], Clk, En & Q[0] & Q[1] & Q[2], Res);
    assign Trig = En & Q[0] & Q[1] & Q[2] & Q[3];
endmodule

module T_flip_flop(Q, Clk, T, Res);
    input Clk, Res;
    input T;
    output reg Q = 0;

    always @ (posedge Clk)
    begin
        if (~Res)
            Q <= 1'b0;
        else
            Q <= Q ^ T;
    end
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