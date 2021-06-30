module ex6_2(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, CLOCK_50);
    input [9:0] SW;
    input CLOCK_50;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire clk;
    wire [5:0] sec, min, hr;
    wire C[2:0];

    clock c(clk, CLOCK_50);

    timer t(hr, min, sec, clk, SW[9], SW[8], SW[7:0]);

    display_4bits d0(HEX0, sec % 6'd10);
    display_4bits d1(HEX1, sec / 6'd10);
    display_4bits d2(HEX2, min % 6'd10);
    display_4bits d3(HEX3, min / 6'd10);
    display_4bits d4(HEX4, hr % 6'd10);
    display_4bits d5(HEX5, hr / 6'd10);
endmodule

module timer(hr, min, sec, clk, select, preset, value);
    input clk, select, preset;
    input [5:0] value;
    output reg [5:0] hr, min, sec;

    reg preset_f = 0;
    always @ (posedge clk, posedge preset) begin
        if (preset) begin
			if (~preset_f) begin
				if (select)
                    hr <= value;
                else
                    min <= value;
            end
		end

        else begin 
            sec <= sec + 1;
            if (hr >= 23) begin
                hr <= 0;
            end
            if (min >= 59 && sec >= 59) begin
                min <= 0;
                hr <= hr + 1;
            end
            if (sec >= 59) begin
                sec <= 0;
                min <= (min + 1) % 60;
            end        
        end
    end

    always @ (posedge clk) begin
        preset_f <= preset;
    end        
endmodule

module clock(Clkout, Clkin);
    input Clkin;
    output reg Clkout;
    reg [26:0] t;

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