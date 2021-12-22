`timescale 1ns / 1ps

module MEM_WB (
	input              clk               , // Clock
	input              rst               , // Asynchronous reset active low
	// Registers - IN
	input  wire [31:0] i_PC_Address      ,
	input  wire [31:0] i_ALUAddress      ,
	input  wire [31:0] i_Read_data       ,
	input  wire [ 4:0] i_MuxRegDst_result,
	// WB - Control - IN
	input  wire        i_RegWrite        ,
	input  wire [ 1:0] i_MemtoReg        ,
	input  wire        i_Halt            ,
	// Registers - OUT
	output wire [31:0] o_PC_Address      ,
	output wire [31:0] o_ALUAddress      ,
	output wire [31:0] o_Read_data       ,
	output wire [ 4:0] o_MuxRegDst_result,
	// WB - Control - OUT
	output wire        o_RegWrite        ,
	output wire [ 1:0] o_MemtoReg        ,
	output wire        o_Halt
);
	// Registers
	reg [31:0] PC_Address      ;
	reg [31:0] ALUAddress      ;
	reg [31:0] Read_data       ;
	reg [ 4:0] MuxRegDst_result;
	// Control
	reg       RegWrite;
	reg [1:0] MemtoReg;
	reg       Halt;

	

	always @(negedge clk) begin : proc_registers
		if(rst) begin
			RegWrite         <= 1'b0 ;
			MemtoReg         <= 2'b0 ;
			Halt             <= 1'b0 ;

			PC_Address       <= 32'b0;
			Read_data        <= 32'b0;
			ALUAddress       <= 32'b0;
			MuxRegDst_result <= 5'b0 ;
		end else begin
			RegWrite <= i_RegWrite;
			MemtoReg <= i_MemtoReg;
			Halt     <= i_Halt    ;

			PC_Address       <= i_PC_Address      ;
			Read_data        <= i_Read_data       ;
			ALUAddress       <= i_ALUAddress      ;
			MuxRegDst_result <= i_MuxRegDst_result;

		end
	end
	// Registers
	assign o_PC_Address       = PC_Address  ;
	assign o_Read_data        = Read_data;
	assign o_ALUAddress       = ALUAddress  ;
	assign o_MuxRegDst_result = MuxRegDst_result;
	// Control
	assign o_RegWrite = RegWrite   ;
	assign o_MemtoReg = MemtoReg   ;
	assign o_Halt     = Halt       ;

endmodule : MEM_WB

/*
Señales:

RegWrite
MemtoReg

PC_Address      
ALUAddress      
Read_data       
MuxRegDst_result
Halt
*/
