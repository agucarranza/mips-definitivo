`timescale 1ns / 1ps

module Registers (
	input  wire        i_clk            , // Clock
	input  wire        i_rst            ,
	input  wire        i_RegWrite       ,
	input  wire [ 4:0] i_Read_register_1,
	input  wire [ 4:0] i_Read_register_2,
	input  wire [ 4:0] i_Write_register ,
	input  wire [31:0] i_Write_data     ,
	output wire [31:0] o_Read_data_1    ,
	output wire [31:0] o_Read_data_2
);

	reg [31:0] registers  [0:31]; //Array se pone la cantidad, no los bits!!
	reg [31:0] Read_data_1      ;
	reg [31:0] Read_data_2      ;

	initial begin
		$readmemh("registers.mem",registers);
	end

//	always @(*) begin : proc_zero
//		registers[0] = 32'b0;
	
//	end

	always @(posedge i_clk) begin : proc_Read
		if(i_rst) begin
			Read_data_1 <= 0;
			Read_data_2 <= 0;
		end else begin
			Read_data_1 <= registers[i_Read_register_1];
			Read_data_2 <= registers[i_Read_register_2];
		end
	end

	assign o_Read_data_1 = Read_data_1;
	assign o_Read_data_2 = Read_data_2;

	always @(posedge i_clk) begin : proc_Write
		if(i_RegWrite && |i_Write_register) begin
			registers[i_Write_register] <= i_Write_data;
		end
	end
    
	
	
	integer i;
	always @(posedge i_clk) begin
		$display("Registros:");	
		for (i = 0; i < 32; i = i+1) begin
			$write("%h ",registers[i]);			
		end
		$display("");
	end


endmodule