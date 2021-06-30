module ex7_4(SW, HEX0, HEX1, HEX4, HEX5);
    input [7:0] SW;
    output [6:0] HEX0, HEX1, HEX4, HEX5;

    wire [3:0] a, b;

    assign a = SW[7:4];
    assign b = SW[3:0];

    wire [7:0] product;
    multiplier_4bits m(product, a, b);

    display_4bits d0(HEX0, product[3:0]);
    display_4bits d1(HEX1, product[7:4]);
    display_4bits d4(HEX4, b);
    display_4bits d5(HEX5, a);
endmodule

module multiplier_4bits(product, a, b);
    input [3:0] a, b;
    output [7:0] product;

    wire [3:0] sum [2:0];
    wire [2:0] cout;

    assign product[0] = a[0] & b[0];
    adder_4bits a0(sum[0], cout[0], {1'b0, a[3:1] & {3{b[0]}}}, a[3:0] & {4{b[1]}}, 0);
    assign product[1] = sum[0][0];
    adder_4bits a1(sum[1], cout[1], {cout[0], sum[0][3:1]}, a[3:0] & {4{b[2]}}, 0);
    assign product[2] = sum[1][0];
    adder_4bits a2(sum[2], cout[2], {cout[1], sum[1][3:1]}, a[3:0] & {4{b[3]}}, 0);
    assign product[7:3] = {cout[2], sum[2]};
endmodule

module adder_4bits(sum, overflow, a, b, cin);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output overflow;

    wire [4:0] c;

    genvar i;
    generate
    for (i = 0; i <= 3; i = i + 1) begin: add
        full_adder f(c[i+1], sum[i], a[i], b[i], c[i]);  
    end
    endgenerate

    assign overflow = c[4] ^ c[3];
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