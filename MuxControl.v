`timescale 1ns / 1ps

module MuxControl (
	input  wire       i_StallControl, // Positivo, manda 0. Negativo manda senal.
	input  wire [1:0] i_RegDst      ,
	input  wire [2:0] i_ALUOp       ,
	input  wire       i_ALUSrc      ,
	input  wire       i_Branch      ,
	input  wire       i_Branchne    ,
	input  wire       i_MemRead     ,
	input  wire       i_MemWrite    ,
	input  wire       i_RegWrite    ,
	input  wire [1:0] i_MemtoReg    ,
	input  wire       i_Jump        ,
	input  wire       i_Signed      ,
	input  wire [1:0] i_Long        ,
	input  wire       i_MemSign     ,
	input  wire       i_Halt        ,
	output wire [1:0] o_RegDst      ,
	output wire [2:0] o_ALUOp       ,
	output wire       o_ALUSrc      ,
	output wire       o_Branch      ,
	output wire       o_Branchne    ,
	output wire       o_MemRead     ,
	output wire       o_MemWrite    ,
	output wire       o_RegWrite    ,
	output wire [1:0] o_MemtoReg    ,
	output wire       o_Jump        ,
	output wire       o_Signed      ,
	output wire [1:0] o_Long        ,
	output wire       o_MemSign     ,
	output wire       o_Halt
);

assign o_RegDst   = i_StallControl ? 2'b0 : i_RegDst  ;
assign o_ALUOp    = i_StallControl ? 3'b0 : i_ALUOp   ;
assign o_ALUSrc   = i_StallControl ? 1'b0 : i_ALUSrc  ;
assign o_Branch   = i_StallControl ? 1'b0 : i_Branch  ;
assign o_Branchne = i_StallControl ? 1'b0 : i_Branchne;
assign o_MemRead  = i_StallControl ? 1'b0 : i_MemRead ;
assign o_MemWrite = i_StallControl ? 1'b0 : i_MemWrite;
assign o_RegWrite = i_StallControl ? 1'b0 : i_RegWrite;
assign o_MemtoReg = i_StallControl ? 2'b0 : i_MemtoReg;
assign o_Jump     = i_StallControl ? 1'b0 : i_Jump    ;
assign o_Signed   = i_StallControl ? 1'b0 : i_Signed  ;
assign o_Long     = i_StallControl ? 2'b0 : i_Long    ;
assign o_MemSign  = i_StallControl ? 1'b0 : i_MemSign ;
assign o_Halt     = i_StallControl ? 1'b0 : i_Halt    ;

endmodule