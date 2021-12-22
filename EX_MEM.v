`timescale 1ns / 1ps

module EX_MEM (
	input              clk               , // Clock
	input              rst               , // Asynchronous reset active low
	// Registers - IN
	input  wire [31:0] i_PC_Address      ,
	input  wire [31:0] i_ALU_result      ,
	input  wire [31:0] i_Read_data_2     ,
	input  wire [ 4:0] i_MuxRegDst_result,
	// WB - Control - IN
	input  wire        i_RegWrite        ,
	input  wire [ 1:0] i_MemtoReg        ,
	input  wire        i_Halt            ,
	// M - Control - IN
	input  wire        i_MemRead         ,
	input  wire        i_MemWrite        ,
	input  wire [ 1:0] i_Long            ,
	input  wire        i_MemSign         ,
	// Registers - OUT
	output wire [31:0] o_PC_Address      ,
	output wire [31:0] o_ALU_result      ,
	output wire [31:0] o_Read_data_2     ,
	output wire [ 4:0] o_MuxRegDst_result,
	// WB - Control - OUT
	output wire        o_RegWrite        ,
	output wire [ 1:0] o_MemtoReg        ,
	output  wire        o_Halt            ,
	// M - Control - OUT
	output wire        o_MemRead         ,
	output wire        o_MemWrite        ,
	output wire [ 1:0] o_Long            ,
	output wire        o_MemSign
);
	// Registers
	reg [31:0] PC_Address      ;
	reg [31:0] ALU_result      ;
	reg [31:0] Read_data_2     ;
	reg [ 4:0] MuxRegDst_result;
	// Control
	reg       RegWrite;
	reg [1:0] MemtoReg;
	reg       MemRead ;
	reg       MemWrite;
	reg       Halt    ;
	reg [1:0] Long    ;
	reg       MemSign ;

	always @(negedge clk) begin : proc_Registers
		if(rst) begin
			PC_Address       <= 32'b0;
			ALU_result       <= 32'b0;
			Read_data_2      <= 32'b0;
			MuxRegDst_result <= 5'b0 ;

			RegWrite         <= 1'b0 ;
		    MemtoReg         <= 2'b0 ;
		    MemWrite         <= 1'b0 ;
		    Halt             <= 1'b0 ;

		    MemRead          <= 1'b0 ;
		    Long             <= 2'b0 ;
		    MemSign          <= 1'b0 ;

		end else begin
			// Registers
			PC_Address       <= i_PC_Address       ;
			ALU_result       <= i_ALU_result       ;
			Read_data_2      <= i_Read_data_2      ;
			MuxRegDst_result <= i_MuxRegDst_result ;
			// Control
			RegWrite         <= i_RegWrite   ;
			MemtoReg         <= i_MemtoReg   ;
			Halt             <= i_Halt       ;

			MemRead  <= i_MemRead  ;
			MemWrite <= i_MemWrite ;
			Long     <= i_Long     ;
			MemSign  <= i_MemSign  ;
		end
	end


	// Registers
	assign o_PC_Address       = PC_Address ;
	assign o_ALU_result       = ALU_result ;
	assign o_Read_data_2      = Read_data_2;
	assign o_MuxRegDst_result = MuxRegDst_result;
	// Control
	assign o_RegWrite = RegWrite   ;
	assign o_MemtoReg = MemtoReg   ;
	assign o_Halt     = Halt       ;

	assign o_MemRead  = MemRead    ;
	assign o_MemWrite = MemWrite   ;
	assign o_Long     = Long       ;
	assign o_MemSign  = MemSign    ;

endmodule : EX_MEM

/*
Señales:

PC_Address
ALU_result
Read_data_2
MuxRegDst_result

RegWrite
MemtoReg
MemRead
Halt
MemWrite
Long
MemSign
*/