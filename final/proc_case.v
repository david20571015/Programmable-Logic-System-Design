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
	R7
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
	input [7:0]DIN;
	input Reset, Clock, Run;
	output reg Done;
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

	initial
		Clear = 1'b1;
	end

	reg [1:0]I;
	reg [2:0]X, Y;

	assign IRin = Run;
	assign {I, X, Y} = IR;

	assign Clear = ~Reset | ~Run | Done;

	always @ (Counter) begin
		case (I)
			2'b00:	begin // mv
				case (Counter)
					2'b01: begin
						Rout[Y] = 1'b1;
						Rin[X] = 1'b1;
						Done = 1'b1;
					end
					2'b10: begin
						Rout[Y] = 1'b0;
						Rin[X] = 1'b0;
						Done = 1'b0;
					end
					default: begin
						Rout[Y] = 1'b0;
						Rin[X] = 1'b0;
					 	Done = 1'b0;
					end
				endcase
			end
			2'b01:	begin // mvi
				case (Counter)
					2'b01: begin
						DINout = 1'b1;
						Rin[X] = 1'b1;
						Done = 1'b1;
					end
					2'b10: begin
						DINout = 1'b0;
						Rin[X] = 1'b0;
						Done = 1'b0;
					end
					default: begin
						DINout = 1'b0;
						Rin[X] = 1'b0;
						Done = 1'b0;
					end
				endcase
			end
			2'b10: begin // add
				case (Counter)
					2'b01: begin
						Rout[X] = 1'b1;
						Ain = 1'b1;
						Done = 1'b0;
					end
					2'b10:	begin
						Rout[X] = 1'b0;
						Ain = 1'b0;
						Rout[Y] = 1'b1;
						Gin = 1'b1;
						Addsub = 1'b0;
						Done = 1'b0;
					end
					2'b11:	begin
						Rout[Y] = 1'b0;
						Gin = 1'b0;
						Rin[X] = 1'b1;
						Gout = 1'b1;
						Done = 1'b1;
					end
					default: Done = 1'b0;
				endcase
			end
			2'b11: begin // sub
				case (Counter)
					2'b01: begin
						Rout[X] = 1'b1;
						Ain = 1'b1;
						Done = 1'b0;
					end
					2'b10:	begin
						Rout[X] = 1'b0;
						Ain = 1'b0;
						Rout[Y] = 1'b1;
						Gin = 1'b1;
						Addsub = 1'b1;
						Done = 1'b0;
					end
					2'b11:	begin
						Rout[Y] = 1'b0;
						Gin = 1'b0;
						Rin[X] = 1'b1;
						Gout = 1'b1;
						Done = 1'b1;
					end
					default: Done = 1'b0;
				endcase
			end
			
		endcase
	end
endmodule



module addsub (
	X,
	Y,
	Addsub, // !add, sub
	Out
);
	input [7:0]X, Y;
	input Addsub, Clock;
	output [7:0]Out;

	assign Out = Addsub ? X + Y : X - Y;
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
	output reg [7:0]Out;

	always @ (*) begin
		case (Ctrl) begin
			10'b0000000001: Out = DIN;
			10'b0000000010: Out = G;
			10'b0000000100: Out = R7;
			10'b0000001000: Out = R6;
			10'b0000010000: Out = R5;
			10'b0000100000: Out = R4;
			10'b0001000000: Out = R3;
			10'b0010000000: Out = R2;
			10'b0100000000: Out = R1;
			10'b1000000000: Out = R0;
			default: Out = Out;
		endcase:
	end
endmodule

module counter (
	Clock,
	Clear,
	Out
);
	input Clock, Clear;
	output reg [1:0]Out;

	always @ (posedge Clock) begin
		if (Clear)
			Out = 2'b00;
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
