`timescale 1ns / 1ps



module tb_mips ();

	reg clk        ;
	reg rst        ;
	reg step       ;
	reg serial_rx  ;

	initial begin
		rst= 1'b1;
		clk= 1'b1;
		step=1'b0;
		serial_rx=1'b1;


		#160
			rst = 1'b0;
	end

	always #10 clk = ~clk;


	top i_top (
		.i_clk(clk),
		.i_rst(rst),
		.i_step(step),
		.i_serial_rx(serial_rx)
	);

endmodule