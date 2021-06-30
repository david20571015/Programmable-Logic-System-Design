module ex8_4(KEY, SW, HEX0);
    input [2:0] SW;
    input [0:0] KEY;
    output [6:0] HEX0;

    reg [3:0] count;

    always @ (posedge KEY[0]) begin
        if(~SW[0])
            count = 0;
        else 
            case(SW[2:1])
                2'b00: count = count;
                2'b01: count = (count + 1) % 10;
                2'b10: count = (count + 2) % 10;
                2'b11: count = (count + 9) % 10;
            endcase
    end

    display_4bits d(HEX0, count);

endmodule


module display_4bits(disp, c);
    input [3:0] c;
    output reg [6:0] disp;
    always @ (c)
    begin
        case (c)
            0: disp = 7'b1000000;
            1: disp = 7'b1111001;
            2: disp = 7'b0100100;
            3: disp = 7'b0110000;
            4: disp = 7'b0011001;
            5: disp = 7'b0010010;
            6: disp = 7'b0000010;
            7: disp = 7'b1111000;
            8: disp = 7'b0000000;
            9: disp = 7'b0010000;
            10: disp = 7'b0001000;
            11: disp = 7'b0000011;
            12: disp = 7'b1000110;
            13: disp = 7'b0100001;
            14: disp = 7'b0000110;
            15: disp = 7'b0001110;
        endcase
    end
endmodule