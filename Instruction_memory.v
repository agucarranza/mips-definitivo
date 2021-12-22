`timescale 1ns / 1ps

module Instruction_memory (
	input  wire        i_clk         ,
	input  wire        i_rst         ,
	input  wire [31:0] i_Read_address, //el warning es porque no uso todos los bits
	input  wire        i_Load_enable ,
	input  wire [31:0] i_Write_reg   ,
	input  wire [31:0] i_Write_data  ,
	output wire [31:0] o_Instruction
	);

	reg [31:0] memory[0:31];
	reg [31:0] tmp           ;

	initial begin
		// Relleno del Pipeline
		$readmemb("instructions.mem",memory);
	end

	//Leer

	always @(posedge i_clk) begin : proc_read
		if (i_rst) begin
			tmp <= 32'b0;
		end else begin
			tmp <= memory[i_Read_address];
		end
	end



	//Escribir

	always @(negedge i_clk) begin : proc_write
		if(i_Load_enable) begin
			memory[i_Write_reg] <= i_Write_data;
		end
	end
	
	
    integer i;
	always @(posedge i_clk) begin
		$display("INSTRUCCIONES:");
		
		for (i = 0; i < 32; i = i+1) begin
			$write("%h ",memory[i]);			
		end
		$display("");
	end

	assign o_Instruction = tmp;
endmodule