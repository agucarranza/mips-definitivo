`timescale 1ns / 1ps

module Data_memory (
	input  wire        i_clk       , // Clock
	input  wire        i_rst       , // Asynchronous reset active low
	input  wire [31:0] i_Address   , // El warning es porque no uso todas las lineas de dirección.
	input  wire [31:0] i_Write_data,
	input  wire        i_MemWrite  ,
	input  wire        i_MemRead   ,
	input  wire [ 1:0] i_Long      ,
	input  wire        i_MemSign   ,
	output wire [31:0] o_Read_data
);

	reg [31:0] data[0:31];
	
	reg [31:0] tmp_read         ;
	reg [31:0] tmp_write        ;


	initial begin
		$readmemh("data_memory.mem",data);
	end


	always @(posedge i_clk) begin : proc_read
		if(i_rst) begin
			tmp_read <= 32'b0;
		end else begin
			if (i_MemRead) begin : read_flag
				tmp_read <= data[i_Address];
			end
		end
	end

	wire [23:0] extension24; 
	assign extension24 = (i_MemSign) ? {24{tmp_read[ 7]}} : 24'b0; 
	
	wire [15:0] extension16;
	assign extension16 = (i_MemSign) ? {16{tmp_read[15]}} : 16'b0;

	assign o_Read_data = (i_Long == 2'b00) ? { extension24 ,tmp_read[ 7:0] } :
						 (i_Long == 2'b01) ? { extension16 ,tmp_read[15:0] } :
						 tmp_read;


	wire [31:0] writing_reg = data[i_Address]                    ; 
//	wire [31:8] writing_reg = data[i_Address] [31:8]             ; //aca se podria corregir asi, hay que probar
	
	wire [31:0] v_byte      = {writing_reg[31: 8], i_Write_data[ 7:0]};
	wire [31:0] v_hw        = {writing_reg[31:16], i_Write_data[15:0]};


	always @(posedge i_clk) begin : proc_write
		if(i_MemWrite) begin

			case (i_Long)

				2'b00 : data[i_Address] <= v_byte;
				2'b01 : data[i_Address] <= v_hw;
				2'b11 : data[i_Address] <= i_Write_data;

				default : data[i_Address] <= i_Write_data;
			endcase
		end
	end
	
	
    integer i;
	always @(posedge i_clk) begin
		$display("Memoria de datos1");
		
		// foreach (data[i])
		for (i = 0; i < 32; i = i+1) begin
			$write("%h ",data[i]);			
		end
		$display("");
	end

endmodule