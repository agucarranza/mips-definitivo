`timescale 1ns / 1ps

module Add (
	input  wire  [31:0] i_Operand_0,
	input  wire  [31:0] i_Operand_1,
	output wire  [31:0] o_Add_result
);

assign o_Add_result = i_Operand_1 + i_Operand_0;

endmodule