`timescale 1ns / 1ps

module JR_Control (
	input  wire [2:0] i_AluOp        ,
	input  wire [5:0] i_Function_code,
	output wire       o_JR_Control   ,
	output wire       o_JALR_Control
);

	localparam JR    = 6'b001000;
	localparam JALR  = 6'b001001;
	localparam ALUOP = 3'b011   ;

	reg JRControl   = 1'b0;
	reg JALR_Control = 1'b0;

	always @(*) begin : proc_
		casez ({i_AluOp,i_Function_code})

			{ALUOP,JR}: begin
				JRControl   = 1'b1;
				JALR_Control = 1'b0;
			end

			{ALUOP,JALR}: begin
				JRControl   = 1'b1;
				JALR_Control = 1'b1;
			end

			default :
				begin
					JRControl   = 1'b0;
					JALR_Control = 1'b0;
				end
		endcase

	end

	assign o_JR_Control   = JRControl;
	assign o_JALR_Control = JALR_Control;

endmodule