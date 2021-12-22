`timescale 1ns / 1ps

module Control (
	// INPUT
	input  wire [5:0] i_Op      ,
	// WB
	output wire       o_RegWrite,
	output wire [1:0] o_MemtoReg,
	// MEM
	output wire       o_MemRead ,
	output wire       o_MemWrite,
	output wire [1:0] o_Long    ,
	output wire       o_MemSign ,
	// EX
	output wire [1:0] o_RegDst  ,
	output wire [2:0] o_ALUOp   ,
	output wire       o_ALUSrc  ,
	// ID
	output wire       o_Signed  ,
	// IF
	output wire       o_Branch  ,
	output wire       o_Branchne,
	output wire       o_Jump    ,
	output wire       o_Halt
);


	localparam RTYPE = 6'b000000;
	localparam LB    = 6'b100000;
	localparam LH    = 6'b100001;
	localparam LW    = 6'b100011;
	localparam LWU   = 6'b100111;
	localparam LBU   = 6'b100100;
	localparam LHU   = 6'b100101;
	localparam SB    = 6'b101000;
	localparam SH    = 6'b101001;
	localparam SW    = 6'b101011;
	localparam ADDI  = 6'b001000;
	localparam ANDI  = 6'b001100;
	localparam ORI   = 6'b001101;
	localparam XORI  = 6'b001110;
	localparam LUI   = 6'b001111;
	localparam SLTI  = 6'b001010;
	localparam BEQ   = 6'b000100;
	localparam BNE   = 6'b000101;
	localparam J     = 6'b000010;
	localparam JAL   = 6'b000011;
	localparam HLT   = 6'b111111;



	reg [1:0] RegDst  ;
	reg [2:0] ALUOp   ;
	reg       ALUSrc  ;
	reg       Branch  ;
	reg       Branchne;
	reg       MemRead ;
	reg       MemWrite;
	reg       RegWrite;
	reg [1:0] MemtoReg;
	reg       Jump    ;
	reg       MemSign ;
	reg [1:0] Long    ;
	reg       Signed  ;
	reg       Halt    ;


	always @(*) begin : proc_Op

		case(i_Op)

			RTYPE : begin
				Signed   = 1'bX  ;
				RegDst   = 2'b01 ;
				ALUOp    = 3'b011;
				ALUSrc   = 1'b0	 ;
				Branch   = 1'b0	 ;
				Branchne = 1'b0	 ;
				MemRead  = 1'b0	 ;
				MemWrite = 1'b0	 ;
				RegWrite = 1'b1	 ;
				MemtoReg = 2'b00 ;
				Jump     = 1'b0	 ;
				MemSign  = 1'bX	 ;
				Long     = 2'bXX ;
				Halt     = 1'b0  ;
			end

			LB : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00 ;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1	 ;
				Branch   = 1'b0	 ;
				Branchne = 1'b0	 ;
				MemRead  = 1'b1	 ;
				MemWrite = 1'b0	 ;
				RegWrite = 1'b1	 ;
				MemtoReg = 2'b01 ;
				Jump     = 1'b0	 ;
				MemSign  = 1'b1	 ;
				Long     = 2'b00 ;
				Halt     = 1'b0  ;
			end

			LH : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b1;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b01;
				Jump     = 1'b0;
				MemSign  = 1'b1;
				Long     = 2'b01;
				Halt     = 1'b0;
			end

			LW : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b1;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b01;
				Jump     = 1'b0;
				MemSign  = 1'b1;
				Long     = 2'b11;
				Halt     = 1'b0;

			end

			LWU : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b1;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b01;
				Jump     = 1'b0;
				MemSign  = 1'b0;
				Long     = 2'b11;
				Halt     = 1'b0;
			end

			LBU : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b1;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b01;
				Jump     = 1'b0;
				MemSign  = 1'b0;
				Long     = 2'b00;
				Halt     = 1'b0;
			end
			LHU : begin
				Signed   = 1'b1  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b1;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b01;
				Jump     = 1'b0;
				MemSign  = 1'b0;
				Long     = 2'b01;
				Halt     = 1'b0;
			end
			SB : begin
				Signed   = 1'b1  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b1;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'b00;
				Halt     = 1'b0;
			end

			SH : begin
				Signed   = 1'b1  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b1;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'b01;
				Halt     = 1'b0;
			end

			SW : begin
				Signed   = 1'b1  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b1;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'b11;
				Halt     = 1'b0;
			end

			ADDI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			ANDI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b100;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			ORI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b101;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			XORI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b110;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			LUI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b111;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			SLTI : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b00;
				ALUOp    = 3'b010;
				ALUSrc   = 1'b1;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			BEQ : begin
				Signed   = 1'b1  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'b001;
				ALUSrc   = 1'b0;
				Branch   = 1'b1;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			BNE : begin
				Signed   = 1'b0  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'b001;
				ALUSrc   = 1'b0;
				Branch   = 1'b0;
				Branchne = 1'b1;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b0;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end
			J : begin
				Signed   = 1'bX  ;
				RegDst   = 2'bXX;
				ALUOp    = 3'bXXX;
				ALUSrc   = 1'bX;
				Branch   = 1'bX;
				Branchne = 1'b0;
				MemRead  = 1'bX;
				MemWrite = 1'b0;
				RegWrite = 1'b0;
				MemtoReg = 2'bXX;
				Jump     = 1'b1;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end
			JAL : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b10;
				ALUOp    = 3'bXXX;
				ALUSrc   = 1'bX;
				Branch   = 1'bX;
				Branchne = 1'b0;
				MemRead  = 1'bX;
				MemWrite = 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 2'b10;
				Jump     = 1'b1;
				MemSign  = 1'bX;
				Long     = 2'bXX;
				Halt     = 1'b0;
			end

			HLT : begin
				Signed   = 1'b0  ;
				RegDst   = 2'b01;
				ALUOp    = 3'b011;
				ALUSrc   = 1'b0;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b0;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'b0;
				Long     = 2'b00;
				Halt     = 1'b1;
			end

			default : begin
				Signed   = 1'b0;
				RegDst   = 2'b00;
				ALUOp    = 3'b000;
				ALUSrc   = 1'b0;
				Branch   = 1'b0;
				Branchne = 1'b0;
				MemRead  = 1'b0;
				MemWrite = 1'b0;
				RegWrite = 1'b0;
				MemtoReg = 2'b00;
				Jump     = 1'b0;
				MemSign  = 1'b0;
				Long     = 2'b00;
				Halt     = 1'b0;
			end

		endcase

	end

	assign o_RegDst   = RegDst  ;
	assign o_ALUOp    = ALUOp   ;
	assign o_ALUSrc   = ALUSrc  ;
	assign o_Branch   = Branch  ;
	assign o_Branchne = Branchne;
	assign o_MemRead  = MemRead ;
	assign o_MemWrite = MemWrite;
	assign o_RegWrite = RegWrite;
	assign o_MemtoReg = MemtoReg;
	assign o_Jump     = Jump    ;
	assign o_Signed   = Signed  ;
	assign o_Long     = Long    ;
	assign o_MemSign  = MemSign ;
	assign o_Halt     = Halt    ;

endmodule