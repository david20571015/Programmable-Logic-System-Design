`timescale 1 ns/100 ps
`define CYCLE_TIME 30
`define d_patnumber 10000
`define d_SEED 128

module testbench;

real CYCLE=`CYCLE_TIME;
parameter patnumber=`d_patnumber;
integer SEED = `d_SEED;

reg [7:0]DIN;
reg Reset, Clock, Run;
wire Done;
wire [7:0]Bus;
wire [7:0]R0,R1,R2,R3,R4,R5,R6,R7;

wire [1:0]Counter;
wire Clear;

initial Clock = 0;
always #(CYCLE/2.0) Clock = ~Clock;

proc p0(
	// Input signals
	.DIN(DIN),
	.Reset(Reset),
	.Clock(Clock),
	.Run(Run),
	// Output signals
	.Done(Done),
	.Bus(Bus),
	.R0(R0),.R1(R1),.R2(R2),.R3(R3),.R4(R4),.R5(R5),.R6(R6),.R7(R7)
	,.Counter(Counter),.Clear(Clear)
);


integer i,p,t,temp_IR,temp_x,temp_y;
reg [7:0]Register[7:0];
initial begin
	Reset = 1'b1;
	Run = 0;
	DIN = 'dx;
	force Clock = 0;
	reset_signal_task;

	for(p=0; p<patnumber; p=p+1)begin
		input_task;
		$display("PASS PATTERN NO %.4d, golden_R0~R7: %.3d, %.3d, %.3d, %.3d, %.3d, %.3d, %.3d, %.3d",p,Register[0],Register[1],Register[2],Register[3],Register[4],Register[5],Register[6],Register[7]);
	end 
	display_pass;	
end

task reset_signal_task; begin 
	for(i=0;i<8;i=i+1)begin
		Register[i] = 8-i;
	end
	#CYCLE; Reset = 0; 
	#CYCLE; Reset = 1;
	#CYCLE; release Clock;
	 
	//we give all register a value first
	repeat(1)@(negedge Clock);	
	for(i=0;i<8;i=i+1)begin
		Run = 1;
		DIN[7:6] = 2'b01;
		DIN[5:3] = i;
		DIN[2:0] = i;
		repeat(1)@(negedge Clock);
		if(Done!==1)begin
			$display("Done WRONG. golded Done: 1, your Done:%d",Done);
			display_fail;
		end	
		Run = 0;
		DIN = 8-i;	
		repeat(1)@(negedge Clock);
		if(Done===1)begin
			$display("Done WRONG. Done can only have 1 clock");
			display_fail;
		end
		if(Bus!==8-i)begin
			$display("Bus WRONG. golded Bus:%d, your Bus:%d",i,Bus);
			display_fail;
		end
	end
	DIN = 'dx;
end endtask

task input_task; begin
	Run = 0;
	DIN = 'dx;
	t= $urandom(SEED)%3'd7+1;
	SEED = SEED + 1;
	repeat(t) @(negedge Clock);
	Run = 1;
	
	temp_x = $urandom(SEED)%4'd8;
	SEED = SEED + 1;
	DIN[5:3] = temp_x;

	temp_y = $urandom(SEED)%4'd8;
	SEED = SEED + 1;	
	while(temp_y === temp_x)begin
		temp_y = $urandom(SEED)%4'd8;
		SEED = SEED + 1;
	end
	
	temp_IR = $urandom(SEED)%3'd4;
	SEED = SEED + 1;
	//make adder more chance
	if(temp_IR!==2)begin
		temp_IR = $urandom(SEED)%3'd4;
		SEED = SEED + 1;
	end
	while((Register[temp_x]<Register[temp_y])&&(temp_IR==3))begin
		temp_IR = $urandom(SEED)%3'd4;
		SEED = SEED + 1;
	end
	if(Register[temp_x]+ Register[temp_y]>=256)begin
		temp_IR = 1;
	end
	DIN[7:6] = temp_IR;
	if(temp_IR==1)begin
		DIN[2:0] = 0;
	end
	else begin
		DIN[2:0] = temp_y;
	end
	//caculate answer first
	case(temp_IR)
		0:begin //copy
			Register[temp_x] = Register[temp_y];
		end
		1:begin //save DIN
			Register[temp_x] = temp_y;
		end
		2:begin //add
			Register[temp_x] = Register[temp_x] + Register[temp_y];
		end
		3:begin //sub
			Register[temp_x] = Register[temp_x] - Register[temp_y];
		end
	endcase
	
	repeat(1) @(negedge Clock);
	Run = 0;
	DIN = 'dx;
	if(temp_IR===0)begin
		if(Done!==1)begin
			$display("Done WRONG. golded Done: 1, your Done:%d",Done);
			display_fail;
		end	
		if(Bus!==Register[temp_x])begin
			$display("Bus WRONG. golded Bus: 0, your Bus:%d",Bus);
			display_fail;
		end
		repeat(1) @(negedge Clock);
	end
	else if(temp_IR===1)begin
		DIN = temp_y;
		if(Done!==1)begin
			$display("Done WRONG. golded Done: 1, your Done:%d",Done);
			display_fail;
		end
		repeat(1) @(negedge Clock);
		DIN = 'dx;
		if(Bus!==Register[temp_x])begin
			$display("Bus WRONG. golded Bus: 0, your Bus:%d",Bus);
			display_fail;
		end
		repeat(1) @(negedge Clock);		
	end
	else begin
		repeat(2) @(negedge Clock);
		if(Done!==1)begin
			$display("Done WRONG. golded Done: 1, your Done:%d",Done);
			display_fail;
		end	
		if(Bus!==Register[temp_x])begin
			$display("Bus WRONG. golded Bus:%d, your Bus:%d",Register[temp_x],Bus);
			display_fail;
		end
		repeat(1) @(negedge Clock);
		if(Done===1)begin
			$display("Done WRONG. Done can only have 1 clock");
			display_fail;
		end
		
		if(Register[0]!==R0 || Register[1]!==R1 || Register[2]!==R2 || Register[3]!==R3 || Register[4]!==R4 || Register[5]!==R5 || Register[6]!==R6 || Register[7]!==R7)begin
			$display("Register WRONG.");
			$display("golden_R0~R7: %d, %d, %d, %d, %d, %d, %d",Register[0],Register[1],Register[2],Register[3],Register[4],Register[5],Register[6],Register[7]);
			$display("your   R0~R7: %d, %d, %d, %d, %d, %d, %d",R0,R1,R2,R3,R4,R5,R6,R7);
			display_fail;
		end
	end
end endtask

task display_fail; begin
		//just a cute picture
        $display("\n");
        $display("\n");
        $display("        ----------------------------               ");
        $display("        --                        --       |\__||  ");
        $display("        --  OOPS!!                --      / X,X  | ");
        $display("        --                        --    /_____   | ");
        $display("        --  \033[0;31mSimulation Failed!!\033[m   --   /^ ^ ^ \\  |");
        $display("        --                        --  |^ ^ ^ ^ |w| ");
        $display("        ----------------------------   \\m___m__|_|");
        $display("\n");
		  $finish;
end endtask

task display_pass; begin
		//just a cute picture
        $display("\n");
        $display("\n");
        $display("        ----------------------------               ");
        $display("        --                        --       |\__||  ");
        $display("        --  Congratulations !!    --      / O.O  | ");
        $display("        --                        --    /_____   | ");
        $display("        --  \033[0;32mSimulation PASS!!\033[m     --   /^ ^ ^ \\  |");
        $display("        --                        --  |^ ^ ^ ^ |w| ");
        $display("        ----------------------------   \\m___m__|_|");
        $display("\n");
		  $finish;
end endtask

endmodule
