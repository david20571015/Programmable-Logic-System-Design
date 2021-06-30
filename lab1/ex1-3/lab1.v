module lab1 (
    SW, LEDR
);
    input [17:0] SW;
    output [17:0] LEDR;

    assign LEDR = SW;
endmodule