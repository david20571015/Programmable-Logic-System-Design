module ex5_4(HEX0, CLOCK_50);
    output [6:0] HEX0;
    input CLOCK_50;

    wire [3:0] Q;

    counter c0(Q, CLOCK_50);

    display_4bits d0(HEX0, Q);
endmodule

module counter(Q, Clk);
    input Clk;
    output reg [3:0] Q = 0;

    reg [26:0] t;

    always @(posedge Clk)
    begin
        if(t == 27'd50_000_000)
        begin
            t <= 0;
            Q <= (Q + 1) % 10;
        end
        else
            t <= t + 1;
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