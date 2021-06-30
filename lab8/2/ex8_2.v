module ex8_2(KEY, SW, LEDR);
    input [1:0] SW;
    input [0:0] KEY;
    output [9:0] LEDR;

    parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011,
                E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111,
                I = 4'b1000;

    reg [3:0] state;
    reg z;

    always @ (posedge KEY[0]) begin
        if (~SW[0]) 
            state = A;
        else
            case (state)
                A: if(SW[1]) state = F;
                    else state = B;
                B: if(SW[1]) state = F;
                    else state = C;
                C: if(SW[1]) state = F;
                    else state = D;
                D: if(SW[1]) state = F;
                    else state = E;
                E: if(SW[1]) state = F;
                    else state = E;
                F: if(SW[1]) state = G;
                    else state = B;
                G: if(SW[1]) state = H;
                    else state = B;
                H: if(SW[1]) state = I;
                    else state = B;
                I: if(SW[1]) state = I;
                    else state = B;
            endcase
    end

    always @ (state) begin
        case (state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 0;
            E: z = 1;
            F: z = 0;
            G: z = 0;
            H: z = 0;
            I: z = 1;
        endcase
    end

    assign LEDR[3:0] = state[3:0];
    assign LEDR[9] = z;
endmodule