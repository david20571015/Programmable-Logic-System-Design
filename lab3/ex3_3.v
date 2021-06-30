module ex3_3 (SW, LEDR);
    input [9:0] SW;
    output [4:0] LEDR;

    wire [3:0] a = SW[3:0], b = SW[7:4];
    wire cin = SW[9];
    wire [3:0] s;
    wire cout;

    wire c1, c2, c3;
    full_adder fa0(a[0], b[0], cin, s[0], c1);
    full_adder fa1(a[1], b[1], c1, s[1], c2);
    full_adder fa2(a[2], b[2], c2, s[2], c3);
    full_adder fa3(a[3], b[3], c3, s[3], cout);    

    assign LEDR[4:0] = {cout, s[3:0]}; 
endmodule

module full_adder(a, b, ci, s, co);
    input a, b, ci;
    output s, co;

    assign s = a ^ b ^ ci;
    assign co = a&b | b&ci | ci&a;    
endmodule