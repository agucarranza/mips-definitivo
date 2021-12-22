// prueba3.asm
// Probar ADDU, SUBU, AND, OR, XOR, SLT, SLL, SRL, SRA, SLLV, SRLV, SRAV
// SIN RIESGOS.
// Aritmetico:	duplica valores
// Logico:		rellena con ceros

addu 1 , 13, 14		// 1B(r1 ) = D   +  E
subu 2 , 16, 15		//  1(r2 ) = 10  -  F 
and  3 , 17, 18		// 10(r3 ) = 11 AND 12
or   4 , 19, 20		// 17(r4 ) = 13 OR  14
xor  5 , 21, 22		//  3(r5 ) = 15 XOR 16
slt  6 , 23, 24		//  1(r6 ) = 17  <  18
sll  7 , 25, 2		// 64(r7 ) = 19 <<  2
srl  8 , 26, 1		//  D(r8 ) = 1A >>  1 
sra  9 , 27, 2		//  6(r9 ) = 1B >>  3		(con signo)
sllv 10, 28, 2 		// 38(r10) = 1C << 1(r2)
srlv 11, 29, 2 		//  E(r11) = 1D >> 1(r2)
srav 12, 30, 2 		//  F(r12) = 1E >> 1(r2)	(con signo)			