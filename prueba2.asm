// prueba2.asm
// Probar ADDI ANDI ORI XORI SLTI
// SIN RIESGOS

// TODO
addi 1, 2 , 1		// 3(r1 )  = 2  +  1 #5
andi 3, 4 , 1 		// 0(r3 )  = 4 AND 1
ori  5, 6 , 1 		// 7(r5 )  = 6 OR  1 #7
xori 7, 8 , 1 		// 9(r7 )  = 7 XOR 1 #8
SLTI 9, 10, 1 		// 0(r9 )  = A  <  1 
SLTI 11, 12, 100 	// 1(r11)  = C  <  100
lui 13, 1			// 10000(r13) = 1 << 16  