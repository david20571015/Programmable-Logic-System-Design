module ex8_1(KEY, SW, LEDR);
    input [1:0] SW;
    input [0:0] KEY;
    output [9:0] LEDR;

    wire [8:0] y;
    
    // D_flip_flop d0(y[0],                                1'b0, SW[0], 1'b1, KEY[0]);
    // D_flip_flop d1(y[1], (y[0]|y[5]|y[6]|y[7]|y[8]) & ~SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d2(y[2],                       y[1] & ~SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d3(y[3],                       y[2] & ~SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d4(y[4],                (y[3]|y[4]) & ~SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d5(y[5],  (y[0]|y[1]|y[2]|y[3]|y[4]) & SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d6(y[6],                        y[5] & SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d7(y[7],                        y[6] & SW[1], SW[0], 1'b0, KEY[0]);
    // D_flip_flop d8(y[8],                 (y[7]|y[8]) & SW[1], SW[0], 1'b0, KEY[0]);

    D_flip_flop d0(y[0],                                 1'b1, SW[0], 1'b0, KEY[0]);
    D_flip_flop d1(y[1], (~y[0]|y[5]|y[6]|y[7]|y[8]) & ~SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d2(y[2],                        y[1] & ~SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d3(y[3],                        y[2] & ~SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d4(y[4],                 (y[3]|y[4]) & ~SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d5(y[5],  (~y[0]|y[1]|y[2]|y[3]|y[4]) & SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d6(y[6],                         y[5] & SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d7(y[7],                         y[6] & SW[1], SW[0], 1'b0, KEY[0]);
    D_flip_flop d8(y[8],                  (y[7]|y[8]) & SW[1], SW[0], 1'b0, KEY[0]);
    
    assign LEDR[8:0] = y[8:0];                
    assign LEDR[9] = y[4] | y[8];
endmodule

module D_flip_flop(q, d, reset, r_value, clk);
    input d, reset, r_value, clk;
    output reg q;

    always @ (posedge clk) begin
        if (~reset)
            q <= r_value;
        else
            q <= d;
    end
endmodule