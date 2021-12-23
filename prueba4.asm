// prueba4.asm
// Probar LB, LH, LW, LBU, LHU, SB, SH, SW
// SIN RIESGOS

LB 	r1, 1(r10)	//	??(r1) = 	
LH 	r2, 1(r11)	//	??(r1) = 	
LW	r3, 1(r12)	//	A00D(r1) <- [C(r12) + 1] (Mem 0xD / d13)		Cargar el contenido de la memoria d13 en r3 con signo
LBU	r4, 1(r13)	//	??(r1) = 
LHU	r5, 1(r14)	//	A00F(r1) = <- [E(r14) + 1] (Mem 0xF / d15)		Cargar el contenido de la memoria d15 en r5 sin signo
LWU	r6, 1(r15)	//	??(r1) = 
SB 	r7, 1(r16)	//	??(r1) = 
SH	r8, 1(r17)	//	??(r1) = 
SW 	r9, 1(r18)	//	[12(r18) + 1] (Mem 0x13 / d19)  <- 9(r9)		Guardar el contenido de r9 en la memoria d19 con signo