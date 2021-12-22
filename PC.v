`timescale 1ns / 1ps

module PC (
	input  wire        i_clk    ,
	input  wire        i_rst    ,
	input  wire        i_Stall  ,
	input  wire        i_Halt   ,
	input  wire [31:0] i_address,
	output wire [31:0] o_address,
	output wire [31:0] o_clk_counter
);

	reg [31:0] ProgCounter;
	//debug
	reg [31:0] clk_counter;
	reg        Disable     ;

	
	always @(posedge i_clk) begin
		if (i_rst) begin
			ProgCounter <= 32'b0;
			clk_counter <= 32'b0;
			Disable      <= 1'b0 ;
		end else if (i_Halt) begin
			ProgCounter <= ProgCounter;
			Disable     <= 1'b1;
		end else if (~i_Stall && ~Disable)
			ProgCounter <= i_address;		
	end

	always @(posedge i_clk) begin : proc_clk_counter
		if (i_rst)
			clk_counter <= 32'b0;
		else 
			clk_counter <= clk_counter + 32'b1;
	end
	

	assign o_address = ProgCounter;
	assign o_clk_counter = clk_counter;

	always @(posedge i_clk) begin 
		$display("PC       : %d",ProgCounter);
		$display("CLK_COUNT: %d",clk_counter);
	end

endmodule
