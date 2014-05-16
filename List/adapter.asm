
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0100
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _temp_control=R5
	.DEF _bias=R4
	.DEF _Vop=R7
	.DEF _disp_config=R6
	.DEF _LcdCacheIdx=R8
	.DEF _argc=R11
	.DEF _i=R10
	.DEF _flag=R13
	.DEF _TX_flag=R12

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
	JMP  _timer2_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  _spi_isr
	JMP  _usart0_rxc
	JMP  _usart0_dre_my
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rxc
	JMP  _usart1_dre_my
	JMP  0x00
	JMP  _twi_isr
	JMP  0x00

_table:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49
	.DB  0x49,0x31,0x7F,0x49,0x49,0x49,0x36,0x7F
	.DB  0x1,0x1,0x1,0x3,0x70,0x29,0x27,0x21
	.DB  0x7F,0x7F,0x49,0x49,0x49,0x41,0x77,0x8
	.DB  0x7F,0x8,0x77,0x41,0x41,0x41,0x49,0x76
	.DB  0x7F,0x10,0x8,0x4,0x7F,0x7F,0x10,0x9
	.DB  0x4,0x7F,0x7F,0x8,0x14,0x22,0x41,0x20
	.DB  0x41,0x3F,0x1,0x7F,0x7F,0x2,0xC,0x2
	.DB  0x7F,0x7F,0x8,0x8,0x8,0x7F,0x3E,0x41
	.DB  0x41,0x41,0x3E,0x7F,0x1,0x1,0x1,0x7F
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x41
	.DB  0x41,0x22,0x1,0x1,0x7F,0x1,0x1,0x47
	.DB  0x28,0x10,0x8,0x7,0x1E,0x21,0x7F,0x21
	.DB  0x1E,0x63,0x14,0x8,0x14,0x63,0x3F,0x20
	.DB  0x20,0x20,0x5F,0x7,0x8,0x8,0x8,0x7F
	.DB  0x7F,0x40,0x7F,0x40,0x7F,0x3F,0x20,0x3F
	.DB  0x20,0x5F,0x1,0x7F,0x48,0x48,0x30,0x7F
	.DB  0x48,0x30,0x0,0x7F,0x0,0x7F,0x48,0x48
	.DB  0x30,0x41,0x41,0x41,0x49,0x3E,0x7F,0x8
	.DB  0x3E,0x41,0x3E,0x46,0x29,0x19,0x9,0x7F
	.DB  0x20,0x54,0x54,0x54,0x78,0x3C,0x4A,0x4A
	.DB  0x49,0x31,0x7C,0x54,0x54,0x28,0x0,0x7C
	.DB  0x4,0x4,0x4,0xC,0x72,0x2A,0x26,0x22
	.DB  0x7E,0x38,0x54,0x54,0x54,0x18,0x6C,0x10
	.DB  0x7C,0x10,0x6C,0x44,0x44,0x54,0x54,0x38
	.DB  0x7C,0x20,0x10,0x8,0x7C,0x7C,0x21,0x12
	.DB  0x9,0x7C,0x7C,0x10,0x28,0x44,0x0,0x20
	.DB  0x44,0x3C,0x4,0x7C,0x7C,0x8,0x10,0x8
	.DB  0x7C,0x7C,0x10,0x10,0x10,0x7C,0x38,0x44
	.DB  0x44,0x44,0x38,0x7C,0x4,0x4,0x4,0x7C
	.DB  0x7C,0x14,0x14,0x14,0x8,0x38,0x44,0x44
	.DB  0x44,0x20,0x4,0x4,0x7C,0x4,0x4,0x44
	.DB  0x28,0x10,0x8,0x4,0x8,0x14,0x7E,0x14
	.DB  0x8,0x44,0x28,0x10,0x28,0x44,0x3C,0x40
	.DB  0x40,0x7C,0x40,0xC,0x10,0x10,0x10,0x7C
	.DB  0x7C,0x40,0x7C,0x40,0x7C,0x3C,0x20,0x3C
	.DB  0x20,0x7C,0x4,0x7C,0x50,0x50,0x20,0x7C
	.DB  0x50,0x20,0x0,0x7C,0x0,0x7C,0x50,0x50
	.DB  0x20,0x28,0x44,0x44,0x54,0x38,0x7C,0x10
	.DB  0x38,0x44,0x38,0x48,0x54,0x34,0x14,0x7C
_rad1Image:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x80,0xC0,0xE0,0xF0
	.DB  0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF
	.DB  0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0xC0,0xE0
	.DB  0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE
	.DB  0xFE,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xE0,0xF8,0xFE,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0
	.DB  0xE0,0x40,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x40,0xE0,0xF0,0xF8,0xFC,0xFE
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x78,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F
	.DB  0xF,0x3,0x1,0xF0,0xF8,0xFC,0xFC,0xFE
	.DB  0xFE,0xFE,0xFE,0xFE,0xFE,0xFC,0xFC,0xF8
	.DB  0xF0,0x1,0x3,0xF,0x7F,0x7F,0x7F,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0xC0,0xE1
	.DB  0xE3,0xE7,0xC7,0xCF,0x8F,0x8F,0x8F,0x8F
	.DB  0xCF,0xC7,0xE7,0xE3,0xE1,0xC0,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0
	.DB  0xE0,0xC0,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xC,0xE,0x1F,0x1F,0x1F,0x3F
	.DB  0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F
	.DB  0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F
	.DB  0xE,0xC,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_Help:
	.DB  0x48,0x65,0x6C,0x70,0x0
_Set:
	.DB  0x53,0x65,0x74,0x0
_Uart:
	.DB  0x55,0x61,0x72,0x74,0x0
_Mode:
	.DB  0x4D,0x6F,0x64,0x65,0x0
_Speed:
	.DB  0x53,0x70,0x65,0x65,0x64,0x0
_Spi:
	.DB  0x53,0x70,0x69,0x0
_Prescaller:
	.DB  0x50,0x72,0x65,0x73,0x63,0x0
_PhaPol:
	.DB  0x70,0x70,0x0
_I2c:
	.DB  0x49,0x32,0x63,0x0
_W:
	.DB  0x57,0x0
_reset:
	.DB  0x72,0x73,0x74,0x0
_boot:
	.DB  0x62,0x6F,0x6F,0x74,0x0
_dbg:
	.DB  0x64,0x62,0x67,0x0
_error:
	.DB  0x20,0x45,0xD,0x0
_ok:
	.DB  0x20,0x6F,0x6B,0xD,0x0
_largeValue:
	.DB  0x20,0x4C,0x61,0x72,0x67,0x65,0x5F,0x76
	.DB  0x61,0x6C,0x75,0x65,0xD,0x0
_wrongValue:
	.DB  0x20,0x57,0x72,0x6F,0x6E,0x67,0x5F,0x76
	.DB  0x61,0x6C,0x75,0x65,0xD,0x0
_start:
	.DB  0x20,0x53,0x0
_help_mess_0:
	.DB  0xD,0x3E,0x3E,0x3E,0x20,0x48,0x45,0x4C
	.DB  0x50,0x20,0x3C,0x3C,0x3C,0xD,0x20,0x43
	.DB  0x6F,0x6D,0x6D,0x61,0x6E,0x64,0x73,0x3A
	.DB  0xD,0x0
_help_mess_1:
	.DB  0xD,0x20,0x53,0x65,0x74,0x20,0x2D,0x49
	.DB  0x6E,0x74,0x65,0x72,0x66,0x61,0x63,0x65
	.DB  0x5F,0x6E,0x61,0x6D,0x65,0x2D,0x20,0x2D
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x2D,0x20
	.DB  0x4D,0x6F,0x64,0x65,0x20,0x2D,0x76,0x61
	.DB  0x6C,0x75,0x65,0x28,0x6F,0x70,0x74,0x69
	.DB  0x6F,0x6E,0x61,0x6C,0x29,0x2D,0x20,0x53
	.DB  0x70,0x65,0x65,0x64,0x20,0x2D,0x76,0x61
	.DB  0x6C,0x75,0x65,0x28,0x6F,0x70,0x74,0x69
	.DB  0x6F,0x6E,0x61,0x6C,0x29,0x2D,0x0
_help_mess_2:
	.DB  0xD,0x20,0x57,0x20,0x20,0x20,0x2D,0x49
	.DB  0x6E,0x74,0x65,0x72,0x66,0x61,0x63,0x65
	.DB  0x5F,0x6E,0x61,0x6D,0x65,0x2D,0x20,0x2D
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x2D,0x20
	.DB  0x2D,0x64,0x61,0x74,0x61,0x2D,0x0
_help_mess_3:
	.DB  0xD,0x20,0x47,0x65,0x74,0x20,0x2D,0x65
	.DB  0x6E,0x74,0x69,0x74,0x79,0x2D,0x0
_help_mess_4:
	.DB  0xD,0x20,0x20,0x49,0x6E,0x74,0x65,0x72
	.DB  0x66,0x61,0x63,0x65,0x73,0x20,0x61,0x76
	.DB  0x61,0x69,0x6C,0x61,0x62,0x6C,0x65,0x3A
	.DB  0xD,0x20,0x20,0x20,0x55,0x61,0x72,0x74
	.DB  0x28,0x30,0x2C,0x31,0x29,0xD,0x20,0x20
	.DB  0x20,0x53,0x70,0x69,0x28,0x30,0x2D,0x48
	.DB  0x61,0x72,0x64,0x2C,0x20,0x31,0x2D,0x53
	.DB  0x6F,0x66,0x74,0x29,0xD,0x0
_help_Uart_0:
	.DB  0xD,0x3E,0x3E,0x3E,0x20,0x55,0x41,0x52
	.DB  0x54,0x5F,0x48,0x45,0x4C,0x50,0x20,0x3C
	.DB  0x3C,0x3C,0xD,0x20,0x4D,0x6F,0x64,0x65
	.DB  0x3A,0x20,0x30,0x2D,0x20,0x4E,0x4F,0x52
	.DB  0x4D,0x41,0x4C,0x3B,0x20,0x31,0x2D,0x20
	.DB  0x44,0x4F,0x55,0x42,0x4C,0x45,0x44,0x20
	.DB  0x73,0x70,0x65,0x65,0x64,0x0
_help_Uart_1:
	.DB  0xD,0x20,0x53,0x70,0x65,0x65,0x64,0x3A
	.DB  0x20,0x62,0x61,0x75,0x64,0x2F,0x31,0x30
	.DB  0x30,0x20,0x28,0x45,0x78,0x3A,0x20,0x35
	.DB  0x37,0x36,0x20,0x69,0x73,0x20,0x35,0x37
	.DB  0x36,0x30,0x30,0x29,0xD,0x0
_help_Spi_0:
	.DB  0xD,0x3E,0x3E,0x3E,0x20,0x53,0x50,0x49
	.DB  0x5F,0x48,0x45,0x4C,0x50,0x20,0x3C,0x3C
	.DB  0x3C,0xD,0x20,0x4D,0x6F,0x64,0x65,0x3A
	.DB  0x20,0x30,0x2D,0x20,0x53,0x4C,0x41,0x56
	.DB  0x45,0x3B,0x20,0x31,0x2D,0x20,0x4D,0x41
	.DB  0x53,0x54,0x45,0x52,0xA,0x0
_help_Spi_1:
	.DB  0xD,0x20,0x50,0x72,0x65,0x73,0x63,0x61
	.DB  0x6C,0x6C,0x65,0x72,0x3A,0x20,0x70,0x6F
	.DB  0x77,0x20,0x6F,0x66,0x20,0x32,0x20,0x28
	.DB  0x45,0x78,0x3A,0x20,0x50,0x72,0x65,0x73
	.DB  0x63,0x20,0x31,0x36,0x29,0xD,0x0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x8F:
	.DB  0xFF
_0x144:
	.DB  0xC8
_0x168:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x169:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x16A:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x248:
	.DB  0x3,0x3,0x2,0x46,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x70,0x6F,0x72,0x66,0xD,0xA,0x0,0x65
	.DB  0x78,0x74,0x72,0x66,0xD,0xA,0x0,0x62
	.DB  0x6F,0x72,0x66,0xD,0xA,0x0,0x77,0x64
	.DB  0x72,0x66,0xD,0xA,0x0,0x4A,0x54,0x52
	.DB  0x46,0xD,0xA,0x0,0xD,0x3C,0x52,0x41
	.DB  0x4D,0x3E,0x0,0xD,0x55,0x41,0x52,0x54
	.DB  0x5F,0x53,0x45,0x54,0x54,0x49,0x4E,0x47
	.DB  0x53,0xD,0x0,0x55,0x41,0x52,0x54,0x20
	.DB  0x0,0xD,0x20,0x4D,0x6F,0x64,0x65,0x20
	.DB  0x0,0xD,0x20,0x53,0x70,0x65,0x65,0x64
	.DB  0x20,0x0,0xD,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xD,0x0,0xD,0x53,0x50
	.DB  0x49,0x5F,0x53,0x45,0x54,0x54,0x49,0x4E
	.DB  0x47,0x53,0xD,0x0,0x53,0x50,0x49,0x20
	.DB  0x0,0xD,0x20,0x50,0x72,0x65,0x73,0x63
	.DB  0x61,0x6C,0x6C,0x65,0x72,0x20,0x0,0xD
	.DB  0x3C,0x45,0x45,0x50,0x52,0x4F,0x4D,0x3E
	.DB  0x0,0xD,0x42,0x75,0x74,0x65,0x73,0x5F
	.DB  0x52,0x58,0x20,0x0,0xD,0x42,0x75,0x74
	.DB  0x65,0x73,0x5F,0x54,0x58,0x20,0x0,0x76
	.DB  0x72,0x65,0x66,0x3D,0x25,0x64,0x20,0x0
	.DB  0x64,0x3D,0x25,0x64,0x20,0x0,0x64,0x65
	.DB  0x6C,0x74,0x61,0x3D,0x25,0x64,0x20,0x0
	.DB  0x76,0x6F,0x6C,0x74,0x3D,0x25,0x64,0x20
	.DB  0x0,0xD,0x20,0x53,0x65,0x74,0x0,0xD
	.DB  0x20,0x55,0x61,0x72,0x74,0x0,0xD,0x20
	.DB  0x4E,0x75,0x6D,0x0,0xD,0x20,0x4D,0x6F
	.DB  0x64,0x65,0x0,0xD,0x4D,0x20,0x45,0x58
	.DB  0x49,0x54,0x0,0xD,0x20,0x0,0xD,0x20
	.DB  0x55,0x73,0x61,0x72,0x74,0x5F,0x69,0x6E
	.DB  0x69,0x74,0x0,0xD,0x20,0x53,0x70,0x69
	.DB  0x0,0xD,0x53,0x20,0x4E,0x75,0x6D,0x0
	.DB  0xD,0x53,0x20,0x4D,0x6F,0x64,0x65,0x2D
	.DB  0x0,0xD,0x53,0x20,0x50,0x72,0x65,0x73
	.DB  0x63,0x2D,0x0,0xD,0x53,0x20,0x50,0x68
	.DB  0x61,0x50,0x6F,0x6C,0x2D,0x0,0xD,0x53
	.DB  0x20,0x53,0x70,0x69,0x49,0x6E,0x69,0x74
	.DB  0x0,0xD,0x20,0x57,0x0,0xD,0x20,0x55
	.DB  0x20,0x44,0x3E,0x54,0x58,0x20,0x0,0xD
	.DB  0x20,0x53,0x20,0x44,0x3E,0x54,0x58,0x20
	.DB  0x0,0xD,0x20,0x53,0x20,0x44,0x3C,0x52
	.DB  0x58,0x20,0x0,0xD,0x20,0x49,0x32,0x43
	.DB  0x20,0x44,0x3E,0x54,0x58,0x20,0x0,0xD
	.DB  0x20,0x49,0x32,0x43,0x20,0x44,0x3C,0x52
	.DB  0x58,0x20,0x0,0x73,0x0,0x45,0x0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _d
	.DW  _0x144*2

	.DW  0x02
	.DW  _MasterOutFunc
	.DW  _0x168*2

	.DW  0x02
	.DW  _SlaveOutFunc
	.DW  _0x169*2

	.DW  0x02
	.DW  _ErrorOutFunc
	.DW  _0x16A*2

	.DW  0x07
	.DW  _0x1B7
	.DW  _0x0*2+36

	.DW  0x10
	.DW  _0x1B7+7
	.DW  _0x0*2+43

	.DW  0x06
	.DW  _0x1B7+23
	.DW  _0x0*2+59

	.DW  0x08
	.DW  _0x1B7+29
	.DW  _0x0*2+65

	.DW  0x09
	.DW  _0x1B7+37
	.DW  _0x0*2+73

	.DW  0x0B
	.DW  _0x1B7+46
	.DW  _0x0*2+82

	.DW  0x0F
	.DW  _0x1B7+57
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0x1B7+72
	.DW  _0x0*2+108

	.DW  0x08
	.DW  _0x1B7+77
	.DW  _0x0*2+65

	.DW  0x0E
	.DW  _0x1B7+85
	.DW  _0x0*2+113

	.DW  0x0B
	.DW  _0x1B7+99
	.DW  _0x0*2+82

	.DW  0x0A
	.DW  _0x1BE
	.DW  _0x0*2+127

	.DW  0x10
	.DW  _0x1BE+10
	.DW  _0x0*2+43

	.DW  0x06
	.DW  _0x1BE+26
	.DW  _0x0*2+59

	.DW  0x08
	.DW  _0x1BE+32
	.DW  _0x0*2+65

	.DW  0x09
	.DW  _0x1BE+40
	.DW  _0x0*2+73

	.DW  0x0B
	.DW  _0x1BE+49
	.DW  _0x0*2+82

	.DW  0x0F
	.DW  _0x1BE+60
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0x1BE+75
	.DW  _0x0*2+108

	.DW  0x08
	.DW  _0x1BE+80
	.DW  _0x0*2+65

	.DW  0x0E
	.DW  _0x1BE+88
	.DW  _0x0*2+113

	.DW  0x0B
	.DW  _0x1BE+102
	.DW  _0x0*2+82

	.DW  0x0B
	.DW  _0x1C5
	.DW  _0x0*2+137

	.DW  0x0B
	.DW  _0x1C5+11
	.DW  _0x0*2+148

	.DW  0x06
	.DW  _0x1E8
	.DW  _0x0*2+193

	.DW  0x07
	.DW  _0x1E8+6
	.DW  _0x0*2+199

	.DW  0x06
	.DW  _0x1E8+13
	.DW  _0x0*2+206

	.DW  0x07
	.DW  _0x1E8+19
	.DW  _0x0*2+212

	.DW  0x08
	.DW  _0x1E8+26
	.DW  _0x0*2+219

	.DW  0x03
	.DW  _0x1E8+34
	.DW  _0x0*2+227

	.DW  0x08
	.DW  _0x1E8+37
	.DW  _0x0*2+219

	.DW  0x0D
	.DW  _0x1E8+45
	.DW  _0x0*2+230

	.DW  0x06
	.DW  _0x1E8+58
	.DW  _0x0*2+243

	.DW  0x07
	.DW  _0x1E8+64
	.DW  _0x0*2+249

	.DW  0x09
	.DW  _0x1E8+71
	.DW  _0x0*2+256

	.DW  0x0A
	.DW  _0x1E8+80
	.DW  _0x0*2+265

	.DW  0x0B
	.DW  _0x1E8+90
	.DW  _0x0*2+275

	.DW  0x0B
	.DW  _0x1E8+101
	.DW  _0x0*2+286

	.DW  0x04
	.DW  _0x1E8+112
	.DW  _0x0*2+297

	.DW  0x0A
	.DW  _0x1E8+116
	.DW  _0x0*2+301

	.DW  0x0A
	.DW  _0x1E8+126
	.DW  _0x0*2+311

	.DW  0x0A
	.DW  _0x1E8+136
	.DW  _0x0*2+321

	.DW  0x0C
	.DW  _0x1E8+146
	.DW  _0x0*2+331

	.DW  0x0C
	.DW  _0x1E8+158
	.DW  _0x0*2+343

	.DW  0x0A
	.DW  0x04
	.DW  _0x248*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

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
	.ORG 0x200

	.CSEG
;/*****************************************************
;Project : Uni_interface_adapter
;Version :
;Date    : 04.02.2014
;Author  : Vlad
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Data Stack size         : 1024
;*****************************************************/
;
;#define DEBUG
;
;#include <adapter.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;/**********************************************
;****************PCD8544 Driver*****************
;***********************************************
;
;for original NOKIA 3310 & alternative "chinese" version of display
;
;48x84 dots, 6x14 symbols
;
;**********************************************/
;
;//#define china 1		// ���� ���������� - �������� �� ���������� "����������" �������, ����� - �������������
;#define SOFT_SPI 1	// ���� ���������� - ���������� ����������� SPI, ����� - ����������
;
;#ifndef SOFT_SPI
;unsigned char SPCR_val = 0x50;	// �����
;unsigned char SPSR_val = 0x01;  // �������� �������
;#endif
;
;//LCD Port & pinout setup. ����������: ����� � "������" ���������� (���� ���� G � �.�.) �� ��������������
;#define LCD_DC_PORT  	PORTA	// ����� �������-������; ����� ��� ������ �����
;#define LCD_DC_DDR 	    DDRA
;#define LCD_DC_PIN 	    0
;
;#define LCD_CPORT 	    PORTA	// Chip-Select; ����� ��� ������ �����
;#define LCD_CDDR   	    DDRA
;#define LCD_CPIN    	1
;
;#define LCD_RST_PORT 	PORTA	// ����� ������; ����� ��� ������ �����
;#define LCD_RST_DDR   	DDRA
;#define LCD_RST_PIN   	2
;
;#define LCD_MOSI_PORT 	PORTA	// ����� ������ SPI, ������ ���� ��������������� ��� ����������� SPI, ���� �� ������������
;#define LCD_MOSI_DDR	DDRA
;#define LCD_MOSI_PIN    3
;
;#define LCD_CLK_PORT	PORTA	// ������������ SPI, ������ ���� ��������������� ��� ����������� SPI, ���� �� ������������
;#define LCD_CLK_DDR     DDRA
;#define LCD_CLK_PIN     4
;
;
;
;#ifndef SOFT_SPI
;#define LCD_SS_PORT	    PORTB	// ChipSelect SPI, ������ ���� ��������������� ��� ����������� SPI � �������� �� �����
;#define LCD_SS_DDR     	DDRB
;#define LCD_SS_PIN     	0
;#endif
;
;//***********************************************************
;//��������� ����������� ������� � ���������� ��� ������ � ���
;//***********************************************************
;
;#pragma used+
;
;unsigned char lcd_buf[15];		//��������� ����� ��� ������ �� LCD
;
;bit power_down = 0;			//power-down control: 0 - chip is active, 1 - chip is in PD-mode
;bit addressing = 0;			//����������� ���������: 0 - ��������������, 1- ������������
;//bit instuct_set = 0;			//����� ����������: 0 - �����������, 1 - ����������� - � ������� ������ �� ������������
;
;#ifdef china
;bit x_mirror = 0;			//�������������� �� X: 0 - ����., 1 - ���.
;bit y_mirror = 0;			//�������������� �� Y: 0 - ����., 1 - ���.
;bit SPI_invert = 0;			//������� ����� � SPI: 0 - MSB first, 1 - LSB first
;#endif
;
;//unsigned char set_y;			//����� �� �, 0..5 - � ������� ������ �� ������������
;//unsigned char set_x;                 	//����� �� �, 0..83 - � ������� ������ �� ������������
;unsigned char temp_control = 3;  	//������������� �����������, 0..3
;unsigned char bias = 3;                 //��������, 0..7
;unsigned char Vop = 70;			//������� ���������� LCD, 0..127 (���������� �������������)
;unsigned char disp_config = 2;		//����� �������: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;
;#ifdef china
;unsigned char shift = 5;		//0..3F - ����� ������ �����, � ������
;#endif
;
;#define PIXEL_OFF	0		//������ ����������� ������� - ������������ � ����������� ��������
;#define PIXEL_ON	1
;#define PIXEL_XOR	2
;
;#define LCD_X_RES               84	//���������� ������
;#define LCD_Y_RES               48
;#define LCD_CACHSIZE          LCD_X_RES*LCD_Y_RES/8
;
;#define Cntr_X_RES              102    	//���������� ����������� - �������������� - �� ��������))
;#define Cntr_Y_RES              64
;#define Cntr_buf_size           Cntr_X_RES*Cntr_Y_RES/8
;
;unsigned char  LcdCache [LCD_CACHSIZE];	//Cache buffer in SRAM 84*48 bits or 504 bytes
;unsigned int   LcdCacheIdx;              	//Cache index
;
;#define LCD_CMD         0
;#define LCD_DATA        1
;
;//***************************************************
;//****************��������� �������******************
;//***************************************************
;void LcdSend (unsigned char data, unsigned char cmd);    			//Sends data to display controller
;void LcdUpdate (void);   							//Copies the LCD cache into the device RAM
;void LcdClear (void);    							//Clears the display
;void LcdInit ( void );								//��������� SPI � �������
;void LcdContrast (unsigned char contrast); 					//contrast -> Contrast value from 0x00 to 0x7F
;void LcdMode (unsigned char mode); 						//������ �������: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;void LcdPwrMode (void);								//����������� ��������� ���/���� �������
;void LcdImage (flash unsigned char *imageData);					//����� �����������
;void LcdPixel (unsigned char x, unsigned char y, unsigned char mode);     	//Displays a pixel at given absolute (x, y) location, mode -> Off, On or Xor
;void LcdLine (int x1, int y1, int x2, int y2, unsigned char mode);  		//Draws a line between two points on the display
;void LcdCircle(char x, char y, char radius, unsigned char mode);		//������ ���� � ������������ ������ � ��������
;void LcdBatt(int x1, int y1, int x2, int y2, unsigned char persent);		//������ ��������� � ��������� �� �� %
;void LcdGotoXYFont (unsigned char x, unsigned char y);   			//Sets cursor location to xy location. Range: 1,1 .. 14,6
;void clean_lcd_buf (void);							//������� ���������� ������
;void LcdChr (int ch);								//Displays a character at current cursor location and increment cursor location
;void LcdString (unsigned char x, unsigned char y);				//Displays a string at current cursor location
;void LcdChrBold (int ch);							//�������� ������ �� ������� �����, ������� � ������)
;void LcdStringBold (unsigned char x, unsigned char y);				//�������� ������� � ������ ������
;void LcdChrBig (int ch);							//�������� ������ �� ������� �����, �������
;void LcdStringBig (unsigned char x, unsigned char y);				//�������� ������� ������
;//***************************************************
;// UPDATE ##1
;void LcdBar(int x1, int y1, int x2, int y2, unsigned char persent);		// ������ ��������-��� � ��������� ��� �� "�������"
;void LcdBarLine(unsigned char line, unsigned char persent);			// ������ ��������-��� � ��������� ������
;void LcdStringInv (unsigned char x, unsigned char y);                           // �������� ������ � ��������� ������ (������ ��� ��������)
;
;const char table[0x0500] =
;{
;0x00, 0x00, 0x00, 0x00, 0x00,// 00
;0x00, 0x00, 0x5F, 0x00, 0x00,// 01
;0x00, 0x07, 0x00, 0x07, 0x00,// 02
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 03
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 04
;0x23, 0x13, 0x08, 0x64, 0x62,// 05
;0x36, 0x49, 0x55, 0x22, 0x50,// 06
;0x00, 0x05, 0x03, 0x00, 0x00,// 07
;0x00, 0x1C, 0x22, 0x41, 0x00,// 08
;0x00, 0x41, 0x22, 0x1C, 0x00,// 09
;0x14, 0x08, 0x3E, 0x08, 0x14,// 0A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 0B
;0x00, 0x50, 0x30, 0x00, 0x00,// 0C
;0x08, 0x08, 0x08, 0x08, 0x08,// 0D
;0x00, 0x60, 0x60, 0x00, 0x00,// 0E
;0x20, 0x10, 0x08, 0x04, 0x02,// 0F
;0x00, 0x00, 0x00, 0x00, 0x00,// 10
;0x00, 0x00, 0x5F, 0x00, 0x00,// 11
;0x00, 0x07, 0x00, 0x07, 0x00,// 12
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 13
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 14
;0x23, 0x13, 0x08, 0x64, 0x62,// 15
;0x36, 0x49, 0x55, 0x22, 0x50,// 16
;0x00, 0x05, 0x03, 0x00, 0x00,// 17
;0x00, 0x1C, 0x22, 0x41, 0x00,// 18
;0x00, 0x41, 0x22, 0x1C, 0x00,// 19
;0x14, 0x08, 0x3E, 0x08, 0x14,// 1A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 1B
;0x00, 0x50, 0x30, 0x00, 0x00,// 1C
;0x08, 0x08, 0x08, 0x08, 0x08,// 1D
;0x00, 0x60, 0x60, 0x00, 0x00,// 1E
;0x20, 0x10, 0x08, 0x04, 0x02,// 1F
;0x00, 0x00, 0x00, 0x00, 0x00,// 20 space
;0x00, 0x00, 0x5F, 0x00, 0x00,// 21 !
;0x00, 0x07, 0x00, 0x07, 0x00,// 22 "
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 23 #
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 24 $
;0x23, 0x13, 0x08, 0x64, 0x62,// 25 %
;0x36, 0x49, 0x55, 0x22, 0x50,// 26 &
;0x00, 0x05, 0x03, 0x00, 0x00,// 27 '
;0x00, 0x1C, 0x22, 0x41, 0x00,// 28 (
;0x00, 0x41, 0x22, 0x1C, 0x00,// 29 )
;0x14, 0x08, 0x3E, 0x08, 0x14,// 2a *
;0x08, 0x08, 0x3E, 0x08, 0x08,// 2b +
;0x00, 0x50, 0x30, 0x00, 0x00,// 2c ,
;0x08, 0x08, 0x08, 0x08, 0x08,// 2d -
;0x00, 0x60, 0x60, 0x00, 0x00,// 2e .
;0x20, 0x10, 0x08, 0x04, 0x02,// 2f /
;0x3E, 0x51, 0x49, 0x45, 0x3E,// 30 0
;0x00, 0x42, 0x7F, 0x40, 0x00,// 31 1
;0x42, 0x61, 0x51, 0x49, 0x46,// 32 2
;0x21, 0x41, 0x45, 0x4B, 0x31,// 33 3
;0x18, 0x14, 0x12, 0x7F, 0x10,// 34 4
;0x27, 0x45, 0x45, 0x45, 0x39,// 35 5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// 36 6
;0x01, 0x71, 0x09, 0x05, 0x03,// 37 7
;0x36, 0x49, 0x49, 0x49, 0x36,// 38 8
;0x06, 0x49, 0x49, 0x29, 0x1E,// 39 9
;0x00, 0x36, 0x36, 0x00, 0x00,// 3a :
;0x00, 0x56, 0x36, 0x00, 0x00,// 3b ;
;0x08, 0x14, 0x22, 0x41, 0x00,// 3c <
;0x14, 0x14, 0x14, 0x14, 0x14,// 3d =
;0x00, 0x41, 0x22, 0x14, 0x08,// 3e >
;0x02, 0x01, 0x51, 0x09, 0x06,// 3f ?
;0x32, 0x49, 0x79, 0x41, 0x3E,// 40 @
;0x7E, 0x11, 0x11, 0x11, 0x7E,// 41 A
;0x7F, 0x49, 0x49, 0x49, 0x36,// 42 B
;0x3E, 0x41, 0x41, 0x41, 0x22,// 43 C
;0x7F, 0x41, 0x41, 0x22, 0x1C,// 44 D
;0x7F, 0x49, 0x49, 0x49, 0x41,// 45 E
;0x7F, 0x09, 0x09, 0x09, 0x01,// 46 F
;0x3E, 0x41, 0x49, 0x49, 0x7A,// 47 G
;0x7F, 0x08, 0x08, 0x08, 0x7F,// 48 H
;0x00, 0x41, 0x7F, 0x41, 0x00,// 49 I
;0x20, 0x40, 0x41, 0x3F, 0x01,// 4a J
;0x7F, 0x08, 0x14, 0x22, 0x41,// 4b K
;0x7F, 0x40, 0x40, 0x40, 0x40,// 4c L
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// 4d M
;0x7F, 0x04, 0x08, 0x10, 0x7F,// 4e N
;0x3E, 0x41, 0x41, 0x41, 0x3E,// 4f O
;0x7F, 0x09, 0x09, 0x09, 0x06,// 50 P
;0x3E, 0x41, 0x51, 0x21, 0x5E,// 51 Q
;0x7F, 0x09, 0x19, 0x29, 0x46,// 52 R
;0x46, 0x49, 0x49, 0x49, 0x31,// 53 S
;0x01, 0x01, 0x7F, 0x01, 0x01,// 54 T
;0x3F, 0x40, 0x40, 0x40, 0x3F,// 55 U
;0x1F, 0x20, 0x40, 0x20, 0x1F,// 56 V
;0x3F, 0x40, 0x38, 0x40, 0x3F,// 57 W
;0x63, 0x14, 0x08, 0x14, 0x63,// 58 X
;0x07, 0x08, 0x70, 0x08, 0x07,// 59 Y
;0x61, 0x51, 0x49, 0x45, 0x43,// 5a Z
;0x00, 0x7F, 0x41, 0x41, 0x00,// 5b [
;0x02, 0x04, 0x08, 0x10, 0x20,// 5c Yen Currency Sign
;0x00, 0x41, 0x41, 0x7F, 0x00,// 5d ]
;0x04, 0x02, 0x01, 0x02, 0x04,// 5e ^
;0x40, 0x40, 0x40, 0x40, 0x40,// 5f _
;0x00, 0x01, 0x02, 0x04, 0x00,// 60 `
;0x20, 0x54, 0x54, 0x54, 0x78,// 61 a
;0x7F, 0x48, 0x44, 0x44, 0x38,// 62 b
;0x38, 0x44, 0x44, 0x44, 0x20,// 63 c
;0x38, 0x44, 0x44, 0x48, 0x7F,// 64 d
;0x38, 0x54, 0x54, 0x54, 0x18,// 65 e
;0x08, 0x7E, 0x09, 0x01, 0x02,// 66 f
;0x0C, 0x52, 0x52, 0x52, 0x3E,// 67 g
;0x7F, 0x08, 0x04, 0x04, 0x78,// 68 h
;0x00, 0x44, 0x7D, 0x40, 0x00,// 69 i
;0x20, 0x40, 0x44, 0x3D, 0x00,// 6a j
;0x7F, 0x10, 0x28, 0x44, 0x00,// 6b k
;0x00, 0x41, 0x7F, 0x40, 0x00,// 6c l
;0x7C, 0x04, 0x18, 0x04, 0x78,// 6d m
;0x7C, 0x08, 0x04, 0x04, 0x78,// 6e n
;0x38, 0x44, 0x44, 0x44, 0x38,// 6f o
;0x7C, 0x14, 0x14, 0x14, 0x08,// 70 p
;0x08, 0x14, 0x14, 0x18, 0x7C,// 71 q
;0x7C, 0x08, 0x04, 0x04, 0x08,// 72 r
;0x48, 0x54, 0x54, 0x54, 0x20,// 73 s
;0x04, 0x3F, 0x44, 0x40, 0x20,// 74 t
;0x3C, 0x40, 0x40, 0x20, 0x7C,// 75 u
;0x1C, 0x20, 0x40, 0x20, 0x1C,// 76 v
;0x3C, 0x40, 0x30, 0x40, 0x3C,// 77 w
;0x44, 0x28, 0x10, 0x28, 0x44,// 78 x
;0x0C, 0x50, 0x50, 0x50, 0x3C,// 79 y
;0x44, 0x64, 0x54, 0x4C, 0x44,// 7a z
;0x00, 0x08, 0x36, 0x41, 0x00,// 7b <
;0x00, 0x00, 0x7F, 0x00, 0x00,// 7c |
;0x00, 0x41, 0x36, 0x08, 0x00,// 7d >
;0x10, 0x08, 0x08, 0x10, 0x08,// 7e Right Arrow ->
;0x78, 0x46, 0x41, 0x46, 0x78,// 7f Left Arrow <-
;0x00, 0x00, 0x00, 0x00, 0x00,// 80
;0x00, 0x00, 0x5F, 0x00, 0x00,// 81
;0x00, 0x07, 0x00, 0x07, 0x00,// 82
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 83
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 84
;0x23, 0x13, 0x08, 0x64, 0x62,// 85
;0x36, 0x49, 0x55, 0x22, 0x50,// 86
;0x00, 0x05, 0x03, 0x00, 0x00,// 87
;0x00, 0x1C, 0x22, 0x41, 0x00,// 88
;0x00, 0x41, 0x22, 0x1C, 0x00,// 89
;0x14, 0x08, 0x3E, 0x08, 0x14,// 8A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 8B
;0x00, 0x50, 0x30, 0x00, 0x00,// 8C
;0x08, 0x08, 0x08, 0x08, 0x08,// 8D
;0x00, 0x60, 0x60, 0x00, 0x00,// 8E
;0x20, 0x10, 0x08, 0x04, 0x02,// 8F
;0x00, 0x00, 0x00, 0x00, 0x00,// 90
;0x00, 0x00, 0x5F, 0x00, 0x00,// 91
;0x00, 0x07, 0x00, 0x07, 0x00,// 92
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 93
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 94
;0x23, 0x13, 0x08, 0x64, 0x62,// 95
;0x36, 0x49, 0x55, 0x22, 0x50,// 96
;0x00, 0x05, 0x03, 0x00, 0x00,// 97
;0x00, 0x1C, 0x22, 0x41, 0x00,// 98
;0x00, 0x41, 0x22, 0x1C, 0x00,// 99
;0x14, 0x08, 0x3E, 0x08, 0x14,// 9A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 9B
;0x00, 0x50, 0x30, 0x00, 0x00,// 9C
;0x08, 0x08, 0x08, 0x08, 0x08,// 9D
;0x00, 0x60, 0x60, 0x00, 0x00,// 9E
;0x20, 0x10, 0x08, 0x04, 0x02,// 9F
;0x00, 0x00, 0x00, 0x00, 0x00,// A0
;0x00, 0x00, 0x5F, 0x00, 0x00,// A1
;0x00, 0x07, 0x00, 0x07, 0x00,// A2
;0x14, 0x7F, 0x14, 0x7F, 0x14,// A3
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// A4
;0x23, 0x13, 0x08, 0x64, 0x62,// A5
;0x36, 0x49, 0x55, 0x22, 0x50,// A6
;0x00, 0x05, 0x03, 0x00, 0x00,// A7
;0x00, 0x1C, 0x22, 0x41, 0x00,// A8
;0x00, 0x41, 0x22, 0x1C, 0x00,// A9
;0x14, 0x08, 0x3E, 0x08, 0x14,// AA
;0x08, 0x08, 0x3E, 0x08, 0x08,// AB
;0x00, 0x50, 0x30, 0x00, 0x00,// AC
;0x08, 0x08, 0x08, 0x08, 0x08,// AD
;0x00, 0x60, 0x60, 0x00, 0x00,// AE
;0x20, 0x10, 0x08, 0x04, 0x02,// AF
;0x3E, 0x51, 0x49, 0x45, 0x3E,// B0
;0x00, 0x42, 0x7F, 0x40, 0x00,// B1
;0x42, 0x61, 0x51, 0x49, 0x46,// B2
;0x21, 0x41, 0x45, 0x4B, 0x31,// B3
;0x18, 0x14, 0x12, 0x7F, 0x10,// B4
;0x27, 0x45, 0x45, 0x45, 0x39,// B5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// B6
;0x01, 0x71, 0x09, 0x05, 0x03,// B7
;0x36, 0x49, 0x49, 0x49, 0x36,// B8
;0x06, 0x49, 0x49, 0x29, 0x1E,// B9
;0x00, 0x36, 0x36, 0x00, 0x00,// BA
;0x00, 0x56, 0x36, 0x00, 0x00,// BB
;0x08, 0x14, 0x22, 0x41, 0x00,// BC
;0x14, 0x14, 0x14, 0x14, 0x14,// BD
;0x00, 0x41, 0x22, 0x14, 0x08,// BE
;0x02, 0x01, 0x51, 0x09, 0x06,// BF
;0x7E, 0x11, 0x11, 0x11, 0x7E,// C0 ?
;0x7F, 0x49, 0x49, 0x49, 0x31,// C1 ?
;0x7F, 0x49, 0x49, 0x49, 0x36,// C2 ?
;0x7F, 0x01, 0x01, 0x01, 0x03,// C3 ?
;0x70, 0x29, 0x27, 0x21, 0x7F,// C4 ?
;0x7F, 0x49, 0x49, 0x49, 0x41,// C5 ?
;0x77, 0x08, 0x7F, 0x08, 0x77,// C6 ?
;0x41, 0x41, 0x41, 0x49, 0x76,// C7 ?
;0x7F, 0x10, 0x08, 0x04, 0x7F,// C8 ?
;0x7F, 0x10, 0x09, 0x04, 0x7F,// C9 ?
;0x7F, 0x08, 0x14, 0x22, 0x41,// CA ?
;0x20, 0x41, 0x3F, 0x01, 0x7F,// CB ?
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// CC ?
;0x7F, 0x08, 0x08, 0x08, 0x7F,// CD ?
;0x3E, 0x41, 0x41, 0x41, 0x3E,// CE ?
;0x7F, 0x01, 0x01, 0x01, 0x7F,// CF ?
;0x7F, 0x09, 0x09, 0x09, 0x06,// D0 ?
;0x3E, 0x41, 0x41, 0x41, 0x22,// D1 ?
;0x01, 0x01, 0x7F, 0x01, 0x01,// D2 ?
;0x47, 0x28, 0x10, 0x08, 0x07,// D3 ?
;0x1E, 0x21, 0x7F, 0x21, 0x1E,// D4 ?
;0x63, 0x14, 0x08, 0x14, 0x63,// D5 ?
;0x3F, 0x20, 0x20, 0x20, 0x5F,// D6 ?
;0x07, 0x08, 0x08, 0x08, 0x7F,// D7 ?
;0x7F, 0x40, 0x7F, 0x40, 0x7F,// D8 ?
;0x3F, 0x20, 0x3F, 0x20, 0x5F,// D9 ?
;0x01, 0x7F, 0x48, 0x48, 0x30,// DA ?
;0x7F, 0x48, 0x30, 0x00, 0x7F,// DB ?
;0x00, 0x7F, 0x48, 0x48, 0x30,// DC ?
;0x41, 0x41, 0x41, 0x49, 0x3E,// DD ?
;0x7F, 0x08, 0x3E, 0x41, 0x3E,// DE ?
;0x46, 0x29, 0x19, 0x09, 0x7F,// DF ?
;0x20, 0x54, 0x54, 0x54, 0x78,// E0 ?
;0x3C, 0x4A, 0x4A, 0x49, 0x31,// E1 ?
;0x7C, 0x54, 0x54, 0x28, 0x00,// E2 ?
;0x7C, 0x04, 0x04, 0x04, 0x0C,// E3 ?
;0x72, 0x2A, 0x26, 0x22, 0x7E,// E4 ?
;0x38, 0x54, 0x54, 0x54, 0x18,// E5 ?
;0x6C, 0x10, 0x7C, 0x10, 0x6C,// E6 ?
;0x44, 0x44, 0x54, 0x54, 0x38,// E7 ?
;0x7C, 0x20, 0x10, 0x08, 0x7C,// E8 ?
;0x7C, 0x21, 0x12, 0x09, 0x7C,// E9 ?
;0x7C, 0x10, 0x28, 0x44, 0x00,// EA ?
;0x20, 0x44, 0x3C, 0x04, 0x7C,// EB ?
;0x7C, 0x08, 0x10, 0x08, 0x7C,// EC ?
;0x7C, 0x10, 0x10, 0x10, 0x7C,// ED ?
;0x38, 0x44, 0x44, 0x44, 0x38,// EE ?
;0x7C, 0x04, 0x04, 0x04, 0x7C,// EF ?
;0x7C, 0x14, 0x14, 0x14, 0x08,// F0 ?
;0x38, 0x44, 0x44, 0x44, 0x20,// F1 ?
;0x04, 0x04, 0x7C, 0x04, 0x04,// F2 ?
;0x44, 0x28, 0x10, 0x08, 0x04,// F3 ?
;0x08, 0x14, 0x7E, 0x14, 0x08,// F4 ?
;0x44, 0x28, 0x10, 0x28, 0x44,// F5 ?
;0x3C, 0x40, 0x40, 0x7C, 0x40,// F6 ?
;0x0C, 0x10, 0x10, 0x10, 0x7C,// F7 ?
;0x7C, 0x40, 0x7C, 0x40, 0x7C,// F8 ?
;0x3C, 0x20, 0x3C, 0x20, 0x7C,// F9 ?
;0x04, 0x7C, 0x50, 0x50, 0x20,// FA ?
;0x7C, 0x50, 0x20, 0x00, 0x7C,// FB ?
;0x00, 0x7C, 0x50, 0x50, 0x20,// FC ?
;0x28, 0x44, 0x44, 0x54, 0x38,// FD ?
;0x7C, 0x10, 0x38, 0x44, 0x38,// FE ?
;0x48, 0x54, 0x34, 0x14, 0x7C }; // FF
;
;void LcdSend (unsigned char data, unsigned char cmd)    //Sends data to display controller
; 0000 000F         {

	.CSEG
_LcdSend:
;        #ifdef SOFT_SPI
;        unsigned char i, mask = 128;
;        #endif
;
;        LCD_CPORT.LCD_CPIN = 0;                //Enable display controller (active low)
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+3
;	cmd -> Y+2
;	i -> R17
;	mask -> R16
	LDI  R16,128
	CBI  0x1B,1
;         if (cmd) LCD_DC_PORT.LCD_DC_PIN = 1;	//�������� ������� ��� ������
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x5
	SBI  0x1B,0
;         else LCD_DC_PORT.LCD_DC_PIN = 0;
	RJMP _0x8
_0x5:
	CBI  0x1B,0
;
;        #ifdef SOFT_SPI
;        for (i=0;i<8;i++)
_0x8:
	LDI  R17,LOW(0)
_0xC:
	CPI  R17,8
	BRSH _0xD
;          {
;            	if ((data&mask)!=0) LCD_MOSI_PORT.LCD_MOSI_PIN = 1;
	MOV  R30,R16
	LDD  R26,Y+3
	AND  R30,R26
	BREQ _0xE
	SBI  0x1B,3
;                else LCD_MOSI_PORT.LCD_MOSI_PIN = 0;
	RJMP _0x11
_0xE:
	CBI  0x1B,3
;        	mask = mask/2;
_0x11:
	LSR  R16
;        	LCD_CLK_PORT.LCD_CLK_PIN = 1;
	SBI  0x1B,4
;            LCD_CLK_PORT.LCD_CLK_PIN = 0;
	CBI  0x1B,4
;          }
	SUBI R17,-1
	RJMP _0xC
_0xD:
;        #endif
;
;        #ifndef SOFT_SPI
;        SPDR = data;                            //Send data to display controller
;        while ( (SPSR & 0x80) != 0x80 );        //Wait until Tx register empty
;        #endif
;
;        LCD_CPORT.LCD_CPIN = 1;                //Disable display controller
	SBI  0x1B,1
;        }
	RJMP _0x20C000C
;
;void LcdUpdate (void)   //Copies the LCD cache into the device RAM
;        {
_LcdUpdate:
;        int i;
;	#ifdef china
;	char j;
;	#endif
;
;        LcdSend(0x80, LCD_CMD);		//������� ��������� ��������� ������ ������� �� 0,0
	CALL SUBOPT_0x0
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;
;    #ifdef china                    		//���� ��������� ������� - ������ ������ ������
;		for (j = Cntr_X_RES; j>0; j--) LcdSend(0, LCD_DATA);
;	#endif
;
;        for (i = 0; i < LCD_CACHSIZE; i++)		//������ ������
_0x1B:
	__CPWRN 16,17,504
	BRGE _0x1C
;                {
;                LcdSend(LcdCache[i], LCD_DATA);
	CALL SUBOPT_0x1
	LD   R30,X
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LcdSend
;		#ifdef china				//���� ������� ��������� - ��������� ������ ������ �� ������� ��� ������
;		if (++j == LCD_X_RES)
;			{
;			for (j = (Cntr_X_RES-LCD_X_RES); j>0; j--) LcdSend(0, LCD_DATA);
;			j=0;
;			}
;		#endif
;                }
	__ADDWRN 16,17,1
	RJMP _0x1B
_0x1C:
;        }
	RJMP _0x20C0010
;
;void LcdClear (void)    //Clears the display
;{
_LcdClear:
;        int i;
;	for (i = 0; i < LCD_CACHSIZE; i++) LcdCache[i] = 0;	//�������� ��� ������ 0
	CALL SUBOPT_0x2
;	i -> R16,R17
_0x1E:
	__CPWRN 16,17,504
	BRGE _0x1F
	CALL SUBOPT_0x1
	LDI  R30,LOW(0)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x1E
_0x1F:
	RCALL _LcdUpdate
;}
_0x20C0010:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;/*     or
;void lcd_clear(void) // Clears the display   //Upd - 7
;{
;	lcdCacheIdx = 0;
;	lcd_base_addr(lcdCacheIdx);
;    // Set the entire cache to zero and write 0s to lcd
;    for(int i=0;i<LCD_CACHE_SIZE;i++) {
;		lcd_send(0, LCD_DATA);
;    }
;}
;*/
;
;void LcdInit ( void )	//������������� SPI � �������
;        {
_LcdInit:
;        LCD_RST_PORT.LCD_RST_PIN = 1;       //��������� ����� �����/������
	SBI  0x1B,2
;        LCD_RST_DDR.LCD_RST_PIN = LCD_DC_DDR.LCD_DC_PIN = LCD_CDDR.LCD_CPIN = LCD_MOSI_DDR.LCD_MOSI_PIN = LCD_CLK_DDR.LCD_CLK_PIN = 1;
	SBI  0x1A,4
	SBI  0x1A,3
	SBI  0x1A,1
	SBI  0x1A,0
	SBI  0x1A,2
;        LCD_CLK_PORT.LCD_CLK_PIN = 0;
	CBI  0x1B,4
;        	#ifndef SOFT_SPI
;        LCD_SS_DDR.LCD_SS_PIN = 1;
;        LCD_SS_PORT.LCD_SS_PIN = 0;
;        	#endif
;        delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3
;        	#ifndef SOFT_SPI
;        //SPCR = SPCR_val;
;        //SPSR = SPSR_val;
;        	#endif
;        LCD_RST_PORT.LCD_RST_PIN = 0;       //������� �����
	CBI  0x1B,2
;        delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x3
;        LCD_RST_PORT.LCD_RST_PIN = 1;
	SBI  0x1B,2
;
;        LCD_CPORT.LCD_CPIN = 1;        //Disable LCD controller
	SBI  0x1B,1
;
;/*
;    LCD_PORT |= LCD_SCE_PIN;    // Disable LCD controller
;    lcd_send(0x21, LCD_CMD);  // LCD Extended Commands
;    lcd_send(0xC8, LCD_CMD);  // Set LCD Vop(Contrast)
;    lcd_send(0x06, LCD_CMD);  // Set Temp coefficent
;    lcd_send(0x13, LCD_CMD);  // LCD bias mode 1:48
;    lcd_send(0x20, LCD_CMD);  // Standard Commands, Horizontal addressing
;    lcd_send(0x0C, LCD_CMD);  // LCD in normal mode
;*/
;        LcdSend( 0b00100001, LCD_CMD ); 				//LCD Extended Commands
	LDI  R30,LOW(33)
	CALL SUBOPT_0x4
;        LcdSend( 0b00000100+temp_control, LCD_CMD ); 	//Set Temp coefficent   //! �� 128 - ������
	MOV  R30,R5
	SUBI R30,-LOW(4)
	CALL SUBOPT_0x4
;#ifdef china
;        LcdSend( 0b00001000|SPI_invert<<3, LCD_CMD ); 	//������� ����� � SPI
;#endif
;        LcdSend( 0b00010000+bias, LCD_CMD ); 			//LCD bias mode 1:48
	MOV  R30,R4
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x4
;#ifdef china
;        LcdSend( 0b01000000+shift, LCD_CMD ); 			//������ ������ ���� ������, ���������� �� ������
;#endif
;	    LcdSend( 0b10000000+Vop, LCD_CMD ); 			//Set LCD Vop (Contrast)
	MOV  R30,R7
	SUBI R30,-LOW(128)
	CALL SUBOPT_0x4
;#ifdef china
;	    LcdSend( 0x20|x_mirror<<5|y_mirror<<4|power_down<<3, LCD_CMD );			//LCD Standard Commands
;#endif
;#ifndef china
;        LcdSend( 0x20|power_down<<3|addressing<<2, LCD_CMD );				//LCD Standard Commands
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x20
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	OR   R30,R0
	CALL SUBOPT_0x4
;#endif
;        LcdSend( 0b00001000|((disp_config<<1|disp_config)&0b00000101), LCD_CMD ); 	//LCD mode
	MOV  R30,R6
	LSL  R30
	OR   R30,R6
	ANDI R30,LOW(0x5)
	ORI  R30,8
	CALL SUBOPT_0x4
;        LcdClear();
	RCALL _LcdClear
;        }
	RET
;
;void LcdContrast (unsigned char contrast) 	//contrast -> Contrast value from 0x00 to 0x7F
;        {
;        if (contrast > 0x7F) return;
;	contrast -> Y+0
;        LcdSend( 0x21, LCD_CMD );               //LCD Extended Commands
;        LcdSend( 0x80 | contrast, LCD_CMD );    //Set LCD Vop (Contrast)
;        LcdSend( 0x20, LCD_CMD );               //LCD Standard Commands,Horizontal addressing mode
;        }
;
;void LcdMode (unsigned char mode) 		//����� �������: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;        {
;        if (mode > 3) return;
;	mode -> Y+0
;        LcdSend( 0b00001000|((mode<<1|mode)&0b00000101), LCD_CMD ); 	//LCD mode
;        }
;
; void LcdPwrMode (void) 				//����������� ��������� ���/���� �������
;        {
;        power_down = ~power_down;
;        LcdSend( 0x20|power_down<<3, LCD_CMD );
;        }
;/*
;void LcdPwrMode (void) 				//����������� ��������� ���/���� �������
;        {
;        power_down = ~power_down;
;        	#ifdef china
;	LcdSend( 0x20|x_mirror<<4|y_mirror<<3|power_down<<2|addressing<<1, LCD_CMD );			//LCD Standard Commands
;        	#elif
;        LcdSend( 0x20|0<<2|addressing<<1, LCD_CMD );
;                #endif
;        }
;
;void Lcd_off (void) 				//���� �������
;        {
;        	#ifdef china
;	LcdSend( 0x20|x_mirror<<4|y_mirror<<3|1<<2|addressing<<1, LCD_CMD );			//LCD Standard Commands
;        	#elif
;        LcdSend( 0x20|1<<2|addressing<<1, LCD_CMD );
;                #endif
;        }
;
;void Lcd_on (void) 				//��� �������
;        {
;        	#ifdef china
;	LcdSend( 0x20|x_mirror<<4|y_mirror<<3|0<<2|addressing<<1, LCD_CMD );			//LCD Standard Commands
;        	#elif
;        LcdSend( 0x20|0<<2|addressing<<1, LCD_CMD );
;                #endif
;        }   */
;
;
;
;void LcdImage (flash unsigned char *imageData)	//����� �����������
;        {
_LcdImage:
;        unsigned int i;
;
;        LcdSend(0x80, LCD_CMD);		//������ ��������� �� 0,0
	CALL SUBOPT_0x0
;	*imageData -> Y+2
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;        for (i = 0; i < LCD_CACHSIZE; i++) LcdCache[i] = imageData[i];	//������ ������
_0x37:
	__CPWRN 16,17,504
	BRSH _0x38
	MOVW R30,R16
	SUBI R30,LOW(-_LcdCache)
	SBCI R31,HIGH(-_LcdCache)
	MOVW R0,R30
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x37
_0x38:
	RJMP _0x20C000C
;
;void LcdPixel (unsigned char x, unsigned char y, unsigned char mode)     //Displays a pixel at given absolute (x, y) location, mode -> Off, On or Xor
;        {
_LcdPixel:
;        int index;
;        unsigned char offset, data;
;
;        if ( x > LCD_X_RES ) return;	//���� �������� � ������� ���� - �������
	CALL __SAVELOCR4
;	x -> Y+6
;	y -> Y+5
;	mode -> Y+4
;	index -> R16,R17
;	offset -> R19
;	data -> R18
	LDD  R26,Y+6
	CPI  R26,LOW(0x55)
	BRSH _0x20C000F
;        if ( y > LCD_Y_RES ) return;
	LDD  R26,Y+5
	CPI  R26,LOW(0x31)
	BRSH _0x20C000F
;
;        index = (((int)(y)/8)*84)+x;    //������� ����� ����� � ������� ������ �������
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	LDI  R26,LOW(84)
	LDI  R27,HIGH(84)
	CALL __MULW12
	MOVW R26,R30
	LDD  R30,Y+6
	CALL SUBOPT_0x5
	MOVW R16,R30
;        offset  = y-((y/8)*8);          //������� ����� ���� � ���� �����
	LDD  R30,Y+5
	LSR  R30
	LSR  R30
	LSR  R30
	LSL  R30
	LSL  R30
	LSL  R30
	LDD  R26,Y+5
	SUB  R26,R30
	MOV  R19,R26
;
;        data = LcdCache[index];         //����� ���� �� ���������� �������
	CALL SUBOPT_0x1
	LD   R18,X
;
;        if ( mode == PIXEL_OFF ) data &= ( ~( 0x01 << offset ) );	//����������� ��� � ���� �����
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x3B
	CALL SUBOPT_0x6
	COM  R30
	AND  R18,R30
;                else if ( mode == PIXEL_ON ) data |= ( 0x01 << offset );
	RJMP _0x3C
_0x3B:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x3D
	CALL SUBOPT_0x6
	OR   R18,R30
;                        else if ( mode  == PIXEL_XOR ) data ^= ( 0x01 << offset );
	RJMP _0x3E
_0x3D:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x3F
	CALL SUBOPT_0x6
	EOR  R18,R30
;
;        LcdCache[index] = data;		//��������� ���� �����
_0x3F:
_0x3E:
_0x3C:
	MOVW R30,R16
	SUBI R30,LOW(-_LcdCache)
	SBCI R31,HIGH(-_LcdCache)
	ST   Z,R18
;        }
_0x20C000F:
	CALL __LOADLOCR4
	ADIW R28,7
	RET
;
;void LcdLine (int x1, int y1, int x2, int y2, unsigned char mode)  	//Draws a line between two points on the display - �� �����������
;        {
_LcdLine:
;        signed int dy = 0;
;        signed int dx = 0;
;        signed int stepx = 0;
;        signed int stepy = 0;
;        signed int fraction = 0;
;
;        if (x1>LCD_X_RES || x2>LCD_X_RES || y1>LCD_Y_RES || y2>LCD_Y_RES) return;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	x1 -> Y+17
;	y1 -> Y+15
;	x2 -> Y+13
;	y2 -> Y+11
;	mode -> Y+10
;	dy -> R16,R17
;	dx -> R18,R19
;	stepx -> R20,R21
;	stepy -> Y+8
;	fraction -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRGE _0x41
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRGE _0x41
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	SBIW R26,49
	BRGE _0x41
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,49
	BRLT _0x40
_0x41:
	RJMP _0x20C000E
;
;        dy = y2 - y1;
_0x40:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
;        dx = x2 - x1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
;        if (dy < 0)
	TST  R17
	BRPL _0x43
;                {
;                dy = -dy;
	MOVW R30,R16
	CALL __ANEGW1
	MOVW R16,R30
;                stepy = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x22D
;                }
;                else stepy = 1;
_0x43:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x22D:
	STD  Y+8,R30
	STD  Y+8+1,R31
;        if (dx < 0)
	TST  R19
	BRPL _0x45
;                {
;                dx = -dx;
	MOVW R30,R18
	CALL __ANEGW1
	MOVW R18,R30
;                stepx = -1;
	__GETWRN 20,21,-1
;                }
;                else stepx = 1;
	RJMP _0x46
_0x45:
	__GETWRN 20,21,1
;        dy <<= 1;
_0x46:
	LSL  R16
	ROL  R17
;        dx <<= 1;
	LSL  R18
	ROL  R19
;        LcdPixel(x1,y1,mode);
	CALL SUBOPT_0x7
;        if (dx > dy)
	__CPWRR 16,17,18,19
	BRGE _0x47
;                {
;                fraction = dy - (dx >> 1);
	MOVW R30,R18
	ASR  R31
	ROR  R30
	MOVW R26,R30
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
;                while (x1 != x2)
_0x48:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x4A
;                        {
;                        if (fraction >= 0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x4B
;                                {
;                                y1 += stepy;
	CALL SUBOPT_0x8
;                                fraction -= dx;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R18
	SBC  R31,R19
	STD  Y+6,R30
	STD  Y+6+1,R31
;                                }
;                        x1 += stepx;
_0x4B:
	CALL SUBOPT_0x9
;                        fraction += dy;
	MOVW R30,R16
	CALL SUBOPT_0xA
;                        LcdPixel(x1,y1,mode);
;                        }
	RJMP _0x48
_0x4A:
;                }
;                else
	RJMP _0x4C
_0x47:
;                        {
;                        fraction = dx - (dy >> 1);
	MOVW R30,R16
	ASR  R31
	ROR  R30
	MOVW R26,R30
	MOVW R30,R18
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
;                        while (y1 != y2)
_0x4D:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x4F
;                                {
;                                if (fraction >= 0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x50
;                                        {
;                                        x1 += stepx;
	CALL SUBOPT_0x9
;                                        fraction -= dy;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R16
	SBC  R31,R17
	STD  Y+6,R30
	STD  Y+6+1,R31
;                                        }
;                                y1 += stepy;
_0x50:
	CALL SUBOPT_0x8
;                                fraction += dx;
	MOVW R30,R18
	CALL SUBOPT_0xA
;                                LcdPixel(x1,y1,mode);
;                                }
	RJMP _0x4D
_0x4F:
;                        }
_0x4C:
;        }
_0x20C000E:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
;
;#warning Upd-7 not tested!
;// Set the base address of the lcd
;void lcd_base_addr(unsigned int addr) {   //Upd-7
;	LcdSend(0x80 |(addr % LCD_X_RES), LCD_CMD);
;	addr -> Y+0
;	LcdSend(0x40 |(addr / LCD_X_RES), LCD_CMD);
;}
;
;/* Clears an area on a line */    //Upd-7
;/*
;void lcd_clear_area(unsigned char line, unsigned char startX, unsigned char endX)
;{
;    // Start and end positions of line
;    int start = (line-1)*84+(startX-1);
;    int end = (line-1)*84+(endX-1);
;
;	lcd_base_addr(start);
;
;    // Clear all data in range from cache
;    for(uint16_t i=start;i<end;i++) {
;       LcdSend(0, LCD_DATA);
;    }
;}
;*/
;
;void LcdCircle(char x, char y, char radius, unsigned char mode)		//������ ���� �� ����������� � �������� - �� �����������
;        {
;        signed char xc = 0;
;        signed char yc = 0;
;        signed char p = 0;
;
;        if (x>LCD_X_RES || y>LCD_Y_RES) return;
;	x -> Y+7
;	y -> Y+6
;	radius -> Y+5
;	mode -> Y+4
;	xc -> R17
;	yc -> R16
;	p -> R19
;
;        yc=radius;
;        p = 3 - (radius<<1);
;        while (xc <= yc)
;                {
;                LcdPixel(x + xc, y + yc, mode);
;                LcdPixel(x + xc, y - yc, mode);
;                LcdPixel(x - xc, y + yc, mode);
;                LcdPixel(x - xc, y - yc, mode);
;                LcdPixel(x + yc, y + xc, mode);
;                LcdPixel(x + yc, y - xc, mode);
;                LcdPixel(x - yc, y + xc, mode);
;                LcdPixel(x - yc, y - xc, mode);
;                if (p < 0) p += (xc++ << 2) + 6;
;                        else p += ((xc++ - yc--)<<2) + 10;
;                }
;        }
;
;void LcdBatt(int x1, int y1, int x2, int y2, unsigned char persent)	//������ ��������� � ����������� � %
;        {
;        unsigned char horizon_line,horizon_line2,i;
;        if(persent>100)return;
;	x1 -> Y+11
;	y1 -> Y+9
;	x2 -> Y+7
;	y2 -> Y+5
;	persent -> Y+4
;	horizon_line -> R17
;	horizon_line2 -> R16
;	i -> R19
;        LcdLine(x1,y2,x2,y2,1);  //down
;        LcdLine(x2,y1,x2,y2,1);  //right
;	LcdLine(x1,y1,x1,y2,1);  //left
;	LcdLine(x1,y1,x2,y1,1);  //up
;	LcdLine(x1+7,y1-1,x2-7,y1-1,1);
;	LcdLine(x1+7,y1-2,x2-7,y1-2,1);
;
;        horizon_line=persent*(y2-y1-3)/100;
;        for(i=0;i<horizon_line;i++) LcdLine(x1+2,y2-2-i,x2-2,y2-2-i,1);
;        for(i=horizon_line2;i>horizon_line;i--) LcdLine(x1+2,y2-2-i,x2-2,y2-2-i,0);
;
;void LcdBar(int x1, int y1, int x2, int y2, unsigned char persent)	//������ ��������-���
;        {
;        unsigned char line;
;        if(persent>100)return;
;	x1 -> Y+8
;	y1 -> Y+6
;	x2 -> Y+4
;	y2 -> Y+2
;	persent -> Y+1
;	line -> R17
;        LcdLine(x1+2,y2,x2-2,y2,1);  //down
;        LcdLine(x2-2,y1,x2-2,y2,1);  //right
;	LcdLine(x1+2,y1,x1+2,y2,1);  //left
;	LcdLine(x1+2,y1,x2-2,y1,1);  //up
;
;        LcdLine(x2-1,y1+1,x2-1,y2-1,1);  //right
;	LcdLine(x1+1,y1+1,x1+1,y2-1,1);  //left
;
;        LcdLine(x2,y1+2,x2,y2-2,1);  //right
;	LcdLine(x1,y1+2,x1,y2-2,1);  //left
;
;        line=persent*(x2-x1-7)/100-1;
;        LcdLine(x1+4,y1+2,x2-4,y2-2,0);
;        LcdLine(x1+4,y1+2,x1+4+line,y2-2,1);
;	}
;
;void LcdBarLine(unsigned char line, unsigned char persent)	//������ ��������-���
;        {
;        LcdBar(0, (line-1)*7+1, 83, (line-1)*7+5, persent);
;	line -> Y+1
;	persent -> Y+0
;        }
;
;void LcdGotoXYFont (unsigned char x, unsigned char y)   //Sets cursor location to xy location. Range: 1,1 .. 14,6
;        {
_LcdGotoXYFont:
;        if (x <= 14 && y <= 6) LcdCacheIdx = ( (int)(y) - 1 ) * 84 + ( (int)(x) - 1 ) * 6;
;	x -> Y+1
;	y -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0xF)
	BRSH _0x62
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRLO _0x63
_0x62:
	RJMP _0x61
_0x63:
	LD   R30,Y
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(84)
	LDI  R27,HIGH(84)
	CALL __MULW12
	MOVW R22,R30
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R8,R30
;        }
_0x61:
	ADIW R28,2
	RET
;
;void clean_lcd_buf (void)	//������� ���������� ������
;	{
_clean_lcd_buf:
;	char i;
;
;	for (i=0; i<14; i++) lcd_buf[i] = 0;
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x65:
	CPI  R17,14
	BRSH _0x66
	CALL SUBOPT_0xB
	LDI  R26,LOW(0)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0x65
_0x66:
	LD   R17,Y+
	RET
;
;void LcdChr (int ch)	//Displays a character at current cursor location and increment cursor location
; 	{
_LcdChr:
;     	unsigned char i;
;
;        for ( i = 0; i < 5; i++ ) LcdCache[LcdCacheIdx++] = table[(ch*5+i)];	//�������� ����-������� �� ������� � ������ � ������ - 5 ���
	ST   -Y,R17
;	ch -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x68:
	CPI  R17,5
	BRSH _0x69
	CALL SUBOPT_0xC
	MOVW R22,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R17
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_table*2)
	SBCI R31,HIGH(-_table*2)
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	SUBI R17,-1
	RJMP _0x68
_0x69:
	CALL SUBOPT_0xC
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 	}
	LDD  R17,Y+0
	RJMP _0x20C000B
;
;void LcdChrInv (int ch)	//Displays a character at current cursor location and increment cursor location
; 	{
;     	unsigned char i;
;
;        for ( i = 0; i < 5; i++ ) LcdCache[LcdCacheIdx++] = ~(table[(ch*5+i)]);	//�������� ����-������� �� ������� � ������ � ������ - 5 ���
;	ch -> Y+1
;	i -> R17
; 	}
;
;void LcdString (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
_LcdString:
;	unsigned char i;
;
;	if (x > 14 || y > 6) return;
	ST   -Y,R17
;	x -> Y+2
;	y -> Y+1
;	i -> R17
	LDD  R26,Y+2
	CPI  R26,LOW(0xF)
	BRSH _0x6E
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRLO _0x6D
_0x6E:
	LDD  R17,Y+0
	RJMP _0x20C000B
;	LcdGotoXYFont (x, y);
_0x6D:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _LcdGotoXYFont
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChr (lcd_buf[i]);
	LDI  R17,LOW(0)
_0x71:
	LDD  R26,Y+2
	LDI  R30,LOW(15)
	SUB  R30,R26
	CP   R17,R30
	BRSH _0x72
	CALL SUBOPT_0xB
	LD   R30,Z
	CPI  R30,0
	BREQ _0x73
	CALL SUBOPT_0xB
	LD   R30,Z
	CALL SUBOPT_0xD
	RCALL _LcdChr
;	clean_lcd_buf();
_0x73:
	SUBI R17,-1
	RJMP _0x71
_0x72:
	RCALL _clean_lcd_buf
;	}
	LDD  R17,Y+0
	RJMP _0x20C000B
;
;void LcdStringInv (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
;	unsigned char i;
;
;	if (x > 14 || y > 6) return;
;	x -> Y+2
;	y -> Y+1
;	i -> R17
;	LcdGotoXYFont (x, y);
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChrInv (lcd_buf[i]);
;	clean_lcd_buf();
;	}
;
;void LcdChrBold (int ch)	//Displays a bold character at current cursor location and increment cursor location
; 	{
;     	unsigned char i;
;     	unsigned char a = 0, b = 0, c = 0;
;
;     	for ( i = 0; i < 5; i++ )
;	ch -> Y+4
;	i -> R17
;	a -> R16
;	b -> R19
;	c -> R18
;     	        {
;     	        c = table[(ch*5+i)];		//�������� ������� �� �������
;
;     	        b =  (c & 0x01) * 3;            //"�����������" ������� �� ��� �����
;              	b |= (c & 0x02) * 6;
;              	b |= (c & 0x04) * 12;
;              	b |= (c & 0x08) * 24;
;
;              	c >>= 4;
;              	a =  (c & 0x01) * 3;
;              	a |= (c & 0x02) * 6;
;              	a |= (c & 0x04) * 12;
;              	a |= (c & 0x08) * 24;
;
;     	        LcdCache[LcdCacheIdx] = b;	//�������� ����� � �������� �����
;     	        LcdCache[LcdCacheIdx+1] = b;    //��������� ��� ��������� ������� ������
;     	        LcdCache[LcdCacheIdx+84] = a;
;     	        LcdCache[LcdCacheIdx+85] = a;
;     	        LcdCacheIdx = LcdCacheIdx+2;
;     	        }
;
;     	LcdCache[LcdCacheIdx++] = 0x00;	//��� ������� ����� ���������
;     	LcdCache[LcdCacheIdx++] = 0x00;
; 	}
;
;void LcdStringBold (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
;	unsigned char i;
;
;	if (x > 13 || y > 5) return;
;	x -> Y+2
;	y -> Y+1
;	i -> R17
;	LcdGotoXYFont (x, y);
;	for ( i = 0; i < 14-x; i++ ) if (lcd_buf[i]) LcdChrBold (lcd_buf[i]);
;	clean_lcd_buf();
;	}
;
;void LcdChrBig (int ch)	//Displays a character at current cursor location and increment cursor location
; 	{
;     	unsigned char i;
;     	unsigned char a = 0, b = 0, c = 0;
;
;     	for ( i = 0; i < 5; i++ )
;	ch -> Y+4
;	i -> R17
;	a -> R16
;	b -> R19
;	c -> R18
;     	        {
;     	        c = table[(ch*5+i)];		//�������� ������� �� �������
;
;     	        b =  (c & 0x01) * 3;            //"�����������" ������� �� ��� �����
;              	b |= (c & 0x02) * 6;
;              	b |= (c & 0x04) * 12;
;              	b |= (c & 0x08) * 24;
;
;              	c >>= 4;
;              	a =  (c & 0x01) * 3;
;              	a |= (c & 0x02) * 6;
;              	a |= (c & 0x04) * 12;
;              	a |= (c & 0x08) * 24;
;     	        LcdCache[LcdCacheIdx] = b;
;     	        LcdCache[LcdCacheIdx+84] = a;
;     	        LcdCacheIdx = LcdCacheIdx+1;
;     	        }
;
;     	LcdCache[LcdCacheIdx++] = 0x00;
;     	}
;
;void LcdStringBig (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
;	unsigned char i;
;
;	if (x > 14 || y > 5) return;
;	x -> Y+2
;	y -> Y+1
;	i -> R17
;	LcdGotoXYFont (x, y);
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChrBig (lcd_buf[i]);
;	clean_lcd_buf();
;	}
;
;#pragma used-
;// �������� ��� 3310
;
;  flash unsigned char waitImage[] = {
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC0,0x20,0x20,
;  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0xF0,0x10,0x10,0x10,0x10,0xE0,0x00,0x00,0xF0,0x00,0x00,0x80,0x40,0x40,
;  0x40,0x80,0x00,0x00,0x80,0x40,0x40,0x40,0x80,0x00,0x00,0x80,0x40,0x40,0x40,0x80,
;  0x00,0x00,0x80,0x40,0x40,0x40,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x0F,0x11,0x31,0x31,0xD1,0xF1,0xD1,0xD1,0x31,0x11,0x11,0x0F,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x1F,0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x1F,0x00,
;  0x00,0x0F,0x12,0x12,0x12,0x0B,0x00,0x00,0x0C,0x12,0x12,0x0A,0x1F,0x00,0x00,0x09,
;  0x12,0x12,0x12,0x0C,0x00,0x00,0x0F,0x12,0x12,0x12,0x0B,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0xF0,0x18,0x86,0x86,0xE1,0xF1,0xE1,0xE1,0x86,0x18,0x18,
;  0xF0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x60,0x80,0x00,0x80,
;  0x60,0x80,0x00,0x80,0x60,0x00,0x40,0x20,0x20,0x20,0xC0,0x00,0x00,0xE8,0x00,0x20,
;  0xF8,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x07,0x07,0x07,0x07,0x07,0x07,
;  0x07,0x07,0x07,0x07,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x03,0x0C,0x03,0x00,0x03,0x0C,0x03,0x00,0x00,0x06,0x09,0x09,0x05,0x0F,0x00,
;  0x00,0x0F,0x00,0x00,0x0F,0x08,0x00,0x00,0x00,0x00,0x08,0x00,0x00,0x08,0x00,0x00,
;  0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;  };
;
; flash unsigned char rad1Image[] = {	// �������
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,
; 0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE,
; 0xFE,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0xF8,0xFE,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0x40,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x40,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x0F,0x03,0x01,0xF0,0xF8,0xFC,0xFC,0xFE,
; 0xFE,0xFE,0xFE,0xFE,0xFE,0xFC,0xFC,0xF8,0xF0,0x01,0x03,0x0F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE1,
; 0xE3,0xE7,0xC7,0xCF,0x8F,0x8F,0x8F,0x8F,0xCF,0xC7,0xE7,0xE3,0xE1,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0C,0x0E,0x1F,0x1F,0x1F,0x3F,
; 0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F,0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F,
; 0x0E,0x0C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;
; flash unsigned char rad2Image[] = {	// �������+��������
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,
; 0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE,
; 0xFC,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0xF8,0xFE,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0x40,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x40,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x0F,0x03,0x01,0xF0,0xF8,0xFC,0xFC,0xFE,
; 0xFE,0xFE,0xFE,0xFE,0xFE,0xFC,0xFC,0xF8,0xF0,0x01,0x03,0x0F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE1,
; 0xE3,0xE7,0xC7,0xCF,0x8F,0x8F,0x8F,0x8F,0xCF,0xC7,0xE7,0xE3,0xE1,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x70,0x88,0x70,0x50,0x88,0x70,0x00,0xC8,0xA8,0x90,0x00,0x70,
; 0x88,0x70,0x00,0x10,0xF8,0x00,0x70,0x88,0x70,0x00,0x0C,0x0E,0x1F,0x1F,0x1F,0x3F,
; 0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F,0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F,
; 0x0E,0x0C,0x00,0x00,0x00,0xF0,0x28,0xF0,0x00,0xF8,0x20,0xF8,0x00,0xF8,0xA8,0x88,
; 0x00,0x88,0xF8,0x88,0x00,0xF8,0x48,0xB0};
;
;flash unsigned char rad3Image[] = {	 //�������+��������+abc
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,
;0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,
;0x00,0x00,0x00,0x00,0x00,0xC0,0x20,0x20,0x20,0x40,0x80,0x40,0x20,0x10,0x0C,0x00,
;0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE,
;0xFC,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0xF8,0xFE,0xFF,
;0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
;0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0x41,0x02,0x02,0x02,0x01,0x00,0x01,
;0x02,0x02,0x41,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
;0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,0x7F,
;0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
;0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x0F,0x03,0x01,0xF0,0xF8,0xFC,0xFC,0xFE,
;0xFE,0xFE,0xFE,0xFE,0xFE,0xFC,0xFC,0xF8,0xF0,0x01,0x03,0x0F,0x7F,0x7F,0x7F,0x7F,
;0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
;0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0xF8,0x24,0x24,0x58,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE1,
;0xE3,0xE7,0xC7,0xCF,0x8F,0x8F,0x8F,0x8F,0xCF,0xC7,0xE7,0xE3,0xE1,0xC0,0x80,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x30,0xC0,0xC0,0x30,0x0C,0x02,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x08,0x10,0x10,0x0F,0x02,0x04,0x84,0xC3,0xE0,0xF0,0xF8,0xFC,0xFE,
;0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
;0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x0F,0x10,0x10,0x0F,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x70,0x88,0x70,0x50,0x88,0x70,0x00,0xC8,0xA8,0x90,0x00,0x70,
;0x88,0x70,0x00,0x10,0xF8,0x00,0x10,0xF8,0x00,0x00,0x0C,0x0E,0x1F,0x1F,0x1F,0x3F,
; 0x88,0x70,0x00,0x10,0xF8,0x00,0x70,0x88,0x70,0x00,0x0C,0x0E,0x1F,0x1F,0x1F,0x3F,
;0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
;0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F,0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F,
;0x0E,0x0C,0x00,0x00,0x00,0xF0,0x28,0xF0,0x00,0xF8,0x20,0xF8,0x00,0xF8,0xA8,0x88,
;0x00,0x88,0xF8,0x88,0x00,0xF8,0x48,0xB0};
;
; flash unsigned char rad4Image[] = {	// �������+��������+abc(���)
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,
; 0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE,
; 0xFC,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0xF8,0xFE,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0x1F,0xEF,0xEF,0xEF,0x5F,0xBF,0x5F,0xEF,0xF7,0x79,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0x40,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x40,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
; 0xFB,0x67,0x9F,0x9F,0x67,0xF9,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7E,0x7E,0x7E,0x7F,0x7F,0x7F,
; 0x7E,0x7E,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x0F,0x03,0x01,0xF0,0xF8,0xFC,0xFC,0xFE,
; 0xFE,0xFE,0xFE,0xFE,0xFE,0xFC,0xFC,0xF8,0xF0,0x01,0x03,0x0F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x77,0x77,0x78,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,0x7F,
; 0x7F,0x7F,0x7F,0x7F,0x7F,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE1,
; 0xE3,0xE7,0xC7,0xCF,0x8F,0x8F,0x8F,0x8F,0xCF,0xC7,0xE7,0xE3,0xE1,0xC0,0x80,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,
; 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x07,0xDB,0xDB,0xA7,0x7F,0xFF,0xFF,
; 0xFF,0xFF,0xFF,0xFF,0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; 0x00,0x00,0x00,0x00,0x70,0x88,0x70,0x50,0x88,0x70,0x00,0xC8,0xA8,0x90,0x00,0x70,
; 0x88,0x70,0x00,0x10,0xF8,0x00,0x70,0x88,0x70,0x00,0x0C,0x0E,0x1F,0x1F,0x1F,0x3F,
; 0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF,0xFF,0xFF,0xF7,0xEF,0xEF,0xF0,0xFD,0xFB,
; 0xFB,0xFC,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F,0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F,
; 0x0E,0x0C,0x00,0x00,0x00,0xF0,0x28,0xF0,0x00,0xF8,0x20,0xF8,0x00,0xF8,0xA8,0x88,
; 0x00,0x88,0xF8,0x88,0x00,0xF8,0x48,0xB0};
;
;
; flash unsigned char mini_WIN[504] =
;{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x80, 0x80, 0xC0, 0xE0, 0xE0, 0xE0, 0xE0, 0xF0, 0x70,
;  0x70, 0x38, 0x38, 0x38, 0x38, 0x18, 0x18, 0x18, 0x1C, 0x1C, 0x1C, 0x1C,
;  0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C,
;  0x1C, 0x1C, 0x1C, 0x1C, 0x18, 0x18, 0x18, 0x38, 0x38, 0x38, 0x79, 0x70,
;  0xF0, 0xF0, 0xE0, 0xE0, 0xE0, 0xC0, 0xC0, 0x80, 0x80, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0, 0xE0, 0xF0, 0xF8, 0x7C, 0x3E,
;  0x1F, 0x0F, 0x07, 0x07, 0x03, 0x03, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0xC0, 0xE0, 0xF8, 0xF8, 0xF8, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC,
;  0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xF8, 0x38, 0x10, 0x80, 0xC0,
;  0xE0, 0xE0, 0xE0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0,
;  0xC0, 0xC0, 0xC0, 0xC1, 0xC1, 0x61, 0x23, 0x03, 0x07, 0x0F, 0x1F, 0x3E,
;  0x7E, 0x7C, 0xF8, 0xF0, 0xE0, 0xE0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x03, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xC0, 0xEC,
;  0xE6, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7,
;  0xE7, 0xE7, 0xE7, 0xCF, 0x0F, 0x0F, 0x83, 0x81, 0x9C, 0x3E, 0x3F, 0x7F,
;  0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x3F,
;  0xBF, 0x1F, 0x1F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x03, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFC, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x3F, 0x7F, 0xFF, 0xFC, 0xF0, 0xE0,
;  0xC0, 0x80, 0x00, 0x00, 0x00, 0x30, 0x38, 0x1E, 0x1F, 0x1F, 0x1F, 0x1F,
;  0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x3F, 0x3F, 0x3F, 0x3F,
;  0x0F, 0x07, 0x41, 0xF0, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x0F, 0x03,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0,
;  0xE0, 0xF0, 0xFE, 0xFF, 0x7F, 0x3F, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03,
;  0x07, 0x0F, 0x0F, 0x1E, 0x1E, 0x3C, 0x3C, 0x38, 0x38, 0x70, 0x70, 0xF0,
;  0xE0, 0xE0, 0xE0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0x80, 0x80, 0x80,
;  0x80, 0x80, 0x80, 0x80, 0x80, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81,
;  0x81, 0x81, 0x81, 0xC1, 0xC1, 0xC1, 0xC0, 0xC0, 0xC0, 0xE0, 0xE0, 0xF0,
;  0x70, 0x70, 0x78, 0x38, 0x38, 0x3C, 0x3C, 0x1E, 0x0E, 0x0F, 0x07, 0x07,
;  0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0xF0, 0x10, 0x20, 0x11, 0xF1, 0x01, 0x01, 0xE9, 0x01, 0x03,
;  0xE3, 0x23, 0xE3, 0x03, 0x03, 0xEB, 0x03, 0x03, 0x03, 0x13, 0x23, 0x43,
;  0x83, 0x41, 0x21, 0x41, 0x81, 0x41, 0x21, 0x10, 0x00, 0x00, 0xE8, 0x00,
;  0x00, 0xE0, 0x20, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;
; static const char psydion [504]  =       //��������
;{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x80, 0x80, 0xC0, 0xC0, 0xE0, 0x60, 0x70, 0x30, 0x30, 0x18, 0x18, 0x18,
;  0x0C, 0x2C, 0x2C, 0x2C, 0x2C, 0xE6, 0xE6, 0xE6, 0xC6, 0x02, 0x02, 0x02,
;  0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
;  0x02, 0x02, 0xC2, 0xE6, 0xE6, 0xE6, 0x26, 0x2C, 0x2C, 0x2C, 0x0C, 0x08,
;  0x18, 0x18, 0x18, 0x30, 0x30, 0x70, 0x60, 0xE0, 0xC0, 0xC0, 0x80, 0x80,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x80, 0xC0, 0xF0, 0x38, 0x1C, 0x8C, 0x0E, 0x06, 0x07,
;  0x03, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x1F, 0x3F, 0x7F, 0x78, 0x60, 0x40,
;  0xC3, 0xC3, 0xC3, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xC3, 0xC3, 0xC3, 0x40,
;  0x60, 0x78, 0x7F, 0x3F, 0x1F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x03,
;  0x07, 0x06, 0x8E, 0x1C, 0x38, 0x78, 0xF0, 0xC0, 0x80, 0x00, 0x00, 0x00,
;  0x00, 0xF8, 0xFE, 0x1F, 0x03, 0x00, 0x00, 0x00, 0x07, 0x06, 0x06, 0x0E,
;  0x0E, 0xEE, 0xEE, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8C, 0x9C, 0xF8,
;  0xF0, 0xC0, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
;  0x80, 0xC0, 0xE0, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0xE0, 0xC0, 0x80, 0x80,
;  0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xE0, 0xF8, 0xB8,
;  0x9C, 0x8C, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0xEE, 0xEE, 0x0E, 0x0E, 0x0E,
;  0x06, 0x06, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x1F, 0xFE, 0xF8, 0x00,
;  0x00, 0x3F, 0xFF, 0xF0, 0xC0, 0x00, 0x00, 0x00, 0xC0, 0xE0, 0xE0, 0xE0,
;  0xE0, 0xEF, 0xEF, 0xE3, 0xE3, 0xE3, 0xE3, 0x63, 0x73, 0x73, 0x3B, 0x3F,
;  0x1F, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03,
;  0x03, 0x07, 0x0F, 0xFF, 0xFD, 0xFE, 0xFD, 0xFF, 0x0F, 0x07, 0x03, 0x03,
;  0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x0F, 0x1F, 0x3B,
;  0x73, 0x73, 0x63, 0x63, 0xE3, 0xE3, 0xE3, 0xEF, 0xEF, 0xE0, 0xE0, 0xE0,
;  0xE0, 0xE0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xF0, 0xFF, 0x3F, 0x00,
;  0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x18, 0x30, 0x33, 0x60, 0xE0, 0xC0,
;  0xC0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xF8, 0xFC, 0xFC, 0x1C, 0x0E, 0x06,
;  0x86, 0x86, 0x86, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x86, 0x86, 0x86, 0x06,
;  0x0E, 0x1C, 0xFC, 0xF8, 0xF8, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0,
;  0xC0, 0xE0, 0x73, 0x38, 0x38, 0x1E, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x01, 0x03, 0x03, 0x07, 0x06, 0x0E, 0x0C, 0x0C, 0x18, 0x18, 0x38, 0x30,
;  0x20, 0x28, 0x28, 0x68, 0x6C, 0x6F, 0x6F, 0x67, 0x43, 0xC0, 0xC0, 0xC0,
;  0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC0,
;  0xC0, 0xC0, 0xC3, 0x47, 0x6F, 0x6F, 0x6C, 0x68, 0x68, 0x28, 0x20, 0x30,
;  0x30, 0x38, 0x18, 0x18, 0x0C, 0x0C, 0x0E, 0x06, 0x07, 0x03, 0x03, 0x01,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;  static const char psy[504] =                      // �����  ����
;{ 0x00, 0x00, 0x00, 0x30, 0x30, 0x30, 0x70, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0,
;  0xE0, 0xE0, 0xC0, 0xC0, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0xF0, 0xF0,
;  0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0,
;  0xF0, 0xF0, 0xF0, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0x70, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xC0, 0xE0, 0xE0,
;  0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0x70, 0x30, 0x30, 0x30, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1F, 0xFF, 0xFF, 0xFF,
;  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xF0, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0xF0, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0xFF, 0xFF, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0F,
;  0x3F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0xF0, 0xE0,
;  0xC0, 0xC0, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0xC0,
;  0xC0, 0xE0, 0xF0, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F,
;  0x0F, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x03, 0x03, 0x03, 0x03, 0x07, 0x07,
;  0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F,
;  0x0F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
;  0x07, 0x07, 0x03, 0x03, 0x03, 0x03, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1E, 0x1E,
;  0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;  0x1F, 0x1E, 0x1E, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;  static const char owl[504] =                 //����
;{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x72, 0xF2, 0x9E, 0x5C,
;  0xDC, 0xFC, 0xF8, 0x38, 0x08, 0xC0, 0xF0, 0xC0, 0x08, 0x38, 0xF8, 0xFC,
;  0xDC, 0x5C, 0x9E, 0xF2, 0x72, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x7E, 0xE6, 0xDE, 0xBF, 0x77, 0xB3,
;  0x9F, 0xFF, 0xC7, 0x82, 0x00, 0x20, 0x71, 0x20, 0x00, 0x82, 0xC7, 0xFF,
;  0x9F, 0xB3, 0x77, 0xBF, 0xDE, 0xE6, 0x7E, 0x3C, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x02,
;  0x05, 0x01, 0x04, 0x6F, 0x3E, 0x0E, 0x7C, 0x0E, 0x3E, 0x6F, 0x04, 0x01,
;  0x05, 0x02, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x08, 0x0C, 0x0E, 0x0E, 0x0E, 0x0E, 0x1E, 0x1F, 0x1F, 0x3F,
;  0x3F, 0x3F, 0x37, 0x7B, 0xFB, 0x86, 0xFE, 0xEE, 0xE6, 0x3E, 0xCE, 0xFE,
;  0xBC, 0xCC, 0xFC, 0xF8, 0xF8, 0xF0, 0xE0, 0x01, 0x39, 0xF9, 0xFF, 0xCF,
;  0xAE, 0xEE, 0xFC, 0x7C, 0x00, 0x60, 0xF8, 0x60, 0x00, 0x7C, 0xFC, 0xEE,
;  0xAE, 0xCF, 0xFF, 0xF9, 0x39, 0x01, 0xE0, 0xF0, 0xF8, 0xF8, 0xFC, 0xCC,
;  0xBC, 0xFE, 0xCE, 0x3E, 0xE6, 0xEE, 0xFE, 0x86, 0xFB, 0x7B, 0x37, 0x3F,
;  0x3F, 0x3F, 0x1F, 0x1F, 0x1E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0C, 0x08, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03, 0x07, 0x01, 0x0F,
;  0x0F, 0x0B, 0x0D, 0x0E, 0x1E, 0x1F, 0x1F, 0x1F, 0x38, 0x07, 0x37, 0x75,
;  0xDB, 0xBF, 0xE7, 0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x81, 0xE7, 0xBF,
;  0xDB, 0x75, 0x37, 0x07, 0x38, 0x1F, 0x1F, 0x1F, 0x1E, 0x0E, 0x0D, 0x0B,
;  0x0F, 0x0F, 0x01, 0x07, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x01, 0x63, 0x73, 0x3F, 0xE7, 0xF7, 0x1E, 0xF7, 0xE7, 0x3F, 0x73, 0x63,
;  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;static const char BattFull[504] =
;{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7E, 0x42, 0x5A,
;  0x5A, 0x5A, 0x5A, 0x5A, 0x5A, 0x5A, 0x5A, 0x5A, 0x5A, 0x42, 0x7E, 0x3C,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;
;  static const char bell[504] =
;{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x80, 0xC0, 0xC0, 0xE0, 0xE0, 0xE0, 0xF0, 0xF0, 0xF0, 0xF8, 0xF8,
;  0xF8, 0x78, 0x7C, 0x7C, 0x7C, 0x7E, 0x3E, 0x3E, 0x3E, 0x3E, 0x3E, 0x1E,
;  0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E,
;  0x3E, 0x3E, 0x3E, 0x3E, 0x3E, 0x7E, 0x7C, 0x7C, 0x7C, 0xF8, 0xF8, 0xF8,
;  0xF8, 0xF0, 0xF0, 0xF0, 0xE0, 0xE0, 0xC0, 0xC0, 0x80, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF,
;  0x7F, 0x7F, 0x1F, 0x1F, 0x0F, 0x07, 0x07, 0x03, 0x01, 0x01, 0x01, 0x00,
;  0xC0, 0xE0, 0xE0, 0xE0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0,
;  0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xF0, 0xF0,
;  0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0, 0xE0, 0xC0, 0x00,
;  0x01, 0x03, 0x03, 0x07, 0x07, 0x0F, 0x1F, 0x1F, 0x3F, 0x3F, 0xFF, 0xFE,
;  0xFC, 0xFC, 0xF8, 0xF0, 0xE0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0xC0, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x01, 0x01,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE,
;  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x03, 0x01, 0x01, 0x01, 0x01,
;  0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
;  0x01, 0x01, 0x03, 0x0F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
;  0x07, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xF8, 0xC0, 0x00, 0x00,
;  0x00, 0x07, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0, 0x80, 0x80,
;  0x00, 0x00, 0x00, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFE, 0xFF, 0xFF,
;  0xFF, 0xFF, 0xEF, 0xE7, 0xE3, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0,
;  0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0,
;  0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE3, 0xE7, 0xEF, 0xFF, 0xFF, 0xFF, 0xFF,
;  0xFF, 0xFE, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;  0xE0, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x07, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x0F, 0x1F, 0x1F, 0x3F, 0x7F, 0xFF,
;  0xFE, 0xFE, 0xF8, 0xF8, 0xF1, 0xE1, 0xE1, 0xC1, 0x81, 0x81, 0x01, 0x01,
;  0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
;  0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x01, 0x01,
;  0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
;  0x81, 0xC1, 0xC1, 0xC1, 0xE1, 0xF1, 0xF0, 0xF8, 0xFC, 0xFC, 0xFF, 0xFF,
;  0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;  0x00, 0x01, 0x03, 0x03, 0x07, 0x07, 0x07, 0x0F, 0x0F, 0x1F, 0x1F, 0x1F,
;  0x3F, 0x3F, 0x3E, 0x3E, 0x3E, 0x3C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C,
;  0x7C, 0x78, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0x7C, 0x7C,
;  0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x3C, 0x3E, 0x3E, 0x3E, 0x3F, 0x1F, 0x1F,
;  0x1F, 0x1F, 0x0F, 0x0F, 0x07, 0x07, 0x03, 0x03, 0x01, 0x01, 0x00, 0x00,
;  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
;
;
;
;
;flash unsigned char Batt0[16] = {0x7F,0x41,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};	 // ������� ������ �������
;flash unsigned char Batt1[16] = {0x7F,0x41,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt2[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt3[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt4[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt5[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt6[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt7[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt8[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt9[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x41,0x7F,0x3E};
;flash unsigned char Batt10[16] = {0x7F,0x41,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x5D,0x41,0x7F,0x3E};
;flash unsigned char Batt_done[16] = {0x7F,0x41,0x55,0x49,0x55,0x49,0x55,0x49,0x55,0x49,0x55,0x49,0x55,0x41,0x7F,0x3E};
;
;// flash unsigned char Card[7] = {0x7C,0x42,0x5D,0x55,0x49,0x41,0x7F};
;flash unsigned char Card[7] = {0x7C,0x42,0x41,0x41,0x41,0x41,0x7F};	  //������� ����� ������
;flash unsigned char CardFail[7] = {0x7C,0x62,0x55,0x49,0x55,0x63,0x7F};  // ������������� ����� - ������ �������
;flash unsigned char CardFull[7] = {0x7C,0x7E,0x7F,0x7F,0x7F,0x7F,0x7F};  // ����������� �����
;
;
;//flash unsigned char Power[14] = {0x14,0x14,0x3E,0x22,0x22,0x22,0x1C,0x08,0x04,0x04,0x08,0x10,0x10,0x08};	//  ������ �����
;
;//flash unsigned char USB[12] = {0x1E,0x20,0x20,0x1E,0x00,0x24,0x2A,0x12,0x00,0x3E,0x2A,0x14};	 // USB
;
;flash unsigned char Bell[9] = {0x20,0x50,0x4E,0x61,0x61,0x61,0x4E,0x50,0x20};                  //   ���������
;
;flash unsigned char Radar[8] = {0x03,0x44,0x68,0x78,0x54,0x22,0x20,0x20};                       //  GPS
;flash unsigned char RadarLocate[8] = {0x03,0x44,0x68,0x79,0x54,0x22,0x28,0x25};                 //  GPS �� ����������
;
;flash unsigned char Level0[2] = {0x60,0x60};                                                    //  ��������� ������� ������
;flash unsigned char Level1[4] = {0x60,0x60,0x70,0x70};
;flash unsigned char Level2[6] = {0x60,0x60,0x70,0x70,0x78,0x78};
;flash unsigned char Level3[8] = {0x60,0x60,0x70,0x70,0x78,0x78,0x7C,0x7C};
;flash unsigned char Level4[10] = {0x60,0x60,0x70,0x70,0x78,0x78,0x7C,0x7C,0x7E,0x7E};
;flash unsigned char Level5[12] = {0x60,0x60,0x70,0x70,0x78,0x78,0x7C,0x7C,0x7E,0x7E,0x7F,0x7F};

	.DSEG
;//***************************************************************************
;//
;//  Author(s)...: Pashgan    http://ChipEnable.Ru
;//
;//
;//  Compiler....: CodeVision 2.04
;//
;//  Description.: USART/UART. ���������� ��������� �����
;//
;//  Data........: 3.01.10
;//
;//***************************************************************************
;#include "usart.h"
;
;
;#warning �������� �� ���������+ ���������� �� Usart_rxCount!
;/*
;  struct {
;	u08 buff[TX_BUFFER_SIZE];
;	u08 head;
;	u08 tail;
;} TX_buff;
;
;struct {
;	u08 buff[RX_BUFFER_SIZE];
;	u08 head;
;	u08 tail;
;} RX_buff;
;*/
;//���������� �����
;static volatile char Usart0_TX_buf[SIZE_BUF_TX];
;static volatile uint16_t Usart0_txBufTail = 0;
;static volatile uint16_t Usart0_txBufHead = 0;
;//static volatile uint16_t Usart0_txCount = 0;
;
;static volatile char Usart1_TX_buf[SIZE_BUF_TX];
;static volatile uint16_t Usart1_txBufTail = 0;
;static volatile uint16_t Usart1_txBufHead = 0;
;//static volatile uint16_t Usart1_txCount = 0;
; #warning  Usart0_txCount not used
;
;
;//�������� �����
;static volatile char Usart0_RX_buf[SIZE_BUF_RX];
;static volatile uint16_t Usart0_rxBufTail = 0;
;static volatile uint16_t Usart0_rxBufHead = 0;
;static volatile uint16_t Usart0_rxCount = 0;
;
;static volatile char Usart1_RX_buf[SIZE_BUF_RX];
;static volatile uint16_t Usart1_rxBufTail = 0;
;static volatile uint16_t Usart1_rxBufHead = 0;
;static volatile uint16_t Usart1_rxCount = 0;
;
;#ifndef F_CPU
;#error "F_CPU is not defined"
;#endif
;
;void UartTxBufOvf_Handler(void){ //���������� ������������ ����������� ������ UART

	.CSEG
_UartTxBufOvf_Handler:
;PORTD.6=1;
	SBI  0x12,6
;}
	RET
;
;
;uint16_t Calk_safe_baud(uint8_t mode, uint16_t input_baud){
; uint8_t max_total_err = 52; //����� ������, ���� ������ - ����������� ����������. 52 ������������� 2.1%
;
; uint32_t tmp0 = 0;
; uint16_t tmp1 = 0;
;
; if (mode == USART_NORMAL){tmp0 = 16UL*input_baud;}
;	mode -> Y+10
;	input_baud -> Y+8
;	max_total_err -> R17
;	tmp0 -> Y+4
;	tmp1 -> R18,R19
; else {tmp0 = 8UL*input_baud;}
;
; tmp1 = (F_CPU/100)/tmp0;   //{ubrrValue = F_CPU/(16UL*baudRate) - 1;}
; tmp1 = tmp1*tmp0;
; tmp1 = ((F_CPU/100) - tmp1);
; tmp1 = tmp1>>5; // /32
; if(tmp1 > max_total_err){tmp1 = 48;} //��� ������� ������������� ������ �������� (>2.1%) �������� ����� 4800baud (�� �������� ������ �� ����� ��������)
; else {tmp1 = input_baud;} //���� �� ��, ������� �������� ��������
;return tmp1;
;}
;
;
; void USART_Init (uint8_t sel, uint8_t mode, uint16_t baudRate) //������������� usart`a
;{
_USART_Init:
;  uint16_t ubrrValue;
;__disable_interrupts();
	ST   -Y,R17
	ST   -Y,R16
;	sel -> Y+5
;	mode -> Y+4
;	baudRate -> Y+2
;	ubrrValue -> R16,R17
	IN   R30,0x3F
	STS  _saved_state,R30
	cli
;
;#ifdef UART_BAUD-ERR-CONTROL_EN
;baudRate = Calk_safe_baud(mode, baudRate);// �������� ����������� ��� �������� �������� (������� �� F_CPU)
;#endif
;baudRate = baudRate * 100;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	STD  Y+2,R30
	STD  Y+2+1,R31
;if(sel==USART_0)
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x99
;{
;  Usart0_txBufTail = 0;  Usart0_txBufHead = 0;
	CALL SUBOPT_0xE
;  Usart0_rxBufTail = 0;  Usart0_rxBufHead = 0;
	LDI  R30,LOW(0)
	STS  _Usart0_rxBufTail_G000,R30
	STS  _Usart0_rxBufTail_G000+1,R30
	STS  _Usart0_rxBufHead_G000,R30
	STS  _Usart0_rxBufHead_G000+1,R30
;  Usart0_rxCount = 0;
	STS  _Usart0_rxCount_G000,R30
	STS  _Usart0_rxCount_G000+1,R30
;  UCSR0A = 0; // USART0 disabled
	OUT  0xB,R30
;  UCSR0B = 0;
	OUT  0xA,R30
;  UCSR0C = 0;
	STS  149,R30
;
;    if (mode == USART_NORMAL){ubrrValue = F_CPU/(16UL*baudRate) - 1;}
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x9A
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
;    else                     {ubrrValue = F_CPU/(8UL*baudRate) - 1; UCSR0A = (1<<U2X0);}//doubles speed
	RJMP _0x9B
_0x9A:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	OUT  0xB,R30
_0x9B:
;
;  // Communication Parameters: 8 Data, 1 Stop, No Parity
;  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
;  UBRR0H = (uint8_t)(ubrrValue >> 8);
	STS  144,R17
;  UBRR0L = (uint8_t)ubrrValue;
	OUT  0x9,R16
;  UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0); //����. ������ ��� ������ � ��������, ���� ������, ���� ��������.
	LDI  R30,LOW(152)
	OUT  0xA,R30
;  UCSR0C = (1<<UCSZ01)|(1<<UCSZ00); //������ ����� 8 ��������
	LDI  R30,LOW(6)
	STS  149,R30
;}
;else
	RJMP _0x9C
_0x99:
;{
;  Usart1_txBufTail = 0;  Usart1_txBufHead = 0;
	CALL SUBOPT_0x12
;  Usart1_rxBufTail = 0;  Usart1_rxBufHead = 0;
	LDI  R30,LOW(0)
	STS  _Usart1_rxBufTail_G000,R30
	STS  _Usart1_rxBufTail_G000+1,R30
	STS  _Usart1_rxBufHead_G000,R30
	STS  _Usart1_rxBufHead_G000+1,R30
;  Usart1_rxCount = 0;
	STS  _Usart1_rxCount_G000,R30
	STS  _Usart1_rxCount_G000+1,R30
;  UCSR1A = 0;  // USART1 disabled
	STS  155,R30
;  UCSR1B = 0;
	STS  154,R30
;  UCSR1C = 0;
	STS  157,R30
;
;    if (mode == USART_NORMAL){ubrrValue = F_CPU/(16UL*baudRate) - 1;}
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x9D
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
;    else                     {ubrrValue = F_CPU/(8UL*baudRate) - 1; UCSR1A = (1<<U2X1);}//doubles speed
	RJMP _0x9E
_0x9D:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	STS  155,R30
_0x9E:
;
;  // Communication Parameters: 8 Data, 1 Stop, No Parity
;  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
;  UBRR1H = (uint8_t)(ubrrValue >> 8);
	STS  152,R17
;  UBRR1L = (uint8_t)ubrrValue;
	STS  153,R16
;  UCSR1B = (1<<RXCIE1)|(1<<RXEN1)|(1<<TXEN1); //����. ������ ��� ������ � ��������, ���� ������, ���� ��������.
	LDI  R30,LOW(152)
	STS  154,R30
;  UCSR1C = (1<<UCSZ11)|(1<<UCSZ10); //������ ����� 8 ��������
	LDI  R30,LOW(6)
	STS  157,R30
;}
_0x9C:
;__restore_interrupts();
	CALL SUBOPT_0x13
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;
;//______________________________________________________________________________
; /*
;unsigned char USART_Get_txCount(void) //���������� ����������� �������� ����������� ������
;{
;  return Usart_txCount;
;}
;*/
;void USART_FlushTxBuf(uint8_t sel) //"�������" ���������� �����
;{
_USART_FlushTxBuf:
;__disable_interrupts();
;	sel -> Y+0
	IN   R30,0x3F
	STS  _saved_state,R30
	cli
;TX_CNT=0;
	LDI  R30,LOW(0)
	STS  _TX_CNT,R30
	STS  _TX_CNT+1,R30
	STS  _TX_CNT+2,R30
	STS  _TX_CNT+3,R30
;
; switch (sel)
	LD   R30,Y
; {
;   case USART_0:
	CPI  R30,0
	BRNE _0xA5
;Usart_0_flush:
_0xA6:
;  Usart0_txBufTail = 0;
	CALL SUBOPT_0xE
;  Usart0_txBufHead = 0;
;    //txCount = 0; //not used
;   break;
	RJMP _0xA4
;   case USART_1:
_0xA5:
	CPI  R30,LOW(0x1)
	BRNE _0xA8
;  Usart1_txBufTail = 0;
	CALL SUBOPT_0x12
;  Usart1_txBufHead = 0;
;   break;
	RJMP _0xA4
;     default:
_0xA8:
; goto Usart_0_flush;
	RJMP _0xA6
;   break;
;}
_0xA4:
;__restore_interrupts();
	CALL SUBOPT_0x13
;}
	RJMP _0x20C000D
;
;
;//OPTIMISED!
;//�������� ������ � �����, ���������� ������ ��������
;
;void USART_PutChar(uint8_t sel, unsigned char symbol) //�������� ������ � �����, ���������� ������ ��������
;{
_USART_PutChar:
; uint16_t Tmp_0 = Usart0_txBufHead;
; uint16_t Tmp_1 = Usart1_txBufHead;
;
; switch (sel)
	CALL __SAVELOCR4
;	sel -> Y+5
;	symbol -> Y+4
;	Tmp_0 -> R16,R17
;	Tmp_1 -> R18,R19
	__GETWRMN 16,17,0,_Usart0_txBufHead_G000
	__GETWRMN 18,19,0,_Usart1_txBufHead_G000
	LDD  R30,Y+5
; {
;   case USART_0:
	CPI  R30,0
	BRNE _0xAC
; Usart_0:
_0xAD:
;       // if(((UCSR0A & (1<<UDRE0)) == 1)) {UDR0 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
;       //  else {                                                           //����� ������ ����� � ������� UDR
;               if((uint16_t)(Tmp_0 - Usart0_txBufTail ) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
	LDS  R26,_Usart0_txBufTail_G000
	LDS  R27,_Usart0_txBufTail_G000+1
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	CPI  R30,LOW(0x201)
	LDI  R26,HIGH(0x201)
	CPC  R31,R26
	BRSH _0xAE
;               Usart0_TX_buf[Tmp_0 & (SIZE_BUF_TX - 1)] = symbol;
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_Usart0_TX_buf_G000)
	SBCI R31,HIGH(-_Usart0_TX_buf_G000)
	LDD  R26,Y+4
	STD  Z+0,R26
;               ++Tmp_0;
	__ADDWRN 16,17,1
;               __disable_interrupts();
	IN   R30,0x3F
	STS  _saved_state,R30
	cli
;               Usart0_txBufHead = Tmp_0;
	__PUTWMRN _Usart0_txBufHead_G000,0,16,17
;               UCSR0B |= (1 << UDRIE0);
	SBI  0xA,5
;               } else {UartTxBufOvf_Handler();}
	RJMP _0xB2
_0xAE:
	RCALL _UartTxBufOvf_Handler
_0xB2:
;         //    }
;   break;
	RJMP _0xAB
;   case USART_1:
_0xAC:
	CPI  R30,LOW(0x1)
	BRNE _0xB9
;      //  if(((UCSR1A & (1<<UDRE1)) == 1)) {UDR1 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
;       //  else {                                                           //����� ������ ����� � ������� UDR
;               if((uint16_t)(Tmp_1 - Usart1_txBufTail) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
	LDS  R26,_Usart1_txBufTail_G000
	LDS  R27,_Usart1_txBufTail_G000+1
	MOVW R30,R18
	SUB  R30,R26
	SBC  R31,R27
	CPI  R30,LOW(0x201)
	LDI  R26,HIGH(0x201)
	CPC  R31,R26
	BRSH _0xB4
;               Usart1_TX_buf[Tmp_1 & (SIZE_BUF_TX - 1)] = symbol;
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_Usart1_TX_buf_G000)
	SBCI R31,HIGH(-_Usart1_TX_buf_G000)
	LDD  R26,Y+4
	STD  Z+0,R26
;               ++Tmp_1;
	__ADDWRN 18,19,1
;               __disable_interrupts();
	IN   R30,0x3F
	STS  _saved_state,R30
	cli
;               Usart1_txBufHead = Tmp_1;
	__PUTWMRN _Usart1_txBufHead_G000,0,18,19
;               UCSR1B |= (1 << UDRIE1);
	LDS  R30,154
	ORI  R30,0x20
	STS  154,R30
;               }else {UartTxBufOvf_Handler();}
	RJMP _0xB8
_0xB4:
	RCALL _UartTxBufOvf_Handler
_0xB8:
;          //   }
;   break;
	RJMP _0xAB
;     default:
_0xB9:
;     goto Usart_0;
	RJMP _0xAD
;     break;
; }
_0xAB:
; __restore_interrupts();
	CALL SUBOPT_0x13
;}
	CALL __LOADLOCR4
	JMP  _0x20C0008
;
;
;
;void USART_SendStr(uint8_t sel, unsigned char * data)//������� ���������� ������ �� usart`�
;{
_USART_SendStr:
; // unsigned char symbol;
;  while(*data)
;	sel -> Y+2
;	*data -> Y+0
_0xBA:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xBC
;  {
;    //symbol = *data++;// USART_PutChar(sel,symbol);
;   USART_PutChar(sel, *data++);//Optimized
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	RCALL _USART_PutChar
;  }
	RJMP _0xBA
_0xBC:
;}
	RJMP _0x20C000B
;
;void USART_SendStrFl(uint8_t sel, unsigned char __flash * data) //������� ���������� ������ �� ����� �� usart`�
;{
_USART_SendStrFl:
; // unsigned char symbol;
;  while(*data)
;	sel -> Y+2
;	*data -> Y+0
_0xBD:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xBF
;  {
;    //symbol = *data++; //USART_PutChar(sel, symbol);
;    USART_PutChar(sel, *data++);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _USART_PutChar
;  }
	RJMP _0xBD
_0xBF:
;}
	RJMP _0x20C000B
;
;
;  //Optimised
;//���������� ���������� �� ���������� ��������
;interrupt [USART0_DRE] void usart0_dre_my(void)  //USART Data Register Empty Interrupt
;{
_usart0_dre_my:
	CALL SUBOPT_0x14
;uint16_t Tmp = Usart0_txBufTail; // use local variable instead of volatile
;
;      if(Tmp != Usart0_txBufHead) // Not all transmitted
	ST   -Y,R16
;	Tmp -> R16,R17
	__GETWRMN 16,17,0,_Usart0_txBufTail_G000
	LDS  R30,_Usart0_txBufHead_G000
	LDS  R31,_Usart0_txBufHead_G000+1
	CP   R30,R16
	CPC  R31,R17
	BREQ _0xC0
;       {
;       UDR0 = Usart0_TX_buf[Tmp & (SIZE_BUF_TX - 1)];
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_Usart0_TX_buf_G000)
	SBCI R31,HIGH(-_Usart0_TX_buf_G000)
	LD   R30,Z
	OUT  0xC,R30
;       ++Tmp;
	__ADDWRN 16,17,1
;       Usart0_txBufTail = Tmp;
	__PUTWMRN _Usart0_txBufTail_G000,0,16,17
;       }
;       else{
	RJMP _0xC1
_0xC0:
;    // PORTD.6=0;
;         Usart0_txBufHead = 0; Usart0_txBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart0_txBufHead_G000,R30
	STS  _Usart0_txBufHead_G000+1,R30
	STS  _Usart0_txBufTail_G000,R30
	STS  _Usart0_txBufTail_G000+1,R30
;        UCSR0B &= ~(1 << UDRIE0); // disable this int
	CBI  0xA,5
;       }
_0xC1:
;#ifdef DEBUG
;TX_CNT++;
	LDI  R26,LOW(_TX_CNT)
	LDI  R27,HIGH(_TX_CNT)
	CALL SUBOPT_0x15
;#endif
;}
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x247
;
;//���������� ���������� �� ���������� ��������
;interrupt [USART1_DRE] void usart1_dre_my(void)  //USART Data Register Empty Interrupt
;{
_usart1_dre_my:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;uint16_t Tmp = Usart1_txBufTail; // use local variable instead of volatile
;        UDR1 = Usart1_TX_buf[Tmp & (SIZE_BUF_TX - 1)];
	ST   -Y,R17
	ST   -Y,R16
;	Tmp -> R16,R17
	__GETWRMN 16,17,0,_Usart1_txBufTail_G000
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_Usart1_TX_buf_G000)
	SBCI R31,HIGH(-_Usart1_TX_buf_G000)
	LD   R30,Z
	STS  156,R30
;       ++Tmp;
	__ADDWRN 16,17,1
;       Usart1_txBufTail = Tmp;
	__PUTWMRN _Usart1_txBufTail_G000,0,16,17
;      if(Tmp == Usart1_txBufHead) // all transmitted
	LDS  R30,_Usart1_txBufHead_G000
	LDS  R31,_Usart1_txBufHead_G000+1
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xC2
;       {
;       //PORTD.6=0;
;         Usart1_txBufHead = 0; Usart1_txBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart1_txBufHead_G000,R30
	STS  _Usart1_txBufHead_G000+1,R30
	STS  _Usart1_txBufTail_G000,R30
	STS  _Usart1_txBufTail_G000+1,R30
;        UCSR1B &= ~(1 << UDRIE1); // disable this int
	LDS  R30,154
	ANDI R30,0xDF
	STS  154,R30
;       }
;#ifdef DEBUG
;//TX_CNT++;
;#endif
;}
_0xC2:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;/*
;ISR (USART_TXC_vect) {
;	if (TX_buff.head!=TX_buff.tail) {
;		UDR = TX_buff.buff[TX_buff.head];
;		TX_buff.head = (TX_buff.head+1)&(TX_BUFFER_SIZE-1);
;	} else {
;		UART_message = UART_TX_COMPLETE;
;		SendMessageWParam(MSG_UART, &UART_message);
;	}
;}
;*/
;//______________________________________________________________________________
;
;unsigned char USART_Get_rxCount(uint8_t sel) //���������� ����������� �������� ����������� � �������� ������
;{
_USART_Get_rxCount:
;return  sel ? Usart1_rxCount : Usart0_rxCount;
;	sel -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0xC3
	LDS  R30,_Usart1_rxCount_G000
	RJMP _0xC4
_0xC3:
	LDS  R30,_Usart0_rxCount_G000
_0xC4:
	RJMP _0x20C000D
;}
;
;void USART_FlushRxBuf(uint8_t sel)//"�������" �������� �����
;{
;  // uint8_t saved_state;
;   RX_CNT = 0;
;	sel -> Y+0
;__disable_interrupts();
;if(!sel){
;  Usart0_rxBufTail = 0;
;  Usart0_rxBufHead = 0;
;  Usart0_rxCount = 0;
;} else{
;  Usart1_rxBufTail = 0;
;  Usart1_rxBufHead = 0;
;  Usart1_rxCount = 0;
;}
;__restore_interrupts();
;}
;
;
;char USART_GetChar(uint8_t sel) //������ ������
;{
_USART_GetChar:
;  unsigned char symbol;
;  uint8_t saved_state;
;if(!sel){
	ST   -Y,R17
	ST   -Y,R16
;	sel -> Y+2
;	symbol -> R17
;	saved_state -> R16
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xCB
;  if (Usart0_rxCount > 0)        //���� �������� ����� �� ������
	LDS  R26,_Usart0_rxCount_G000
	LDS  R27,_Usart0_rxCount_G000+1
	CALL __CPW02
	BRSH _0xCC
;  {
;    symbol = Usart0_RX_buf[Usart0_rxBufHead];        //��������� �� ���� ������
	LDS  R30,_Usart0_rxBufHead_G000
	LDS  R31,_Usart0_rxBufHead_G000+1
	SUBI R30,LOW(-_Usart0_RX_buf_G000)
	SBCI R31,HIGH(-_Usart0_RX_buf_G000)
	LD   R17,Z
;    Usart0_rxBufHead++;                        //���������������� ������ ������ ������
	LDI  R26,LOW(_Usart0_rxBufHead_G000)
	LDI  R27,HIGH(_Usart0_rxBufHead_G000)
	CALL SUBOPT_0x16
;    if (Usart0_rxBufHead == SIZE_BUF_RX) Usart0_rxBufHead = 0;
	LDS  R26,_Usart0_rxBufHead_G000
	LDS  R27,_Usart0_rxBufHead_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xCD
	LDI  R30,LOW(0)
	STS  _Usart0_rxBufHead_G000,R30
	STS  _Usart0_rxBufHead_G000+1,R30
;__disable_interrupts();
_0xCD:
	IN   R16,63
	cli
;    Usart0_rxCount--;                          //��������� ������� ��������
	LDI  R26,LOW(_Usart0_rxCount_G000)
	LDI  R27,HIGH(_Usart0_rxCount_G000)
	CALL SUBOPT_0x17
;__restore_interrupts();
;    return symbol;                         //������� ����������� ������
	RJMP _0x20C000B
;  }
;  return 0;
_0xCC:
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000B
;  }
;  else
_0xCB:
;  {
;   if (Usart1_rxCount > 0)        //���� �������� ����� �� ������
	LDS  R26,_Usart1_rxCount_G000
	LDS  R27,_Usart1_rxCount_G000+1
	CALL __CPW02
	BRSH _0xD2
;  {
;    symbol = Usart1_RX_buf[Usart1_rxBufHead];        //��������� �� ���� ������
	LDS  R30,_Usart1_rxBufHead_G000
	LDS  R31,_Usart1_rxBufHead_G000+1
	SUBI R30,LOW(-_Usart1_RX_buf_G000)
	SBCI R31,HIGH(-_Usart1_RX_buf_G000)
	LD   R17,Z
;    Usart1_rxBufHead++;                        //���������������� ������ ������ ������
	LDI  R26,LOW(_Usart1_rxBufHead_G000)
	LDI  R27,HIGH(_Usart1_rxBufHead_G000)
	CALL SUBOPT_0x16
;    if (Usart1_rxBufHead == SIZE_BUF_RX) Usart1_rxBufHead = 0;
	LDS  R26,_Usart1_rxBufHead_G000
	LDS  R27,_Usart1_rxBufHead_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xD3
	LDI  R30,LOW(0)
	STS  _Usart1_rxBufHead_G000,R30
	STS  _Usart1_rxBufHead_G000+1,R30
;__disable_interrupts();
_0xD3:
	IN   R16,63
	cli
;    Usart1_rxCount--;                          //��������� ������� ��������
	LDI  R26,LOW(_Usart1_rxCount_G000)
	LDI  R27,HIGH(_Usart1_rxCount_G000)
	CALL SUBOPT_0x17
;__restore_interrupts();
;    return symbol;                         //������� ����������� ������
	RJMP _0x20C000B
;  }
;  return 0;
_0xD2:
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000B
;  }
;}
;
;
;
;/*
;  ISR (USART_RXC_vect) {
;	u08 tmp = 0;
;	tmp = UDR;
;	if (((RX_buff.tail - RX_buff.head + 256) & (RX_BUFFER_SIZE-1)) < (RX_BUFFER_SIZE-1)) {
;		RX_buff.buff[RX_buff.tail] = tmp;
;		RX_buff.tail = (RX_buff.tail+1)&(RX_BUFFER_SIZE-1);
;		if (tmp == 0x0D) {										// found end string classifier
;			RX_buff.tail = (RX_buff.tail-1)&(RX_BUFFER_SIZE-1); // remove string end classifier from buffer
;			///RX_buff.buff[RX_buff.tail] = '\0';				// replace string end delimiter with C standard string end
;			UART_message = UART_RX_COMPLETE;
;			SendMessageWParam(MSG_UART, &UART_message);
;		}
;	} else {
;		sys_error = SYS_ERR_RX_BUF_FULL;
;	}
;}
;*/
; interrupt [USART0_RXC] void usart0_rxc(void) //���������� �� ���������� ������
;{
_usart0_rxc:
	CALL SUBOPT_0x14
;char data;//!
;data =  UDR0;//! read to clear RxC flag!
;	data -> R17
	IN   R17,12
;    if (Usart0_rxCount < SIZE_BUF_RX) //���� � ������ ��� ���� �����
	LDS  R26,_Usart0_rxCount_G000
	LDS  R27,_Usart0_rxCount_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0xD7
;    {
;      //!//Usart0_RX_buf[Usart0_rxBufTail] = UDR;    //������� ������ �� UDR � �����
;       Usart0_RX_buf[Usart0_rxBufTail] = data;//!    //������� ������ � �����
	LDS  R30,_Usart0_rxBufTail_G000
	LDS  R31,_Usart0_rxBufTail_G000+1
	SUBI R30,LOW(-_Usart0_RX_buf_G000)
	SBCI R31,HIGH(-_Usart0_RX_buf_G000)
	ST   Z,R17
;      Usart0_rxBufTail++;                    //��������� ������ ������ ��������� ������
	LDI  R26,LOW(_Usart0_rxBufTail_G000)
	LDI  R27,HIGH(_Usart0_rxBufTail_G000)
	CALL SUBOPT_0x16
;      Usart0_rxCount++;                      //��������� ������� �������� ��������
	LDI  R26,LOW(_Usart0_rxCount_G000)
	LDI  R27,HIGH(_Usart0_rxCount_G000)
	CALL SUBOPT_0x16
;#warning ��������� ������������� ���������� �����
;     if (Usart0_rxBufTail == SIZE_BUF_RX)
	LDS  R26,_Usart0_rxBufTail_G000
	LDS  R27,_Usart0_rxBufTail_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xD8
;      {
;       Usart0_rxBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart0_rxBufTail_G000,R30
	STS  _Usart0_rxBufTail_G000+1,R30
;      }
;    }
_0xD8:
;#ifdef DEBUG
;RX_CNT++;
_0xD7:
	LDI  R26,LOW(_RX_CNT)
	LDI  R27,HIGH(_RX_CNT)
	CALL SUBOPT_0x15
;#endif
;}
	LD   R17,Y+
_0x247:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;
;
;
; interrupt [USART1_RXC] void usart1_rxc(void) //���������� �� ���������� ������
;{
_usart1_rxc:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;char data;//!
;data =  UDR1;//! read to clear RxC flag!
	ST   -Y,R17
;	data -> R17
	LDS  R17,156
;    if (Usart1_rxCount < SIZE_BUF_RX) //���� � ������ ��� ���� �����
	LDS  R26,_Usart1_rxCount_G000
	LDS  R27,_Usart1_rxCount_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0xD9
;    {
;      //!//Usart1_RX_buf[Usart1_rxBufTail] = UDR1;    //������� ������ �� UDR � �����
;       Usart1_RX_buf[Usart1_rxBufTail] = data;//!    //������� ������  � �����
	LDS  R30,_Usart1_rxBufTail_G000
	LDS  R31,_Usart1_rxBufTail_G000+1
	SUBI R30,LOW(-_Usart1_RX_buf_G000)
	SBCI R31,HIGH(-_Usart1_RX_buf_G000)
	ST   Z,R17
;      Usart1_rxBufTail++;                    //��������� ������ ������ ��������� ������
	LDI  R26,LOW(_Usart1_rxBufTail_G000)
	LDI  R27,HIGH(_Usart1_rxBufTail_G000)
	CALL SUBOPT_0x16
;      Usart1_rxCount++;                      //��������� ������� �������� ��������
	LDI  R26,LOW(_Usart1_rxCount_G000)
	LDI  R27,HIGH(_Usart1_rxCount_G000)
	CALL SUBOPT_0x16
;#warning ��������� ������������� ���������� �����
;    if (Usart1_rxBufTail == SIZE_BUF_RX)
	LDS  R26,_Usart1_rxBufTail_G000
	LDS  R27,_Usart1_rxBufTail_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xDA
;      {
;       Usart1_rxBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart1_rxBufTail_G000,R30
	STS  _Usart1_rxBufTail_G000+1,R30
;      }
;     }
_0xDA:
;}
_0xD9:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;//������� ���-�� ������ � ��������� ������
; uint16_t How_Much_data_in_buf (uint16_t BufTail, uint16_t BufHead)
;{
;    if (BufTail >=  BufHead)
;	BufTail -> Y+2
;	BufHead -> Y+0
;        return (BufTail -  BufHead);
;    else
;        return ((SIZE_BUF_TX -  BufHead) + BufTail);
;}
;
;
;
;/////// ���������� �����. ����� ���� ������ ��������� �������� � ����� ������, � �����. �� ��������� ������ ����� UART �� ����
;static volatile char WorkLog[512];
;static volatile uint16_t LogIndex = 0;
;
;void WorkLogPutChar(unsigned char symbol){
_WorkLogPutChar:
;__disable_interrupts();
;	symbol -> Y+0
	IN   R30,0x3F
	STS  _saved_state,R30
	cli
;if (LogIndex <1023)							// ���� ��� �� ����������
	LDS  R26,_LogIndex_G000
	LDS  R27,_LogIndex_G000+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRSH _0xE0
;{
;		WorkLog[LogIndex]= symbol;			// ����� ������ � ���
	CALL SUBOPT_0x18
	LD   R26,Y
	CALL SUBOPT_0x19
;		LogIndex++;
;}
; __restore_interrupts();
_0xE0:
	CALL SUBOPT_0x13
;}
	RJMP _0x20C000D
;
;void Put_In_LogFl (unsigned char __flash* data){
_Put_In_LogFl:
;  while(*data)
;	*data -> Y+0
_0xE1:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xE3
;  {
;    WorkLogPutChar(*data++);
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _WorkLogPutChar
;  }
	RJMP _0xE1
_0xE3:
;}
	RJMP _0x20C0009
;
;void Put_In_Log (unsigned char * data){
_Put_In_Log:
;  while(*data)
;	*data -> Y+0
_0xE4:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xE6
;  {
;    WorkLogPutChar(*data++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _WorkLogPutChar
;  }
	RJMP _0xE4
_0xE6:
;}
	RJMP _0x20C0009
;/////////////
;
;
;
;
;
;
;#include "parser.h"
;
;char buf[SIZE_RECEIVE_BUF];
;char *argv[AMOUNT_PAR];
;uint8_t argc;
;
;uint8_t i = 0;
;uint8_t flag = 0;
;
;void PARSER_Init(void)
;{
_PARSER_Init:
;  argc = 0;
	CLR  R11
;  argv[0] = buf;
	CALL SUBOPT_0x1A
;  flag = FALSE;
	CLR  R13
;  i = 0;
	CLR  R10
;}
	RET
;
;void PARS_Parser(char symbol)
;{
_PARS_Parser:
;   if (symbol !='\r'){               //'\r' //end of string
;	symbol -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BREQ _0xE7
;     if (i < SIZE_RECEIVE_BUF - 1){
	LDI  R30,LOW(127)
	CP   R10,R30
	BRSH _0xE8
;        if (symbol != ' '){
	CPI  R26,LOW(0x20)
	BREQ _0xE9
;           if (!argc){
	TST  R11
	BRNE _0xEA
;              argv[0] = buf;
	CALL SUBOPT_0x1A
;              argc++;
	INC  R11
;           }
;
;           if (flag){
_0xEA:
	TST  R13
	BREQ _0xEB
;              if (argc < AMOUNT_PAR){
	LDI  R30,LOW(10)
	CP   R11,R30
	BRSH _0xEC
;                 argv[argc] = &buf[i];
	MOV  R30,R11
	LDI  R26,LOW(_argv)
	LDI  R27,HIGH(_argv)
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	ST   X+,R30
	ST   X,R31
;                 argc++;
	INC  R11
;              }
;              flag = FALSE;
_0xEC:
	CLR  R13
;            }
;
;            buf[i] = symbol;
_0xEB:
	CALL SUBOPT_0x1C
	LD   R26,Y
	STD  Z+0,R26
;            i++;
	INC  R10
;        }
;        else{                 // "space" - is divider
	RJMP _0xED
_0xE9:
;           if (!flag){
	TST  R13
	BRNE _0xEE
;              buf[i] = 0;
	CALL SUBOPT_0x1C
	LDI  R26,LOW(0)
	STD  Z+0,R26
;              i++;
	INC  R10
;              flag = TRUE;
	LDI  R30,LOW(1)
	MOV  R13,R30
;           }
;        }
_0xEE:
_0xED:
;     }
;     buf[i] = 0;
_0xE8:
	CALL SUBOPT_0x1C
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     return;
	RJMP _0x20C000D
;   }
;   else{
_0xE7:
;      buf[i] = 0;
	CALL SUBOPT_0x1C
	LDI  R26,LOW(0)
	STD  Z+0,R26
;        if (argc)
	TST  R11
	BREQ _0xF0
;           {
;                PARS_Handler(argc, argv);
	ST   -Y,R11
	LDI  R30,LOW(_argv)
	LDI  R31,HIGH(_argv)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PARS_Handler
;           }
;      //   else{
;                  //���� ����� ���-�� ��������  ");
;       //      }
;      argc = 0;
_0xF0:
	CLR  R11
;      flag = FALSE;
	CLR  R13
;      i = 0;
	CLR  R10
;   }
;}
_0x20C000D:
	ADIW R28,1
	RET
;
;#ifdef  __GNUC__
;
;uint8_t PARS_EqualStrFl(char *s1, char const *s2)
;{
;  uint8_t i = 0;
;
;  while(s1[i] == pgm_read_byte(&s2[i]) && s1[i] != '\0' && pgm_read_byte(&s2[i]) != '\0')
;  {
;     i++;
;  }
;  if (s1[i] =='\0' && pgm_read_byte(&s2[i]) == '\0')
;  {
;     return TRUE;
;  }
;  else
;  {
;     return FALSE;
;  }
;}
;
;#else
;
;#warning standart strcmpf req less memory
;uint8_t PARS_EqualStrFl(char *s1, char __flash *s2)
;{
;  uint8_t i = 0;
;
;  while(s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0')
;	*s1 -> Y+3
;	*s2 -> Y+1
;	i -> R17
;  {
;     i++;
;  }
;  if (s1[i] =='\0' && s2[i] == '\0')
;  {
;     return TRUE;
;  }
;  else
;  {
;     return FALSE;
;  }
;}
;
;#endif
;
;#warning standart strcmp req less memory
;uint8_t PARS_EqualStr(char *s1, char *s2)
;{
;  uint8_t i = 0;
;
;  while(s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0')
;	*s1 -> Y+3
;	*s2 -> Y+1
;	i -> R17
;  {
;     i++;
;  }
;  if (s1[i] =='\0' && s2[i] == '\0')
;  {
;     return TRUE;
;  }
;  else
;  {
;     return FALSE;
;  }
;}
;
;uint8_t PARS_StrToUchar(char *s)
;{
_PARS_StrToUchar:
;   uint8_t value = 0;
;  // while(*s == '0'){s++;} // For what?
;   while(*s)
	ST   -Y,R17
;	*s -> Y+1
;	value -> R17
	LDI  R17,0
_0x103:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x105
;   {
;      value += (*s - 0x30);
	SUBI R30,LOW(48)
	ADD  R17,R30
;      s++;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
;      if (*s){
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x106
;         value *= 10;
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOV  R17,R0
;      }
;   };
_0x106:
	RJMP _0x103
_0x105:
;
;  return value;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C000B
;}
;
;uint16_t PARS_StrToUint(char *s)
;{
_PARS_StrToUint:
;   uint16_t value = 0;
;
;   //while(*s == '0'){s++;}
;
;   while(*s)
	CALL SUBOPT_0x2
;	*s -> Y+2
;	value -> R16,R17
_0x107:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x109
;   {
;      value += (*s - 0x30);
	SUBI R30,LOW(48)
	LDI  R31,0
	__ADDWRR 16,17,30,31
;      s++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
;      if (*s){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x10A
;         value *= 10;
	__MULBNWRU 16,17,10
	MOVW R16,R30
;      }
;   };
_0x10A:
	RJMP _0x107
_0x109:
;
;  return value;
	MOVW R30,R16
_0x20C000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;}
;//***************************************************************************
;//
;//  Author(s)...: Vlad
;//
;//  Target(s)...: Mega
;//
;//  Compiler....:
;//
;//  Description.: ������� SPI
;//
;//  Data........: 11.2.14
;//
;//***************************************************************************
;#include "spi.h"
;
;#include "RTOS/EERTOS.h"
;#include "RTOS/EERTOSHAL.h"
; #include "D_Tasks/task_list.h"
; /*
; �������� �������� �� SPDR ����� � ���������� �������!
; */
;#warning �������� �� ���������
;//���������� �����
;static volatile char Spi0_TX_buf[SIZE_SPI_BUF_TX];
;static volatile uint16_t Spi0_txBufTail = 0;
;static volatile uint16_t Spi0_txBufHead = 0;
;
;static volatile char Spi1_TX_buf[SIZE_SPI_BUF_TX];
;static volatile uint16_t Spi1_txBufTail = 0;
;static volatile uint16_t Spi1_txBufHead = 0;
; #warning  Spi0_txCount not used
;
;
;//�������� �����
;static volatile char Spi0_RX_buf[SIZE_SPI_BUF_RX];
;static volatile uint16_t Spi0_rxBufTail = 0;
;static volatile uint16_t Spi0_rxBufHead = 0;
;static volatile uint16_t Spi0_rxCount = 0;
;
;static volatile char Spi1_RX_buf[SIZE_SPI_BUF_RX];
;static volatile uint16_t Spi1_rxBufTail = 0;
;static volatile uint16_t Spi1_rxBufHead = 0;
;static volatile uint16_t Spi1_rxCount = 0;
;
;bool TX_flag = 0;
;bool RX_flag = 0;
;
;
;void SpiTxBufOvf_Handler(void){
;PORTD.7=0;
;}
;
;void SPI_FlushTxBuf(uint8_t sel) //"�������" ���������� �����
;{
;  uint8_t saved_state;
;__disable_interrupts();
;	sel -> Y+1
;	saved_state -> R17
;
; switch (sel)
; {
;   case SPI_0:
;Spi_0_flush:
;  Spi0_txBufTail = 0;
;  Spi0_txBufHead = 0;
;   break;
;   case SPI_1:
;
;   break;
;     default:
; goto Spi_0_flush;
;   break;
;}
;__restore_interrupts();
;}
;
;
;///////////////////////////////////////////////////////////////
;////////////////////SOFTWARE SPI///////////////////////////////
;
;#warning ���������� ��������!
;/*������������� SPI*/
;void Soft_SPI_Master_Init(void)
;{
;  /*��������� ������ �����-������
;  ��� ������, ����� MISO ������*/
;  SPI_DDRX = (1<<SPI_MOSI)|(1<<SPI_SCK)|(1<<SPI_SS)|(0<<SPI_MISO);
;  SPI_PORTX = (1<<SPI_MOSI)|(1<<SPI_SCK)|(1<<SPI_SS)|(1<<SPI_MISO);
;
;  /*���������� spi,������� ��� ������,������, ����� 0*/
;  SPCR = (1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(1<<SPR1)|(0<<SPR0);
; // SPSR = (0<<SPI2X);
; SPCR = (1<<SPIE); /* Enable SPI, Interrupt */
;}
;
;////////////////////SOFTWARE SPI///////////////////////////////
;///////////////////////////////////////////////////////////////
;
;
;
;
;
;
;///////////////////////////////////////////////////////////////
;////////////////////HARDWARE SPI///////////////////////////////
;
;//---------------MASTER-----------------//
;
;void Hard_SPI_Master_Init_default(void)
;{
_Hard_SPI_Master_Init_default:
;SPCR = 0; /* Set MOSI and SCK output, all others input */
	LDI  R30,LOW(0)
	OUT  0xD,R30
;  DDR_SPI = (1<<_MOSI)|(1<<_SCK)|(1<<_SS)|(0<<_MISO);;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;  PORT_SPI = (1<<_MOSI)|(1<<_SCK)|(1<<_SS)|(1<<_MISO);
	LDI  R30,LOW(15)
	OUT  0x18,R30
;/* Enable SPI, Master, set clock rate fck/16, Interrupt */
;
;SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);
	LDI  R30,LOW(81)
	RJMP _0x20C000A
;//SPCR = (1<<SPIE)|(1<<SPE); /* Enable SPI, Interrupt */  � ���������� �� ���������!
;}
;
;
;void Hard_SPI_Master_Init(bool phase, bool polarity, uint8_t prescaller)
;{
_Hard_SPI_Master_Init:
;SPCR = 0;
;	phase -> Y+2
;	polarity -> Y+1
;	prescaller -> Y+0
	LDI  R30,LOW(0)
	OUT  0xD,R30
;/* Set MOSI and SCK output, all others input */
;  DDR_SPI = (1<<_MOSI)|(1<<_SCK)|(1<<_SS);  DDR_SPI &=~(1<<_MISO);
	LDI  R30,LOW(7)
	OUT  0x17,R30
	CBI  0x17,3
;  PORT_SPI = (1<<_MOSI)|(1<<_SCK)|(1<<_SS);//|(1<<_MISO);//����� � ���������!
	OUT  0x18,R30
;
;  SPCR = (phase<<CPHA) | (polarity<<CPOL);
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	MOV  R26,R30
	LDD  R30,Y+1
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R30,R26
	OUT  0xD,R30
;
;        switch(prescaller)  //prescaller
	LD   R30,Y
;        {
;          case 2:
	CPI  R30,LOW(0x2)
	BRNE _0x11A
;           SPSR = (1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0xE,R30
;          break;
	RJMP _0x119
;          case 4:
_0x11A:
	CPI  R30,LOW(0x4)
	BRNE _0x11B
;           SPCR = (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(0)
	RJMP _0x230
;          break;
;          case 8:
_0x11B:
	CPI  R30,LOW(0x8)
	BRNE _0x11C
;           SPSR |= (1<<SPI2X);
	SBI  0xE,0
;           SPCR |= (1<<SPR0);
	SBI  0xD,0
;          break;
	RJMP _0x119
;          case 16:
_0x11C:
	CPI  R30,LOW(0x10)
	BREQ _0x231
;            SPCR = (1<<SPR0);
;          break;
;          case 32:
	CPI  R30,LOW(0x20)
	BRNE _0x11E
;           SPSR = (1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0xE,R30
;           SPCR = (1<<SPR1);
	LDI  R30,LOW(2)
	RJMP _0x230
;          break;
;          case 64:
_0x11E:
;           SPCR = (1<<SPR0);
;          break;
;          case 128:
;            SPCR = (1<<SPR0) | (1<<SPR0);
;          break;
;          default:
;            SPCR = (1<<SPR0);
_0x231:
	LDI  R30,LOW(1)
_0x230:
	OUT  0xD,R30
;          break;
;        }
_0x119:
;SPCR = (1<<SPE)|(1<<MSTR);
	LDI  R30,LOW(80)
	OUT  0xD,R30
;}
_0x20C000B:
	ADIW R28,3
	RET
;
;/*
;sel - number of spi(0 - hardware)
;mode - master/slave
;*/
;
;void SPI_init(char sel, bool mode, bool phase, bool polarity, uint8_t prescaller){
_SPI_init:
; switch (sel)
;	sel -> Y+4
;	mode -> Y+3
;	phase -> Y+2
;	polarity -> Y+1
;	prescaller -> Y+0
	LDD  R30,Y+4
; {
;  case SPI_0:
	CPI  R30,0
	BRNE _0x128
;   SPCR = 0;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;   SPSR = 0;
	OUT  0xE,R30
;     if(mode == SPI_MASTER)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x126
;     {
;       Hard_SPI_Master_Init(phase, polarity, prescaller);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _Hard_SPI_Master_Init
;     }
;     else //SLAVE
	RJMP _0x127
_0x126:
;     {
;       Hard_SPI_Slave_Init();
	RCALL _Hard_SPI_Slave_Init
;     }
_0x127:
;  break;
	RJMP _0x124
;  /*
;   case SPI_1:  //soft spi
;   break;
;  */
;  default:
_0x128:
;  Hard_SPI_Master_Init_default();
	RCALL _Hard_SPI_Master_Init_default
;  break;
; }
_0x124:
;}
	RJMP _0x20C0006
;
;#warning can be optimized!
;void SPI_RW_Buf(uint8_t num, uint8_t *data_tx, uint8_t *data_rx)   //SPI write-read
;{
_SPI_RW_Buf:
;uint8_t i=0; //char data;
;   SPI_PORTX &= ~(1<<SPI_SS);
	ST   -Y,R17
;	num -> Y+5
;	*data_tx -> Y+3
;	*data_rx -> Y+1
;	i -> R17
	LDI  R17,0
	CBI  0x18,0
;/*
;while(num)
;{
;      SPDR = data_tx[i];  data_tx[i] = 0;
;      while(!(SPSR & (1<<SPIF)));
;      data_rx[i] = SPDR;
;      // *data_tx++; *data_rx++;
;       --num;
;        i++;
;}  */
;
;
; while(*data_tx)
_0x129:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x12B
;  {
;      SPDR = *data_tx++;  //data_tx[i] = 0;
	LD   R30,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
	OUT  0xF,R30
;      while(!(SPSR & (1<<SPIF)));
_0x12C:
	SBIS 0xE,7
	RJMP _0x12C
;      if(i<SIZE_SPI_BUF_RX){data_rx[i] = SPDR;}
	CPI  R17,64
	BRSH _0x12F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	IN   R30,0xF
	ST   X,R30
;      i++;
_0x12F:
	SUBI R17,-1
;  }
	RJMP _0x129
_0x12B:
;   SPI_PORTX |= (1<<SPI_SS);
	SBI  0x18,0
;  SetTask(Task_SPI_ClrBuf); //��������
	LDI  R30,LOW(_Task_SPI_ClrBuf)
	LDI  R31,HIGH(_Task_SPI_ClrBuf)
	CALL SUBOPT_0x1D
;}
	LDD  R17,Y+0
	RJMP _0x20C0008
;//---------------END_MASTER-----------------//
;
;
;//---------------SLAVE------------------------//
;void Hard_SPI_Slave_Init(void)
;{
_Hard_SPI_Slave_Init:
;SPCR = 0;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;DDR_SPI = (1<<_MISO);/* Set MISO output, all others input */
	LDI  R30,LOW(8)
	OUT  0x17,R30
;SPCR = (1<<SPE);/* Enable SPI */
	LDI  R30,LOW(64)
_0x20C000A:
	OUT  0xD,R30
;}
	RET
;//---------------END SLAVE----------------------//
;
;
;////////////////////HARDWARE SPI///////////////////////////////
;///////////////////////////////////////////////////////////////
;
;
;
;//���������� ���������� �� ���������� ��������/�����
;interrupt [SPI_STC] void spi_isr(void)  //����������� � ������/���������!!!!!
;{
_spi_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;char data;
;uint8_t Tmp = Spi0_txBufTail; // use local variable instead of volatile
; SPCR = (1<<MSTR);  //Master
	ST   -Y,R17
	ST   -Y,R16
;	data -> R17
;	Tmp -> R16
	LDS  R16,_Spi0_txBufTail_G000
	LDI  R30,LOW(16)
	OUT  0xD,R30
;  PORTD.6^=1;
	LDI  R26,0
	SBIC 0x12,6
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x130
	CBI  0x12,6
	RJMP _0x131
_0x130:
	SBI  0x12,6
_0x131:
;////////RX
;data =  SPDR;
	IN   R17,15
;/*
;    if (Spi0_rxCount < SIZE_SPI_BUF_RX) //���� � ������ ��� ���� �����
;    {
;       Spi0_RX_buf[Spi0_rxBufTail] = data;//!    //������� ������ �� SPDR � �����
;       Spi0_rxBufTail++;                    //��������� ������ ������ ��������� ������
;      if (Spi0_rxBufTail == SIZE_BUF_RX)
;      {
;       Spi0_rxBufTail = 0;
;      }
;      Spi0_rxCount++;                      //��������� ������� �������� ��������
;    }
;    */
;///////////
;
;//////////TX
;/*
; if(Tmp != Spi0_txBufHead) // all transmitted
;  {
;  // SPDR = Spi0_TX_buf[Tmp & (SIZE_SPI_BUF_TX - 1)];
;   ++Tmp;
;   Spi0_txBufTail = Tmp;
;   SPDR = Spi0_TX_buf[Tmp & (SIZE_SPI_BUF_TX - 1)];
;  }
;   */
;/////////
;
;}
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;
;
;
;
;
;
;
;
;/*
;unsigned char spi(unsigned char data)
;{
;_ATXMEGA_SPI_.DATA=data;
;while ((_ATXMEGA_SPI_.STATUS & SPI_IF_bm)==0);
;return _ATXMEGA_SPI_.DATA;
;}
;
;void spi_init(bool master_mode,bool lsb_first,SPI_MODE_t mode,bool clk2x,SPI_PRESCALER_t clock_div, unsigned char ss_pin)
;{
;if (master_mode)
;   {
;   // Init SS pin as output with wired AND and pull-up
;   _ATXMEGA_SPI_PORT_.DIRSET=ss_pin;
;   _ATXMEGA_SPI_PORT_.PIN4CTRL=PORT_OPC_WIREDANDPULL_gc;
;
;   // Set SS output to high
;   _ATXMEGA_SPI_PORT_.OUTSET=ss_pin;
;
;   // SPI master mode
;   _ATXMEGA_SPI_.CTRL=clock_div |                      // SPI prescaler.
;                      (clk2x ? SPI_CLK2X_bm : 0) |     // SPI Clock double.
;                      SPI_ENABLE_bm |                  // Enable SPI module.
;                      (lsb_first ? SPI_DORD_bm : 0) |  // Data order.
;                      SPI_MASTER_bm |                  // SPI master.
;                      mode;                            // SPI mode.
;
;   // MOSI and SCK as output
;   _ATXMEGA_SPI_PORT_.DIRSET=SPI_MOSI_bm | SPI_SCK_bm;
;   }
;else
;   {
;   // SPI slave mode
;   _ATXMEGA_SPI_.CTRL=SPI_ENABLE_bm |                 // Enable SPI module.
;                      (lsb_first ? SPI_DORD_bm : 0) | // Data order.
;	                  mode;                           // SPI mode.
;
;   // MISO as output
;   _ATXMEGA_SPI_PORT_.DIRSET=SPI_MISO_bm;
;   };
;// No interrupts, polled mode
;_ATXMEGA_SPI_.INTCTRL=SPI_INTLVL_OFF_gc;
;}
;*/
   .equ __i2c_port=0x1B ;PORTA
   .equ __sda_bit=0
   .equ __scl_bit=1
;//***************************************************************************
;//
;//  Author(s)...: Vlad
;//
;//  Target(s)...: Mega
;//
;//  Compiler....:
;//
;//  Description.: ������� I2C
;//
;//  Data........:
;//
;//***************************************************************************
;#include "I2C.h"
;
;
;/*
;TODO:
;Hard/Software implementations
;
;*/
;////////////////HARDWARE_TWI/I2C///////////////////////////
;///////////////////////////////////////////////////////////
;
;void hard_twi_init(void){// TWI initialization
;// Bit Rate: 400,000 kHz
;TWBR=0x02;
;// Two Wire Bus Slave Address: 0x0
;// General Call Recognition: Off
;TWAR=0x00;
;// Generate Acknowledge Pulse: Off
;// TWI Interrupt: On
;TWCR = (1<<TWIE)|(1<<TWEN) ;
;TWSR=0x00;
;}
;
;
;/*
;void hard_twi_init(void);
;void hard_twi_start(void);
;void hard_twi_stop(void);
;unsigned char hard_twi_read(unsigned char ack);
;unsigned char hard_twi_write(unsigned char data);
;*/
;
;void hard_twi_start() {
;	TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN); // send start condition
;	while (!(TWCR & (1 << TWINT)));
;    //�������� ����� ����� ��������  TWSTA
;}
;
;void hard_twi_write_byte(char byte) {
;	TWDR = byte;
;	byte -> Y+0
;	TWCR = (1 << TWINT) | (1 << TWEN); // start address transmission
;	while (!(TWCR & (1 << TWINT)));
;}
;
;char hard_twi_read_byte() {
;	TWCR = (1 << TWINT) | (1 << TWEA) | (1 << TWEN); // start data reception, transmit ACK
;	while (!(TWCR & (1 << TWINT)));
;	return TWDR;
;}
;
;char hard_twi_read_last_byte() {
;	TWCR = (1 << TWINT) | (1 << TWEN); // start data reception
;	while (!(TWCR & (1 << TWINT)));
;	return TWDR;
;}
;
;void hard_twi_stop() {
;	  TWCR = (1 << TWINT) | (1 << TWSTO) | (1 << TWEN); // send stop condition
;}
;
;uint8_t hard_twi_read_ACK(void)
;{
;    TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWEA);
;    while ((TWCR & (1<<TWINT)) == 0);
;    return TWDR;
;}
;//read byte with NACK
;uint8_t hard_twi_read_NACK(void)
;{
;    TWCR = (1<<TWINT)|(1<<TWEN);
;    while ((TWCR & (1<<TWINT)) == 0);
;    return TWDR;
;}
;
;uint8_t hard_twi_get_status(void)
;{
;    uint8_t status;
;    status = TWSR & 0xF8;     //mask status
;	status -> R17
;    return status;
;}
;
;/*
;// Two Wire bus interrupt service routine
;interrupt [TWI] void twi_isr(void)
;{
;
;TWCR = (1<<TWINT) ;// At the end - clear interrupt flag
;}
;*/

	.DSEG
;#include "ADC.h"
;
;void ADC_init(void){ // ADC initialization  //Upd-6

	.CSEG
_ADC_init:
;PORTF=0x00; DDRF=0x00;
	CALL SUBOPT_0x1E
;// ADC Clock frequency: 1000,000 kHz
;// ADC Voltage Reference: Int., cap. on AREF
;ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
;ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
;}
	RET
;
;void adc_use (void)
;{
;  ADCSRA=0b11011111;  //���
;};
;
;
;//-----------������� �������������� ���-----------------   //Upd-7
;void adc_calibrate (void)   //����� ������������ ���������� Vref
;{
_adc_calibrate:
;  ADMUX &= 0xDF & 0x7F & 0xFE; ADMUX |= 0x40 | 0x0E;   //������� ADMUX: ��� 10 ���, Vref=AVCC (5B), ���=1,23�
	IN   R30,0x7
	ANDI R30,LOW(0x5E)
	OUT  0x7,R30
	IN   R30,0x7
	ORI  R30,LOW(0x4E)
	OUT  0x7,R30
;  ADCSRA &= 0xDF & 0xFC; ADCSRA |= 0x80 | 0x40 | 0x04; //������� ADCSRA: ���. ���, ��������� ����, F���=62 ���
	IN   R30,0x6
	ANDI R30,LOW(0xDC)
	OUT  0x6,R30
	IN   R30,0x6
	ORI  R30,LOW(0xC4)
	OUT  0x6,R30
;  for (volt=0, adc_calib_cnt=100; adc_calib_cnt>0; adc_calib_cnt--) //���������� 100 �������
	LDI  R30,LOW(0)
	STS  _volt,R30
	STS  _volt+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _adc_calib_cnt,R30
	STS  _adc_calib_cnt+1,R31
_0x146:
	LDS  R26,_adc_calib_cnt
	LDS  R27,_adc_calib_cnt+1
	CALL __CPW02
	BRSH _0x147
;  {
;    ADCSRA |= 0x40;        //������ ������ ��������� ���
	SBI  0x6,6
;    while (ADCSRA & 0x40);   //�������� ��������� ������
_0x148:
	SBIC 0x6,6
	RJMP _0x148
;    volt += ADCL;    //������ ������� 8 ����� ����������
	IN   R30,0x4
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x5
	STS  _volt,R30
	STS  _volt+1,R31
;    volt += ((int)ADCH << 8);    //���� ��� ������� ����
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x1F
	ADD  R30,R26
	ADC  R31,R27
	STS  _volt,R30
	STS  _volt+1,R31
;  }                   //��������� 100 ������� ����������
	LDI  R26,LOW(_adc_calib_cnt)
	LDI  R27,HIGH(_adc_calib_cnt)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x146
_0x147:
;  for (avcc=4750; avcc<5250; avcc++) //�������� AVCC, ��
	LDI  R30,LOW(4750)
	LDI  R31,HIGH(4750)
	STS  _avcc,R30
	STS  _avcc+1,R31
_0x14C:
	LDS  R26,_avcc
	LDS  R27,_avcc+1
	CPI  R26,LOW(0x1482)
	LDI  R30,HIGH(0x1482)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x14D
;  {
;     adc_tmp = volt*avcc/1024; //������� �������� ��� (1,23�)
	LDS  R30,_avcc
	LDS  R31,_avcc+1
	CALL SUBOPT_0x1F
	CALL __MULW12U
	CALL __LSRW2
	MOV  R30,R31
	LDI  R31,0
	STS  _adc_tmp,R30
	STS  _adc_tmp+1,R31
;     if (adc_tmp > ION) {delta=adc_tmp-ION;}   //������������� ��������
	LDS  R26,_adc_tmp
	LDS  R27,_adc_tmp+1
	CPI  R26,LOW(0x513)
	LDI  R30,HIGH(0x513)
	CPC  R27,R30
	BRLO _0x14E
	LDS  R30,_adc_tmp
	LDS  R31,_adc_tmp+1
	SUBI R30,LOW(1298)
	SBCI R31,HIGH(1298)
	RJMP _0x232
;     else delta=ION-adc_tmp;           //������������� ��������
_0x14E:
	LDS  R26,_adc_tmp
	LDS  R27,_adc_tmp+1
	LDI  R30,LOW(1298)
	LDI  R31,HIGH(1298)
	SUB  R30,R26
	SBC  R31,R27
_0x232:
	STS  _delta,R30
	STS  _delta+1,R31
;     if (delta < d){d=delta; vref=avcc;} //���� ������ ����������� �������� - ��������� ����� ����������� �������� � ����������� ���������� Vref
	LDS  R30,_d
	LDS  R31,_d+1
	LDS  R26,_delta
	LDS  R27,_delta+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x150
	LDS  R30,_delta
	LDS  R31,_delta+1
	STS  _d,R30
	STS  _d+1,R31
	LDS  R30,_avcc
	LDS  R31,_avcc+1
	STS  _vref,R30
	STS  _vref+1,R31
;  }                                      //��������� ���������� ����� ��������, ��������� ������ ������������ ���������� Vref
_0x150:
	LDI  R26,LOW(_avcc)
	LDI  R27,HIGH(_avcc)
	CALL SUBOPT_0x16
	RJMP _0x14C
_0x14D:
;}                 //��������� ������� �������������� ���
	RET
;
;uint16_t adc_get_volt(void)
;{
;   return vref-adc_result*vref/1024;
;}
;
;/*
;//�������������� ���,=AVR. ������� 8=, ��, �9, 2005 �     =1
;//Make: avr83,atmega8,Level=2,VMLab,SRC=$(TARGET).c lcd.c =2
;//�����: SUT0=CKSEL3=CKSEL2=CKSEL1="0" (��������� 1 ���)  =3
;#include <avr/io.h>             //���������� �����-������ =4
;#define RIZM 200  //������������� �����. ��������� � ���� =5
;#define ION 1298 //���������� ����������� ��� (1,23) � �� =6
;extern void lcd_com(unsigned char p);   //���� ������ ��� =7
;extern void lcd_dat(unsigned char p);   //���� ������ ��� =8
;extern void lcd_init(void);           //������������� ��� =9
;unsigned char t0[]=" ==WATTMETER==          mWt     "; //=10
;unsigned long vref=0,volt,watt,delta,i,d=200,avcc;     //=11
;unsigned int a;                //��������������� ������� =12
;//-----------������� �������������� ���----------------- =13
;void calib (void)   //����� ������������ ���������� Vref =14
;{ //������� ADMUX: ��� 10 ���, Vref=AVCC (5B), ���=1,23� =15
;        ADMUX &= 0xDF & 0x7F & 0xFE; ADMUX |= 0x40 | 0x0E;   //=16
;//������� ADCSRA: ���. ���, ��������� ����, F���=62 ���  =17
;        ADCSRA &= 0xDF & 0xFC; ADCSRA |= 0x80 | 0x40 | 0x04; //=18
;  for (volt=0, a=100; a>0; a--) //���������� 100 ������� =19
;  {    ADCSRA |= 0x40;        //������ ������ ��������� ��� =20
;          while (ADCSRA & 0x40);   //�������� ��������� ������ =21
;          volt += ADCL;    //������ ������� 8 ����� ���������� =22
;    volt += ((int)ADCH << 8);    //���� ��� ������� ���� =23
;        }                   //��������� 100 ������� ���������� =24
;        for (avcc=4750; avcc<5250; avcc++) //�������� AVCC, �� =25
;  { i = volt*avcc/102400; //������� �������� ��� (1,23�) =26
;          if (i > ION) delta=i-ION;   //������������� �������� =27
;          else delta=ION-i;           //������������� �������� =28
;          if (delta < d)    //���� ������ ����������� �������� =29
;    { d=delta;    //��������� ����� ����������� �������� =30
;      vref=avcc; //��������� ����������� ���������� Vref =31
;    }              //��������� ���������� ����� �������� =32
;  }      //��������� ������ ������������ ���������� Vref =33
;}                 //��������� ������� �������������� ��� =34
;//================�������� ���������==================== =35
;int main(void)               //������ �������� ��������� =36
;{ PORTB = DDRD = 0xFF; //�=����� � �����������, D=������ =37
;  PORTC = 0xF0; DDRC = 0x05;   //PC0, PC2 ������ � ���.0 =38
;  lcd_init();          //������������� ��� (4 ���, 16�2) =39
;  for (lcd_com(0x80), a=0; a<32; a++)  //��������� ����� =40
;        { if (a==16) lcd_com(0xC0); //������� �� ������ ������ =41
;          lcd_dat(t0[a]);             //����� �������� ������� =42
;        }       //��������� ������ ��������� ������� WATTMETER =43
;        calib(); //�������������� ��� �� ����������� ��� 1,23� =44
;        ADMUX &= 0xF3; ADMUX |= 0x03;   //����������� ������-3 =45
;        ADCSRA |= 0x20 | 0x40;   //���� ���������� ������� ��� =46
;        while (1)                           //����������� ���� =47
;        { for (a=65000; a>0; a--);       //����� ��� ��������� =48
;          volt = ADCL;     //������ ������� 8 ����� ���������� =49
;    volt += ((int)ADCH << 8);    //���� ��� ������� ���� =50
;          watt=(vref-volt*vref/1024)*(volt*vref/1024)/RIZM; // =51
;                lcd_com(0xC4);               //��������� ������� ��� =52
;                lcd_dat(watt/1000 + 0x30); //������� ��������� (���) =53
;				lcd_dat(',');	lcd_dat((watt/100)%10 +0x30); //0,1��� =54
;		}                     //������� � ������ ��������� ��� =55
;}              //WinAVR-20050214, ����� ���� 1342 ������ =56
;
;
;
;//����������� �� ��� (���),=AVR. ������� 9=, ��, �10-2005 =1
;//Make: avr91,atmega8,Level=2,VMLab,SRC=$(TARGET).c lcd.c =2
;//�����: SUT0=CKSEL3=CKSEL1=CKSEL0="0" (��������� 8 ���)  =3
;#include <avr/io.h>             //���������� �����-������ =4
;extern void lcd_com(unsigned char p);   //���� ������ ��� =5
;extern void lcd_dat(unsigned char p);   //���� ������ ��� =6
;extern void lcd_init(void);           //������������� ��� =7
;unsigned char t[]="        ��c/�e� ";    //����� �������� =8
;//================�������� ���������===================== =9
;int main(void)               //������ �������� ��������� =10
;{ unsigned char a, b, c, scan, ur, h;         //�������� =11
;  unsigned int izm, d, k;       //�������� ������� ����� =12
;		unsigned int osc[32];   //������ �������� ������������ =13
;		PORTB = DDRD = 0xFF; //�=����� � �����������, D=������ =14
;  PORTC = 0xC2; DDRC = 0x05;   //PC0, PC2 ������ � ���.0 =15
;		ADMUX &= 0x7F; ADMUX |= 0x20 | 0x40;  //8-10 ���, AVCC =16
;//������� ADCSRA: ���.���, �������. �������., F���=1 ��� =17
;		ADCSRA &= 0xFB; ADCSRA |= 0x80 | 0x40 | 0x20 | 0x03; //=18
;		lcd_init();          //������������� ��� (4 ���, 16�2) =19
;		lcd_com(0x40); lcd_dat(0x00); //������ ��������������� =20
;		for (a=1; a<63; a++)  //�������� 8 ��������� ��������� =21
;		{ if (a%7 == 0) lcd_dat(0x1F);      //� ������ 5 ����� =22
;	   else lcd_dat(0x00);       //������ ������, ��� ����� =23
;		}       //��������� �������� 62 ������ ��������������� =24
;		lcd_dat(0x00); //��������� (64-�) ���� ��������������� =25
;		for (lcd_com(0xC0), a=0; a<16; a++) lcd_dat(t[a]);  // =26
;		while (1)                 //����������� ���� ��������� =27
;		{ ADMUX &=0xF5; ADMUX |=0x05;     //�����-5, ��������� =28
;		  for (a=5; a>0; a--) for (d=60000; d>0; d--);	//����� =29
;				scan = (ADCH <= 5)? 1 : (ADCH - 4); //���������, ��� =30
;				ADMUX &=0xF4; ADMUX |=0x04; //�����-4, ������� ����� =31
;				lcd_com(0xC2);               //��������� ������� ��� =32
;				for (k=13*scan, d=10000, b=5; b > 0; b--, d=d/10) // =33
;    { lcd_dat(((k / d)%10) + 0x30); //����� �����. ����� =34
;    }  //��������� ������ 5 ���� ������� ��������� � ��� =35
;				ur = (ADCH <= 10)? 0 : ADCH; //������� ���������., � =36
;		  ADMUX &= 0xF3; ADMUX |= 0x03; //�����-3, ���� �����. =37
;				for(lcd_com(0x80), a=0; a<32; a++)   //32 ������ ��� =38
;				{ for (izm=0, b=scan; b > 0; b--)  //����� ��������� =39
;						{ while (!(ADCSRA & 0x10));   //�������� ��������� =40
;		      ADCSRA |= 0x10;   //���������� ���������� ������ =41
;        izm += ADCH;             //���������� ���������� =42
;						}                //��������� ���������� ������ ��� =43
;						osc[a] = izm;        //���������� ������� �������� =44
;				}              	//��������� 32 ������� ��������� ��� =45
;				lcd_com(0x0D);               //��������� ������� ��� =46
;				if (!ur)	for (a=0; a<16; a++) lcd_dat((osc[a]/scan)/32);
;				else  //���� ������������� ��� ��������� ����������� =48
;				{	if (ur < 0xF0)    //���� ��� ��������� ����������� =49
;				  { for (a=b=c=h=0; a<16; a++) //����� ������������� =50
;        { if (bit_is_set(PINB,PB0)) c=1; //������ SB1(+) =51
;								  else b=1;   //����� ������������� �� <+> � <-> =52
;								  if((osc[a+b]/scan<(ur-3))&&(osc[a+c]/scan>(ur+3)))
;								  { h=a; a=32;       //��������� ����� �� ������ =54
;										}            //������������� ��������� ������� =55
;						  }     //��������� ��������� ������ ������������� =56
;						  for (a=h; a<(h+16); a++) lcd_dat((osc[a]/scan)/32);
;						}  //��������� ���������� ������� � �������������� =58
;						else lcd_com(0x0C);  //����. ������� ��� ��������� =59
;				}        //���������� ��������� ������ ������������� =60
;		}               //������� � ������ ����� ��������� ��� =61
;}               //WinAVR-20050214, ����� ���� 882 ������ =62
;
;
;
;//������������ �����������,=AVR. ������� 10=, �� �11-2005 =1
;//Make:avr101,atmega8,Level=2,VMLab,SRC=$(TARGET).c lcd.c =2
;//�����: SUT0=CKSEL3=CKSEL2=CKSEL1="0" (��������� 1 ���)  =3
;#include <avr/io.h>             //���������� �����-������ =4
;extern void lcd_com(unsigned char p);   //���� ������ ��� =5
;extern void lcd_dat(unsigned char p);   //���� ������ ��� =6
;extern void lcd_init(void);           //������������� ��� =7
;#define TIME 30 //�������� ������������ ������ ������ ��� =8
;unsigned char t[]="C�ap� ���epe���";     //����� �������� =9
;//================�������� ���������==================== =10
;int main(void)               //������ �������� ��������� =11
;{ unsigned char u1[450], u2[450]; //������� ������ �����.=12
;		unsigned int a, b, c, d, h=0;        //�������� ������ =13
;  PORTB = DDRD = 0xFF; //�=����� � �����������, D=������ =14
;  PORTC = 0xC2; DDRC = 0x05;   //PC0, PC2 ������ � ���.0 =15
;		ADMUX &= 0x7F; ADMUX |= 0x20 | 0x40;  //8-10 ���, AVCC =16
;//������� ADCSRA: �������� ���, ����������, F���=125 ��� =17
;		ADCSRA &= 0xDF & 0xFB; ADCSRA |= 0x80 | 0x40 | 0x03; //=18
;		lcd_init();          //������������� ��� (4 ���, 16�2) =19
;		lcd_com(0x40); lcd_dat(0x00); //������ ��������������� =20
;		for (a=1; a<63; a++)  //�������� 8 ��������� ��������� =21
;		{ if (a%7 == 0) lcd_dat(0x1F);      //� ������ 5 ����� =22
;	   else lcd_dat(0x00);       //������ ������, ��� ����� =23
;		}       //��������� �������� 62 ������ ��������������� =24
;		lcd_dat(0x00); //��������� (64-�) ���� ��������������� =25
;		for(lcd_com(0x80),a=0; a<15; a++) lcd_dat(t[a]); //��� =26
;		do  //���� �������� �������� ���������� U��� ����� 4 � =27
;		{ ADMUX &=0xF3; ADMUX |=0x03; ADCSRA |=0x40; //�����-3 =28
;		  while (ADCSRA & 0x40);   //�������� ��������� ������ =29
;		} while (ADCH > 0xCC); //���������, ���� ������� > 4 � =30
;		lcd_com(0x0C); //���������� ������� ��� ������ ������� =31
;		for (a=0; a<450; a++) //���� ���������� ������� ������ =32
;		{ for (c=d=0, b=TIME; b>0; b--)   //���������� ������� =33
;		  { ADMUX &=0xF4; ADMUX |=0x04; ADCSRA |=0x40; //���.4 =34
;		    while (ADCSRA & 0x40); //�������� ��������� ������ =35
;		    c += ADCH;  //���������� ��������� ��� �� ������-4 =36
;				  ADMUX &=0xF5; ADMUX |=0x05; ADCSRA |=0x40; //���.5 =37
;		    while (ADCSRA & 0x40); //�������� ��������� ������ =38
;		    d += ADCH;  //���������� ��������� ��� �� ������-5 =39
;				}         //��������� ����� ������� � �������-4 � -5 =40
;				u1[a] = c/(TIME*32);  //����������� ������� ����� U1 =41
;				u2[a] = d/(TIME*32);  //����������� ������� ����� U2 =42
;		}         //��������� ���������� ������� ������ U1, U2 =43
;  while (1) //����������� ���� ���������, ������ - ����� =44
;		{ lcd_com(0x80);  //��������� ������� � ������� ������ =45
;		  for(a=h; a < h+15; a++) lcd_dat(u1[a]);  //������ U1 =46
;				lcd_com(0xC0);   //��������� ������� � ������ ������ =47
;				for(a=h; a < h+15; a++) lcd_dat(u2[a]);  //������ U2 =48
;				lcd_dat(0x30 + h/15);  //�������� ����� ����� ������ =49
;				if (bit_is_clear(PINB,PB0))     //������� ������ SB1 =50
;    { if ((h += 15) > 435) h=0;  //��������� ���� ������ =51
;      for (c=65000; c>0; c--);  //������������ ��������� =52
;				}         //��������� ���������� ������ ����� ������ =53
;				if (bit_is_clear(PINB,PB1))     //������� ������ SB2 =54
;    { h = (h < 15)? 435 : (h-15); //���������� ���� ���. =55
;      for (c=65000; c>0; c--);  //������������ ��������� =56
;				}         //��������� ���������� ������ ����� ������ =57
;		}               //������� � ���������� �������� ������ =58
;}               //WinAVR-20050214, ����� ���� 752 ������ =59
;
;*/
;/**** A V R  A P P L I C A T I O N  NOTE 1 3 4 **************************
; *
; * Title:           Real Time Clock
; * Version:         2.00
; * Last Updated:    24.09.2013
; * Target:          ATmega128 (All AVR Devices with secondary external oscillator)
; *
; * Support E-mail:  avr@atmel.com
; *
; * Description
; * This application note shows how to implement a Real Time Clock utilizing a secondary
; * external oscilator. Included a test program that performs this function, which keeps
; * track of time, date, month, and year with auto leap-year configuration. 8 LEDs are used
; * to display the RTC. The 1st LED flashes every second, the next six represents the
; * minute, and the 8th LED represents the hour.
; *
; ******************************************************************************************/
;
;#ifdef _GCC_
;#include <avr/io.h>
;#include <avr/interrupt.h>
;#include <avr/sleep.h>
;#else
;
;#endif
;
;	time t;
;/*
;int main(void)
;{
;    rtc_init();	//Initialize registers and configure RTC.
;
;	while(1)
;	{
;		sleep_mode();										//Enter sleep mode. (Will wake up from timer overflow interrupt)
;		TCCR0=(1<<CS00)|(1<<CS02);							//Write dummy value to control register
;		while(ASSR&((1<<TCN0UB)|(1<<OCR0UB)|(1<<TCR0UB)));	//Wait until TC0 is updated
;	}
;}
;*/
;static void rtc_init(void)
;{
_rtc_init_G000:
;   	TIMSK &= ~((1<<TOIE0)|(1<<OCIE0));						//Make sure all TC0 interrupts are disabled
	IN   R30,0x37
	ANDI R30,LOW(0xFC)
	OUT  0x37,R30
;	ASSR |= (1<<AS0);										//set Timer/counter0 to be asynchronous from the CPU clock
	IN   R30,0x30
	ORI  R30,8
	OUT  0x30,R30
;															//with a second external clock (32,768kHz)driving it.
;	TCNT0 =0;												//Reset timer
	LDI  R30,LOW(0)
	OUT  0x32,R30
;	TCCR0 =(1<<CS00)|(1<<CS02);								//Prescale the timer to be clock source/128 to make it
	LDI  R30,LOW(5)
	OUT  0x33,R30
;															//exactly 1 second for every overflow to occur
;	while (ASSR & ((1<<TCN0UB)|(1<<OCR0UB)|(1<<TCR0UB))){ }	//Wait until TC0 is updated
_0x151:
	IN   R30,0x30
	ANDI R30,LOW(0x7)
	BRNE _0x151
;	TIMSK |= (1<<TOIE0);									//Set 8-bit Timer/Counter0 Overflow Interrupt Enable
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;#asm("sei")													//Set the Global Interrupt Enable Bit
	sei
;}
	RET
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;{
_timer0_ovf_isr:
	CALL SUBOPT_0x20
;	if (++t.second==60)        //keep track of time, date, month, and year
	LDS  R26,_t
	SUBI R26,-LOW(1)
	STS  _t,R26
	CPI  R26,LOW(0x3C)
	BREQ PC+3
	JMP _0x154
;	{
;		t.second=0;
	LDI  R30,LOW(0)
	STS  _t,R30
;		if (++t.minute==60)
	__GETB1MN _t,1
	SUBI R30,-LOW(1)
	__PUTB1MN _t,1
	CPI  R30,LOW(0x3C)
	BREQ PC+3
	JMP _0x155
;		{
;			t.minute=0;
	LDI  R30,LOW(0)
	__PUTB1MN _t,1
;			if (++t.hour==24)
	__GETB1MN _t,2
	SUBI R30,-LOW(1)
	__PUTB1MN _t,2
	CPI  R30,LOW(0x18)
	BREQ PC+3
	JMP _0x156
;			{
;				t.hour=0;
	LDI  R30,LOW(0)
	__PUTB1MN _t,2
;				if (++t.date==32)
	__GETB1MN _t,3
	SUBI R30,-LOW(1)
	__PUTB1MN _t,3
	CPI  R30,LOW(0x20)
	BREQ _0x233
;				{
;					t.month++;
;					t.date=1;
;				}
;				else if (t.date==31)
	__GETB2MN _t,3
	CPI  R26,LOW(0x1F)
	BRNE _0x159
;				{
;					if ((t.month==4) || (t.month==6) || (t.month==9) || (t.month==11))
	__GETB2MN _t,4
	CPI  R26,LOW(0x4)
	BREQ _0x15B
	__GETB2MN _t,4
	CPI  R26,LOW(0x6)
	BREQ _0x15B
	__GETB2MN _t,4
	CPI  R26,LOW(0x9)
	BREQ _0x15B
	__GETB2MN _t,4
	CPI  R26,LOW(0xB)
	BRNE _0x15A
_0x15B:
;					{
;						t.month++;
	CALL SUBOPT_0x21
;						t.date=1;
;					}
;				}
_0x15A:
;				else if (t.date==30)
	RJMP _0x15D
_0x159:
	__GETB2MN _t,3
	CPI  R26,LOW(0x1E)
	BRNE _0x15E
;				{
;					if(t.month==2)
	__GETB2MN _t,4
	CPI  R26,LOW(0x2)
	BRNE _0x15F
;					{
;						t.month++;
	CALL SUBOPT_0x21
;						t.date=1;
;					}
;				}
_0x15F:
;				else if (t.date==29)
	RJMP _0x160
_0x15E:
	__GETB2MN _t,3
	CPI  R26,LOW(0x1D)
	BRNE _0x161
;				{
;					if((t.month==2) && (not_leap()))
	__GETB2MN _t,4
	CPI  R26,LOW(0x2)
	BRNE _0x163
	RCALL _not_leap_G000
	CPI  R30,0
	BRNE _0x164
_0x163:
	RJMP _0x162
_0x164:
;					{
;						t.month++;
_0x233:
	__GETB1MN _t,4
	SUBI R30,-LOW(1)
	__PUTB1MN _t,4
	SUBI R30,LOW(1)
;						t.date=1;
	LDI  R30,LOW(1)
	__PUTB1MN _t,3
;					}
;				}
_0x162:
;				if (t.month==13)
_0x161:
_0x160:
_0x15D:
	__GETB2MN _t,4
	CPI  R26,LOW(0xD)
	BRNE _0x165
;				{
;					t.month=1;
	LDI  R30,LOW(1)
	__PUTB1MN _t,4
;					t.year++;
	__GETB1MN _t,5
	SUBI R30,-LOW(1)
	__PUTB1MN _t,5
	SUBI R30,LOW(1)
;				}
;			}
_0x165:
;		}
_0x156:
;	}
_0x155:
;	//PORTB=~(((t.second&0x01)|t.minute<<1)|t.hour<<7);
;}
_0x154:
	RJMP _0x246
;
;static char not_leap(void)      //check for leap year
;{
_not_leap_G000:
;	if (!(t.year%100))
	__GETB2MN _t,5
	LDI  R30,LOW(100)
	CALL __MODB21U
	CPI  R30,0
	BRNE _0x166
;	{
;		return (char)(t.year%400);
	__GETB2MN _t,5
	CLR  R27
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL __MODW21U
	RET
;	}
;	else
_0x166:
;	{
;		return (char)(t.year%4);
	__GETB1MN _t,5
	ANDI R30,LOW(0x3)
	RET
;	}
;}
	RET
;#include "D_IIC_ultimate/IIC_ultimate.h"
;
;
;void DoNothing(void);
;
;uint8_t i2c_Do;								// ���������� ��������� ����������� IIC
;uint8_t i2c_InBuff[i2c_MasterBytesRX];		// ����� ����� ��� ������ ��� Slave
;uint8_t i2c_OutBuff[i2c_MasterBytesTX];		// ����� �������� ��� ������ ��� Slave
;uint8_t i2c_SlaveIndex;						// ������ ������ Slave
;
;
;uint8_t i2c_Buffer[i2c_MaxBuffer];			// ����� ��� ������ ������ � ������ Master
;uint8_t i2c_index;							// ������ ����� ������
;uint8_t i2c_ByteCount;						// ����� ���� ������������
;
;uint8_t i2c_SlaveAddress;						// ����� ������������
;
;uint8_t i2c_PageAddress[i2c_MaxPageAddrLgth];	// ����� ������ ������� (��� ������ � sawsarp)
;uint8_t i2c_PageAddrIndex;						// ������ ������ ������ �������
;uint8_t i2c_PageAddrCount;						// ����� ���� � ������ �������� ��� �������� Slave
;
;											// ��������� ������ �� ��������:
;IIC_F MasterOutFunc = &DoNothing;			//  � Master ������

	.DSEG
;IIC_F SlaveOutFunc 	= &DoNothing;			//  � ������ Slave
;IIC_F ErrorOutFunc 	= &DoNothing;			//  � ���������� ������ � ������ Master
;
;/*
;uint8_t 	WorkLog[100];						// ��� ����� ����
;uint8_t		WorkIndex=0;						// ������ ����
;*/
;
;// Two Wire bus interrupt service routine
;interrupt [TWI] void twi_isr(void)								// ���������� TWI ��� ���� ���.
;{

	.CSEG
_twi_isr:
	CALL SUBOPT_0x20
;/*
;PORTB ^= 0x01;								// ������� ����� �����, ��� ������������� ����������� ����������� � ������� ������ TWI
;
;
;// ���������� �����. ����� ���� ������ ��������� �������� � ����� ������, � �����. �� ��������� ������ ����� UART �� ����
;if (WorkIndex <99)							// ���� ��� �� ����������
;{
;	if (TWSR)								// ������ �������?
;		{
;		WorkLog[WorkIndex]= TWSR;			// ����� ������ � ���
;		WorkIndex++;
;		}
;	else
;		{
;		WorkLog[WorkIndex]= 0xFF;			// ���� ������ ������� �� ��������� FF
;		WorkIndex++;
;		}
;}
;*/
;switch(TWSR & 0xF8)						// �������� ���� ����������
	LDS  R30,113
	ANDI R30,LOW(0xF8)
;	{
;	case 0x00:	// Bus Fail (������� ��������)
	CPI  R30,0
	BRNE _0x16E
;			{
;			i2c_Do |= i2c_ERR_BF;
	LDS  R30,_i2c_Do
	ORI  R30,1
	CALL SUBOPT_0x22
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			MACRO_i2c_WhatDo_ErrorOut
;			break;
	RJMP _0x16D
;			}
;
;	case 0x08:	// ����� ���, � ����� ��:
_0x16E:
	CPI  R30,LOW(0x8)
	BRNE _0x16F
;			{
;			if( (i2c_Do & i2c_type_msk)== i2c_sarp)							// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	BRNE _0x170
;				{
;				i2c_SlaveAddress |= 0x01;									// ���� Addr+R
	LDS  R30,_i2c_SlaveAddress
	ORI  R30,1
	RJMP _0x234
;				}
;			else															// ���
_0x170:
;				{
;				i2c_SlaveAddress &= 0xFE;									// ���� Addr+W
	LDS  R30,_i2c_SlaveAddress
	ANDI R30,0xFE
_0x234:
	STS  _i2c_SlaveAddress,R30
;				}
;
;			TWDR = i2c_SlaveAddress;													// ����� ������
	CALL SUBOPT_0x23
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			break;
	RJMP _0x16D
;			}
;
;	case 0x10:	// ��������� ����� ���, � ����� ��
_0x16F:
	CPI  R30,LOW(0x10)
	BRNE _0x172
;			{
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)						// � ����������� �� ������
	CALL SUBOPT_0x24
	BRNE _0x173
;				{
;				i2c_SlaveAddress |= 0x01;									// ���� Addr+R
	LDS  R30,_i2c_SlaveAddress
	ORI  R30,1
	RJMP _0x235
;				}
;			else
_0x173:
;				{
;				i2c_SlaveAddress &= 0xFE;									// ���� Addr+W
	LDS  R30,_i2c_SlaveAddress
	ANDI R30,0xFE
_0x235:
	STS  _i2c_SlaveAddress,R30
;				}
;
;			// To Do: �������� ���� ��������� ������
;
;			TWDR = i2c_SlaveAddress;													// ����� ������
	CALL SUBOPT_0x23
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			break;
	RJMP _0x16D
;			}
;
;	case 0x18:	// ��� ������ SLA+W �������� ACK, � �����:
_0x172:
	CPI  R30,LOW(0x18)
	BRNE _0x175
;			{
;			if( (i2c_Do & i2c_type_msk) == i2c_sawp)						// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x176
;				{
;				TWDR = i2c_Buffer[i2c_index];								// ���� ���� ������
	CALL SUBOPT_0x25
;				i2c_index++;												// ����������� ��������� ������
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  // Go!
;
;				}
;
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)
_0x176:
	CALL SUBOPT_0x24
	BRNE _0x177
;				{
;				TWDR = i2c_PageAddress[i2c_PageAddrIndex];					// ��� ���� ����� ������� (�� ���� ���� ���� ������)
	CALL SUBOPT_0x26
;				i2c_PageAddrIndex++;										// ����������� ��������� ������ ��������
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;	// Go!
	STS  116,R30
;				}
;			}
_0x177:
;			break;
	RJMP _0x16D
;
;	case 0x20:	// ��� ������ SLA+W �������� NACK - ����� ���� �����, ���� ��� ��� ����.
_0x175:
	CPI  R30,LOW(0x20)
	BRNE _0x178
;			{
;			i2c_Do |= i2c_ERR_NA;															// ��� ������
	LDS  R30,_i2c_Do
	ORI  R30,0x10
	CALL SUBOPT_0x22
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// ���� ���� Stop
;
;			MACRO_i2c_WhatDo_ErrorOut 														// ������������ ������� ������;
;			break;
	RJMP _0x16D
;			}
;
;	case 0x28: 	// ���� ������ �������, �������� ACK!  (���� sawp - ��� ��� ���� ������. ���� sawsarp - ���� ������ ��������)
_0x178:
	CPI  R30,LOW(0x28)
	BRNE _0x179
;			{	// � ������:
;			if( (i2c_Do & i2c_type_msk) == i2c_sawp)							// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x17A
;				{
;				if (i2c_index == i2c_ByteCount)												// ���� ��� ���� ������ ���������
	LDS  R30,_i2c_ByteCount
	LDS  R26,_i2c_index
	CP   R30,R26
	BRNE _0x17B
;					{
;					TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;	// ���� Stop
	CALL SUBOPT_0x27
;
;					MACRO_i2c_WhatDo_MasterOut												// � ������� � ��������� �����
;
;					}
;				else
	RJMP _0x17C
_0x17B:
;					{
;					TWDR = i2c_Buffer[i2c_index];												// ���� ���� ��� ���� ����
	CALL SUBOPT_0x25
;					i2c_index++;
;					TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;					}
_0x17C:
;				}
;
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)						// � ������ ������ ��
_0x17A:
	CALL SUBOPT_0x24
	BRNE _0x17D
;				{
;				if(i2c_PageAddrIndex == i2c_PageAddrCount)					// ���� ��������� ���� ������ ��������
	LDS  R30,_i2c_PageAddrCount
	LDS  R26,_i2c_PageAddrIndex
	CP   R30,R26
	BRNE _0x17E
;					{
;					TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ��������� ��������� �����!
	LDI  R30,LOW(229)
	RJMP _0x236
;					}
;				else
_0x17E:
;					{														// �����
;					TWDR = i2c_PageAddress[i2c_PageAddrIndex];				// ���� ��� ���� ����� ��������
	CALL SUBOPT_0x26
;					i2c_PageAddrIndex++;									// ����������� ������ �������� ������ �������
;					TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// Go!
_0x236:
	STS  116,R30
;					}
;				}
;			}
_0x17D:
;			break;
	RJMP _0x16D
;
;	case 0x30:	//���� ����, �� �������� NACK ������ ���. 1� �������� �������� ������� � ��� ����. 2� ����� �������.
_0x179:
	CPI  R30,LOW(0x30)
	BRNE _0x180
;			{
;			i2c_Do |= i2c_ERR_NK;				// ������� ������ ������. ���� ��� �� ����, ��� ������.
	LDS  R30,_i2c_Do
	ORI  R30,2
	STS  _i2c_Do,R30
;
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ���� Stop
	CALL SUBOPT_0x27
;
;			MACRO_i2c_WhatDo_MasterOut													// ������������ ������� ������
;
;			break;
	RJMP _0x16D
;			}
;
;	case 0x38:	//  �������� �� ����. ������� ��� �� ���������
_0x180:
	CPI  R30,LOW(0x38)
	BRNE _0x181
;			{
;			i2c_Do |= i2c_ERR_LP;			// ������ ������ ������ ����������
	LDS  R30,_i2c_Do
	ORI  R30,0x20
	CALL SUBOPT_0x28
;
;			// ����������� ������� ������.
;			i2c_index = 0;
;			i2c_PageAddrIndex = 0;
;
;			TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ��� ������ ���� ����� ��������
	LDI  R30,LOW(229)
	STS  116,R30
;			break;																		// ��������� �������� �����.
	RJMP _0x16D
;			}
;
;	case 0x40: // ������� SLA+R �������� ���. � ������ ����� �������� �����
_0x181:
	CPI  R30,LOW(0x40)
	BRNE _0x182
;			{
;			if(i2c_index+1 == i2c_ByteCount)								// ���� ����� �������� �� ���� �����, ��
	CALL SUBOPT_0x29
	BRNE _0x183
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ������� ����, � � ����� ����� ������ NACK(Disconnect)
	LDI  R30,LOW(133)
	RJMP _0x237
;				}															// ��� ���� ������ ������, ��� ��� ������ �����. � �� �������� ����
;			else
_0x183:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;	// ��� ������ ������ ���� � ������ ����� ACK
	LDI  R30,LOW(197)
_0x237:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x16D
;			}
;
;	case 0x48: // ������� SLA+R, �� �������� NACK. ������ slave ����� ��� ��� ��� ����.
_0x182:
	CPI  R30,LOW(0x48)
	BRNE _0x185
;			{
;			i2c_Do |= i2c_ERR_NA;															// ��� ������ No Answer
	LDS  R30,_i2c_Do
	ORI  R30,0x10
	CALL SUBOPT_0x22
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// ���� Stop
;
;			MACRO_i2c_WhatDo_ErrorOut														// ������������ �������� �������� ������
;			break;
	RJMP _0x16D
;			}
;
;	case 0x50: // ������� ����.
_0x185:
	CPI  R30,LOW(0x50)
	BRNE _0x186
;			{
;			i2c_Buffer[i2c_index] = TWDR;			// ������� ��� �� ������
	CALL SUBOPT_0x2A
;			i2c_index++;
	LDS  R30,_i2c_index
	SUBI R30,-LOW(1)
	STS  _i2c_index,R30
;
;			// To Do: �������� �������� ������������ ������. � �� ���� �� ��� ���� ���������
;
;			if (i2c_index+1 == i2c_ByteCount)		// ���� ������� ��� ���� ���� �� ���, ��� �� ������ �������
	CALL SUBOPT_0x29
	BRNE _0x187
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// ����������� ��� � ����� ������ NACK (Disconnect)
	LDI  R30,LOW(133)
	RJMP _0x238
;				}
;			else
_0x187:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;		// ���� ���, �� ����������� ��������� ����, � � ����� ������ ���
	LDI  R30,LOW(197)
_0x238:
	STS  116,R30
;				}
;			break;
	RJMP _0x16D
;			}
;
;	case 0x58:	// ��� �� ����� ��������� ����, ������� NACK ����� �������� � �����.
_0x186:
	CPI  R30,LOW(0x58)
	BRNE _0x189
;			{
;			i2c_Buffer[i2c_index] = TWDR;													// ����� ���� � �����
	CALL SUBOPT_0x2A
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// �������� Stop
	CALL SUBOPT_0x27
;
;			MACRO_i2c_WhatDo_MasterOut														// ���������� ����� ������
;
;			break;
	RJMP _0x16D
;			}
;
;// IIC  Slave ============================================================================
;
;	case 0x68:	// RCV SLA+W Low Priority							// ������� ���� ����� �� ����� �������� ��������
_0x189:
	CPI  R30,LOW(0x68)
	BREQ _0x18B
;	case 0x78:	// RCV SLA+W Low Priority (Broadcast)				// ��� ��� ��� ����������������� �����. �� �����
	CPI  R30,LOW(0x78)
	BRNE _0x18C
_0x18B:
;			{
;			i2c_Do |= i2c_ERR_LP | i2c_Interrupted;					// ������ ���� ������ Low Priority, � ����� ���� ����, ��� ������� ��������
	LDS  R30,_i2c_Do
	ORI  R30,LOW(0xA0)
	CALL SUBOPT_0x28
;
;			// Restore Trans after.
;			i2c_index = 0;											// ����������� ��������� �������� ������
;			i2c_PageAddrIndex = 0;
;			}														// � ����� ������. ��������!!! break ��� ���, � ������ ���� � "case 60"
;
;	case 0x60: // RCV SLA+W  Incoming?								// ��� ������ �������� ���� �����
	RJMP _0x18D
_0x18C:
	CPI  R30,LOW(0x60)
	BRNE _0x18E
_0x18D:
;	case 0x70: // RCV SLA+W  Incoming? (Broascast)					// ��� ����������������� �����
	RJMP _0x18F
_0x18E:
	CPI  R30,LOW(0x70)
	BRNE _0x190
_0x18F:
;			{
;
;			i2c_Do |= i2c_Busy;										// �������� ����. ����� ������ �� ��������
	CALL SUBOPT_0x2B
;			i2c_SlaveIndex = 0;										// ��������� �� ������ ������ ������, ������� ����� �����. �� ��������
	LDI  R30,LOW(0)
	STS  _i2c_SlaveIndex,R30
;
;			if (i2c_MasterBytesRX == 1)								// ���� ��� ������� ������� ����� ���� ����, �� ��������� �������  ���
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;			// ������� � ������� ����� ��� �... NACK!
	LDI  R30,LOW(133)
;				}
;			else
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// � ���� ���� ���� ��� ���� ����, �� ������ � ��������� ��� ACK!
_0x239:
	STS  116,R30
;				}
;			break;
	RJMP _0x16D
;			}
;
;	case 0x80:	// RCV Data Byte									// � ��� �� ������� ���� ����. ��� ��� �����������������. �� �����
_0x190:
	CPI  R30,LOW(0x80)
	BREQ _0x194
;	case 0x90:	// RCV Data Byte (Broadcast)
	CPI  R30,LOW(0x90)
	BRNE _0x195
_0x194:
;			{
;			i2c_InBuff[i2c_SlaveIndex] = TWDR;						// ������� ��� � �����.
	CALL SUBOPT_0x2C
;
;			i2c_SlaveIndex++;										// �������� ���������
	CALL SUBOPT_0x2D
;
;			if (i2c_SlaveIndex == i2c_MasterBytesRX-1) 				// �������� ����� ����� ��� ���� ����?
	CPI  R30,0
	BRNE _0x196
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;			// ������� ��� � ������� NACK!
	LDI  R30,LOW(133)
	RJMP _0x23A
;				}
;			else
_0x196:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ����� ��� ������? ������� � ACK!
	LDI  R30,LOW(197)
_0x23A:
	STS  116,R30
;				}
;			break;
	RJMP _0x16D
;			}
;
;	case 0x88: // RCV Last Byte										// ������� ��������� ����
_0x195:
	CPI  R30,LOW(0x88)
	BREQ _0x199
;	case 0x98: // RCV Last Byte (Broadcast)
	CPI  R30,LOW(0x98)
	BRNE _0x19A
_0x199:
;			{
;			i2c_InBuff[i2c_SlaveIndex] = TWDR;						// ������� ��� � �����
	CALL SUBOPT_0x2C
;
;			if (i2c_Do & i2c_Interrupted)							// ���� � ��� ��� ���������� ����� �� ����� �������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x80)
	BREQ _0x19B
;				{
;				TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ������ � ���� ���� Start �������� � ������� ��� ���� �������
	LDI  R30,LOW(229)
	RJMP _0x23B
;				}
;			else
_0x19B:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ���� �� ���� ������ �����, �� ������ ��������� � ����� �����
	LDI  R30,LOW(197)
_0x23B:
	STS  116,R30
;				}
;
;			MACRO_i2c_WhatDo_SlaveOut												// � ������ ���������� ��� �������� ���� ��� ������
	__CALL1MN _SlaveOutFunc,0
;			break;
	RJMP _0x16D
;			}
;
;
;	case 0xA0: // ��, �� �������� ��������� �����. �� �� ��� � ��� ������?
_0x19A:
	CPI  R30,LOW(0xA0)
	BRNE _0x19D
;			{
;			// �����, �������, ������� ��������������� �������, ����� ������������ ��� � ������ ���������� �������, ������� ��������.
;			// �� � �� ���� ��������������. � ���� ������ �������� ��� ���.
;
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ������ �������������, �������������� ���� �����
	LDI  R30,LOW(197)
	STS  116,R30
;			break;
	RJMP _0x16D
;			}
;
;
;
;	case 0xB0:  // ������� ���� ����� �� ������ �� ����� �������� ��������
_0x19D:
	CPI  R30,LOW(0xB0)
	BRNE _0x19E
;			{
;			i2c_Do |= i2c_ERR_LP | i2c_Interrupted;			// �� ��, ���� ������ � ���� ��������� ��������.
	LDS  R30,_i2c_Do
	ORI  R30,LOW(0xA0)
	CALL SUBOPT_0x28
;
;			// ��������������� �������
;			i2c_index = 0;
;			i2c_PageAddrIndex = 0;
;			}												// Break ���! ���� ������
;
;	case 0xA8:	// // ���� ������ ������� ���� ����� �� ������
	RJMP _0x19F
_0x19E:
	CPI  R30,LOW(0xA8)
	BRNE _0x1A0
_0x19F:
;			{
;			i2c_SlaveIndex = 0;								// ������� ��������� �������� �� 0
	LDI  R30,LOW(0)
	STS  _i2c_SlaveIndex,R30
;
;			TWDR = i2c_OutBuff[i2c_SlaveIndex];				// ����, ������� ���� �� ��� ��� ����.
	CALL SUBOPT_0x2E
;
;			if(i2c_MasterBytesTX == 1)
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ���� �� ���������, �� ��� �� NACK � ����� ��������
	LDI  R30,LOW(133)
;				}
;			else
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;	// � ���� ���, ��  ACK ����
_0x23C:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x16D
;			}
;
;
;	case 0xB8: // ������� ����, �������� ACK
_0x1A0:
	CPI  R30,LOW(0xB8)
	BRNE _0x1A3
;			{
;
;			i2c_SlaveIndex++;								// ������ ���������� ���������. ����� ��������� ����
	CALL SUBOPT_0x2D
;			TWDR = i2c_OutBuff[i2c_SlaveIndex];				// ���� ��� �������
	CALL SUBOPT_0x2E
;
;			if (i2c_SlaveIndex == i2c_MasterBytesTX-1)		// ���� �� ��������� ���, ��
	LDS  R30,_i2c_SlaveIndex
	CPI  R30,0
	BRNE _0x1A4
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ���� ��� � ���� NACK
	LDI  R30,LOW(133)
	RJMP _0x23D
;				}
;			else
_0x1A4:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|0<<TWEN|1<<TWIE;	// ���� ���, �� ���� � ���� ACK
	LDI  R30,LOW(193)
_0x23D:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x16D
;			}
;
;	case 0xC0: // �� ������� ��������� ����, ������ � ��� ���, �������� NACK
_0x1A3:
	CPI  R30,LOW(0xC0)
	BREQ _0x1A7
;	case 0xC8: // ��� ACK. � ������ ������ ��� ���. �.�. ������ ������ � ��� ���.
	CPI  R30,LOW(0xC8)
	BRNE _0x1AB
_0x1A7:
;			{
;			if (i2c_Do & i2c_Interrupted)											// ���� ��� ���� ��������� �������� �������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x80)
	BREQ _0x1A9
;				{																	// �� �� ��� �� ������
;				i2c_Do &= i2c_NoInterrupted;										// ������ ���� �����������
	LDS  R30,_i2c_Do
	ANDI R30,0x7F
	STS  _i2c_Do,R30
;				TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// �������� ����� ����� �� ��� ������� ����.
	LDI  R30,LOW(229)
	RJMP _0x23E
;				}
;			else
_0x1A9:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ���� �� ��� ����, �� ������ ������� ����
	LDI  R30,LOW(197)
_0x23E:
	STS  116,R30
;				}
;
;			MACRO_i2c_WhatDo_SlaveOut												// � ���������� ����� ������. �������, �� ���
	__CALL1MN _SlaveOutFunc,0
;																					// �� ����� �� �����. ����� ��� ��� ������, ��� ������
;			break;																	// ��� ������ ����� �������.
;			}
;
;	default:	break;
_0x1AB:
;	}
_0x16D:
;}
_0x246:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void DoNothing(void)																// ������� ��������, �������� �������������� ������
;{
_DoNothing:
;}
	RET
;
;void Init_i2c(void)							// ��������� ������ �������
;{
_Init_i2c:
;i2c_PORT |= 1<<i2c_SCL|1<<i2c_SDA;			// ������� �������� �� ����, ����� ���� �� ��������� ����������
	IN   R30,0x12
	ORI  R30,LOW(0x3)
	OUT  0x12,R30
;i2c_DDR &=~(1<<i2c_SCL|1<<i2c_SDA);
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
;
;TWBR = 0xFF;         						// �������� �������
	LDI  R30,LOW(255)
	STS  112,R30
;TWSR = 0x03;
	LDI  R30,LOW(3)
	STS  113,R30
;/*
;// Bit Rate: 400,000 kHz
;TWBR=0x02;
;// Two Wire Bus Slave Address: 0x0
;// General Call Recognition: Off
;TWAR=0x00;
;// Generate Acknowledge Pulse: Off
;// TWI Interrupt: On
;TWCR = (1<<TWIE)|(1<<TWEN) ;
;TWSR=0x00;*/
;}
	RET
;
;void Init_Slave_i2c(IIC_F Addr)				// ��������� ������ ������ (���� �����)
;{
_Init_Slave_i2c:
;TWAR = i2c_MasterAddress;					// ������ � ������� ���� �����, �� ������� ����� ����������.
;	*Addr -> Y+0
	LDI  R30,LOW(50)
	STS  114,R30
;											// 1 � ������� ���� ��������, ��� �� ���������� �� ����������������� ������
;SlaveOutFunc = Addr;						// �������� ��������� ������ �� ������ ������� ������
	LD   R30,Y
	LDD  R31,Y+1
	STS  _SlaveOutFunc,R30
	STS  _SlaveOutFunc+1,R31
;
;TWCR = 0<<TWSTA|0<<TWSTO|0<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;		// �������� ������� � �������� ������� ����.
	LDI  R30,LOW(69)
	STS  116,R30
;}
_0x20C0009:
	ADIW R28,2
	RET
;#include "D_i2c_AT24C_EEP/i2c_AT24C_EEP.h"
;
;
;#define HI(X) (X>>8)
;#define LO(X) (X & 0xFF)
;
;uint8_t i2c_eep_WriteByte(uint8_t SAddr,uint16_t Addr, uint8_t Byte, IIC_F WhatDo)
;{
_i2c_eep_WriteByte:
;
;if (i2c_Do & i2c_Busy) return 0;
;	SAddr -> Y+5
;	Addr -> Y+3
;	Byte -> Y+2
;	*WhatDo -> Y+0
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x40)
	BREQ _0x1AC
	LDI  R30,LOW(0)
	RJMP _0x20C0008
;
;i2c_index = 0;
_0x1AC:
	LDI  R30,LOW(0)
	STS  _i2c_index,R30
;i2c_ByteCount = 3;
	LDI  R30,LOW(3)
	STS  _i2c_ByteCount,R30
;
;i2c_SlaveAddress = SAddr;
	LDD  R30,Y+5
	STS  _i2c_SlaveAddress,R30
;
;
;i2c_Buffer[0] = HI(Addr);
	LDD  R30,Y+4
	STS  _i2c_Buffer,R30
;i2c_Buffer[1] = LO(Addr);
	LDD  R30,Y+3
	__PUTB1MN _i2c_Buffer,1
;i2c_Buffer[2] = Byte;
	LDD  R30,Y+2
	__PUTB1MN _i2c_Buffer,2
;
;i2c_Do = i2c_sawp;
	LDI  R30,LOW(4)
	STS  _i2c_Do,R30
;
;MasterOutFunc = WhatDo;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _MasterOutFunc,R30
	STS  _MasterOutFunc+1,R31
;ErrorOutFunc = WhatDo;
	CALL SUBOPT_0x2F
;
;TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;
;
;i2c_Do |= i2c_Busy;
;
;return 1;
	LDI  R30,LOW(1)
_0x20C0008:
	ADIW R28,6
	RET
;}
;
;
;uint8_t i2c_eep_ReadByte(uint8_t SAddr, uint16_t Addr, uint8_t ByteNumber, IIC_F WhatDo)
;{
;if (i2c_Do & i2c_Busy) return 0;
;	SAddr -> Y+5
;	Addr -> Y+3
;	ByteNumber -> Y+2
;	*WhatDo -> Y+0
;
;i2c_index = 0;
;i2c_ByteCount = ByteNumber;
;
;i2c_SlaveAddress = SAddr;
;
;i2c_PageAddress[0] = HI(Addr);
;i2c_PageAddress[1] = LO(Addr);
;
;i2c_PageAddrIndex = 0;
;i2c_PageAddrCount = 2;
;
;i2c_Do = i2c_sawsarp;
;
;MasterOutFunc = WhatDo;
;ErrorOutFunc = WhatDo;
;
;TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;
;
;i2c_Do |= i2c_Busy;
;
;return 1;
;}
;#include <adapter.h>
;
;//initialize watchdog
;void WDT_Init(void)
;{
;#asm("cli")//disable interrupts
;#asm("wdr")//reset watchdog
;//set up WDT interrupt
;WDTCR = (1<<WDCE)|(1<<WDE);
;//Start watchdog timer with 2s prescaller
;WDTCR = (1<<WDP2)|(1<<WDP1)|(1<<WDP0);
;#asm("sei")//Enable global interrupts
;}
;/*
;//Watchdog timeout ISR
;ISR(WDT_vect)
;{
;    //Burst of fice 0.1Hz pulses
;    for (uint8_t i=0;i<4;i++)
;    {
;        //LED ON
;        PORTD|=(1<<PD2);
;        //~0.1s delay
;        _delay_ms(20);
;        //LED OFF
;        PORTD&=~(1<<PD2);
;        _delay_ms(80);
;    }
; */
;#include <adapter.h>
;
;#include "D_usart/usart.h"
;//#include "D_usart/usart.c"
;
;#include "global_variables.h"
;
;interrupt [ADC_INT] void adc_isr(void)// ADC interrupt service routine
;{
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; adc_result=ADCW*3-ADCW/7; //�������� ����� �������� �� � ������� ��������� �����������
	IN   R30,0x4
	IN   R31,0x4+1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R22,R30
	IN   R30,0x4
	IN   R31,0x4+1
	MOVW R26,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __DIVW21U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STS  _adc_result,R26
	STS  _adc_result+1,R27
;  ADCSRA=0;  //����
	LDI  R30,LOW(0)
	OUT  0x6,R30
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;
;
;/*   //������ ������������� ���������� ����!
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
;{
;SYS_TICK++;
;   //  if (USART_Get_rxCount(USART_0) > 0) //���� � ������� ������ ���-�� ����
;   //    {
;   //     symbol = USART_GetChar(USART_0);
;   //     --Parser_req_state_cnt; //  ��������� �������� ������ �������
;
;            #warning not_optimized
;   //      if(Parser_req_state_cnt % 5 != 0) //������ ������ �������� ����..
;   //      {
;   //        _set(fl.Parser_Req);  //- �������� ������ � ������� �����,..
;   //      }
;   //      else //..�� 1 ��� � 5 ���������� �� �������������� ����� �����..
;   //      {
;   //         PARS_Parser(symbol);//..���� ����� ������� ���� �����
;   //      }
;   //    }
;}
;     */
;#include <adapter.h>
;
;#include "RTOS/EERTOS.h"
;#include "RTOS/EERTOSHAL.h"
; #include "D_Tasks/task_list.h"
;/*
;���������� ���������� �������.(������)
;��� ������� ���������� �������� ����� ���������
;������������������, �� ��� ������� ������ ���� ��
;������ �����.�������� ��� ������� ������ �� �����
;*/
;
;
;
;/*
;void red_blink(void){
;char t=4;
;    do{
;    LED_RED_ON;
;    delay_ms(100);
;    LED_RED_OFF;
;    delay_ms(200);
;    }while(--t);
;}  */
;
;
;uint8_t check_after_pow_on(void)     /*need optimisation*/
;{
;//uint8_t state = 0;
;
;/*#1 check periferie*/
;//if (PINA!=0){printf("P_A=%d\r",PINA);}
;//if (PINB!=0){printf("P_B=%d\r",PINB);}
;//if (PINC!=0){printf("P_C=%d\r",PINC);}
;//if (PIND!=0){printf("P_D=%d\r\n",PIND);}
;
;
;/*#2 check reset source*/
;/*The MCU Control and Status Register provides
;information on which reset source caused an MCU Reset*/
;if (MCUCSR & (1<<PORF))// Power-on Reset
;   {
;    printf("porf\r\n");
;   }
;else if (MCUCSR & (1<<EXTRF))// External Reset
;   {
;    printf("extrf\r\n");
;   }
;else if (MCUCSR & (1<<BORF))// Brown-Out Reset
;   {
;    printf("borf\r\n");
;   }
;else if (MCUCSR & (1<<WDRF))// Watchdog Reset
;   {
;    printf("wdrf\r\n");
;   }
;else if (MCUCSR & (1<<JTRF))// JTAG Reset
;   {
;    printf("JTRF\r\n");
;   }
;
;MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));//clear register
;return 0;
;}
;
;
;void TIM2_ON(void){
;//TCCR2 |= (1<<CS21)|(1<<CS20);
;TCCR2 |= (1<<CS22)|(1<<CS21)|(1<<CS20);
;
;}
;
;void TIM2_OFF(void){
;//TCCR2 &= ~((1<<CS21)|(1<<CS20));
;TCCR2 &= ~((1<<CS22)|(1<<CS21)|(1<<CS20));
;}
;
;void Sys_timer_init(void){ //USED BY RTOS (DONT TOUCH!)
;//Settings for Timer2
;OCR2 = 125; //125000 /125 = 1000 compare interruptes per second
;TCCR2 |= (1<<CS21)|(1<<CS20);//START timer (8Mhz div 64 = 125000)   //Upd-5 ������ 16���
;TIMSK |= (1<<OCIE2); //compare interrupt EN
;}
;
;
;void print_help(void){
_print_help:
;StopRTOS();
	CALL _StopRTOS
;USART_SendStrFl(SYSTEM_USART, help_mess_0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_help_mess_0*2)
	LDI  R31,HIGH(_help_mess_0*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART, help_mess_1);
	LDI  R30,LOW(_help_mess_1*2)
	LDI  R31,HIGH(_help_mess_1*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART, help_mess_2);
	LDI  R30,LOW(_help_mess_2*2)
	LDI  R31,HIGH(_help_mess_2*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART, help_mess_3);
	LDI  R30,LOW(_help_mess_3*2)
	LDI  R31,HIGH(_help_mess_3*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART, help_mess_4);
	LDI  R30,LOW(_help_mess_4*2)
	LDI  R31,HIGH(_help_mess_4*2)
	CALL SUBOPT_0x30
;
;USART_SendStrFl(SYSTEM_USART,help_Uart_0);
	LDI  R30,LOW(_help_Uart_0*2)
	LDI  R31,HIGH(_help_Uart_0*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART,help_Uart_1);
	LDI  R30,LOW(_help_Uart_1*2)
	LDI  R31,HIGH(_help_Uart_1*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART,help_Spi_0);
	LDI  R30,LOW(_help_Spi_0*2)
	LDI  R31,HIGH(_help_Spi_0*2)
	CALL SUBOPT_0x30
;USART_SendStrFl(SYSTEM_USART,help_Spi_1);
	LDI  R30,LOW(_help_Spi_1*2)
	LDI  R31,HIGH(_help_Spi_1*2)
	CALL SUBOPT_0x31
;RunRTOS();
;}
	RET
;
;void print_settings_ram(void){
_print_settings_ram:
;uint8_t i = 0;
;char str[10];
;
;USART_SendStr(USART_0,"\r<RAM>");
	SBIW R28,10
	ST   -Y,R17
;	i -> R17
;	str -> Y+1
	LDI  R17,0
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,0
	CALL SUBOPT_0x32
;USART_SendStr(USART_0,"\rUART_SETTINGS\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,7
	CALL SUBOPT_0x32
;  for(i=0;i<COUNT_OF_UARTS;i++)
	LDI  R17,LOW(0)
_0x1B9:
	CPI  R17,2
	BRSH _0x1BA
;    {
;    USART_SendStr(USART_0,"UART ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,23
	CALL SUBOPT_0x32
;    ltoa(i,str);
	CALL SUBOPT_0x33
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Mode ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,29
	CALL SUBOPT_0x32
;    ltoa(RAM_settings.MODE_of_Uart[i],str);
	__POINTW2MN _RAM_settings,4
	CALL SUBOPT_0x34
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Speed ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,37
	CALL SUBOPT_0x32
;    ltoa(RAM_settings.baud_of_Uart[i],str);
	MOV  R30,R17
	CALL SUBOPT_0x35
	CALL __GETW1P
	CALL SUBOPT_0x36
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r--------\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,46
	CALL SUBOPT_0x32
;    }
	SUBI R17,-1
	RJMP _0x1B9
_0x1BA:
;
;USART_SendStr(USART_0,"\rSPI_SETTINGS\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,57
	CALL SUBOPT_0x32
;  for(i=0;i<COUNT_OF_SPI;i++)
	LDI  R17,LOW(0)
_0x1BC:
	CPI  R17,2
	BRSH _0x1BD
;    {
;    USART_SendStr(USART_0,"SPI ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,72
	CALL SUBOPT_0x32
;    ltoa(i,str);
	CALL SUBOPT_0x33
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Mode ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,77
	CALL SUBOPT_0x32
;    ltoa(RAM_settings.MODE_of_Spi[i],str);
	__POINTW2MN _RAM_settings,6
	CALL SUBOPT_0x34
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Prescaller ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,85
	CALL SUBOPT_0x32
;    ltoa(RAM_settings.prescaller_of_Spi[i],str);
	__POINTW2MN _RAM_settings,10
	CALL SUBOPT_0x34
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r--------\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1B7,99
	CALL SUBOPT_0x32
;    }
	SUBI R17,-1
	RJMP _0x1BC
_0x1BD:
;//USART_FlushTxBuf(USART_0);
;}
	RJMP _0x20C0007

	.DSEG
_0x1B7:
	.BYTE 0x6E
;
;void print_settings_eeprom(void){

	.CSEG
_print_settings_eeprom:
;uint8_t i = 0;
;char str[10];
;
;USART_SendStr(USART_0,"\r<EEPROM>");
	SBIW R28,10
	ST   -Y,R17
;	i -> R17
;	str -> Y+1
	LDI  R17,0
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,0
	CALL SUBOPT_0x32
;USART_SendStr(USART_0,"\rUART_SETTINGS\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,10
	CALL SUBOPT_0x32
;  for(i=0;i<COUNT_OF_UARTS;i++)
	LDI  R17,LOW(0)
_0x1C0:
	CPI  R17,2
	BRSH _0x1C1
;    {
;    USART_SendStr(USART_0,"UART ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,26
	CALL SUBOPT_0x32
;    ltoa(i,str);
	CALL SUBOPT_0x33
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Mode ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,32
	CALL SUBOPT_0x32
;    ltoa(EE_settings.MODE_of_Uart[i],str);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Speed ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,40
	CALL SUBOPT_0x32
;    ltoa(EE_settings.baud_of_Uart[i],str);
	MOV  R30,R17
	LDI  R26,LOW(_EE_settings)
	LDI  R27,HIGH(_EE_settings)
	CALL SUBOPT_0x1B
	CALL __EEPROMRDW
	CALL SUBOPT_0x36
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r--------\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,49
	CALL SUBOPT_0x32
;    }
	SUBI R17,-1
	RJMP _0x1C0
_0x1C1:
;
;USART_SendStr(USART_0,"\rSPI_SETTINGS\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,60
	CALL SUBOPT_0x32
;  for(i=0;i<COUNT_OF_SPI;i++)
	LDI  R17,LOW(0)
_0x1C3:
	CPI  R17,2
	BRSH _0x1C4
;    {
;    USART_SendStr(USART_0,"SPI ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,75
	CALL SUBOPT_0x32
;    ltoa(i,str);
	CALL SUBOPT_0x33
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Mode ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,80
	CALL SUBOPT_0x32
;    ltoa(EE_settings.MODE_of_Spi[i],str);
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r Prescaller ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,88
	CALL SUBOPT_0x32
;    ltoa(EE_settings.prescaller_of_Spi[i],str);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x38
;    USART_SendStr(USART_0,str); //convert dec to str
;
;    USART_SendStr(USART_0,"\r--------\r");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1BE,102
	CALL SUBOPT_0x32
;    }
	SUBI R17,-1
	RJMP _0x1C3
_0x1C4:
;//USART_FlushTxBuf(USART_0);
;}
_0x20C0007:
	LDD  R17,Y+0
	ADIW R28,11
	RET

	.DSEG
_0x1BE:
	.BYTE 0x71
;
;
;void print_sys(void)
;{

	.CSEG
_print_sys:
;char str[5];
;USART_SendStr(USART_0,"\rButes_RX ");
	SBIW R28,5
;	str -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1C5,0
	CALL SUBOPT_0x32
;ltoa(RX_CNT,str);
	LDS  R30,_RX_CNT
	LDS  R31,_RX_CNT+1
	LDS  R22,_RX_CNT+2
	LDS  R23,_RX_CNT+3
	CALL SUBOPT_0x3B
;USART_SendStr(USART_0,str); //convert dec to str
;
;USART_SendStr(USART_0,"\rButes_TX ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _0x1C5,11
	CALL SUBOPT_0x32
;ltoa(TX_CNT,str);
	LDS  R30,_TX_CNT
	LDS  R31,_TX_CNT+1
	LDS  R22,_TX_CNT+2
	LDS  R23,_TX_CNT+3
	CALL SUBOPT_0x3B
;USART_SendStr(USART_0,str); //convert dec to str
;}
_0x20C0006:
	ADIW R28,5
	RET

	.DSEG
_0x1C5:
	.BYTE 0x16
;
;
;
;#warning TODO
;uint8_t get_curr_cpu_freq (void){ //���������� �������� ������� ������� ������ ��

	.CSEG
;uint8_t freq = 0;
;
;return freq;
;	freq -> R17
;}
;
;#warning ��������!
;void cust_delay_ms(uint16_t delay){ //����� ��������
;uint32_t timecnt = SYS_TICK + delay;
;while (SYS_TICK < timecnt){}
;	delay -> Y+4
;	timecnt -> Y+0
;}
;
;
;void LogOut(void)				// ������ �����
;{
_LogOut:
;StopRTOS();
	CALL _StopRTOS
;WorkLog[LogIndex]= 0xFF;
	CALL SUBOPT_0x18
	LDI  R26,LOW(255)
	CALL SUBOPT_0x19
;LogIndex++;
;USART_SendStr(USART_0, WorkLog);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_WorkLog_G000)
	LDI  R31,HIGH(_WorkLog_G000)
	CALL SUBOPT_0x32
;RunRTOS();
	CALL _RunRTOS
;
;SetTimerTask(Task_Flush_WorkLog,10);//������� ��� �������
	LDI  R30,LOW(_Task_Flush_WorkLog)
	LDI  R31,HIGH(_Task_Flush_WorkLog)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3C
;LogIndex = 0;
	LDI  R30,LOW(0)
	STS  _LogIndex_G000,R30
	STS  _LogIndex_G000+1,R30
;}
	RET
;
;/**
;void cust_ltoa(long int n, char *str;)
;{
;unsigned long i;
;unsigned char j,p;
;i=1000000000L;
;p=0;
;if (n<0)
;   {
;   n=-n;
;   *str++='-';
;   };
;do
;  {
;  j=(unsigned char) (n/i);
;  if (j || p || (i==1))
;     {
;     *str++=j+'0';
;     p=1;
;     }
;  n%=i;
;  i/=10L;
;  } while (i!=0);
;   *str = 0;
;}
;*/
;//����������� ���� ����� ��� RTOS
;
;#include "task_list.h"
;//============================================================================
;//������� �����
;//============================================================================
;
;void Task_Start (void)
;{
_Task_Start:
;LED_PORT  |=1<<LED1;
	SBI  0x12,6
;SetTimerTask(Task_LedOff,50); //������ �������-�������������
	CALL SUBOPT_0x3D
	RJMP _0x20C0005
;}
;
;void Task_LedOff (void)
;{
_Task_LedOff:
;SetTimerTask(Task_LedOn,500);
	LDI  R30,LOW(_Task_LedOn)
	LDI  R31,HIGH(_Task_LedOn)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x3C
;LED_PORT  &= ~(1<<LED1);
	CBI  0x12,6
;}
	RET
;
;void Task_LedOn (void)
;{
_Task_LedOn:
;SetTimerTask(Task_LedOff,50);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
;LED_PORT  |= (1<<LED1);
	SBI  0x12,6
;}
	RET
;
;void Task_ADC_test (void) //Upd-6     //��� �������� ����������� ���������
; {
_Task_ADC_test:
;
; SetTimerTask(Task_ADC_test,5000);
	CALL SUBOPT_0x3E
	RJMP _0x20C0005
; }
;void Task_LcdGreetImage (void) //Greeting image on start    //Upd-4
;{
_Task_LcdGreetImage:
;SetTask(LcdClear);
	LDI  R30,LOW(_LcdClear)
	LDI  R31,HIGH(_LcdClear)
	CALL SUBOPT_0x1D
; LcdImage(rad1Image);
	LDI  R30,LOW(_rad1Image*2)
	LDI  R31,HIGH(_rad1Image*2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _LcdImage
;SetTask(LcdUpdate);
	LDI  R30,LOW(_LcdUpdate)
	LDI  R31,HIGH(_LcdUpdate)
	CALL SUBOPT_0x1D
;SetTimerTask(LcdClear,2000);
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3C
;SetTimerTask(Task_LcdLines,3000);
	LDI  R30,LOW(_Task_LcdLines)
	LDI  R31,HIGH(_Task_LcdLines)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP _0x20C0005
;}
;
;void Task_LcdLines (void)      //Upd-4       //������ ������!
;{
_Task_LcdLines:
;    	for (i=0; i<84; i++){
	CLR  R10
_0x1CA:
	LDI  R30,LOW(84)
	CP   R10,R30
	BRSH _0x1CB
;		LcdLine ( 0, 47, i, 0, 1);
	CALL SUBOPT_0x40
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R10
	CALL SUBOPT_0xD
	CALL SUBOPT_0x40
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _LcdLine
;        LcdLine ( 84, 47, 84-i, 0, 1);
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(84)
	SUB  R30,R10
	CALL SUBOPT_0xD
	CALL SUBOPT_0x40
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _LcdLine
;		LcdUpdate();
	CALL _LcdUpdate
;		}
	INC  R10
	RJMP _0x1CA
_0x1CB:
;SetTimerTask(LcdClear,2000);
	CALL SUBOPT_0x3F
	RJMP _0x20C0005
;}
;
;void Task_AdcOnLcd (void)
;{
_Task_AdcOnLcd:
; sprintf (lcd_buf, "vref=%d ",vref);      // ����� �� ����� ����������
	CALL SUBOPT_0x41
	__POINTW1FN _0x0,159
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_vref
	LDS  R31,_vref+1
	CALL SUBOPT_0x42
; LcdString(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x43
;  sprintf (lcd_buf, "d=%d ",d);      // ����� �� ����� ����������
	__POINTW1FN _0x0,168
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_d
	LDS  R31,_d+1
	CALL SUBOPT_0x42
; LcdString(1,2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x43
;  sprintf (lcd_buf, "delta=%d ",delta);      // ����� �� ����� ����������
	__POINTW1FN _0x0,174
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_delta
	LDS  R31,_delta+1
	CALL SUBOPT_0x42
; LcdString(1,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x43
;  sprintf (lcd_buf, "volt=%d ",volt);      // ����� �� ����� ����������
	__POINTW1FN _0x0,184
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_volt
	LDS  R31,_volt+1
	CALL SUBOPT_0x42
; LcdString(1,4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _LcdString
; LcdUpdate();
	CALL _LcdUpdate
;}
	RET
;
;void Task_pars_cmd (void)
;{
_Task_pars_cmd:
;  if (USART_Get_rxCount(SYSTEM_USART) > 0) //���� � ������� ������ ���-�� ����
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _USART_Get_rxCount
	CPI  R30,LOW(0x1)
	BRLO _0x1CC
;       {
;        symbol = USART_GetChar(SYSTEM_USART);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _USART_GetChar
	STS  _symbol,R30
;        PARS_Parser(symbol);
	LDS  R30,_symbol
	ST   -Y,R30
	CALL _PARS_Parser
;       }
;SetTimerTask(Task_pars_cmd, 25);
_0x1CC:
	CALL SUBOPT_0x44
_0x20C0005:
	ST   -Y,R31
	ST   -Y,R30
	CALL _SetTimerTask
;}
	RET
;
;
;void Task_LogOut (void)
;{
_Task_LogOut:
;SetTimerTask(Task_LogOut,50);
	CALL SUBOPT_0x45
;if(LogIndex){LogOut();} //���� ���-�� ���� � ��� ������ - �������
	LDS  R30,_LogIndex_G000
	LDS  R31,_LogIndex_G000+1
	SBIW R30,0
	BREQ _0x1CD
	RCALL _LogOut
;}
_0x1CD:
	RET
;
;
;void Task_Flush_WorkLog(void){ //������� ��� �������
_Task_Flush_WorkLog:
;uint16_t i = 0;
;while(i<512){WorkLog[i] = 0; i++;}
	CALL SUBOPT_0x2
;	i -> R16,R17
_0x1CE:
	__CPWRN 16,17,512
	BRSH _0x1D0
	LDI  R26,LOW(_WorkLog_G000)
	LDI  R27,HIGH(_WorkLog_G000)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x1CE
_0x1D0:
;PORTD.7^=1;
	LDI  R26,0
	SBIC 0x12,7
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x1D1
	CBI  0x12,7
	RJMP _0x1D2
_0x1D1:
	SBI  0x12,7
_0x1D2:
;}
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;/*
;void Task_Uart_ByfSend(void){ //������� ��� �������
;
;}*/
;
;void Task_SPI_ClrBuf (void){ //������� rx/tx �������� SPI
_Task_SPI_ClrBuf:
;uint8_t i;
;for(i=0;i<64;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x1D4:
	CPI  R17,64
	BRSH _0x1D5
; {
;Spi0_RX_buf[i] = 0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Spi0_RX_buf_G000)
	SBCI R31,HIGH(-_Spi0_RX_buf_G000)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;Spi0_TX_buf[i] = 0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Spi0_TX_buf_G000)
	SBCI R31,HIGH(-_Spi0_TX_buf_G000)
	STD  Z+0,R26
;  //if(i<=SIZE_SPI_BUF_TX){Spi0_TX_buf[i] = 0;}
; }
	SUBI R17,-1
	RJMP _0x1D4
_0x1D5:
;}
	LD   R17,Y+
	RET
;
;//=================================================
;//////////////////////////I2C//////////////////////
;
;//============================================================================
;//������� �����
;//============================================================================
;
;// ���������� � ������ ����.
;void StartWrite2EPP(void)
;{
_StartWrite2EPP:
;if (!i2c_eep_WriteByte(0xA0,0x00FF,/*(char)Usart0_RX_buf[15]*/ 9,&Writed2EEP))    // ���� ���� �����������
	LDI  R30,LOW(160)
	ST   -Y,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(_Writed2EEP)
	LDI  R31,HIGH(_Writed2EEP)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _i2c_eep_WriteByte
	CPI  R30,0
	BRNE _0x1D6
;    {
;    SetTimerTask(StartWrite2EPP,50);                        // ��������� ������� ����� 50��
	LDI  R30,LOW(_StartWrite2EPP)
	LDI  R31,HIGH(_StartWrite2EPP)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x3C
;    }
;}
_0x1D6:
	RET
;
;// ����� ������ �� �������� �� ������ � ������
;void Writed2EEP(void)
;{
_Writed2EEP:
;i2c_Do &= i2c_Free;                                            // ����������� ����
	CALL SUBOPT_0x46
;
;if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))                        // ���� ������ �� �������
	BREQ _0x1D7
;    {
;    SetTimerTask(StartWrite2EPP,20);                        // ��������� �������
	LDI  R30,LOW(_StartWrite2EPP)
	LDI  R31,HIGH(_StartWrite2EPP)
	CALL SUBOPT_0x47
;    }
;else
	RJMP _0x1D8
_0x1D7:
;    {
;    SetTask(SendAddrToSlave);        						// ���� ��� ��, �� ���� �� ���������
	LDI  R30,LOW(_SendAddrToSlave)
	LDI  R31,HIGH(_SendAddrToSlave)
	CALL SUBOPT_0x1D
;	}														// ����� ������� - �������� ������ ������ 2
_0x1D8:
;}
	RET
;
;// ��������� � SLAVE �����������
;void SendAddrToSlave(void)
;{
_SendAddrToSlave:
;if (i2c_Do & i2c_Busy)						// ���� ���������� �����
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x40)
	BREQ _0x1D9
;		{
;		SetTimerTask(SendAddrToSlave,100);	// �� ��������� ����� 100��
	LDI  R30,LOW(_SendAddrToSlave)
	LDI  R31,HIGH(_SendAddrToSlave)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x3C
;		}
;
;i2c_index = 0;								// ����� �������
_0x1D9:
	LDI  R30,LOW(0)
	STS  _i2c_index,R30
;i2c_ByteCount = 2;							// ���� ��� �����
	LDI  R30,LOW(2)
	STS  _i2c_ByteCount,R30
;
;i2c_SlaveAddress = 0xB0;					// ����� ����������� 0xB0
	LDI  R30,LOW(176)
	STS  _i2c_SlaveAddress,R30
;
;i2c_Buffer[0] = 0x00;						// �� ����� ��� �����, ��� �� ���� ������������
	LDI  R30,LOW(0)
	STS  _i2c_Buffer,R30
;i2c_Buffer[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _i2c_Buffer,1
;
;i2c_Do = i2c_sawp;							// ����� = ������� ������, �����+��� ����� ������
	LDI  R30,LOW(4)
	STS  _i2c_Do,R30
;
;MasterOutFunc = &SendedAddrToSlave;			// ����� ������ �� �������� ���� ��� ������
	LDI  R30,LOW(_SendedAddrToSlave)
	LDI  R31,HIGH(_SendedAddrToSlave)
	STS  _MasterOutFunc,R30
	STS  _MasterOutFunc+1,R31
;ErrorOutFunc = &SendedAddrToSlave;			// � ���� ��� �����.
	LDI  R30,LOW(_SendedAddrToSlave)
	LDI  R31,HIGH(_SendedAddrToSlave)
	CALL SUBOPT_0x2F
;
;TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// �������!
;i2c_Do |= i2c_Busy;												// ���� ������!
;}
	RET
;
;
;// ����� �� �������� IIC
;void SendedAddrToSlave(void)
;{
_SendedAddrToSlave:
;i2c_Do &= i2c_Free;							// ����������� ����
	CALL SUBOPT_0x46
;
;if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))		// ���� ������� ��� �� ������� ��� ��� ���� �� �����
	BREQ _0x1DA
;	{
;	SetTimerTask(SendAddrToSlave,20);		// ��������� �������
	LDI  R30,LOW(_SendAddrToSlave)
	LDI  R31,HIGH(_SendAddrToSlave)
	CALL SUBOPT_0x47
;	}
;}
_0x1DA:
	RET
;
;
;// ���� ������� ���� ����� � ������� ������
;void SlaveControl(void)
;{
_SlaveControl:
;i2c_Do &= i2c_Free;				// ����������� ����
	LDS  R30,_i2c_Do
	ANDI R30,0xBF
	STS  _i2c_Do,R30
;UDR0 = i2c_InBuff[0];			// ��������� �������� ����
	LDS  R30,_i2c_InBuff
	OUT  0xC,R30
;}
	RET
;
;//==============================================================================
;#include "init.c"
;#include <adapter.h>
;
;inline void GPIO_init(void){
; 0000 0010 inline void GPIO_init(void){
_GPIO_init:
;PORTA=0x00; DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	OUT  0x1A,R30
;PORTB=0x00; DDRB=0x07;
	OUT  0x18,R30
	LDI  R30,LOW(7)
	OUT  0x17,R30
;PORTC=0x00; DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
	OUT  0x14,R30
;PORTD=0x00; DDRD=0x00;
	OUT  0x12,R30
	OUT  0x11,R30
;PORTE=0x00; DDRE=0x00;
	OUT  0x3,R30
	OUT  0x2,R30
;PORTF=0x00; DDRF=0x00;
	CALL SUBOPT_0x1E
;PORTG=0x00; DDRG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
	STS  100,R30
;}
	RET
;
;
;inline void TIM_0_init(void){// Timer/Counter 0 initialization
_TIM_0_init:
;// Clock source: System Clock
;// Clock value: Timer 0 Stopped
;// Mode: Normal top=0xFF
;// OC0 output: Disconnected
;ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;TCCR0=0x00;
	OUT  0x33,R30
;TCNT0=0x00;
	OUT  0x32,R30
;OCR0=0x00;
	OUT  0x31,R30
;}
	RET
;
;inline void TIM_1_init(void){// Timer/Counter 1 initialization
_TIM_1_init:
;TCCR1A=0x00;    TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	OUT  0x2E,R30
;TCNT1H=0x00;    TCNT1L=0x00;
	OUT  0x2D,R30
	OUT  0x2C,R30
;ICR1H=0x00;     ICR1L=0x00;
	OUT  0x27,R30
	OUT  0x26,R30
;OCR1AH=0x00;    OCR1AL=0x00;
	OUT  0x2B,R30
	OUT  0x2A,R30
;OCR1BH=0x00;    OCR1BL=0x00;
	OUT  0x29,R30
	OUT  0x28,R30
;OCR1CH=0x00;    OCR1CL=0x00;
	STS  121,R30
	STS  120,R30
;}
	RET
;
;inline void TIM_2_init(void){// Timer/Counter 2 initialization
_TIM_2_init:
;TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
;TCNT2=0x00;
	OUT  0x24,R30
;OCR2=0x00;
	OUT  0x23,R30
;}
	RET
;
;inline void TIM_3_init(void){ // Timer/Counter 3 initialization
_TIM_3_init:
;TCCR3A=0x00;    TCCR3B=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
	STS  138,R30
;TCNT3H=0x00;    TCNT3L=0x00;
	STS  137,R30
	STS  136,R30
;ICR3H=0x00;     ICR3L=0x00;
	STS  129,R30
	STS  128,R30
;OCR3AH=0x00;    OCR3AL=0x00;
	STS  135,R30
	STS  134,R30
;OCR3BH=0x00;    OCR3BL=0x00;
	STS  133,R30
	STS  132,R30
;OCR3CH=0x00;    OCR3CL=0x00;
	STS  131,R30
	STS  130,R30
;}
	RET
;
;inline void INT_init(void){// External Interrupt(s) initialization
_INT_init:
;// INTx: Off
;EICRA=0x00;
	LDI  R30,LOW(0)
	STS  106,R30
;EICRB=0x00;
	OUT  0x3A,R30
;EIMSK=0x00;
	OUT  0x39,R30
;
;// Timer(s)/Counter(s) Interrupt(s) initialization
;TIMSK=0x00;
	OUT  0x37,R30
;ETIMSK=0x00;
	STS  125,R30
;}
	RET
;
;
;inline void USART_0_init(void){// USART0 initialization
_USART_0_init:
;// Communication Parameters: 8 Data, 1 Stop, No Parity
;// USART0 Receiver: On
;// USART0 Transmitter: On
;// USART0 Mode: Asynchronous
;// USART0 Baud Rate: 9600
;UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
;}
	RET
;
;inline void USART_1_init(void){// USART1 initialization
_USART_1_init:
;// Communication Parameters: 8 Data, 1 Stop, No Parity
;// USART1 Receiver: On
;// USART1 Transmitter: On
;// USART1 Mode: Asynchronous
;// USART1 Baud Rate: 115200 (Double Speed Mode)
;UCSR1A=0x02;
	LDI  R30,LOW(2)
	STS  155,R30
;UCSR1B=0xD8;
	LDI  R30,LOW(216)
	STS  154,R30
;UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;UBRR1L=0x08;
	LDI  R30,LOW(8)
	STS  153,R30
;}
	RET
;
;/*
;void SPI_init(void){// SPI initialization
;// SPI Type: Master
;// SPI Clock Rate: 2000,000 kHz
;// SPI Clock Phase: Cycle Start
;// SPI Clock Polarity: Low
;// SPI Data Order: MSB First
;SPCR=0xD0;
;SPSR=0x00;
;// Clear the SPI interrupt flag
;#asm
;    in   r30,spsr
;    in   r30,spdr
;#endasm
;}*/
;
;inline void TWI_init(void){// TWI initialization
;// Bit Rate: 400,000 kHz
;TWBR=0x02;
;// Two Wire Bus Slave Address: 0x0
;// General Call Recognition: Off
;TWAR=0x00;
;// Generate Acknowledge Pulse: Off
;// TWI Interrupt: On
;TWCR=0x05;
;TWSR=0x00;
;}
;
;void settings_EE_cpy_R(void){ // settings transfer from eeprom to ram
_settings_EE_cpy_R:
;uint8_t i = 0;
;  for(i=0;i<COUNT_OF_UARTS;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x1DC:
	CPI  R17,2
	BRSH _0x1DD
;    {
;        RAM_settings.MODE_of_Uart[i] = EE_settings.MODE_of_Uart[i];
	__POINTW2MN _RAM_settings,4
	MOV  R30,R17
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x37
	MOVW R26,R0
	ST   X,R30
;        RAM_settings.baud_of_Uart[i] = EE_settings.baud_of_Uart[i];
	MOV  R30,R17
	CALL SUBOPT_0x48
	MOVW R0,R30
	MOV  R30,R17
	LDI  R26,LOW(_EE_settings)
	LDI  R27,HIGH(_EE_settings)
	CALL SUBOPT_0x1B
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;    }
	SUBI R17,-1
	RJMP _0x1DC
_0x1DD:
;  for(i=0;i<COUNT_OF_SPI;i++)
	LDI  R17,LOW(0)
_0x1DF:
	CPI  R17,2
	BRSH _0x1E0
;    {
;        RAM_settings.MODE_of_Spi[i] = EE_settings.MODE_of_Spi[i];
	__POINTW2MN _RAM_settings,6
	MOV  R30,R17
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x39
	MOVW R26,R0
	ST   X,R30
;        RAM_settings.prescaller_of_Spi[i] =  EE_settings.prescaller_of_Spi[i];
	__POINTW2MN _RAM_settings,10
	MOV  R30,R17
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x3A
	MOVW R26,R0
	ST   X,R30
;    }
	SUBI R17,-1
	RJMP _0x1DF
_0x1E0:
;}
	JMP  _0x20C0002
;
;inline void First_EE_init(void){ // settings transfer from eeprom to ram
;uint8_t i = 0;
;  for(i=0;i<COUNT_OF_UARTS;i++)
;	i -> R17
;    {
;EE_settings.baud_of_Uart[i] = 576; //57600baud
;EE_settings.MODE_of_Uart[i] = USART_NORMAL;
;    }
;  for(i=0;i<COUNT_OF_SPI;i++)
;    {
;EE_settings.MODE_of_Spi[i] = 0;
;EE_settings.prescaller_of_Spi[i] = 16;
;    }
;}
;
;
;void HARDWARE_init(void)
;{
_HARDWARE_init:
; GPIO_init();
	RCALL _GPIO_init
; ADC_init(); //Upd-6
	RCALL _ADC_init
; adc_calibrate(); //Upd-7
	RCALL _adc_calibrate
; TIM_0_init();
	RCALL _TIM_0_init
; TIM_1_init();
	RCALL _TIM_1_init
; TIM_2_init();
	RCALL _TIM_2_init
; TIM_3_init();
	RCALL _TIM_3_init
; INT_init();
	RCALL _INT_init
; USART_0_init();
	RCALL _USART_0_init
; USART_1_init();
	RCALL _USART_1_init
; Hard_SPI_Master_Init_default();
	CALL _Hard_SPI_Master_Init_default
;//TWI_init();
; rtc_init();
	RCALL _rtc_init_G000
;
;//i2c_init(); // I2C Bus initialization
;//w1_init(); // 1 Wire Bus initialization
;// 1 Wire Data port: PORTA
;// 1 Wire Data bit: 2
;// Note: 1 Wire port settings must be specified in the
;// Project|Configure|C Compiler|Libraries|1 Wire IDE menu.
;}
	RET
;
;void SOFTWARE_init (void){
_SOFTWARE_init:
;#ifdef EEPROM_REINIT  //Upd-5
;First_EE_init();  //��������� ������������� ������ (����������� 1 ��� ��� ����������)
;#endif
;settings_EE_cpy_R(); //�������� �������� �� ������
	RCALL _settings_EE_cpy_R
;
;// check_after_pow_on();
;// flags_init();
;
;//WDT_Init();//Watchdog
;
;USART_Init(USART_0, RAM_settings.MODE_of_Uart[USART_0], RAM_settings.baud_of_Uart[USART_0]);
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETB1MN _RAM_settings,4
	ST   -Y,R30
	LDS  R30,_RAM_settings
	LDS  R31,_RAM_settings+1
	CALL SUBOPT_0x49
;USART_Init(USART_1, RAM_settings.MODE_of_Uart[USART_1], RAM_settings.baud_of_Uart[USART_1]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB1MN _RAM_settings,5
	ST   -Y,R30
	__GETW1MN _RAM_settings,2
	CALL SUBOPT_0x49
;
;//Soft_SPI_Master_Init();
;//Hard_SPI_Master_Init_default();
;#warning ������� �� ������!
;SPI_init(SPI_0, SPI_MASTER, 1, 0, 16);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _SPI_init
;LcdInit();//Upd-3 //soft spi on portA
	CALL _LcdInit
;
;//cust_I2C_init(I2C_0);
;
;PARSER_Init();
	CALL _PARSER_Init
;InitRTOS();			// �������������� ����
	CALL _InitRTOS
;
;//======
;Init_i2c();						// ��������� � ������������� i2c
	RCALL _Init_i2c
;Init_Slave_i2c(&SlaveControl);	// ����������� ������� ������ ��� �������� ��� Slave
	LDI  R30,LOW(_SlaveControl)
	LDI  R31,HIGH(_SlaveControl)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Init_Slave_i2c
;//======
;
;// Clear the SPI interrupt flag   //Upd-4
;#asm
    in   r30,spsr
    in   r30,spdr
;
;#ifdef DEBUG
;LogIndex=0;					// ��� � ������
	LDI  R30,LOW(0)
	STS  _LogIndex_G000,R30
	STS  _LogIndex_G000+1,R30
;WorkLog[LogIndex]=1;		// ���������� ����� ������
	CALL SUBOPT_0x18
	LDI  R26,LOW(1)
	CALL SUBOPT_0x19
;LogIndex++;
;#endif
;}
	RET
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;#include "D_Globals/global_variables.h"
;#include "D_Globals/global_defines.h"
;#include "PARSER/pars_hndl.c"           //Upd-8 in folder
;//���������� ������ ������
;
;#include <adapter.h>
;
;//#include "RTOS/HAL.h"
;//#include "RTOS/EERTOS.c"
;#include "RTOS/EERTOSHAL.h"
;
;void PARS_Handler(uint8_t argc, char *argv[])
; 0000 0013 {
_PARS_Handler:
;char __flash *response = error;
; // uint8_t value = 0;
; // uint8_t mode = 0;
;  uint8_t i = 0;
;
; uint8_t Interface_Num = 0;
; uint32_t tmp = 0;
; bool Tmp_param_1 = 0;
; bool Tmp_param_2 = 0;
;
;char str [6];
;
;#ifdef DEBUG
;//StopRTOS();
;#endif
;/////////////////////SET_COMAND////////////////////////////////
;/////////////////////////////////////////////////////////////////
;if (!strcmpf(argv[0], Set))
	SBIW R28,10
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+7,R30
	STD  Y+8,R30
	STD  Y+9,R30
	CALL __SAVELOCR6
;	argc -> Y+18
;	argv -> Y+16
;	*response -> R16,R17
;	i -> R19
;	Interface_Num -> R18
;	tmp -> Y+12
;	Tmp_param_1 -> R21
;	Tmp_param_2 -> R20
;	str -> Y+6
	__POINTWRFN 16,17,_error,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_Set*2)
	LDI  R31,HIGH(_Set*2)
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x1E7
; {
;#ifdef DEBUG
; Put_In_Log("\r Set");
	__POINTW1MN _0x1E8,0
	CALL SUBOPT_0x4C
;#endif
;   if (argc > 1)
	CPI  R26,LOW(0x2)
	BRSH PC+3
	JMP _0x1E9
;  {
;//////////////////////////////////////////////////////////////////
;/////////////////////UART_SET_START///////////////////////////////
;      if (!strcmpf(argv[1], Uart))
	CALL SUBOPT_0x4D
	LDI  R30,LOW(_Uart*2)
	LDI  R31,HIGH(_Uart*2)
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x1EA
;     {
;#ifdef DEBUG
;   Put_In_Log("\r Uart");
	__POINTW1MN _0x1E8,6
	CALL SUBOPT_0x4C
;#endif
;
;       if (argc > 2)
	CPI  R26,LOW(0x3)
	BRSH PC+3
	JMP _0x1EB
;        {
;          tmp = PARS_StrToUint(argv[2]);//Get number of interface
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
;          if (tmp <= COUNT_OF_UARTS){Interface_Num = tmp; response = ok;
	CALL SUBOPT_0x50
	BRSH _0x1EC
	LDD  R18,Y+12
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;#ifdef DEBUG
;  Put_In_Log("\r Num");
	__POINTW1MN _0x1E8,13
	CALL SUBOPT_0x51
;#endif
;          }
;          else{response = largeValue; goto exit;}
	RJMP _0x1ED
_0x1EC:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	RJMP _0x240
_0x1ED:
;
;         if (argc > 3)    //Mode
	LDD  R26,Y+18
	CPI  R26,LOW(0x4)
	BRSH PC+3
	JMP _0x1EF
;        {
;             if (!strcmpf(argv[3], Mode))
	CALL SUBOPT_0x52
	BRNE _0x1F0
;             {
;               tmp = PARS_StrToUchar(argv[4]); //Get uart mode
	CALL SUBOPT_0x53
;              if (tmp==1 || tmp==0){RAM_settings.MODE_of_Uart[Interface_Num] = tmp; response = ok;
	BREQ _0x1F2
	CALL SUBOPT_0x54
	CALL __CPD02
	BRNE _0x1F1
_0x1F2:
	__POINTW2MN _RAM_settings,4
	MOV  R30,R18
	CALL SUBOPT_0x5
	LDD  R26,Y+12
	STD  Z+0,R26
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;#ifdef DEBUG
;  Put_In_Log("\r Mode");
	__POINTW1MN _0x1E8,19
	CALL SUBOPT_0x51
;#endif
;               i = 2; //go to next param "speed"
	LDI  R19,LOW(2)
;               }
;              else{response = largeValue;
	RJMP _0x1F4
_0x1F1:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	MOVW R16,R30
;#ifdef DEBUG
; //USART_SendStr(SYSTEM_USART,"\rM EXIT");
; Put_In_Log("\rM EXIT");
	__POINTW1MN _0x1E8,26
	CALL SUBOPT_0x51
;#endif
;            goto exit;}
	RJMP _0x1EE
_0x1F4:
;             }
;
;             if (!strcmpf(argv[3+i], Speed)) //may be 3 or 5th param
_0x1F0:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LDI  R30,LOW(_Speed*2)
	LDI  R31,HIGH(_Speed*2)
	CALL SUBOPT_0x4B
	BRNE _0x1F5
;             {
;              tmp = PARS_StrToUint(argv[4+i]); //get Baud Rate
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	CALL SUBOPT_0x4F
;              if (tmp <= MAX_BAUD_RATE)
	__CPD2N 0x481
	BRSH _0x1F6
;              {
;              RAM_settings.baud_of_Uart[Interface_Num] = tmp;
	MOV  R30,R18
	CALL SUBOPT_0x48
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	STD  Z+0,R26
	STD  Z+1,R27
;              response = ok; i = 0;
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
	LDI  R19,LOW(0)
;#ifdef DEBUG
;  Put_In_Log("\r ");
	__POINTW1MN _0x1E8,34
	CALL SUBOPT_0x51
;  Put_In_LogFl(Speed);
	LDI  R30,LOW(_Speed*2)
	LDI  R31,HIGH(_Speed*2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Put_In_LogFl
;#endif
;              }
;              else{response = largeValue;
	RJMP _0x1F7
_0x1F6:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	MOVW R16,R30
;#ifdef DEBUG
; Put_In_Log("\rM EXIT");
	__POINTW1MN _0x1E8,37
	CALL SUBOPT_0x51
;#endif
;             goto exit;}
	RJMP _0x1EE
_0x1F7:
;        }
;
;     USART_Init(Interface_Num, RAM_settings.MODE_of_Uart[Interface_Num], RAM_settings.baud_of_Uart[Interface_Num]);
_0x1F5:
	ST   -Y,R18
	CALL SUBOPT_0x58
	ST   -Y,R30
	MOV  R30,R18
	CALL SUBOPT_0x35
	CALL __GETW1P
	CALL SUBOPT_0x49
;     Interface_Num = 0;
	LDI  R18,LOW(0)
;
;     EE_settings.MODE_of_Uart[Interface_Num] = RAM_settings.MODE_of_Uart[Interface_Num];  //save to eeprom
	__POINTW2MN _EE_settings,4
	MOV  R30,R18
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x58
	MOVW R26,R0
	CALL __EEPROMWRB
;     EE_settings.baud_of_Uart[Interface_Num] = RAM_settings.baud_of_Uart[Interface_Num];
	MOV  R30,R18
	LDI  R26,LOW(_EE_settings)
	LDI  R27,HIGH(_EE_settings)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R18
	CALL SUBOPT_0x35
	CALL __GETW1P
	MOVW R26,R0
	CALL __EEPROMWRW
;#ifdef DEBUG          //�� ����������� ���������!!!
; Put_In_Log("\r Usart_init");
	__POINTW1MN _0x1E8,45
	CALL SUBOPT_0x51
; //print_settings_ram();
;#endif
;      }
;     }
_0x1EF:
;#ifdef DEBUG
;       USART_FlushTxBuf(USART_0);
_0x1EB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _USART_FlushTxBuf
;#endif
;    }
;/////////////////////UART_SET_END////////////////////////////////
;/////////////////////////////////////////////////////////////////
;
;//////////////////////////////////////////////////////////////////
;/////////////////////SPI_SET_START////////////////////////////////
;     if (!strcmpf(argv[1], Spi))
_0x1EA:
	CALL SUBOPT_0x4D
	LDI  R30,LOW(_Spi*2)
	LDI  R31,HIGH(_Spi*2)
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x1F8
;     {
;#ifdef DEBUG
;    Put_In_Log("\r Spi");
	__POINTW1MN _0x1E8,58
	CALL SUBOPT_0x4C
;#endif
;       if (argc > 2)
	CPI  R26,LOW(0x3)
	BRSH PC+3
	JMP _0x1F9
;        {
;#ifdef DEBUG
;  Put_In_Log("\rS Num");
	__POINTW1MN _0x1E8,64
	CALL SUBOPT_0x51
;#endif
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x59
;          if (tmp <= COUNT_OF_SPI){Interface_Num = tmp; response = ok;}
	CALL SUBOPT_0x50
	BRSH _0x1FA
	LDD  R18,Y+12
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;          else{response = largeValue; goto exit;}
	RJMP _0x1FB
_0x1FA:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	RJMP _0x240
_0x1FB:
;
;      if (argc > 3)    //Mode
	LDD  R26,Y+18
	CPI  R26,LOW(0x4)
	BRSH PC+3
	JMP _0x1FC
;      {
;         if (!strcmpf(argv[3], Mode))
	CALL SUBOPT_0x52
	BRNE _0x1FD
;         {
;            tmp = PARS_StrToUchar(argv[4]); //Get spi mode
	CALL SUBOPT_0x53
;            if (tmp==1 || tmp==0){RAM_settings.MODE_of_Spi[Interface_Num] = tmp;
	BREQ _0x1FF
	CALL SUBOPT_0x54
	CALL __CPD02
	BRNE _0x1FE
_0x1FF:
	__POINTW2MN _RAM_settings,6
	MOV  R30,R18
	CALL SUBOPT_0x5
	LDD  R26,Y+12
	STD  Z+0,R26
;            i = 2; //go to next param "speed"
	LDI  R19,LOW(2)
;            response = ok;
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
; #ifdef DEBUG
;Put_In_Log("\rS Mode-");
	__POINTW1MN _0x1E8,71
	CALL SUBOPT_0x51
;#endif
;            }
;            else{response = largeValue; goto exit;}
	RJMP _0x201
_0x1FE:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	RJMP _0x240
_0x201:
;        }
;
;          if (!strcmpf(argv[3+i], Prescaller)) //Prescaller, may be 3 or 5th param
_0x1FD:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LDI  R30,LOW(_Prescaller*2)
	LDI  R31,HIGH(_Prescaller*2)
	CALL SUBOPT_0x4B
	BRNE _0x202
;         {
;            tmp = PARS_StrToUchar(argv[4+i]); //get SPI prescaller Rate
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	CALL SUBOPT_0x59
;            if (tmp <= MAX_SPI_PRESCALLER){RAM_settings.prescaller_of_Spi[Interface_Num] = tmp;
	__CPD2N 0x81
	BRSH _0x203
	__POINTW2MN _RAM_settings,10
	MOV  R30,R18
	CALL SUBOPT_0x5
	LDD  R26,Y+12
	STD  Z+0,R26
;            i += 2;
	SUBI R19,-LOW(2)
;            response = ok;
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;#ifdef DEBUG
;Put_In_Log("\rS Presc-");
	__POINTW1MN _0x1E8,80
	CALL SUBOPT_0x51
;#endif
;            }
;            else{response = largeValue; goto exit;}
	RJMP _0x204
_0x203:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
	RJMP _0x240
_0x204:
;        }
;
;          if (!strcmpf(argv[3+i], PhaPol)) //may be 3 or 5 or 7th  param
_0x202:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LDI  R30,LOW(_PhaPol*2)
	LDI  R31,HIGH(_PhaPol*2)
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x205
;         {
;            tmp = PARS_StrToUchar(argv[4+i]);//get phase/polarity mode (0-3)
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	CALL SUBOPT_0x59
;           if (tmp>=0 && tmp <= 3)
	CALL __CPD20
	BRLO _0x207
	CALL SUBOPT_0x54
	__CPD2N 0x4
	BRLO _0x208
_0x207:
	RJMP _0x206
_0x208:
;           {
;            switch(tmp){  //phase/polarity select
	__GETD1S 12
;             case 0:
	CALL __CPD10
	BREQ _0x241
;              Tmp_param_1 = 0; Tmp_param_2 = 0;
;             break;
;             case 1:
	__CPD1N 0x1
	BRNE _0x20D
;              Tmp_param_1 = 0; Tmp_param_2 = 1;
	LDI  R21,LOW(0)
	LDI  R20,LOW(1)
;             break;
	RJMP _0x20B
;             case 2:
_0x20D:
	__CPD1N 0x2
	BRNE _0x20E
;              Tmp_param_1 = 1; Tmp_param_2 = 0;
	LDI  R21,LOW(1)
	RJMP _0x242
;             break;
;             case 3:
_0x20E:
	__CPD1N 0x3
	BRNE _0x210
;              Tmp_param_1 = 1; Tmp_param_2 = 1;
	LDI  R21,LOW(1)
	LDI  R20,LOW(1)
;             break;
	RJMP _0x20B
;             default:
_0x210:
;              Tmp_param_1 = 0; Tmp_param_2 = 0;
_0x241:
	LDI  R21,LOW(0)
_0x242:
	LDI  R20,LOW(0)
;             break;
;            } response = ok;
_0x20B:
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;#ifdef DEBUG
; Put_In_Log("\rS PhaPol-");
	__POINTW1MN _0x1E8,90
	CALL SUBOPT_0x51
;#endif
;            RAM_settings.PhaPol_of_Spi[Interface_Num] = tmp; //Upd - 1
	__POINTW2MN _RAM_settings,8
	MOV  R30,R18
	CALL SUBOPT_0x5
	LDD  R26,Y+12
	STD  Z+0,R26
;           }
;           else{response = wrongValue; goto exit;}
	RJMP _0x211
_0x206:
	LDI  R30,LOW(_wrongValue*2)
	LDI  R31,HIGH(_wrongValue*2)
	RJMP _0x240
_0x211:
;         }
;     SPI_init(Interface_Num, RAM_settings.MODE_of_Spi[Interface_Num], Tmp_param_2 ,Tmp_param_1, RAM_settings.prescaller_of_Spi[Interface_Num]);
_0x205:
	ST   -Y,R18
	CALL SUBOPT_0x5A
	ST   -Y,R30
	ST   -Y,R20
	ST   -Y,R21
	CALL SUBOPT_0x5B
	ST   -Y,R30
	CALL _SPI_init
;     i = 0; Tmp_param_1=0; Tmp_param_2=0;
	LDI  R19,LOW(0)
	LDI  R21,LOW(0)
	LDI  R20,LOW(0)
;
;      EE_settings.MODE_of_Spi[Interface_Num] = RAM_settings.MODE_of_Spi[Interface_Num];
	__POINTW2MN _EE_settings,6
	MOV  R30,R18
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x5A
	MOVW R26,R0
	CALL __EEPROMWRB
;      EE_settings.PhaPol_of_Spi[Interface_Num] = RAM_settings.PhaPol_of_Spi[Interface_Num];//Upd - 1
	__POINTW2MN _EE_settings,8
	MOV  R30,R18
	CALL SUBOPT_0x5
	MOVW R0,R30
	__POINTW2MN _RAM_settings,8
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	CALL __EEPROMWRB
;     // Tmp_param_2 ,Tmp_param_1,
;      EE_settings.prescaller_of_Spi[Interface_Num] = RAM_settings.prescaller_of_Spi[Interface_Num];
	__POINTW2MN _EE_settings,10
	MOV  R30,R18
	CALL SUBOPT_0x5
	MOVW R0,R30
	CALL SUBOPT_0x5B
	MOVW R26,R0
	CALL __EEPROMWRB
;
;
;#ifdef DEBUG
; Put_In_Log("\rS SpiInit");
	__POINTW1MN _0x1E8,101
	CALL SUBOPT_0x51
;#endif
;      }
;     }
_0x1FC:
;    }
_0x1F9:
;/////////////////////SPI_SET_END//////////////////////////////////
;//////////////////////////////////////////////////////////////////
;  }
_0x1F8:
; }
_0x1E9:
;
;/////////////////////WRITE_COMAND////////////////////////////////
;/////////////////////////////////////////////////////////////////
;if (!strcmpf(argv[0], W)) //Write
_0x1E7:
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_W*2)
	LDI  R31,HIGH(_W*2)
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x212
; {
; #ifdef DEBUG
; Put_In_Log("\r W");
	__POINTW1MN _0x1E8,112
	CALL SUBOPT_0x4C
;#endif
;  if (argc > 1)
	CPI  R26,LOW(0x2)
	BRSH PC+3
	JMP _0x213
;  {
;///////////////////////////////////////////////////////////////////
;/////////////////////UART_WRITE_START//////////////////////////////
;      if (!strcmpf(argv[1], Uart))
	CALL SUBOPT_0x4D
	LDI  R30,LOW(_Uart*2)
	LDI  R31,HIGH(_Uart*2)
	CALL SUBOPT_0x4B
	BRNE _0x214
;     {
;       if (argc > 2)
	LDD  R26,Y+18
	CPI  R26,LOW(0x3)
	BRLO _0x215
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x59
;          if (tmp <= COUNT_OF_UARTS){Interface_Num = tmp; response = ok;}
	CALL SUBOPT_0x50
	BRSH _0x216
	LDD  R18,Y+12
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	RJMP _0x243
;          else{response = largeValue;}
_0x216:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
_0x243:
	MOVW R16,R30
;      if (argc > 3)    //Data
	LDD  R26,Y+18
	CPI  R26,LOW(0x4)
	BRLO _0x218
;      {
;      StopRTOS; //��� ��� �������� �� UART-� ����� ���� ���������,RTOS �� ����� ����������� (��� ������� ��������� ������������)
	LDI  R30,LOW(_StopRTOS)
	LDI  R31,HIGH(_StopRTOS)
;        USART_SendStr(Interface_Num, argv[3]);
	ST   -Y,R18
	CALL SUBOPT_0x5C
	CALL _USART_SendStr
;      RunRTOS;
	LDI  R30,LOW(_RunRTOS)
	LDI  R31,HIGH(_RunRTOS)
;      #ifdef DEBUG
;Put_In_Log("\r U D>TX ");
	__POINTW1MN _0x1E8,116
	CALL SUBOPT_0x51
;  ltoa(PARS_StrToUint(argv[3]),str);
	CALL SUBOPT_0x5D
;Put_In_Log(str); //convert dec to str
;     #endif
;      }
;     }
_0x218:
;    }
_0x215:
;/////////////////////UART_WRITE_END////////////////////////////////
;///////////////////////////////////////////////////////////////////
;
;///////////////////////////////////////////////////////////////////
;/////////////////////SPI_WRITE-READ_START//////////////////////////
;    if (!strcmpf(argv[1], Spi))
_0x214:
	CALL SUBOPT_0x4D
	LDI  R30,LOW(_Spi*2)
	LDI  R31,HIGH(_Spi*2)
	CALL SUBOPT_0x4B
	BRNE _0x219
;     {
; #ifdef DEBUG
; //USART_SendStr(SYSTEM_USART,"\r SPI ");
; #endif
;       if (argc > 2)
	LDD  R26,Y+18
	CPI  R26,LOW(0x3)
	BRLO _0x21A
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x59
;          if (tmp <= COUNT_OF_SPI){Interface_Num = tmp; response = ok;
	CALL SUBOPT_0x50
	BRSH _0x21B
	LDD  R18,Y+12
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	RJMP _0x244
; #ifdef DEBUG
; //USART_SendStr(SYSTEM_USART,"\r SPI num w ");
; #endif
;          }
;          else{response = largeValue;}
_0x21B:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
_0x244:
	MOVW R16,R30
;
;      if (argc > 3)    //Data
	LDD  R26,Y+18
	CPI  R26,LOW(0x4)
	BRLO _0x21D
;      {
;#ifdef DEBUG
;
;Put_In_Log("\r S D>TX ");
	__POINTW1MN _0x1E8,126
	CALL SUBOPT_0x51
; ltoa(PARS_StrToUint(argv[3]),str);  //�������� ������� �� > 65535
	CALL SUBOPT_0x5D
;Put_In_Log(str); //convert dec to str
; #endif
;
; SPI_RW_Buf(10/*array_size(argv[3])*/, argv[3], Spi0_RX_buf); //TODO ���������� ���-�� �������������
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL SUBOPT_0x5C
	LDI  R30,LOW(_Spi0_RX_buf_G000)
	LDI  R31,HIGH(_Spi0_RX_buf_G000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _SPI_RW_Buf
;
; #ifdef DEBUG
;Put_In_Log("\r S D<RX ");
	__POINTW1MN _0x1E8,136
	CALL SUBOPT_0x51
;Put_In_Log(Spi0_RX_buf);
	LDI  R30,LOW(_Spi0_RX_buf_G000)
	LDI  R31,HIGH(_Spi0_RX_buf_G000)
	CALL SUBOPT_0x51
;//SetTimerTask(Task_SPI_ClrBuf, 10);
; // USART_SendStr(SYSTEM_USART, Spi0_RX_buf);
;  #endif
;      }
;     }
_0x21D:
;    }
_0x21A:
;/////////////////////SPI_WRITE-READ_END////////////////////////////
;///////////////////////////////////////////////////////////////////
;
;///////////////////////////////////////////////////////////////////
;/////////////////////I2C_WRITE_START//////////////////////////////
;    if (!strcmpf(argv[1], I2c))
_0x219:
	CALL SUBOPT_0x4D
	LDI  R30,LOW(_I2c*2)
	LDI  R31,HIGH(_I2c*2)
	CALL SUBOPT_0x4B
	BRNE _0x21E
;     {
; #ifdef DEBUG
; //USART_SendStr(SYSTEM_USART,"\r I2c ");
; #endif
;       if (argc > 2)
	LDD  R26,Y+18
	CPI  R26,LOW(0x3)
	BRLO _0x21F
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x59
;          if (tmp <= COUNT_OF_I2C){Interface_Num = tmp; response = ok;
	CALL SUBOPT_0x50
	BRSH _0x220
	LDD  R18,Y+12
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	RJMP _0x245
; #ifdef DEBUG
; //USART_SendStr(SYSTEM_USART,"\r I2C num w ");
; #endif
;          }
;          else{response = largeValue;}
_0x220:
	LDI  R30,LOW(_largeValue*2)
	LDI  R31,HIGH(_largeValue*2)
_0x245:
	MOVW R16,R30
;
;      if (argc > 3)    //Data
	LDD  R26,Y+18
	CPI  R26,LOW(0x4)
	BRLO _0x222
;      {
;#ifdef DEBUG
;
;Put_In_Log("\r I2C D>TX ");
	__POINTW1MN _0x1E8,146
	CALL SUBOPT_0x51
; ltoa(PARS_StrToUint(argv[3]),str);  //�������� ������� �� > 65535
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	ST   -Y,R27
	ST   -Y,R26
	CALL _PARS_StrToUint
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
; USART_SendStr(SYSTEM_USART,str); //convert dec to str
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	CALL SUBOPT_0x32
; #endif
;
; //I2C_RW_Buf(10/*array_size(argv[3])*/, argv[3], Spi0_RX_buf); //TODO ���������� ���-�� �������������
; //I2C_write(argv[3]);
;
;
; #ifdef DEBUG
;Put_In_Log("\r I2C D<RX ");
	__POINTW1MN _0x1E8,158
	CALL SUBOPT_0x51
;  USART_SendStr(SYSTEM_USART, Spi0_RX_buf);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_Spi0_RX_buf_G000)
	LDI  R31,HIGH(_Spi0_RX_buf_G000)
	CALL SUBOPT_0x32
;  #endif
;      }
;     }
_0x222:
;    }
_0x21F:
;/////////////////////I2C_WRITE_END/////////////////////////////////
;///////////////////////////////////////////////////////////////////
;   }
_0x21E:
; }
_0x213:
;
; /*
; ���������  ���� � uart1,
; �������� ��������� spi (� 1 ����������!!).
; �������� ���������� � ������,
;
; ������� �2�,
; �������� ����� ������������ �/�� �������� ���������.
;
; +������� ���������
; */
;
;    if (!strcmpf(argv[0], Help)){ print_help(); response = ok; }
_0x212:
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_Help*2)
	LDI  R31,HIGH(_Help*2)
	CALL SUBOPT_0x4B
	BRNE _0x223
	RCALL _print_help
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;    if (!strcmpf(argv[0], boot)){#asm("call 0x1E00");response = ok;}//Boot_reset "Goto bootloader"
_0x223:
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_boot*2)
	LDI  R31,HIGH(_boot*2)
	CALL SUBOPT_0x4B
	BRNE _0x224
	call 0x1E00
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;    if (!strcmpf(argv[0], reset)){#asm("jmp 0x0000");response = ok;} //reset
_0x224:
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_reset*2)
	LDI  R31,HIGH(_reset*2)
	CALL SUBOPT_0x4B
	BRNE _0x225
	jmp 0x0000
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;    // dbg �� �������� ��������� ��-�� ���������� ����(�������� �������� �������������, � � help �� ��.)
;    if (!strcmpf(argv[0], dbg)){StopRTOS(); print_settings_eeprom(); print_settings_ram(); print_sys(); response = ok; RunRTOS();}
_0x225:
	CALL SUBOPT_0x4A
	LDI  R30,LOW(_dbg*2)
	LDI  R31,HIGH(_dbg*2)
	CALL SUBOPT_0x4B
	BRNE _0x226
	CALL _StopRTOS
	RCALL _print_settings_eeprom
	CALL _print_settings_ram
	RCALL _print_sys
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
	CALL _RunRTOS
;    if (!strcmpf(argv[0], "s")){ print_sys(); response = ok;}
_0x226:
	CALL SUBOPT_0x4A
	__POINTW1FN _0x0,355
	CALL SUBOPT_0x4B
	BRNE _0x227
	RCALL _print_sys
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
	MOVW R16,R30
;        if (!strcmpf(argv[0], "E")){SetTask(StartWrite2EPP); response = ok;}  // ��������� ������� ������ � ������.
_0x227:
	CALL SUBOPT_0x4A
	__POINTW1FN _0x0,357
	CALL SUBOPT_0x4B
	BRNE _0x228
	LDI  R30,LOW(_StartWrite2EPP)
	LDI  R31,HIGH(_StartWrite2EPP)
	CALL SUBOPT_0x1D
	LDI  R30,LOW(_ok*2)
	LDI  R31,HIGH(_ok*2)
_0x240:
	MOVW R16,R30
;
; //EE_settings = RAM_settings; //rewrite settings to EEPROM
;
;exit:
_0x228:
_0x1EE:
;  //USART_FlushTxBuf(SYSTEM_USART);
;  USART_SendStrFl(SYSTEM_USART,response);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	CALL _USART_SendStrFl
;#ifdef DEBUG
; // RunRTOS();
;#endif
;}
	CALL __LOADLOCR6
	ADIW R28,19
	RET

	.DSEG
_0x1E8:
	.BYTE 0xAA
;
;// G_vars are here
;
;void main(void)
; 0000 0018 {

	.CSEG
_main:
; 0000 0019 char i;
; 0000 001A char str[7];
; 0000 001B 
; 0000 001C HARDWARE_init();
	SBIW R28,7
;	i -> R17
;	str -> Y+0
	RCALL _HARDWARE_init
; 0000 001D SOFTWARE_init();
	RCALL _SOFTWARE_init
; 0000 001E 
; 0000 001F #ifdef DEBUG
; 0000 0020     //DDRD.7=1;//PORTD.7=1;  //Led VD2
; 0000 0021     //DDRD.6=1;PORTD.6=1;    //Led VD1
; 0000 0022     USART_SendStrFl(USART_1,start);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_start*2)
	LDI  R31,HIGH(_start*2)
	CALL SUBOPT_0x30
; 0000 0023     USART_SendStrFl(SYSTEM_USART,start);
	LDI  R30,LOW(_start*2)
	LDI  R31,HIGH(_start*2)
	CALL SUBOPT_0x31
; 0000 0024 #endif
; 0000 0025 
; 0000 0026 
; 0000 0027 //#asm("sei") // Global enable interrupts Upd-1
; 0000 0028 //sprintf(lcd_buf, "Z=%d", SYS_TICK); ;LcdString(1,3); LcdUpdate();
; 0000 0029 RunRTOS();			// ����� ����.
; 0000 002A 
; 0000 002B //delay_ms(1000);// ������ ������� �����.
; 0000 002C SetTask(Task_Start);     //290uS (50/50) and (10/10) �� ��� 1/1 ���� 1 ������
	LDI  R30,LOW(_Task_Start)
	LDI  R31,HIGH(_Task_Start)
	CALL SUBOPT_0x1D
; 0000 002D 
; 0000 002E ///-----------------Upd-7-----------------------------
; 0000 002F // ��������� ������ ���� �����
; 0000 0030 SetTimerTask(Task_pars_cmd, 25); //Upd-6
	CALL SUBOPT_0x44
	CALL SUBOPT_0x3C
; 0000 0031 #ifdef DEBUG                    //Upd-6
; 0000 0032 SetTimerTask(Task_LogOut,50);
	CALL SUBOPT_0x45
; 0000 0033 SetTimerTask(Task_ADC_test,5000);   //Upd-6
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3C
; 0000 0034 SetTask(Task_LcdGreetImage);    //Upd-4
	LDI  R30,LOW(_Task_LcdGreetImage)
	LDI  R31,HIGH(_Task_LcdGreetImage)
	CALL SUBOPT_0x1D
; 0000 0035 SetTask(Task_AdcOnLcd);
	LDI  R30,LOW(_Task_AdcOnLcd)
	LDI  R31,HIGH(_Task_AdcOnLcd)
	CALL SUBOPT_0x1D
; 0000 0036 #endif
; 0000 0037 ///---------------------------------------------------
; 0000 0038 
; 0000 0039 
; 0000 003A delay_ms(1000); //?
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x3
; 0000 003B while (1)
_0x229:
; 0000 003C  {
; 0000 003D //wdt_reset();	// ����� ��������� �������
; 0000 003E TaskManager();	// ����� ����������
	RCALL _TaskManager
; 0000 003F  }
	RJMP _0x229
; 0000 0040 } //END MAIN
_0x22C:
	RJMP _0x22C
;
;
;
;// Timer2 interrupt service routine
;interrupt [RTOS_ISR] void timer2_comp_isr(void)//RTOS Interrupt 1mS
; 0000 0046 {
_timer2_comp_isr:
	CALL SUBOPT_0x20
; 0000 0047  TimerService();
	RCALL _TimerService
; 0000 0048  SYS_TICK++;
	LDI  R26,LOW(_SYS_TICK)
	LDI  R27,HIGH(_SYS_TICK)
	CALL SUBOPT_0x15
; 0000 0049 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;#include "RTOS/EERTOS.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "RTOS/EERTOSHAL.h"
;
;
;/*
;��������� ������ ��� ����� ��������, ���� ������ ���������� �� 50-100��� ��� 16���?
;
;DI HALT:
;9 ������ 2012 � 21:08
;����� ����� ��������. ��� �������� ������ ����� ��������������,
;������� ���������� ����� ��������� ������ ������ ����� 600 ������.
;�� ��� ����� ����. ������� �� � ������� �������� ������� �������,
;��������� ������� ������� 700 ������, ��������� ������ ����� 400 ������.
;������� ������� ������� �� 500��� ,�� ������ ����� ������� ������, ����� ������ ������ �����.
;*/
;
;
;/*
;  UPDATE - ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� �����
;  ����������� ������ �� ������� MainTimer, ������� ��� "���������",
;  �������������� ���������� ���� ����� �����������.
;  MEMORY -58 WORDS
;*/
;
;
;
;// ������� �����, ��������.
;// ��� ������ - ��������� �� �������
;//volatile static TPTR	TaskQueue[TaskQueueSize+1];			// ������� ����������
;//update
;volatile static struct
;						{
;						    TPTR GoToTask; 						// ��������� ��������
;						    uint16_t Time;					// �������� � ��
;						}
;						MainTimer[MainTimerQueueSize+1];	// ������� ��������
;
;
;// RTOS ����������. ������� ��������
;  void InitRTOS(void)
; 0001 0029 {

	.CSEG
_InitRTOS:
; 0001 002A uint8_t	index;
; 0001 002B 
; 0001 002C /*   //UPDATE
; 0001 002D     for(index=0;index!=TaskQueueSize+1;index++)	// �� ��� ������� ���������� Idle
; 0001 002E 	    {
; 0001 002F 	    TaskQueue[index] = Idle;
; 0001 0030 	 }
; 0001 0031 */
; 0001 0032       for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,16
	BREQ _0x20005
; 0001 0033     	{
; 0001 0034 	    MainTimer[index].GoToTask = Idle;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
; 0001 0035 	    MainTimer[index].Time = 0;
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0001 0036 	 }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0037 }
	RJMP _0x20C0002
;
;
;//������ ��������� - ������� ����.
;  void  Idle(void)
; 0001 003C {
_Idle:
; 0001 003D 
; 0001 003E }
	RET
;
;
;
; //UPDATE
; void SetTask(TPTR TS){  // ��������� ������ � ������� ��� ������������ ����������
; 0001 0043 void SetTask(TPTR TS){
_SetTask:
; 0001 0044  SetTimerTask(TS,0);
;	*TS -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x3C
; 0001 0045 }
	ADIW R28,2
	RET
;
;
;//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
;// ����� �������� � ����� ���������� �������. ��������� ��� ������.
;
;void SetTimerTask(TPTR TS, unsigned int NewTime)    //1 task ~12words
; 0001 004C {
_SetTimerTask:
; 0001 004D uint8_t		index=0;
; 0001 004E uint8_t		nointerrupted = 0;
; 0001 004F 
; 0001 0050 if (STATUS_REG & (1<<Interrupt_Flag)) 			// �������� ������� ����������, ���������� ������� ����
	ST   -Y,R17
	ST   -Y,R16
;	*TS -> Y+4
;	NewTime -> Y+2
;	index -> R17
;	nointerrupted -> R16
	LDI  R17,0
	LDI  R16,0
	IN   R30,0x3F
	SBRS R30,7
	RJMP _0x20006
; 0001 0051 	{
; 0001 0052 	_disable_interrupts()
	cli
; 0001 0053 	nointerrupted = 1;
	LDI  R16,LOW(1)
; 0001 0054 	}
; 0001 0055 //====================================================================
; 0001 0056 // My UPDATE - not optimized
; 0001 0057   for(index=0;index!=MainTimerQueueSize+1;++index)	//����������� ������� ��������
_0x20006:
	LDI  R17,LOW(0)
_0x20008:
	CPI  R17,16
	BREQ _0x20009
; 0001 0058 	{
; 0001 0059 	if(MainTimer[index].GoToTask == TS)				// ���� ��� ���� ������ � ����� �������
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2000A
; 0001 005A 		{
; 0001 005B 		MainTimer[index].Time = NewTime;			// �������������� �� ��������
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x61
; 0001 005C 		if (nointerrupted) 	_enable_interrupts()		// ��������� ���������� ���� �� ���� ���������.
	BREQ _0x2000B
	sei
; 0001 005D 		return;										// �������. ������ ��� ��� �������� ��������. ���� �����
_0x2000B:
	RJMP _0x20C0004
; 0001 005E 		}
; 0001 005F 	}
_0x2000A:
	SUBI R17,-LOW(1)
	RJMP _0x20008
_0x20009:
; 0001 0060   for(index=0;index!=MainTimerQueueSize+1;++index)	// ���� �� ������� ������� ������, �� ���� ����� ������
	LDI  R17,LOW(0)
_0x2000D:
	CPI  R17,16
	BREQ _0x2000E
; 0001 0061 	{
; 0001 0062 	if (MainTimer[index].GoToTask == Idle)
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x62
	BRNE _0x2000F
; 0001 0063 		{
; 0001 0064 		MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
	CALL SUBOPT_0x5E
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0001 0065 		MainTimer[index].Time = NewTime;		// � ���� �������� �������
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x61
; 0001 0066 		if (nointerrupted) 	_enable_interrupts()	// ��������� ����������
	BREQ _0x20010
	sei
; 0001 0067 		return;									// �����.
_0x20010:
	RJMP _0x20C0004
; 0001 0068 		}
; 0001 0069 
; 0001 006A 	}
_0x2000F:
	SUBI R17,-LOW(1)
	RJMP _0x2000D
_0x2000E:
; 0001 006B //====================================================================
; 0001 006C /*
; 0001 006D   for(index=0;index!=MainTimerQueueSize+1;++index)	//����������� ������� ��������
; 0001 006E 	{
; 0001 006F 	if(MainTimer[index].GoToTask == TS)				// ���� ��� ���� ������ � ����� �������
; 0001 0070 		{
; 0001 0071 		MainTimer[index].Time = NewTime;			// �������������� �� ��������
; 0001 0072 		if (nointerrupted) 	_enable_interrupts()		// ��������� ���������� ���� �� ���� ���������.
; 0001 0073 		return;										// �������. ������ ��� ��� �������� ��������. ���� �����
; 0001 0074 		}
; 0001 0075 	}
; 0001 0076   for(index=0;index!=MainTimerQueueSize+1;++index)	// ���� �� ������� ������� ������, �� ���� ����� ������
; 0001 0077 	{
; 0001 0078 	if (MainTimer[index].GoToTask == Idle)
; 0001 0079 		{
; 0001 007A 		MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
; 0001 007B 		MainTimer[index].Time = NewTime;		// � ���� �������� �������
; 0001 007C 		if (nointerrupted) 	_enable_interrupts()	// ��������� ����������
; 0001 007D 		return;									// �����.
; 0001 007E 		}
; 0001 007F 
; 0001 0080 	}	*/								// ��� ����� ������� return c ����� ������ - ��� ��������� ��������
; 0001 0081 }
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;/*=================================================================================
;��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.
;*/
;
;inline void TaskManager(void)
; 0001 0088 {
_TaskManager:
; 0001 0089 uint8_t		index=0;
; 0001 008A 
; 0001 008B //UPDATE
; 0001 008C TPTR task;
; 0001 008D //TPTR	GoToTask = Idle;		// �������������� ����������
; 0001 008E 
; 0001 008F _disable_interrupts()				// ��������� ����������!!!
	CALL __SAVELOCR4
;	index -> R17
;	*task -> R18,R19
	LDI  R17,0
	cli
; 0001 0090 //UPDATE
; 0001 0091 //================================================================================================
; 0001 0092   for(index=0;index!=MainTimerQueueSize+1;++index) {  // ����������� ������� � ������� ������ ������
	LDI  R17,LOW(0)
_0x20012:
	CPI  R17,16
	BREQ _0x20013
; 0001 0093 		if ((MainTimer[index].GoToTask != Idle)&&(MainTimer[index].Time==0)) { // ���������� ������ ������ � ��, ����� ������� ��� �� �������
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x62
	BREQ _0x20015
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20016
_0x20015:
	RJMP _0x20014
_0x20016:
; 0001 0094 		    task=MainTimer[index].GoToTask;             // �������� ������
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0001 0095 		    MainTimer[index].GoToTask = Idle;           // ������ �������
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
; 0001 0096             _enable_interrupts()							// ��������� ����������
	sei
; 0001 0097             (task)();								    // ��������� � ������
	MOVW R30,R18
	ICALL
; 0001 0098             return;                                     // ����� �� ���������� �����
	RJMP _0x20C0003
; 0001 0099 		}
; 0001 009A 	}
_0x20014:
	SUBI R17,-LOW(1)
	RJMP _0x20012
_0x20013:
; 0001 009B     _enable_interrupts()							// ��������� ����������
	sei
; 0001 009C 	Idle();                                     // ������ ������, ������ ��� - �������
	RCALL _Idle
; 0001 009D //====================================================================================================
; 0001 009E /* //UPDATE
; 0001 009F GoToTask = TaskQueue[0];		// ������� ������ �������� �� �������
; 0001 00A0 if (GoToTask==Idle) 			// ���� ��� �����
; 0001 00A1 	{_enable_interrupts()			// ��������� ����������
; 0001 00A2 	(Idle)(); 					// ��������� �� ��������� ������� �����
; 0001 00A3 	}
; 0001 00A4 else
; 0001 00A5 	{ for(index=0;index!=TaskQueueSize;index++)	// � ��������� ������ �������� ��� �������
; 0001 00A6 		{
; 0001 00A7 		TaskQueue[index]=TaskQueue[index+1];
; 0001 00A8 		}
; 0001 00A9 	TaskQueue[TaskQueueSize]= Idle;				// � ��������� ������ ������ �������
; 0001 00AA _enable_interrupts()							// ��������� ����������
; 0001 00AB 	(GoToTask)();								// ��������� � ������
; 0001 00AC 	}
; 0001 00AD  */
; 0001 00AE }
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;/*
;������ �������� ����. ������ ���������� �� ���������� ��� � 1��. ���� ����� ����� ����������� � ����������� �� ������
;
;To DO: �������� � ����������� ��������� ������������ ������� ��������. ����� ����� ����� ��������� �� ����� ������.
;� ����� ������������ ��� ������� ������������ �������.
;� ���� ������ �� ������ �������� �������� ����������.
;*/
;inline void TimerService(void)
; 0001 00B8 {
_TimerService:
; 0001 00B9 uint8_t index;
; 0001 00BA 
; 0001 00BB for(index=0;index!=MainTimerQueueSize+1;index++)		// ����������� ������� ��������
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x20018:
	CPI  R17,16
	BREQ _0x20019
; 0001 00BC 	{
; 0001 00BD //==========================================================================
; 0001 00BE //UPDATE
; 0001 00BF          if((MainTimer[index].GoToTask != Idle) && 		    // ���� �� �������� �
; 0001 00C0            (MainTimer[index].Time > 0)) {					// ������ �� ��������, ��
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x62
	BREQ _0x2001B
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	MOVW R26,R30
	CALL __CPW02
	BRLO _0x2001C
_0x2001B:
	RJMP _0x2001A
_0x2001C:
; 0001 00C1             MainTimer[index].Time--;						// ������� ��� ���.
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 00C2 		};
_0x2001A:
; 0001 00C3 	}
	SUBI R17,-1
	RJMP _0x20018
_0x20019:
; 0001 00C4 }
_0x20C0002:
	LD   R17,Y+
	RET
;
;//���������� �� sniuk 7.1.14
;void ClearTimerTask(TPTR TS)  //��������� �������
; 0001 00C8 {
; 0001 00C9 uint8_t	 index=0;
; 0001 00CA uint8_t nointerrupted = 0;
; 0001 00CB if (STATUS_REG & (1<<Interrupt_Flag))
;	*TS -> Y+2
;	index -> R17
;	nointerrupted -> R16
; 0001 00CC {
; 0001 00CD _disable_interrupts();
; 0001 00CE nointerrupted = 1;
; 0001 00CF }
; 0001 00D0     for(index=0; index!=MainTimerQueueSize+1; ++index)
; 0001 00D1     {
; 0001 00D2         if(MainTimer[index].GoToTask == TS)
; 0001 00D3         {
; 0001 00D4             MainTimer[index].GoToTask = Idle;
; 0001 00D5             MainTimer[index].Time = 0; // �������� �����
; 0001 00D6             if (nointerrupted) _enable_interrupts();
; 0001 00D7             return;
; 0001 00D8         }
; 0001 00D9     }
; 0001 00DA }
;
;
;    #warning ������� �� ���� ����!
;/*
;
;����� www.google.com-accounts-o8-id-id-AItOawmi18Y12U8R4bYF3i0GRgR
;����: C++
;������������ 8 ������ 2011 ���� � 00:05
;���������� 1067
;������� � ���� 5 ������ :) ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� ����� ����������� ������ �� ������� MainTimer, ������� ��� "���������", �������������� ���������� ���� ����� �����������. ������� ������ ��� eertos.c
;#include "eertos.h"
;
;// ������� �����.
;volatile static struct	{
;	TPTR GoToTask; 						// ��������� ��������
;	uint16_t Time;							// �������� � ��
;} MainTimer[MainTimerQueueSize+1];	// ������� ��������
;
;// RTOS ����������. ������� ��������
;inline void InitRTOS(void)
;{
;    uint8_t	index;
;
;    for(index=0;index!=MainTimerQueueSize+1;index++) { // �������� ��� �������.
;		MainTimer[index].GoToTask = Idle;
;        MainTimer[index].Time = 0;
;	}
;}
;
;//������ ��������� - ������� ����.
;void  Idle(void) {
;
;}
;
;//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
;// ����� �������� � ����� ���������� �������. ��������� ��� ������.
;void SetTimerTask(TPTR TS, uint16_t NewTime) {
;
;    uint8_t		index=0;
;    uint8_t		nointerrupted = 0;
;
;    if (STATUS_REG & (_BV(Interrupt_Flag))) { 			// �������� ������� ����������, ���������� ������� ����
;        Disable_Interrupt
;        nointerrupted = 1;
;	}
;
;    for(index=0;index!=MainTimerQueueSize+1;++index) {	//����������� ������� ��������
;        if(MainTimer[index].GoToTask == TS) {			// ���� ��� ���� ������ � ����� �������
;            MainTimer[index].Time = NewTime;			// �������������� �� ��������
;            if (nointerrupted) 	Enable_Interrupt		// ��������� ���������� ���� �� ���� ���������.
;            return;										// �������. ������ ��� ��� �������� ��������. ���� �����
;		}
;	}
;
;    for(index=0;index!=MainTimerQueueSize+1;++index) {	// ���� �� ������� ������� ������, �� ���� ����� ������
;		if (MainTimer[index].GoToTask == Idle) {
;			MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
;            MainTimer[index].Time = NewTime;		// � ���� �������� �������
;            if (nointerrupted) 	Enable_Interrupt	// ��������� ����������
;            return;									// �����.
;		}
;	}												// ��� ����� ������� return c ����� ������ - ��� ��������� ��������
;}
;
;void SetTask(TPTR TS) {                             // ��������� ������ � ������� ��� ������������ ����������
;    SetTimerTask(TS,0);
;}
;
;//=================================================================================
;��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.
;
;
;inline void TaskManager(void) {
;
;uint8_t		index=0;
;TPTR task;
;
;    Disable_Interrupt				// ��������� ����������!!!
;    for(index=0;index!=MainTimerQueueSize+1;++index) {  // ����������� ������� � ������� ������ ������
;		if ((MainTimer[index].GoToTask != Idle)&&(MainTimer[index].Time==0)) { // ���������� ������ ������ � ��, ����� ������� ��� �� �������
;		    task=MainTimer[index].GoToTask;             // �������� ������
;		    MainTimer[index].GoToTask = Idle;           // ������ �������
;            Enable_Interrupt							// ��������� ����������
;            (task)();								    // ��������� � ������
;            return;                                     // ����� �� ���������� �����
;		}
;	}
;    Enable_Interrupt							// ��������� ����������
;	Idle();                                     // ������ ������, ������ ��� - �������
;}
;
;
;//������ �������� ����. ������ ���������� �� ���������� ��� � 1��. ���� ����� ����� ����������� � ����������� �� ������
;
;inline void TimerService(void) {
;
;uint8_t index;
;
;    for(index=0;index!=MainTimerQueueSize+1;index++) {		// ����������� ������� ��������
;        if((MainTimer[index].GoToTask != Idle) && 		    // ���� �� �������� �
;           (MainTimer[index].Time > 0)) {					// ������ �� ��������, ��
;            MainTimer[index].Time--;						// ������� ��� ���.
;		};
;	}
;}
;
;*/
;#include "RTOS/EERTOSHAL.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;//RTOS ������ ���������� �������
;  void RunRTOS (void)
; 0002 0005 {

	.CSEG
_RunRTOS:
; 0002 0006 TCCR2 = (1<<WGM21)|(1<<CS22)|(0<<CS20)|(0<<CS21); // Freq = CK/256 - ���������� ����� � ������������
	LDI  R30,LOW(12)
	OUT  0x25,R30
; 0002 0007 										         // ��������� ����� ���������� �������� ���������
; 0002 0008 TCNT2 = 0;								// ���������� ��������� �������� ���������
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0002 0009 OCR2  = LO(TimerDivider); 				// ���������� �������� � ������� ���������
	LDI  R30,LOW(62)
	OUT  0x23,R30
; 0002 000A TIMSK = (0<<TOIE0)|(1<<OCIE2);
	LDI  R30,LOW(128)
	OUT  0x37,R30
; 0002 000B #asm("sei");                             // ��������� ���������� RTOS - ������ ��
	sei
; 0002 000C }
	RET
;
;
;//RTOS ���������� ������������ ���������� �������
;  void StopRTOS (void)//���������� �������� ������� ���������� �������
; 0002 0011 {
_StopRTOS:
; 0002 0012 TCCR2 = (0<<CS21)|(1<<CS22)|(1<<CS20); // Freq = CK/1024
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0002 0013 }
	RET
;
;
;//RTOS ��������� ���������� �������
;  void FullStopRTOS (void)
; 0002 0018 {
; 0002 0019 #asm("cli");
; 0002 001A TCCR2 = 0;                        // �������� ����� � ������������
; 0002 001B TIMSK = (0<<TOIE0)|(0<<OCIE2);	 // ��������� ���������� RTOS - ��������� ��
; 0002 001C #asm("sei");
; 0002 001D }

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x16
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x16
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G101:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x63
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x63
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x64
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x65
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x64
	CALL SUBOPT_0x66
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x64
	CALL SUBOPT_0x66
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x64
	CALL SUBOPT_0x67
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x64
	CALL SUBOPT_0x67
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x63
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x63
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x65
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x63
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x65
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x68
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x68
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL SUBOPT_0x56
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_strcmpf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmpf0:
    ld   r1,x+
	lpm  r0,z+
    cp   r0,r1
    brne strcmpf1
    tst  r0
    brne strcmpf0
strcmpf3:
    clr  r30
    ret
strcmpf1:
    sub  r1,r0
    breq strcmpf3
    ldi  r30,1
    brcc strcmpf2
    subi r30,2
strcmpf2:
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ltoa:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x3B9ACA00
	__PUTD1S 2
	LDI  R16,LOW(0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060003
	__GETD1S 8
	CALL __ANEGD1
	__PUTD1S 8
	CALL SUBOPT_0x69
	LDI  R30,LOW(45)
	ST   X,R30
_0x2060003:
_0x2060005:
	CALL SUBOPT_0x6A
	CALL __DIVD21U
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2060008
	CPI  R16,0
	BRNE _0x2060008
	__GETD2S 2
	__CPD2N 0x1
	BRNE _0x2060007
_0x2060008:
	CALL SUBOPT_0x69
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	LDI  R16,LOW(1)
_0x2060007:
	CALL SUBOPT_0x6A
	CALL __MODD21U
	__PUTD1S 8
	__GETD2S 2
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 2
	CALL __CPD10
	BRNE _0x2060005
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
___ds1820_scratch_pad:
	.BYTE 0x9
_lcd_buf:
	.BYTE 0xF
_LcdCache:
	.BYTE 0x1F8
_saved_state:
	.BYTE 0x1
_symbol:
	.BYTE 0x1
_SYS_TICK:
	.BYTE 0x4
_TX_CNT:
	.BYTE 0x4
_RX_CNT:
	.BYTE 0x4

	.ESEG
_EE_settings:
	.BYTE 0xC

	.DSEG
_RAM_settings:
	.BYTE 0xC
_Usart0_TX_buf_G000:
	.BYTE 0x200
_Usart0_txBufTail_G000:
	.BYTE 0x2
_Usart0_txBufHead_G000:
	.BYTE 0x2
_Usart1_TX_buf_G000:
	.BYTE 0x200
_Usart1_txBufTail_G000:
	.BYTE 0x2
_Usart1_txBufHead_G000:
	.BYTE 0x2
_Usart0_RX_buf_G000:
	.BYTE 0x100
_Usart0_rxBufTail_G000:
	.BYTE 0x2
_Usart0_rxBufHead_G000:
	.BYTE 0x2
_Usart0_rxCount_G000:
	.BYTE 0x2
_Usart1_RX_buf_G000:
	.BYTE 0x100
_Usart1_rxBufTail_G000:
	.BYTE 0x2
_Usart1_rxBufHead_G000:
	.BYTE 0x2
_Usart1_rxCount_G000:
	.BYTE 0x2
_WorkLog_G000:
	.BYTE 0x200
_LogIndex_G000:
	.BYTE 0x2
_buf:
	.BYTE 0x80
_argv:
	.BYTE 0x14
_Spi0_TX_buf_G000:
	.BYTE 0x40
_Spi0_txBufTail_G000:
	.BYTE 0x2
_Spi0_txBufHead_G000:
	.BYTE 0x2
_Spi0_RX_buf_G000:
	.BYTE 0x40
_adc_result:
	.BYTE 0x2
_vref:
	.BYTE 0x2
_volt:
	.BYTE 0x2
_delta:
	.BYTE 0x2
_adc_tmp:
	.BYTE 0x2
_d:
	.BYTE 0x2
_avcc:
	.BYTE 0x2
_adc_calib_cnt:
	.BYTE 0x2
_t:
	.BYTE 0x6
_MasterOutFunc:
	.BYTE 0x2
_SlaveOutFunc:
	.BYTE 0x2
_ErrorOutFunc:
	.BYTE 0x2
_i2c_Do:
	.BYTE 0x1
_i2c_InBuff:
	.BYTE 0x1
_i2c_OutBuff:
	.BYTE 0x1
_i2c_SlaveIndex:
	.BYTE 0x1
_i2c_Buffer:
	.BYTE 0x3
_i2c_index:
	.BYTE 0x1
_i2c_ByteCount:
	.BYTE 0x1
_i2c_SlaveAddress:
	.BYTE 0x1
_i2c_PageAddress:
	.BYTE 0x2
_i2c_PageAddrIndex:
	.BYTE 0x1
_i2c_PageAddrCount:
	.BYTE 0x1
_MainTimer_G001:
	.BYTE 0x40
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LcdSend
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LcdSend
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_LcdCache)
	LDI  R27,HIGH(_LcdCache)
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x5:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOV  R30,R19
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDD  R30,Y+17
	ST   -Y,R30
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+12
	ST   -Y,R30
	JMP  _LcdPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+15,R30
	STD  Y+15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	MOVW R30,R20
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+17,R30
	STD  Y+17+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
	SUBI R30,LOW(-_LcdCache)
	SBCI R31,HIGH(-_LcdCache)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  _Usart0_txBufTail_G000,R30
	STS  _Usart0_txBufTail_G000+1,R30
	STS  _Usart0_txBufHead_G000,R30
	STS  _Usart0_txBufHead_G000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	__GETD2N 0x10
	CALL __MULD12U
	__GETD2N 0xF42400
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	__GETD2N 0x8
	CALL __MULD12U
	__GETD2N 0xF42400
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
	LDI  R30,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _Usart1_txBufTail_G000,R30
	STS  _Usart1_txBufTail_G000+1,R30
	STS  _Usart1_txBufHead_G000,R30
	STS  _Usart1_txBufHead_G000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	IN   R30,0x3F
	LDS  R26,_saved_state
	OR   R30,R26
	OUT  0x3F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x16:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	IN   R30,0x3F
	OR   R30,R16
	OUT  0x3F,R30
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDS  R30,_LogIndex_G000
	LDS  R31,_LogIndex_G000+1
	SUBI R30,LOW(-_WorkLog_G000)
	SBCI R31,HIGH(-_WorkLog_G000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	STD  Z+0,R26
	LDI  R26,LOW(_LogIndex_G000)
	LDI  R27,HIGH(_LogIndex_G000)
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	STS  _argv,R30
	STS  _argv+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x1B:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SetTask

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  98,R30
	STS  97,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R26,_volt
	LDS  R27,_volt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x20:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	__GETB1MN _t,4
	SUBI R30,-LOW(1)
	__PUTB1MN _t,4
	SUBI R30,LOW(1)
	LDI  R30,LOW(1)
	__PUTB1MN _t,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	STS  _i2c_Do,R30
	LDI  R30,LOW(213)
	STS  116,R30
	__CALL1MN _ErrorOutFunc,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDS  R30,_i2c_SlaveAddress
	STS  115,R30
	LDI  R30,LOW(197)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	LDS  R30,_i2c_index
	LDI  R31,0
	SUBI R30,LOW(-_i2c_Buffer)
	SBCI R31,HIGH(-_i2c_Buffer)
	LD   R30,Z
	STS  115,R30
	LDS  R30,_i2c_index
	SUBI R30,-LOW(1)
	STS  _i2c_index,R30
	LDI  R30,LOW(197)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x26:
	LDS  R30,_i2c_PageAddrIndex
	LDI  R31,0
	SUBI R30,LOW(-_i2c_PageAddress)
	SBCI R31,HIGH(-_i2c_PageAddress)
	LD   R30,Z
	STS  115,R30
	LDS  R30,_i2c_PageAddrIndex
	SUBI R30,-LOW(1)
	STS  _i2c_PageAddrIndex,R30
	LDI  R30,LOW(197)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(213)
	STS  116,R30
	__CALL1MN _MasterOutFunc,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	STS  _i2c_Do,R30
	LDI  R30,LOW(0)
	STS  _i2c_index,R30
	STS  _i2c_PageAddrIndex,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDS  R26,_i2c_index
	SUBI R26,-LOW(1)
	LDS  R30,_i2c_ByteCount
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	LDS  R26,_i2c_index
	LDI  R27,0
	SUBI R26,LOW(-_i2c_Buffer)
	SBCI R27,HIGH(-_i2c_Buffer)
	LDS  R30,115
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDS  R30,_i2c_Do
	ORI  R30,0x40
	STS  _i2c_Do,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDS  R26,_i2c_SlaveIndex
	LDI  R27,0
	SUBI R26,LOW(-_i2c_InBuff)
	SBCI R27,HIGH(-_i2c_InBuff)
	LDS  R30,115
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	LDS  R30,_i2c_SlaveIndex
	SUBI R30,-LOW(1)
	STS  _i2c_SlaveIndex,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDI  R31,0
	SUBI R30,LOW(-_i2c_OutBuff)
	SBCI R31,HIGH(-_i2c_OutBuff)
	LD   R30,Z
	STS  115,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	STS  _ErrorOutFunc,R30
	STS  _ErrorOutFunc+1,R31
	LDI  R30,LOW(165)
	STS  116,R30
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	CALL _USART_SendStrFl
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	CALL _USART_SendStrFl
	JMP  _RunRTOS

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x32:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _USART_SendStr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x33:
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x34:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(_RAM_settings)
	LDI  R27,HIGH(_RAM_settings)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x36:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	__POINTW2MN _EE_settings,4
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x38:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	__POINTW2MN _EE_settings,6
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	__POINTW2MN _EE_settings,10
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3C:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SetTimerTask

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(_Task_LedOff)
	LDI  R31,HIGH(_Task_LedOff)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(_Task_ADC_test)
	LDI  R31,HIGH(_Task_ADC_test)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(_LcdClear)
	LDI  R31,HIGH(_LcdClear)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(_lcd_buf)
	LDI  R31,HIGH(_lcd_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	ST   -Y,R30
	CALL _LcdString
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(_Task_pars_cmd)
	LDI  R31,HIGH(_Task_pars_cmd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(_Task_LogOut)
	LDI  R31,HIGH(_Task_LogOut)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDS  R30,_i2c_Do
	ANDI R30,0xBF
	STS  _i2c_Do,R30
	ANDI R30,LOW(0x11)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(_RAM_settings)
	LDI  R27,HIGH(_RAM_settings)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _USART_Init

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x4B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmpf
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _Put_In_Log
	LDD  R26,Y+18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4F:
	CALL _PARS_StrToUint
	CLR  R22
	CLR  R23
	__PUTD1S 12
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x50:
	__CPD2N 0x3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x51:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Put_In_Log

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(_Mode*2)
	LDI  R31,HIGH(_Mode*2)
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x53:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	ST   -Y,R27
	ST   -Y,R26
	CALL _PARS_StrToUchar
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 12
	__GETD2S 12
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	MOV  R30,R19
	SUBI R30,-LOW(3)
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	MOV  R30,R19
	SUBI R30,-LOW(4)
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__POINTW2MN _RAM_settings,4
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x59:
	CALL _PARS_StrToUchar
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 12
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	__POINTW2MN _RAM_settings,6
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	__POINTW2MN _RAM_settings,10
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	ST   -Y,R27
	ST   -Y,R26
	CALL _PARS_StrToUint
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
	MOVW R30,R28
	ADIW R30,6
	RJMP SUBOPT_0x51

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x5E:
	MOV  R30,R17
	LDI  R26,LOW(_MainTimer_G001)
	LDI  R27,HIGH(_MainTimer_G001)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(_Idle)
	LDI  R31,HIGH(_Idle)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
	CPI  R16,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	MOVW R26,R30
	LDI  R30,LOW(_Idle)
	LDI  R31,HIGH(_Idle)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x63:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x64:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x65:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x66:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x67:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	__GETD1S 2
	__GETD2S 8
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x1B
	.equ __w1_bit=0x02

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE: