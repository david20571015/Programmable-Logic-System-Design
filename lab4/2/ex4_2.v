module ex4_2(SW, LEDR);
    input [1:0] SW;
    output [0:0] LEDR;

    RS_latch rs0(SW[1], ~SW[0], SW[0], LEDR[0]);
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