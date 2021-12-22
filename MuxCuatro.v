`timescale 1ns / 1ps

module MuxCuatro #(parameter BUS_SIZE = 32) (
	input  wire [         1:0] i_Control,
	input  wire [BUS_SIZE-1:0] i_Input_0,
	input  wire [BUS_SIZE-1:0] i_Input_1,
	input  wire [BUS_SIZE-1:0] i_Input_2,
	input  wire [BUS_SIZE-1:0] i_Input_3,
	output wire [BUS_SIZE-1:0] o_Salida
);

	reg [BUS_SIZE-1:0] registro;

	always @(*) begin
		case (i_Control)
			2'b00   : registro = i_Input_0;
			2'b01   : registro = i_Input_1;
			2'b10   : registro = i_Input_2;
			2'b11   : registro = i_Input_3;
			default :
				registro = i_Input_0;
		endcase
	end

	assign o_Salida = registro;
	
endmodule