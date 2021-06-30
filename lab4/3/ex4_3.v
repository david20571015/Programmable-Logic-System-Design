module ex4_3(SW, LEDR);
    input [1:0] SW;
    output [0:0] LEDR;

    wire Qm;
    D_latch m(~SW[1], SW[0], Qm);
    D_latch s(SW[1], Qm, LEDR[0]);
endmodule

module D_latch(Clk, D, Q);
    input Clk, D;
    output Q;
    RS_latch rs0(Clk, ~D, D, Q);
endmodule

module RS_latch(Clk, R, S, Q);
    input Clk, R, S;
    output Q;

    wire R_g, S_g, Qa, Qb;
    and(R_g, R, Clk);
    and(S_g, S, Clk);
    nor(Qa, R_g, Qb);
    nor(Qb, S_g, Qa);
    assign Q = Qa;
endmodule