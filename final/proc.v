module proc(
	// Input signals
	DIN,
	Reset,
	Clock,
	Run,
	// Output signals
	Done,
	Bus,
	R0,
	R1,
	R2,
	R3,
	R4,
	R5,
	R6,
	R7,
	Counter,
	Clear
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
	input [7:0]DIN;
	input Reset, Clock, Run;
	output Done;
	output [7:0]Bus;
	output [7:0]R0, R1, R2, R3, R4, R5, R6, R7;

//---------------------------------------------------------------------
//  STRUCTURE CODING                         
//---------------------------------------------------------------------

	// R0 ~ R7
	wire [7:0]Rin;
	register r0(Bus, Rin[0], Clock, R0);
	register r1(Bus, Rin[1], Clock, R1);
	register r2(Bus, Rin[2], Clock, R2);
	register r3(Bus, Rin[3], Clock, R3);
	register r4(Bus, Rin[4], Clock, R4);
	register r5(Bus, Rin[5], Clock, R5);
	register r6(Bus, Rin[6], Clock, R6);
	register r7(Bus, Rin[7], Clock, R7);


	// Add, Sub
	wire Ain, Addsub, Gin;
	wire [7:0]A, AS, G;
	register a(Bus, Ain, Clock, A);
	addsub as(A, Bus, Addsub, AS);
	register g(AS, Gin, Clock, G);

	// Multiplexer
	wire [7:0]Rout;
	wire Gout, DINout;
	mux m(DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, {Rout, Gout, DINout}, Bus);

	// IR
	wire IRin;
	wire [7:0]IR;
	register ir(DIN, IRin, Clock, IR);

	// Counter
	wire Clear;
	wire [1:0]Counter;
	counter ct(Clock, Clear, Counter);

	// Control Unit
	control_unit cu(Run, Reset, IR, Counter, Done, Clear, IRin, Rout, Gout, DINout, Rin, Ain, Gin, Addsub);

endmodule

module control_unit (
	Run,
	Reset,
	IR,
	Counter,
	Done,
	Clear,
	IRin,
	Rout,
	Gout,
	DINout,
	Rin,
	Ain,
	Gin,
	Addsub
);
	input Run, Reset;
	input [7:0]IR;
	input [1:0]Counter;
	output Done, Clear, IRin, Gout, DINout, Ain, Gin, Addsub;
	output [7:0]Rout, Rin;

	wire [1:0] I;
	wire [2:0] X, Y;

	assign {I, X, Y} = IR;

	// IR
	assign IRin = Run;

	// R0 ~ R7
	assign Rin = (8'b1 << X) & {8{(I == 0 & Counter == 1) | 
								  (I == 1 & Counter == 1) |
								  (I == 2 & Counter == 3) |
								  (I == 3 & Counter == 3)}};

	// Add, Sub
	assign Ain = (I == 2 & Counter == 1) |
				 (I == 3 & Counter == 1);
	assign Gin = (I == 2 & Counter == 2) |
				 (I == 3 & Counter == 2);
	assign Addsub = (I == 3 & Counter == 2);

	// Multiplexer
	assign Rout = (8'b1 << Y) & {8{(I == 0 & Counter == 1) | 
								   (I == 2 & Counter == 2) |
								   (I == 3 & Counter == 2)}} |
				  (8'b1 << X) & {8{(I == 2 & Counter == 1) |
								   (I == 3 & Counter == 1)}};
	assign Gout = (I == 2 & Counter == 3) |
				  (I == 3 & Counter == 3);
	assign DINout = (I == 1 & Counter == 1 & Run) |
					(I == 0 & Counter == 2);

	// Counter
	assign Clear = ~Reset |
				   ~(Run |
					(I == 2 & Counter == 1) |
				   	(I == 2 & Counter == 2) |
				   	(I == 3 & Counter == 1) |
				   	(I == 3 & Counter == 2));

	// Control Unit
	assign Done = (I == 0 & Counter == 1) |
				  (I == 1 & Counter == 1) |
				  (I == 2 & Counter == 3) |
				  (I == 3 & Counter == 3);
endmodule



module addsub (
	X,
	Y,
	Addsub, // !add, sub
	Out
);
	input [7:0]X, Y;
	input Addsub;
	output [7:0]Out;

	assign Out = Addsub ? X - Y : X + Y;
endmodule

module mux (
	DIN,
	R0, 
	R1, 
	R2, 
	R3, 
	R4, 
	R5, 
	R6, 
	R7, 
	G, 
	Ctrl, 
	Out
);
	input [7:0]DIN, R0, R1,	R2,	R3,	R4,	R5,	R6,	R7,	G;
	input [9:0]Ctrl;
	output reg [7:0]Out = 8'b0;

	always @ (*) begin
		case (Ctrl)
			10'b0000000001: Out = DIN;
			10'b0000000010: Out = G;
			10'b0000000100: Out = R0;
			10'b0000001000: Out = R1;
			10'b0000010000: Out = R2;
			10'b0000100000: Out = R3;
			10'b0001000000: Out = R4;
			10'b0010000000: Out = R5;
			10'b0100000000: Out = R6;
			10'b1000000000: Out = R7;
			default: Out = Out;
		endcase
	end
endmodule

module counter (
	Clock,
	Clear,
	Out
);
	input Clock, Clear;
	output reg [1:0]Out = 0;

	always @ (posedge Clock) begin
		if (Clear)
			Out = 0;
		else
			Out = Out + 1;
	end
endmodule

module register (
	Data,
	In,
	Clock,
	Out
);
	input [7:0]Data;
	input In, Clock;
	output reg [7:0]Out = 0;

	always @ (posedge Clock) begin
		if (In)
			Out = Data;
	end
endmodule
