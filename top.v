`timescale 1ns / 1ps


module top (
	input  wire i_clk      , // Clock
	input  wire i_rst      , // Asynchronous reset active low
	input  wire i_step     ,
	input  wire i_serial_rx,
	output wire o_serial_tx
);

	wire stable_clk;
	wire locked    ;
	wire mips_rst  ;

	wire step;

	wire        tx_start                ;
	wire [31:0] bus_tx                  ;
	wire [31:0] bus_rx                  ;
	wire        tx_done                 ;
	wire        rx_done                 ;
	wire [31:0] debug_clk_counter       ;
	wire [31:0] debug_pc                ;
	wire        debug_halt              ;
	wire [31:0] debug_registersA_data   ;
	wire [ 4:0] debug_registersA_address;
	wire        debug_load_enable       ;
	wire [31:0] debug_memory_data       ;	
	wire [31:0] debug_memory_addr       ;
	wire [31:0] debug_instruction_addr  ;
	wire [31:0] debug_instruction_data  ;

	assign mips_rst = ~( ~i_rst & locked );   // reset active low mips

	MIPS i_MIPS (
		.clk                       (stable_clk              ),
		.rst                       (mips_rst                ),
		.o_debug_halt              (debug_halt              ),
		.o_debug_pc                (debug_pc                ),
		.o_clk_counter             (debug_clk_counter       ),
		.o_debug_registersA_data   (debug_registersA_data   ),
		.i_debug_registersA_address(debug_registersA_address),
		.i_debug_memory_data       (debug_memory_data       ),
		.o_debug_memory_addr       (debug_memory_addr       ),
		.i_InstMem_Load_enable     (debug_load_enable       ),
		.i_InstMem_Write_reg       (debug_instruction_addr  ),
		.i_InstMem_Write_data      (debug_instruction_data  )
	);

	clk_wiz_0 my_clk_wzr (
		.clk_in1 (i_clk     ), //in
		.reset   (i_rst     ), //in
		.clk_out1(stable_clk), //out
		.locked  (locked    )  //out
	);

endmodule
