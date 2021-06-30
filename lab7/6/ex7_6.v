module ex7_6(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:9] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3;

    wire [7:0] a, b, c, d;

    storage_8bits s0(a, SW[7:0], ~KEY[2] & ~SW[8] & SW[9], KEY[0], KEY[1]);
    storage_8bits s1(b, SW[7:0], KEY[2] & ~SW[8] & SW[9], KEY[0], KEY[1]);
    storage_8bits s2(c, SW[7:0], ~KEY[2] & SW[8] & SW[9], KEY[0], KEY[1]);
    storage_8bits s3(d, SW[7:0], KEY[2] & SW[8] & SW[9], KEY[0], KEY[1]);

    wire [15:0] ab, cd, sum;
    multiplier m0(a, b, ab);
    multiplier m1(c, d, cd);
    adder a0(ab, cd, LEDR[9], sum);

    reg [15:0] disp;

    always @ (posedge KEY[1]) begin
        if (KEY[3])
            disp = sum;
        else 
            disp = SW[8] ? {c, d} : {a, b};
    end

    display_4bits d0(HEX0, disp[3:0]);
    display_4bits d1(HEX1, disp[7:4]);
    display_4bits d2(HEX2, disp[11:8]);
    display_4bits d3(HEX3, disp[15:12]);
endmodule

module storage_8bits(q, r, set, reset, clk);
    input [7:0] r;
    input set, reset, clk;
    output reg [7:0] q;

    always @ (posedge clk, negedge reset) begin
        if (~reset)
            q = 0;
        else if (set)
            q = r;
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