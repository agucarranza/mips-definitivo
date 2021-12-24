// prueba4.asm
// Probar LB, LH, LW, LBU, LHU, SB, SH, SW
// SIN RIESGOS

LB 	r1, 1(r10)	//	0000000B(r01) <- [A(r10) + 1] (Mem 0x0B / d11)		Cargar el contenido de la memoria d15 en r5 con signo  8 LSB 	
LH 	r2, 1(r11)	//	FFFFA00C(r02) <- [B(r11) + 1] (Mem 0x0C / d12)		Cargar el contenido de la memoria d15 en r5 con signo 16 LSB 	
LW	r3, 1(r12)	//	0000A00D(r03) <- [C(r12) + 1] (Mem 0x0D / d13)		Cargar el contenido de la memoria d13 en r3 con signo

LBU	r4, 1(r13)	//	0000000E(r04) <- [E(r13) + 1] (Mem 0x0E / d14)		Cargar el contenido de la memoria d15 en r5 sin signo  8 LSB
LHU	r5, 1(r14)	//	0000A00F(r05) <- [E(r14) + 1] (Mem 0x0F / d15)		Cargar el contenido de la memoria d15 en r5 sin signo 16 LSB
LWU	r6, 1(r15)	//	0000A010(r06) <- [E(r15) + 1] (Mem 0x10 / d16)		Cargar el contenido de la memoria d15 en r5 sin signo 

SB 	r7, 1(r16)	//	[10(r16) + 1] (Mem 0x13 / d17) <- 0000A007(r7)		Guardar el contenido de r7 en la memoria d17 con signo  8 LSB
SH	r8, 1(r17)	//	[11(r17) + 1] (Mem 0x13 / d18) <- 00000008(r8)		Guardar el contenido de r8 en la memoria d18 con signo 16 LSB
SW 	r9, 1(r18)	//	[12(r18) + 1] (Mem 0x13 / d19) <- 00000009(r9)		Guardar el contenido de r9 en la memoria d19 con signo