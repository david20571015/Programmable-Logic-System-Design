module ex6_1(KEY, HEX0, HEX1, HEX2, CLOCK_50);
    input [3:0] KEY;
    input CLOCK_50;
    output [6:0] HEX0, HEX1, HEX2;

    wire clk;
    wire [9:0] Q;

    clock c(clk, CLOCK_50);

    counter c0(Q, clk, KEY[0]);

    display_4bits d0(HEX0, Q % 10);
    display_4bits d1(HEX1, (Q / 10) % 10);
    display_4bits d2(HEX2, (Q / 100));
endmodule

module counter(Q, clk, reset);
    input clk, reset;
    output reg [9:0] Q;

    always @ (negedge clk, negedge reset)
    begin        
        if (~reset)
            Q <= 0;           
        else
            Q <= (Q + 1) % 1000;
    end
endmodule

module clock(Clkout, Clkin);
    input Clkin;
    output reg Clkout;

    reg [26:0] t;

    initial
    begin
        Clkout = 0;
        t = 0;
    end

    always @(posedge Clkin)
    begin
        if(t == 27'd24_999_999)
            Clkout <= ~Clkout;
        t <= (t + 1) % 27'd25_000_000;
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