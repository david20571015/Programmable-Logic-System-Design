module lab2_1 (
    SW, LEDR
);
    input [9:0] SW;
    output [3:0] LEDR;

    assign LEDR[3:0] = ({4{~SW[9]}} & SW[3:0]) | ({4{SW[9]} & SW[7:4]);
endmodule