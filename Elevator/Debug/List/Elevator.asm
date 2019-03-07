
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _chosenFloor=R4
	.DEF _chosenFloor_msb=R5
	.DEF _currentFloor=R6
	.DEF _currentFloor_msb=R7
	.DEF _condition=R8
	.DEF _condition_msb=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*
; * Elevator.c
; *
; * Created: 3/6/2019 11:12:32 PM
; * Author: MSI
; */
;//#include <mega16.h>
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;int chosenFloor;
;int currentFloor;
;
;int up[4] = {0,0,0,0};
;int down[4] = {0,0,0,0};
;
;int condition;
;
;void GoUp(){
; 0000 0012 void GoUp(){

	.CSEG
_GoUp:
; .FSTART _GoUp
; 0000 0013     PORTD.0 = 1;
	SBI  0x12,0
; 0000 0014     PORTD.1 = 0;
	CBI  0x12,1
; 0000 0015 }
	RET
; .FEND
;void GoDown(){
; 0000 0016 void GoDown(){
_GoDown:
; .FSTART _GoDown
; 0000 0017     PORTD.0 = 0;
	CBI  0x12,0
; 0000 0018     PORTD.1 = 1;
	SBI  0x12,1
; 0000 0019 }
	RET
; .FEND
;int isGoingUp(){
; 0000 001A int isGoingUp(){
_isGoingUp:
; .FSTART _isGoingUp
; 0000 001B     if((PORTD.0 == 1) && (PORTD.1 == 0) && (currentFloor != 3))
	SBIS 0x12,0
	RJMP _0xC
	SBIC 0x12,1
	RJMP _0xC
	RCALL SUBOPT_0x0
	BRNE _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 001C         return 1;
	RJMP _0x2000002
; 0000 001D     return 0;
_0xB:
	RJMP _0x2000001
; 0000 001E }
; .FEND
;int isGoingDown(){
; 0000 001F int isGoingDown(){
_isGoingDown:
; .FSTART _isGoingDown
; 0000 0020     if((PORTD.0 == 0) && (PORTD.1 == 1) && (currentFloor != 1))
	SBIC 0x12,0
	RJMP _0xF
	SBIS 0x12,1
	RJMP _0xF
	RCALL SUBOPT_0x1
	BRNE _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 0021         return 1;
_0x2000002:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0022     return 0;
_0xE:
_0x2000001:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 0023 }
; .FEND
;
;void main(void)
; 0000 0026 {
_main:
; .FSTART _main
; 0000 0027     DDRA = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x1A,R30
; 0000 0028     DDRB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0029     DDRC = 0x00;
	OUT  0x14,R30
; 0000 002A     DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 002B 
; 0000 002C     chosenFloor = 0;
	CLR  R4
	CLR  R5
; 0000 002D 
; 0000 002E     if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0x11
; 0000 002F         currentFloor = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x8E
; 0000 0030     }else if(PINB.1 == 1){
_0x11:
	SBIS 0x16,1
	RJMP _0x13
; 0000 0031         currentFloor = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x8E
; 0000 0032     }else if(PINB.0 == 1){
_0x13:
	SBIS 0x16,0
	RJMP _0x15
; 0000 0033         currentFloor = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x8E:
	MOVW R6,R30
; 0000 0034     }
; 0000 0035 
; 0000 0036     if(PINC.0 == 1){
_0x15:
	SBIS 0x13,0
	RJMP _0x16
; 0000 0037         condition = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x8F
; 0000 0038     }else if(PINC.1 == 1){
_0x16:
	SBIS 0x13,1
	RJMP _0x18
; 0000 0039         condition = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x8F
; 0000 003A     }else if(PINC.2 == 1){
_0x18:
	SBIS 0x13,2
	RJMP _0x1A
; 0000 003B         condition = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x8F:
	MOVW R8,R30
; 0000 003C     }
; 0000 003D 
; 0000 003E     while (1){
_0x1A:
_0x1B:
; 0000 003F         //Check current floor
; 0000 0040         if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0x1E
; 0000 0041             currentFloor = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x90
; 0000 0042         }else if(PINB.1 == 1){
_0x1E:
	SBIS 0x16,1
	RJMP _0x20
; 0000 0043             currentFloor = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x90
; 0000 0044         }else if(PINB.0 == 1){
_0x20:
	SBIS 0x16,0
	RJMP _0x22
; 0000 0045             currentFloor = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x90:
	MOVW R6,R30
; 0000 0046         }
; 0000 0047 
; 0000 0048         //Check current condition
; 0000 0049         if(PINC.0 == 1){
_0x22:
	SBIS 0x13,0
	RJMP _0x23
; 0000 004A             condition = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x91
; 0000 004B         }else if(PINC.1 == 1){
_0x23:
	SBIS 0x13,1
	RJMP _0x25
; 0000 004C             condition = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x91
; 0000 004D         }else if(PINC.2 == 1){
_0x25:
	SBIS 0x13,2
	RJMP _0x27
; 0000 004E             condition = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x91:
	MOVW R8,R30
; 0000 004F         }
; 0000 0050 
; 0000 0051         //Check chosen floor
; 0000 0052         if(PINA.0 == 1 || PINC.3 == 1){
_0x27:
	SBIC 0x19,0
	RJMP _0x29
	SBIS 0x13,3
	RJMP _0x28
_0x29:
; 0000 0053             chosenFloor = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0054             if((currentFloor != chosenFloor) && (PINA.0 == 1))
	__CPWRR 4,5,6,7
	BREQ _0x2C
	SBIC 0x19,0
	RJMP _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 0055                 PORTA.4 = 1;
	SBI  0x1B,4
; 0000 0056         }else if(PINA.1 == 1 || PINA.2 == 1 || PINC.4 == 1){
_0x2B:
	RJMP _0x30
_0x28:
	SBIC 0x19,1
	RJMP _0x32
	SBIC 0x19,2
	RJMP _0x32
	SBIS 0x13,4
	RJMP _0x31
_0x32:
; 0000 0057             chosenFloor = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0058             if(currentFloor != chosenFloor){
	__CPWRR 4,5,6,7
	BREQ _0x34
; 0000 0059                 if(PINA.1 == 1)
	SBIS 0x19,1
	RJMP _0x35
; 0000 005A                     PORTA.5 = 1;
	SBI  0x1B,5
; 0000 005B                 else if(PINA.2 == 1)
	RJMP _0x38
_0x35:
	SBIC 0x19,2
; 0000 005C                     PORTA.6 = 1;
	SBI  0x1B,6
; 0000 005D             }
_0x38:
; 0000 005E         }else if(PINA.3 == 1 || PINC.5 == 1){
_0x34:
	RJMP _0x3C
_0x31:
	SBIC 0x19,3
	RJMP _0x3E
	SBIS 0x13,5
	RJMP _0x3D
_0x3E:
; 0000 005F             chosenFloor = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0060             if((currentFloor != chosenFloor) && (PINA.3 == 1))
	__CPWRR 4,5,6,7
	BREQ _0x41
	SBIC 0x19,3
	RJMP _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 0061                 PORTA.7 = 1;
	SBI  0x1B,7
; 0000 0062         }
_0x40:
; 0000 0063 
; 0000 0064         if((isGoingUp() == 1) && (currentFloor == 2)){
_0x3D:
_0x3C:
_0x30:
	RCALL _isGoingUp
	SBIW R30,1
	BRNE _0x46
	RCALL SUBOPT_0x2
	BREQ _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 0065             up[2] = 0;
	__POINTW1MN _up,4
	RCALL SUBOPT_0x3
; 0000 0066             PORTA.5 = 0;
	CBI  0x1B,5
; 0000 0067         }else if((isGoingDown() == 1) && (currentFloor == 2)){
	RJMP _0x4A
_0x45:
	RCALL _isGoingDown
	SBIW R30,1
	BRNE _0x4C
	RCALL SUBOPT_0x2
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 0068             down[2] = 0;
	__POINTW1MN _down,4
	RCALL SUBOPT_0x3
; 0000 0069             PORTA.6 = 0;
	CBI  0x1B,6
; 0000 006A         }else if(currentFloor == 1){
	RJMP _0x50
_0x4B:
	RCALL SUBOPT_0x1
	BRNE _0x51
; 0000 006B             down[1] = 0;
	__POINTW1MN _down,2
	RCALL SUBOPT_0x3
; 0000 006C             up[1] = 0;
	__POINTW1MN _up,2
	RCALL SUBOPT_0x3
; 0000 006D             PORTA.7 = 0;
	CBI  0x1B,7
; 0000 006E         }else if(currentFloor == 3){
	RJMP _0x54
_0x51:
	RCALL SUBOPT_0x0
	BRNE _0x55
; 0000 006F             down[3] = 0;
	__POINTW1MN _down,6
	RCALL SUBOPT_0x3
; 0000 0070             up[3] = 0;
	__POINTW1MN _up,6
	RCALL SUBOPT_0x3
; 0000 0071             PORTA.4 = 0;
	CBI  0x1B,4
; 0000 0072         }
; 0000 0073 
; 0000 0074         if((up[0]+up[1]+up[2]+up[3]+down[0]+down[1]+down[2]+down[3]) == 0){
_0x55:
_0x54:
_0x50:
_0x4A:
	__GETW1MN _up,2
	LDS  R26,_up
	LDS  R27,_up+1
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _up,4
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_down
	LDS  R27,_down+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _down,4
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _down,6
	ADD  R30,R26
	ADC  R31,R27
	SBIW R30,0
	BRNE _0x58
; 0000 0075             PORTD.0 = 0;
	CBI  0x12,0
; 0000 0076             PORTD.1 = 0;
	CBI  0x12,1
; 0000 0077         }
; 0000 0078 
; 0000 0079         if(chosenFloor != 0){
_0x58:
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x5D
; 0000 007A             if(currentFloor != chosenFloor){
	__CPWRR 4,5,6,7
	BREQ _0x5E
; 0000 007B                 switch (currentFloor > chosenFloor) {
	MOVW R30,R4
	MOVW R26,R6
	CALL __GTW12
; 0000 007C                 case 1 :
	CPI  R30,LOW(0x1)
	BRNE _0x62
; 0000 007D                     down[chosenFloor] = 1;
	MOVW R30,R4
	LDI  R26,LOW(_down)
	LDI  R27,HIGH(_down)
	RCALL SUBOPT_0x6
; 0000 007E                     break;
	RJMP _0x61
; 0000 007F                 case 0 :
_0x62:
	CPI  R30,0
	BRNE _0x64
; 0000 0080                     up[chosenFloor] = 1;
	MOVW R30,R4
	LDI  R26,LOW(_up)
	LDI  R27,HIGH(_up)
	RCALL SUBOPT_0x6
; 0000 0081                     break;
; 0000 0082                 break;
; 0000 0083 
; 0000 0084                 default:
_0x64:
; 0000 0085                 }
_0x61:
; 0000 0086             }
; 0000 0087             chosenFloor = 0;
_0x5E:
	CLR  R4
	CLR  R5
; 0000 0088         }
; 0000 0089 
; 0000 008A         if(PORTA.5 == 1)
_0x5D:
	SBIS 0x1B,5
	RJMP _0x65
; 0000 008B             up[2] = 1;
	__POINTW1MN _up,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 008C         if(PORTA.6 == 1)
_0x65:
	SBIS 0x1B,6
	RJMP _0x66
; 0000 008D             down[2] = 1;
	__POINTW1MN _down,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 008E 
; 0000 008F         if((isGoingUp() == 0) && (isGoingDown() == 0) && (condition != 3)){
_0x66:
	RCALL _isGoingUp
	SBIW R30,0
	BRNE _0x68
	RCALL _isGoingDown
	SBIW R30,0
	BRNE _0x68
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 0090             if(currentFloor == 1){
	RCALL SUBOPT_0x1
	BRNE _0x6A
; 0000 0091                 if((up[2] == 1) || (up[3] == 1))
	__GETW1MN _up,4
	SBIW R30,1
	BREQ _0x6C
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6B
_0x6C:
; 0000 0092                     GoUp();
	RCALL _GoUp
; 0000 0093             }else if(currentFloor == 2){
_0x6B:
	RJMP _0x6E
_0x6A:
	RCALL SUBOPT_0x2
	BRNE _0x6F
; 0000 0094                 PORTA.5 = 0;
	CBI  0x1B,5
; 0000 0095                 PORTA.6 = 0;
	CBI  0x1B,6
; 0000 0096                 if(up[3] == 1)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x74
; 0000 0097                     GoUp();
	RCALL _GoUp
; 0000 0098                 else if(down[1] == 1)
	RJMP _0x75
_0x74:
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x76
; 0000 0099                     GoDown();
	RCALL _GoDown
; 0000 009A             }else if(currentFloor == 3){
_0x76:
_0x75:
	RJMP _0x77
_0x6F:
	RCALL SUBOPT_0x0
	BRNE _0x78
; 0000 009B                 if((down[1] == 1) || (down[2] == 1))
	RCALL SUBOPT_0x5
	SBIW R30,1
	BREQ _0x7A
	__GETW1MN _down,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x79
_0x7A:
; 0000 009C                     GoDown();
	RCALL _GoDown
; 0000 009D             }
_0x79:
; 0000 009E         }
_0x78:
_0x77:
_0x6E:
; 0000 009F 
; 0000 00A0 
; 0000 00A1 
; 0000 00A2         //Display
; 0000 00A3         if(PINB.2 == 1){
_0x67:
	SBIS 0x16,2
	RJMP _0x7C
; 0000 00A4             PORTD.6 = 1;
	SBI  0x12,6
; 0000 00A5             PORTD.7 = 1;
	RJMP _0x92
; 0000 00A6         }else if(PINB.1 == 1){
_0x7C:
	SBIS 0x16,1
	RJMP _0x82
; 0000 00A7             PORTD.6 = 1;
	SBI  0x12,6
; 0000 00A8             PORTD.7 = 0;
	CBI  0x12,7
; 0000 00A9         }else if(PINB.0 == 1){
	RJMP _0x87
_0x82:
	SBIS 0x16,0
	RJMP _0x88
; 0000 00AA             PORTD.6 = 0;
	CBI  0x12,6
; 0000 00AB             PORTD.7 =1;
_0x92:
	SBI  0x12,7
; 0000 00AC         }
; 0000 00AD     }
_0x88:
_0x87:
	RJMP _0x1B
; 0000 00AE }
_0x8D:
	RJMP _0x8D
; .FEND

	.DSEG
_up:
	.BYTE 0x8
_down:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETW1MN _up,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETW1MN _down,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET


	.CSEG
__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
