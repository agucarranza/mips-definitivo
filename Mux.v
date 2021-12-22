`timescale 1ns / 1ps

module Mux #(parameter BUS_SIZE = 32) (
	input  wire              i_Control,
	input  wire [BUS_SIZE-1:0] i_Input_0,
	input  wire [BUS_SIZE-1:0] i_Input_1,
	output wire [BUS_SIZE-1:0] o_Salida
);

	assign o_Salida = i_Control ? i_Input_1 : i_Input_0;

endmodule