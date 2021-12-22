`timescale 1ns / 1ps

module ALU_control (
	input  wire [2:0] i_ALUOp        ,
	input  wire [5:0] i_Function_code,
	output wire [3:0] o_Operation
);

	reg [3:0] Operation;

	localparam F_SLL  = 9'b011_000000;
	localparam F_SRL  = 9'b011_000010;
	localparam F_SRA  = 9'b011_000011;
	localparam F_SLLV = 9'b011_000100;
	localparam F_SRLV = 9'b011_000110;
	localparam F_SRAV = 9'b011_000111;
	localparam F_ADDU = 9'b011_100001;
	localparam F_SUBU = 9'b011_100011;
	localparam F_AND  = 9'b011_100100;
	localparam F_OR   = 9'b011_100101;
	localparam F_XOR  = 9'b011_100110;
	localparam F_NOR  = 9'b011_100111;
	localparam F_SLT  = 9'b011_101010;
	localparam F_JALR = 9'b011_001001; // JALR
	// LB, LH, LW, LWU, LBU, LHU, SB, SH, SW, ADDI
	localparam F_LOADS = 9'b000_??????;
	localparam F_ANDI  = 9'b100_??????;
	localparam F_ORI   = 9'b101_??????;
	localparam F_XORI  = 9'b110_??????;
	localparam F_LUI   = 9'b111_??????;
	localparam F_SLTI  = 9'b010_??????;
	// BEQ, BNE
	localparam F_BEQ = 9'b001_??????;
	//localparam F_J     = 9'b???_??????;
	//localparam F_JAL   = 9'b???_??????;
	//localparam F_HLT   = 9'b???_??????;

	localparam OUT_SLL  = 4'b0000;
	localparam OUT_SRL  = 4'b0001;
	localparam OUT_SRA  = 4'b0010;
	localparam OUT_SLLV = 4'b0011;
	localparam OUT_SRLV = 4'b0100;
	localparam OUT_SRAV = 4'b0101;
	localparam OUT_ADDU = 4'b0110;
	localparam OUT_SUBU = 4'b0111;
	localparam OUT_AND  = 4'b1000;
	localparam OUT_OR   = 4'b1001;
	localparam OUT_XOR  = 4'b1010;
	localparam OUT_NOR  = 4'b1011;
	localparam OUT_SLT  = 4'b1100;
	localparam OUT_JALR = 4'b1101;
	localparam OUT_LUI  = 4'b1110;

	always @(*) begin

		casez ({{i_ALUOp,i_Function_code}})

			F_SLL   : Operation = OUT_SLL ;
			F_SRL   : Operation = OUT_SRL ;
			F_SRA   : Operation = OUT_SRA ;
			F_SLLV  : Operation = OUT_SLLV;
			F_SRLV  : Operation = OUT_SRLV;
			F_SRAV  : Operation = OUT_SRAV;
			F_ADDU  : Operation = OUT_ADDU;
			F_SUBU  : Operation = OUT_SUBU;
			F_AND   : Operation = OUT_AND ;
			F_OR    : Operation = OUT_OR  ;
			F_XOR   : Operation = OUT_XOR ;
			F_NOR   : Operation = OUT_NOR ;
			F_SLT   : Operation = OUT_SLT ;
			F_LOADS : Operation = OUT_ADDU;
			F_ANDI  : Operation = OUT_AND ;
			F_ORI   : Operation = OUT_OR  ;
			F_XORI  : Operation = OUT_XOR ;
			F_LUI   : Operation = OUT_LUI ;
			F_SLTI  : Operation = OUT_SLT ;
			F_BEQ   : Operation = OUT_SUBU;
			F_JALR  : Operation = OUT_JALR;

			default : Operation = 4'b0000 ;
		endcase
	end

	assign o_Operation = Operation;

endmodule