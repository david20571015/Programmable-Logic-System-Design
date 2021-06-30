module ex4_4(Clk, D, Qa, Qb, Qc);
    input Clk, D;
    output Qa, Qb, Qc;

    D_latch m0(Clk, D, Qa);
    D_filp_flop m1(Clk, D, Qb);
    D_filp_flop m2(~Clk, D, Qc);
endmodule

module D_filp_flop(Clk, D, Q);
    input Clk, D;
    output Q;

    wire Qm;
    D_latch m(~Clk, D, Qm);
    D_latch s(Clk, Qm, Q);
endmodule

module D_latch(Clk, D, Q);
    input Clk, D;
    output reg Q;

    always @(D, Clk) 
        if(Clk)
            Q = D;
endmodule