`timescale 1ns / 1ps

module ALU (
	input  wire [ 3:0] i_Control   ,
	input  wire [31:0] i_Data_1    , // [25:21] rs
	input  wire [31:0] i_Data_2    , // [20:16] rt
	input  wire [ 4:0] i_Shamt     , // [10:06] shamt
	output wire [31:0] o_ALU_Result
);

	localparam SLL  = 4'b0000;
	localparam SRL  = 4'b0001;
	localparam SRA  = 4'b0010;
	localparam SLLV = 4'b0011;
	localparam SRLV = 4'b0100;
	localparam SRAV = 4'b0101;
	localparam ADDU = 4'b0110;
	localparam SUBU = 4'b0111;
	localparam AND  = 4'b1000;
	localparam OR   = 4'b1001;
	localparam XOR  = 4'b1010;
	localparam NOR  = 4'b1011;
	localparam SLT  = 4'b1100;
	localparam JALR = 4'b1101;
	localparam LUI  = 4'b1110;

	reg [31:0] ALU_register;

	assign o_ALU_Result = ALU_register;


	always @(*) begin : proc_Operation

		case (i_Control)

			SLL  : ALU_register =   i_Data_2 <<  i_Shamt;
			SRL  : ALU_register =   i_Data_2 >>  i_Shamt;
			SRA  : ALU_register =   $signed(i_Data_2) >>> $signed(i_Shamt);
			SLLV : ALU_register =   i_Data_2 <<  i_Data_1[4:0];
			SRLV : ALU_register =   i_Data_2 >>  i_Data_1[4:0];
			SRAV : ALU_register =   $signed(i_Data_2) >>> $signed(i_Data_1[4:0]);
			ADDU : ALU_register =   i_Data_1  +  i_Data_2;
			SUBU : ALU_register =   i_Data_1  -  i_Data_2;
			AND  : ALU_register =   i_Data_1  &  i_Data_2;
			OR   : ALU_register =   i_Data_1  |  i_Data_2;
			XOR  : ALU_register =   i_Data_1  ^  i_Data_2;
			NOR  : ALU_register = ~(i_Data_1  |  i_Data_2);
			SLT  : ALU_register =   i_Data_1  <  i_Data_2 ? 32'b1 : 32'b0;
			JALR : ALU_register =   i_Data_1  +  1'b1;
			LUI  : ALU_register =   i_Data_2 <<  16;

			default : ALU_register = 32'b0;

		endcase
	end
endmodule