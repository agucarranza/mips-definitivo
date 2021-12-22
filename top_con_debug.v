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


	uart #(.NB_DATA(16)) i_uart (
		.i_clk     (stable_clk ),
		.i_reset   (mips_rst   ),
		.i_rx      (i_serial_rx),
		.i_tx_start(tx_start   ),
		.i_tx      (bus_tx     ),
		.o_tx      (o_serial_tx),
		.o_tx_done (tx_done    ),
		.o_rx_done (rx_done    ),
		.o_rx      (bus_rx     )
	);


	debugUnit i_debugUnit (
		.i_clk                     (stable_clk              ),
		.i_rst                     (mips_rst                ),
		.i_step                    (step                    ),
		.o_debug_step              (o_debug_step            ),
		// TX
		.i_debug_Halt              (debug_halt              ),
		.i_debug_clk_counter       (debug_clk_counter       ),
		.i_debug_PC                (debug_pc                ),
		.i_debug_memory_data       (debug_memory_data       ),
		.i_debug_registersA_data   (debug_registersA_data   ),
		.i_debug_tx_done           (tx_done                 ),
		.o_debug_tx_start          (tx_start                ),
		.o_debug_registersA_address(debug_registersA_address),
		.o_debug_uart_tx           (bus_tx                  ),
		// RX
		.o_debug_memory_address    (debug_memory_addr       ),
		.i_debug_rx_done           (rx_done                 ),
		.i_debug_rx                (bus_rx                  ),
		.o_debug_loading           (debug_load_enable       ),
		.o_debug_instruction_addr  (debug_instruction_addr  ),
		.o_debug_instruction_data  (debug_instruction_data  )
	);

endmodule
