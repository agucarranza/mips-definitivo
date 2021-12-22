`timescale 1ns / 1ps

module IF_ID (
	input  wire        clk          , // Clock
	input  wire        rst          ,
	input  wire        i_IF_Flush   ,
	input  wire        i_Stall      ,
	input  wire        i_Halt       ,
	input  wire [31:0] i_PC_Address ,
	input  wire [31:0] i_Instruction,
	output wire [31:0] o_PC_Address ,
	output wire [31:0] o_Instruction
);

	reg [31:0] PC_Address ;
	reg [31:0] Instruction;

	always @(negedge clk) begin : proc_Registers
		if(rst) begin
			PC_Address  <= 32'b0;
			Instruction <= 32'b0;
		end else if (i_Stall || i_Halt) begin
			PC_Address  <= PC_Address;
			Instruction <= Instruction;
		end else if (i_IF_Flush) begin
			PC_Address  <= PC_Address;
			Instruction <= 32'b0;
		end else begin
			PC_Address  <= i_PC_Address;
			Instruction <= i_Instruction;
		end
	end

	assign o_Instruction = Instruction;
	assign o_PC_Address  = PC_Address;
endmodule

/*
Registros:

PC_Address
Instruction

IF_Flush
*/