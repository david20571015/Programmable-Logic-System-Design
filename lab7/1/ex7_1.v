module ex7_1(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [1:0] KEY;
    input [8:0] SW;
    output [8:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [7:0] a ,b;
    storage_8bits s0(a, SW[7:0], SW[8], KEY[0], KEY[1]);
    storage_8bits s1(b, SW[7:0], ~SW[8], KEY[0], KEY[1]);

    wire [7:0] sum;
    wire overflow;

    adder_8bits a0(sum, overflow, a, b, 0);

    assign LEDR[8] = overflow;
    assign LEDR[7:0] = sum;

    display_4bits d0(HEX0, sum[3:0]);
    display_4bits d1(HEX1, sum[7:4]);
    display_4bits d2(HEX2, b[3:0]);
    display_4bits d3(HEX3, b[7:4]);
    display_4bits d4(HEX4, a[3:0]);
    display_4bits d5(HEX5, a[7:4]);
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

module adder_8bits(sum, overflow, a, b, cin);
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output overflow;

    wire [8:0] c;

    genvar i;
    generate
    for (i = 0; i <= 7; i = i + 1) begin: add
        full_adder f(c[i+1], sum[i], a[i], b[i], c[i]);  
    end
    endgenerate

    // full_adder f0(c[0], sum[0], a[0], b[0], cin);
    // full_adder f1(c[1], sum[1], a[1], b[1], c[0]);
    // full_adder f2(c[2], sum[2], a[2], b[2], c[1]);
    // full_adder f3(c[3], sum[3], a[3], b[3], c[2]);
    // full_adder f4(c[4], sum[4], a[4], b[4], c[3]);
    // full_adder f5(c[5], sum[5], a[5], b[5], c[4]);
    // full_adder f6(c[6], sum[6], a[6], b[6], c[5]);
    // full_adder f7(c[7], sum[7], a[7], b[7], c[6]);
    
    assign overflow = c[8] ^ c[7];
endmodule

module full_adder(cout, s, a, b, cin);
    input a, b, cin;
    output cout, s;
    assign {cout, s} = a + b + cin;
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