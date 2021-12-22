`timescale 1ns / 1ps

module BranchForwarding (
	input  wire       i_IDEX_RegWrite   ,
	input  wire       i_EXMEM_RegWrite  ,
	input  wire       i_MEMWB_RegWrite  ,
	input  wire [4:0] i_IDEX_RegisterRD ,
	input  wire [4:0] i_EXMEM_RegisterRD,
	input  wire [4:0] i_MEMWB_RegisterRD,
	input  wire [4:0] i_Rs              ,
	input  wire [4:0] i_Rt              ,
	output wire [1:0] o_ForwardA        ,
	output wire [1:0] o_ForwardB
);

	localparam DEF = 2'b00;
	localparam EX  = 2'b01;
	localparam MEM = 2'b10;
	localparam WB  = 2'b11;


	reg [1:0] ForwardA;
	reg [1:0] ForwardB;

	// FORWARD A
	always @(*) begin
		// EX
		if (i_IDEX_RegWrite && (i_IDEX_RegisterRD == i_Rs))
			ForwardA = EX;
		// MEM
		else if (i_EXMEM_RegWrite && (i_EXMEM_RegisterRD == i_Rs))
			ForwardA = MEM;
		// WB
		else if (i_MEMWB_RegWrite && (i_MEMWB_RegisterRD == i_Rs))
			ForwardA = WB;
		else
			ForwardA = DEF;
	end

	// FORWARD B
	always @(*) begin
		// EX
		if (i_IDEX_RegWrite && (i_IDEX_RegisterRD == i_Rt))
			ForwardB = EX;
		// MEM
		else if (i_EXMEM_RegWrite && (i_EXMEM_RegisterRD == i_Rt))
			ForwardB = MEM;
		// WB
		else if (i_MEMWB_RegWrite && (i_MEMWB_RegisterRD == i_Rt))
			ForwardB = WB;
		else
			ForwardB = DEF;
	end

	assign o_ForwardA = ForwardA;
	assign o_ForwardB = ForwardB;

endmodule