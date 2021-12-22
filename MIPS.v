`timescale 1ns / 1ps

module MIPS
	(
		input clk, // Clock
		input rst,  // Asynchronous reset active low
		output wire o_debug_halt,
		input wire [4:0] i_debug_registersA_address, // numero de registro que quiero
		output wire [31:0] o_debug_registersA_data, // el registro con la direccion dada
		output  wire [31:0] o_clk_counter,
		input wire [31:0] i_debug_memory_data,
		output wire [31:0] o_debug_memory_addr,
		output wire [31:0] o_debug_pc,
		//rx
		input wire        i_InstMem_Load_enable,
		input wire [31:0] i_InstMem_Write_reg  ,
		input wire [31:0] i_InstMem_Write_data  

	);

//debug
wire [31:0] clk_counter;



// Control
wire       Branch      ;
wire       RegWrite    ;
wire [1:0] RegDst      ;
wire       ALUSrc      ;
wire [2:0] ALUOp       ;
wire       MemWrite    ;
wire       MemRead     ;
wire [1:0] MemtoReg    ;
wire       JARL_Control;

wire       SignZero ;
wire       Jump     ;
wire       JRControl;
wire [1:0] Long     ;
wire       MemSign  ;

wire [1:0] ID_RegDst      ;
wire [2:0] ID_ALUOp       ;
wire       ID_ALUSrc      ;
wire       ID_Branch      ;
wire       ID_Branchne    ;
wire       ID_MemRead     ;
wire       ID_MemWrite    ;
wire       ID_RegWrite    ;
wire       ID_Halt        ;
wire [1:0] ID_MemtoReg    ;
wire [1:0] ID_Long        ;
wire       ID_MemSign     ;
wire       ID_JALR_Control;
wire       EX_MemRead     ;
wire       EX_MemWrite    ;
wire       EX_Halt        ;
wire       EX_RegWrite    ;
wire [1:0] EX_MemtoReg    ;
wire [1:0] EX_Long        ;
wire       EX_MemSign     ;
wire       MEM_RegWrite   ;
wire [1:0] MEM_MemtoReg   ;
wire       MEM_Halt       ;

// En espera
wire Halt;

// IF
wire [31:0] PC_to_AddPC_to_InstMem    ;
wire [31:0] MuxJR_to_PC               ;
wire [31:0] InstMem_to_IFID           ; // Salida Memoria de Instrucciones
wire [31:0] AddPC_to_MuxBranch_to_IFID; // Salida AddPC
wire [31:0] Add_to_MuxBranch_PCAddress;
wire [31:0] MuxBranch_to_MuxJump0     ;
wire [31:0] MuxJump_to_MuxJR0         ;

wire IF_Flush;

// ID
wire [31:0] Instruction                                      ;
wire [ 4:0] MEMWB_to_Registers_WriteRegister                 ;
wire [31:0] MuxMemtoReg_to_Registers_WriteData               ;
wire [31:0] IFID_to_IDEX_to_Add_PCAddress                    ;
wire [31:0] Registers_to_IDEX_to_MuxJR_ReadData1             ;
wire [31:0] Registers_to_IDEX_ReadData2                      ;
wire [31:0] MuxSignZero_to_IDEX_to_Add_to_JRControl_Immediate;
wire [31:0] IFID_to_MuxJump_PCAddress                        ;
wire        Comparador                                       ;
// EX
wire [31:0] IDEX_to_MuxJALR_to_EXMEM_PCAddress              ;
wire [31:0] IDEX_to_MuxForwardA_ReadData1                   ;
wire [31:0] IDEX_to_MuxALUSrc_to_EXMEM_ReadData2            ;
wire [ 4:0] IDEX_to_MuxRegDst_rt_0                          ;
wire [ 4:0] IDEX_to_MuxRegDst_rd_1                          ;
wire [ 4:0] IDEX_to_Forwarding_rs                           ;
wire [31:0] IDEX_to_ALUControl_to_Add_to_MuxALUSrc_Immediate;
wire [31:0] MuxALUSrc_to_ALU_Operand2                       ;
wire [ 3:0] ALUControl_to_ALU_Operation                     ;
wire [31:0] ALU_to_EXMEM_ALUResult                          ;
wire [ 4:0] MuxRegDst_to_EXMEM_Result                       ;
wire [31:0] MuxJALR_to_ALU_Operand1                         ;
// MEM
wire [31:0] EXMEM_to_DataMem_to_MEMWB_ALUAddress;
wire [31:0] EXMEM_to_MEMWB_PC_Address           ;
wire [31:0] EXMEM_to_DataMem_WriteData          ;
wire [ 4:0] EXMEM_to_MEMWB_Result               ;
wire [31:0] DataMem_to_MEMWB_ReadData           ;
// WB
wire [31:0] MEMWB_to_MuxMemtoReg_ReadData  ;
wire [31:0] MEMWB_to_MuxMemtoReg_ALUAddress;
wire [31:0] MEMWB_to_MuxMemtoReg_PC_Address;


// IF

Mux i_Mux_Branch (
	.i_Control(Branch                    ),
	.i_Input_0(AddPC_to_MuxBranch_to_IFID),
	.i_Input_1(Add_to_MuxBranch_PCAddress),
	.o_Salida (MuxBranch_to_MuxJump0     )
);

Mux i_Mux_Jump_JAL (
	.i_Control(Jump                     ),
	.i_Input_0(MuxBranch_to_MuxJump0    ),
	.i_Input_1(IFID_to_MuxJump_PCAddress),
	.o_Salida (MuxJump_to_MuxJR0        )
);

Mux i_Mux_JR (
	.i_Control(JRControl                           ),
	.i_Input_0(MuxJump_to_MuxJR0                   ),
	.i_Input_1(Registers_to_IDEX_to_MuxJR_ReadData1),
	.o_Salida (MuxJR_to_PC                         )
);

wire Stall;

PC i_PC (
	.i_clk    (clk                   ),
	.i_rst    (rst                   ),
	.i_Stall  (Stall                ),
	.i_Halt   (Halt                  ),
	.i_address(MuxJR_to_PC           ),
	.o_address(PC_to_AddPC_to_InstMem),
	.o_clk_counter(clk_counter)

);

Add i_AddPC (
	.i_Operand_0 (PC_to_AddPC_to_InstMem    ),
	.i_Operand_1 (32'd1                     ),
	.o_Add_result(AddPC_to_MuxBranch_to_IFID)
);

Instruction_memory i_Instruction_memory (
	.i_clk         (clk                   ),
	.i_rst         (rst                   ),
	.i_Read_address(PC_to_AddPC_to_InstMem),
	.o_Instruction (InstMem_to_IFID       ),
	.i_Load_enable (i_InstMem_Load_enable   ),
	.i_Write_reg   (i_InstMem_Write_reg     ),
	.i_Write_data  (i_InstMem_Write_data    )
);

assign IF_Flush = Branch | Jump | JRControl;


IF_ID i_IF_ID (
	.clk          (clk                          ),
	.rst          (rst                          ),
	.i_IF_Flush   (IF_Flush                     ),
	.i_Stall      (Stall                        ),
	.i_Halt       (Halt                         ),
	.i_PC_Address (AddPC_to_MuxBranch_to_IFID   ),
	.i_Instruction(InstMem_to_IFID              ),
	.o_PC_Address (IFID_to_IDEX_to_Add_PCAddress),
	.o_Instruction(Instruction                  )
);

// ID

Hazard_detec_unit i_Hazard_detec_unit (
	.i_IDEX_MemRead   (EX_MemRead            ),
	.i_IFID_RegisterRs(Instruction[25:21]    ),
	.i_IFID_RegisterRt(Instruction[20:16]    ),
	.i_IDEX_RegisterRt(IDEX_to_MuxRegDst_rt_0),
	.o_Stall          (Stall                 )
);

wire [31:0] ID_A;
wire [31:0] ID_B;

assign IFID_to_MuxJump_PCAddress = {IFID_to_IDEX_to_Add_PCAddress[31:26], Instruction[25:0]};

Registers i_Registers (
	.i_clk            (clk                               ),
	.i_rst            (rst                               ),
	.i_RegWrite       (RegWrite                          ),
	.i_Read_register_1(Instruction[25:21]                ),
	.i_Read_register_2(Instruction[20:16]                ),
	.i_Write_register (MEMWB_to_Registers_WriteRegister  ),
	.i_Write_data     (MuxMemtoReg_to_Registers_WriteData),
	.o_Read_data_1    (ID_A                              ),
	.o_Read_data_2    (ID_B                              )
);


wire [1:0] ID_BranchForwardA;
wire [1:0] ID_BranchForwardB;




BranchForwarding i_BranchForwarding (
	.i_IDEX_RegWrite   (EX_RegWrite                     ),
	.i_EXMEM_RegWrite  (MEM_RegWrite                    ),
	.i_MEMWB_RegWrite  (RegWrite                        ),
	.i_IDEX_RegisterRD (MuxRegDst_to_EXMEM_Result       ),
	.i_EXMEM_RegisterRD(EXMEM_to_MEMWB_Result           ),
	.i_MEMWB_RegisterRD(MEMWB_to_Registers_WriteRegister),
	.i_Rs              (Instruction[25:21]              ),
	.i_Rt              (Instruction[20:16]              ),
	.o_ForwardA        (ID_BranchForwardA               ),
	.o_ForwardB        (ID_BranchForwardB               )
);



MuxCuatro i_MuxA (
	.i_Control(ID_BranchForwardA                   ),
	.i_Input_0(ID_A                                ),
	.i_Input_1(ALU_to_EXMEM_ALUResult              ),
	.i_Input_2(DataMem_to_MEMWB_ReadData           ),
	.i_Input_3(MuxMemtoReg_to_Registers_WriteData  ),
	.o_Salida (Registers_to_IDEX_to_MuxJR_ReadData1)
);

MuxCuatro i_MuxB (
	.i_Control(ID_BranchForwardB                 ),
	.i_Input_0(ID_B                              ),
	.i_Input_1(ALU_to_EXMEM_ALUResult            ),
	.i_Input_2(DataMem_to_MEMWB_ReadData         ),
	.i_Input_3(MuxMemtoReg_to_Registers_WriteData),
	.o_Salida (Registers_to_IDEX_ReadData2       )
);

assign Comparador = (Registers_to_IDEX_to_MuxJR_ReadData1 == Registers_to_IDEX_ReadData2);




wire [1:0] MuxControl_RegDst      ;
wire [2:0] MuxControl_ALUOp       ;
wire       MuxControl_ALUSrc      ;
wire       MuxControl_Branch      ;
wire       MuxControl_Branchne    ;
wire       MuxControl_MemRead     ;
wire       MuxControl_MemWrite    ;
wire       MuxControl_RegWrite    ;
wire [1:0] MuxControl_MemtoReg    ;
wire       MuxControl_Jump        ;
wire       MuxControl_Signed      ;
wire [1:0] MuxControl_Long        ;
wire       MuxControl_MemSign     ;
wire       MuxControl_Halt        ;


MuxControl i_MuxControl (
	.i_StallControl(Stall),
	.i_RegDst      (MuxControl_RegDst      ),
	.i_ALUOp       (MuxControl_ALUOp       ),
	.i_ALUSrc      (MuxControl_ALUSrc      ),
	.i_Branch      (MuxControl_Branch      ),
	.i_Branchne    (MuxControl_Branchne    ),
	.i_MemRead     (MuxControl_MemRead     ),
	.i_MemWrite    (MuxControl_MemWrite    ),
	.i_RegWrite    (MuxControl_RegWrite    ),
	.i_MemtoReg    (MuxControl_MemtoReg    ),
	.i_Jump        (MuxControl_Jump        ),
	.i_Signed      (MuxControl_Signed      ),
	.i_Long        (MuxControl_Long        ),
	.i_MemSign     (MuxControl_MemSign     ),
	.i_Halt        (MuxControl_Halt        ),
	.o_RegDst      (ID_RegDst              ),
	.o_ALUOp       (ID_ALUOp               ),
	.o_ALUSrc      (ID_ALUSrc              ),
	.o_Branch      (ID_Branch              ),
	.o_Branchne    (ID_Branchne            ),
	.o_MemRead     (ID_MemRead             ),
	.o_MemWrite    (ID_MemWrite            ),
	.o_RegWrite    (ID_RegWrite            ),
	.o_MemtoReg    (ID_MemtoReg            ),
	.o_Jump        (Jump                   ),
	.o_Signed      (SignZero               ),
	.o_Long        (ID_Long                ),
	.o_MemSign     (ID_MemSign             ),
	.o_Halt        (ID_Halt                )
);


Control i_Control (
	.i_Op      (Instruction[31:26] ),
	.o_RegDst  (MuxControl_RegDst  ),
	.o_ALUOp   (MuxControl_ALUOp   ),
	.o_ALUSrc  (MuxControl_ALUSrc  ),
	.o_Branch  (MuxControl_Branch  ),
	.o_Branchne(MuxControl_Branchne),
	.o_MemRead (MuxControl_MemRead ),
	.o_MemWrite(MuxControl_MemWrite),
	.o_RegWrite(MuxControl_RegWrite),
	.o_MemtoReg(MuxControl_MemtoReg),
	.o_Jump    (MuxControl_Jump    ),
	.o_Signed  (MuxControl_Signed  ),
	.o_Long    (MuxControl_Long    ),
	.o_MemSign (MuxControl_MemSign ),
	.o_Halt    (MuxControl_Halt    )
);



assign Branch = ( (ID_Branch & Comparador) | (ID_Branchne & ~Comparador) );


// Signo o Cero extension ?
Mux i_Mux_Sign_Zero (
	.i_Control(SignZero                                         ),
	.i_Input_0({ {16{Instruction[15]}}, Instruction[15:0] }     ), // Signo
	.i_Input_1({ {16'b0}, Instruction[15:0] }                   ), // Cero
	.o_Salida (MuxSignZero_to_IDEX_to_Add_to_JRControl_Immediate)
);

Add i_Add (
	.i_Operand_0 (MuxSignZero_to_IDEX_to_Add_to_JRControl_Immediate),
	.i_Operand_1 (IFID_to_IDEX_to_Add_PCAddress                    ), // Shift left 2
	.o_Add_result(Add_to_MuxBranch_PCAddress                       )
);

JR_Control i_JR_Control (
	.i_AluOp        (ID_ALUOp                                              ),
	.i_Function_code(MuxSignZero_to_IDEX_to_Add_to_JRControl_Immediate[5:0]),
	.o_JR_Control   (JRControl                                             ),
	.o_JALR_Control (ID_JALR_Control                                       )
);

ID_EX i_ID_EX (
	.clk          (clk                                              ),
	.rst          (rst                                              ),
	.i_Stall      (Stall                                            ),
	.i_PC_Address (IFID_to_IDEX_to_Add_PCAddress                    ),
	.i_Read_data_1(Registers_to_IDEX_to_MuxJR_ReadData1             ),
	.i_Read_data_2(Registers_to_IDEX_ReadData2                      ),
	.i_Immediate  (MuxSignZero_to_IDEX_to_Add_to_JRControl_Immediate), // Sign extension con el mux
	.i_rt         (Instruction[20:16]                               ),
	.i_rd         (Instruction[15:11]                               ),
	.i_rs         (Instruction[25:21]                               ),
	.i_RegWrite   (ID_RegWrite                                      ),
	.i_MemtoReg   (ID_MemtoReg                                      ),
	.i_MemRead    (ID_MemRead                                       ),
	.i_MemWrite   (ID_MemWrite                                      ),
	.i_Halt       (ID_Halt                                          ),
	.i_Long       (ID_Long                                          ),
	.i_MemSign    (ID_MemSign                                       ),
	.i_RegDst     (ID_RegDst                                        ),
	.i_ALUOp      (ID_ALUOp                                         ),
	.i_ALUSrc     (ID_ALUSrc                                        ),
	.i_JALRCtrl   (ID_JALR_Control                                  ),
	.o_PC_Address (IDEX_to_MuxJALR_to_EXMEM_PCAddress               ),
	.o_Read_data_1(IDEX_to_MuxForwardA_ReadData1                    ),
	.o_Read_data_2(IDEX_to_MuxALUSrc_to_EXMEM_ReadData2             ),
	.o_Immediate  (IDEX_to_ALUControl_to_Add_to_MuxALUSrc_Immediate ),
	.o_rt         (IDEX_to_MuxRegDst_rt_0                           ),
	.o_rd         (IDEX_to_MuxRegDst_rd_1                           ),
	.o_rs         (IDEX_to_Forwarding_rs                            ),
	.o_RegWrite   (EX_RegWrite                                      ),
	.o_MemtoReg   (EX_MemtoReg                                      ),
	.o_MemRead    (EX_MemRead                                       ),
	.o_MemWrite   (EX_MemWrite                                      ),
	.o_Halt       (EX_Halt                                          ),
	.o_Long       (EX_Long                                          ),
	.o_MemSign    (EX_MemSign                                       ),
	.o_RegDst     (RegDst                                           ),
	.o_ALUOp      (ALUOp                                            ),
	.o_ALUSrc     (ALUSrc                                           ),
	.o_JALRCtrl   (JARL_Control                                     )
);

// EX


wire [ 1:0] EX_ForwardA             ;
wire [ 1:0] EX_ForwardB             ;
wire [31:0] MuxForwardA_to_MuxJALR  ;
wire [31:0] MuxForwardB_to_MuxALUSrc;

MuxTres i_MuxForwardA (
	.i_Control(EX_ForwardA                         ),
	.i_Input_0(IDEX_to_MuxForwardA_ReadData1       ),
	.i_Input_1(MuxMemtoReg_to_Registers_WriteData  ),
	.i_Input_2(EXMEM_to_DataMem_to_MEMWB_ALUAddress),
	.o_Salida (MuxForwardA_to_MuxJALR              )
);

Mux i_Mux_JALR (
	.i_Control(JARL_Control                      ),
	.i_Input_0(MuxForwardA_to_MuxJALR            ),
	.i_Input_1(IDEX_to_MuxJALR_to_EXMEM_PCAddress),
	.o_Salida (MuxJALR_to_ALU_Operand1           )
);

MuxTres i_MuxForwardB (
	.i_Control(EX_ForwardB                         ),
	.i_Input_0(IDEX_to_MuxALUSrc_to_EXMEM_ReadData2),
	.i_Input_1(MuxMemtoReg_to_Registers_WriteData  ),
	.i_Input_2(EXMEM_to_DataMem_to_MEMWB_ALUAddress),
	.o_Salida (MuxForwardB_to_MuxALUSrc            )
);

Mux i_MuxALUSrc (
	.i_Control(ALUSrc                                          ),
	.i_Input_0(MuxForwardB_to_MuxALUSrc                        ),
	.i_Input_1(IDEX_to_ALUControl_to_Add_to_MuxALUSrc_Immediate),
	.o_Salida (MuxALUSrc_to_ALU_Operand2                       )
);


ALU i_ALU (
	.i_Control   (ALUControl_to_ALU_Operation                           ),
	.i_Data_1    (MuxJALR_to_ALU_Operand1                               ),
	.i_Data_2    (MuxALUSrc_to_ALU_Operand2                             ),
	.i_Shamt     (IDEX_to_ALUControl_to_Add_to_MuxALUSrc_Immediate[10:6]),
	.o_ALU_Result(ALU_to_EXMEM_ALUResult                                )
);


ALU_control i_ALU_control (
	.i_ALUOp        (ALUOp                                                ),
	.i_Function_code(IDEX_to_ALUControl_to_Add_to_MuxALUSrc_Immediate[5:0]),
	.o_Operation    (ALUControl_to_ALU_Operation                          )
);


MuxTres #(.BUS_SIZE(5)) i_MuxRegDst (
	.i_Control(RegDst                   ),
	.i_Input_0(IDEX_to_MuxRegDst_rt_0   ),
	.i_Input_1(IDEX_to_MuxRegDst_rd_1   ),
	.i_Input_2(5'd31                    ), // JAL Instruction
	.o_Salida (MuxRegDst_to_EXMEM_Result)
);


Forwarding_unit i_Forwarding_unit (
	.i_IDEX_RegisterRs (IDEX_to_Forwarding_rs           ),
	.i_IDEX_RegisterRt (IDEX_to_MuxRegDst_rt_0          ),
	.i_EXMEM_RegWrite  (MEM_RegWrite                    ),
	.i_EXMEM_RegisterRd(MuxRegDst_to_EXMEM_Result       ),
	.i_MEMWB_RegisterRd(MEMWB_to_Registers_WriteRegister),
	.i_MEMWB_RegWrite  (RegWrite                        ),
	.o_ForwardA        (EX_ForwardA                     ),
	.o_ForwardB        (EX_ForwardB                     )
);

EX_MEM i_EX_MEM (
	.clk               (clk                                 ),
	.rst               (rst                                 ),
	.i_PC_Address      (IDEX_to_MuxJALR_to_EXMEM_PCAddress  ),
	.i_ALU_result      (ALU_to_EXMEM_ALUResult              ),
	.i_Read_data_2     (IDEX_to_MuxALUSrc_to_EXMEM_ReadData2),
	.i_MuxRegDst_result(MuxRegDst_to_EXMEM_Result           ),
	.i_RegWrite        (EX_RegWrite                         ),
	.i_MemtoReg        (EX_MemtoReg                         ),
	.i_MemRead         (EX_MemRead                          ),
	.i_MemWrite        (EX_MemWrite                         ),
	.i_Long            (EX_Long                             ),
	.i_MemSign         (EX_MemSign                          ),
	.i_Halt            (EX_Halt                             ),
	.o_PC_Address      (EXMEM_to_MEMWB_PC_Address           ),
	.o_ALU_result      (EXMEM_to_DataMem_to_MEMWB_ALUAddress), // ALUResult -> Address
	.o_Read_data_2     (EXMEM_to_DataMem_WriteData          ), // ReadData2 -> WriteData
	.o_MuxRegDst_result(EXMEM_to_MEMWB_Result               ), // MuxRegDst -> Result
	.o_RegWrite        (MEM_RegWrite                        ),
	.o_MemtoReg        (MEM_MemtoReg                        ),
	.o_MemRead         (MemRead                             ), // Control
	.o_MemWrite        (MemWrite                            ), // Control
	.o_Long            (Long                                ),
	.o_MemSign         (MemSign                             ),
	.o_Halt            (MEM_Halt                            )
);

// MEM

Data_memory i_Data_memory (
	.i_clk       (clk                                 ),
	.i_rst       (rst                                 ),
	.i_Address   (EXMEM_to_DataMem_to_MEMWB_ALUAddress),
	.i_Write_data(EXMEM_to_DataMem_WriteData          ),
	.i_MemWrite  (MemWrite                            ),
	.i_MemRead   (MemRead                             ),
	.i_Long      (Long                                ),
	.i_MemSign   (MemSign                             ),
	.o_Read_data (DataMem_to_MEMWB_ReadData           )
);

MEM_WB i_MEM_WB (
	.clk               (clk                                 ),
	.rst               (rst                                 ),
	.i_PC_Address      (EXMEM_to_MEMWB_PC_Address           ),
	.i_ALUAddress      (EXMEM_to_DataMem_to_MEMWB_ALUAddress),
	.i_Read_data       (DataMem_to_MEMWB_ReadData           ),
	.i_MuxRegDst_result(EXMEM_to_MEMWB_Result               ),
	.i_RegWrite        (MEM_RegWrite                        ),
	.i_MemtoReg        (MEM_MemtoReg                        ),
	.i_Halt            (MEM_Halt),
	.o_PC_Address      (MEMWB_to_MuxMemtoReg_PC_Address     ),
	.o_ALUAddress      (MEMWB_to_MuxMemtoReg_ALUAddress     ),
	.o_Read_data       (MEMWB_to_MuxMemtoReg_ReadData       ),
	.o_MuxRegDst_result(MEMWB_to_Registers_WriteRegister    ),
	.o_RegWrite        (RegWrite                            ),
	.o_MemtoReg        (MemtoReg                            ),
	.o_Halt            (Halt                                )
);

// WB

MuxTres i_Mux_MemtoReg (
	.i_Control(MemtoReg                          ),
	.i_Input_0(MEMWB_to_MuxMemtoReg_ALUAddress   ),
	.i_Input_1(MEMWB_to_MuxMemtoReg_ReadData     ),
	.i_Input_2(MEMWB_to_MuxMemtoReg_PC_Address   ),
	.o_Salida (MuxMemtoReg_to_Registers_WriteData)
);

assign o_clk_counter = clk_counter; // debuh clk counter
assign o_debug_pc = PC_to_AddPC_to_InstMem; // debug PC

endmodule