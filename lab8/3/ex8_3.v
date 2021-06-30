module ex8_3(KEY, SW, LEDR);
    input [1:0] SW;
    input [0:0] KEY;
    output [9:0] LEDR;

    reg [3:0] ones, zeros;

    always @ (posedge KEY[0]) begin
        if (~SW[0]) begin
            ones = 4'b0000;
            zeros = 4'b1111;
        end 
        else begin
            ones = ones << 1;
            zeros = zeros << 1;
            ones[0] <= SW[1];
            zeros[0] <= SW[1];
        end     
    end

    assign LEDR[7:0] = {ones[3:0], zeros[3:0]};
    assign LEDR[9] = (ones[0] & ones[1] & ones[2] & ones[3]) | (~zeros[0] & ~zeros[1] & ~zeros[2] & ~zeros[3]);

endmodule