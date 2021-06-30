module lab2_2 (
    SW, LEDR
);
    input [2:0] SW;
    output [2:0] LEDR;

    wire [2:0] u, v, w, x, y;
    assign u = 3'b000;
    assign v = 3'b001;
    assign w = 3'b010;
    assign x = 3'b011;
    assign y = 3'b100;

    wire [2:0] o0, o1, o2;

    mux_2to1 m0(u, v, SW[0], o0);
    mux_2to1 m1(w, x, SW[0], o1);
    mux_2to1 m2(o0, o1, SW[1], o2);
    mux_2to1 m3(o2, y, SW[2], LEDR);
endmodule

module mux_2to1 (
    x, y, s, o
);
    input [2:0] x, y;
    input s;
    output [2:0] o;

    assign o = ({3{~s}} & x) | ({3{s}} & y);
endmodule