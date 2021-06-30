module ex6_3(SW, KEY, HEX0, HEX1, HEX2, HEX3, LEDR, CLOCK_50);
    input [3:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3;

    wire clk;
    wire [9:0] ms;
    wire [1:0] set_time;

    clock c(clk, CLOCK_50);
    bin2dec bcd(set_time, SW[3:0]);

    reaction r(LEDR[0], set_time, ~KEY[0], ~KEY[3], clk);
    timer t(ms, clk, ~KEY[3], ~KEY[0]);

    display_4bits d0(HEX0, ms % 10);
    display_4bits d1(HEX1, (ms / 10) % 10);
    display_4bits d2(HEX2, (ms / 100) % 10);
    display_4bits d3(HEX3, ms / 1000);
endmodule

module reaction(led, set_time, start, stop, clk);
    input [1:0] set_time;
    input start, stop, clk;
    output reg led;

    reg [11:0] t;

    always @ (posedge clk) begin
        if (t == set_time * 1000) begin
            led <= 1;
            t <= set_time * 1000;
        end
        else if (start) begin
            t <= 0;
        end
        else if (stop) begin
            led <= 0;
        end
        else begin
            t <= t + 1;
        end
    end
endmodule

module timer(ms, clk, stop, reset);
    input clk, enable, reset;
    output reg [9:0] ms;

    reg stop_f = 0;
    reg reset_f = 0;

    reg enable = 0;

    always @ (posedge clk, posedge stop, posedge reset) begin
        if (enable)
            ms <= (ms + 1) % 1000;
        if (reset)
            ms <= 0;
    end
endmodule

module bin2dec(d, b);
    input [3:0] b;
    output reg [1:0] d;

    always @ (b) begin
        case (b)
            4'b0001: d <= 0;
            4'b0010: d <= 1;
            4'b0100: d <= 2;
            4'b1000: d <= 3;
        endcase
    end
endmodule

module clock(Clkout, Clkin);
    input Clkin;
    output reg Clkout;

    reg [14:0] t;

    always @(posedge Clkin)
    begin
        if(t == 15'd24_999)
            Clkout <= ~Clkout;
        t <= (t + 1) % 15'd25_000;
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