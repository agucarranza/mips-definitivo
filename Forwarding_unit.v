module Forwarding_unit (
	input  wire [4:0] i_IDEX_RegisterRs ,
	input  wire [4:0] i_IDEX_RegisterRt ,
	input  wire       i_EXMEM_RegWrite  ,
	input  wire [4:0] i_EXMEM_RegisterRd,
	input  wire [4:0] i_MEMWB_RegisterRd,
	input  wire       i_MEMWB_RegWrite  ,
	output wire [1:0] o_ForwardA        ,
	output wire [1:0] o_ForwardB
);

	reg [1:0] ForwardA;
	reg [1:0] ForwardB;

	always @(*) begin : proc_ForwardA
		if (i_EXMEM_RegWrite
			&& (i_EXMEM_RegisterRd != 5'b0)
			&& (i_EXMEM_RegisterRd == i_IDEX_RegisterRs))
		ForwardA = 2'b10;
		else if (i_MEMWB_RegWrite
			&& (i_MEMWB_RegisterRd != 5'b0)
			&& (i_EXMEM_RegisterRd != i_IDEX_RegisterRs)
			&& (i_MEMWB_RegisterRd == i_IDEX_RegisterRs))
		ForwardA = 2'b01;
		else
			ForwardA = 2'b00;
	end

	always @(*) begin : proc_ForwardB
		if (i_EXMEM_RegWrite
			&& (i_EXMEM_RegisterRd != 5'b0)
			&& (i_EXMEM_RegisterRd == i_IDEX_RegisterRt))
		ForwardB = 2'b10;
		else if (i_MEMWB_RegWrite
			&& (i_MEMWB_RegisterRd != 5'b0)
			&& (i_EXMEM_RegisterRd != i_IDEX_RegisterRt)
			&& (i_MEMWB_RegisterRd == i_IDEX_RegisterRt))
		ForwardB = 2'b01;
		else
			ForwardB = 2'b00;
	end

	assign o_ForwardA = ForwardA;
	assign o_ForwardB = ForwardB;

endmodule