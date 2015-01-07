
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
;Automatic register allocation : Off

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
	JMP  _timer1_ovf_isr
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
_rad2Image:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x80,0xC0,0xE0,0xF0
	.DB  0xF8,0xF8,0xFC,0xFC,0xFE,0xFE,0xFF,0xFF
	.DB  0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0xC0,0xE0
	.DB  0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFE,0xFE
	.DB  0xFC,0xFC,0xF8,0xF8,0xF0,0xE0,0xC0,0x80
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
	.DB  0x0,0x0,0x0,0x0,0x70,0x88,0x70,0x50
	.DB  0x88,0x70,0x0,0xC8,0xA8,0x90,0x0,0x70
	.DB  0x88,0x70,0x0,0x10,0xF8,0x0,0x70,0x88
	.DB  0x70,0x0,0xC,0xE,0x1F,0x1F,0x1F,0x3F
	.DB  0x3F,0x3F,0x3F,0x7F,0x7F,0x7F,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x7F
	.DB  0x7F,0x3F,0x3F,0x3F,0x3F,0x1F,0x1F,0x1F
	.DB  0xE,0xC,0x0,0x0,0x0,0xF0,0x28,0xF0
	.DB  0x0,0xF8,0x20,0xF8,0x0,0xF8,0xA8,0x88
	.DB  0x0,0x88,0xF8,0x88,0x0,0xF8,0x48,0xB0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;DATA STACK END MARKER INITIALIZATION
__DSTACK_END_INIT:
	.DB  'D','S','T','A','C','K','E','N','D',0

;HARDWARE STACK END MARKER INITIALIZATION
__HSTACK_END_INIT:
	.DB  'H','S','T','A','C','K','E','N','D',0

_0x3:
	.DB  0xFF
_0xE:
	.DB  0x3
_0xF:
	.DB  0x3
_0x10:
	.DB  0x46
_0x11:
	.DB  0x2
_0x14E:
	.DB  0xC8
_0x178:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x179:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x17A:
	.DB  LOW(_DoNothing),HIGH(_DoNothing)
_0x0:
	.DB  0x70,0x6F,0x72,0x66,0x0,0x65,0x78,0x74
	.DB  0x72,0x66,0x0,0x62,0x6F,0x72,0x66,0x0
	.DB  0x77,0x64,0x72,0x66,0x0,0x4A,0x54,0x52
	.DB  0x46,0x0,0xD,0x3C,0x52,0x41,0x4D,0x3E
	.DB  0x0,0xD,0x55,0x41,0x52,0x54,0x5F,0x53
	.DB  0x45,0x54,0x54,0x49,0x4E,0x47,0x53,0xD
	.DB  0x0,0x55,0x41,0x52,0x54,0x20,0x0,0xD
	.DB  0x20,0x4D,0x6F,0x64,0x65,0x20,0x0,0xD
	.DB  0x20,0x53,0x70,0x65,0x65,0x64,0x20,0x0
	.DB  0xD,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xD,0x0,0xD,0x53,0x50,0x49,0x5F
	.DB  0x53,0x45,0x54,0x54,0x49,0x4E,0x47,0x53
	.DB  0xD,0x0,0x53,0x50,0x49,0x20,0x0,0xD
	.DB  0x20,0x50,0x72,0x65,0x73,0x63,0x61,0x6C
	.DB  0x6C,0x65,0x72,0x20,0x0,0xD,0x3C,0x45
	.DB  0x45,0x50,0x52,0x4F,0x4D,0x3E,0x0,0xD
	.DB  0x42,0x75,0x74,0x65,0x73,0x5F,0x52,0x58
	.DB  0x20,0x0,0xD,0x42,0x75,0x74,0x65,0x73
	.DB  0x5F,0x54,0x58,0x20,0x0,0x54,0x61,0x73
	.DB  0x6B,0x33,0x5F,0x32,0x35,0x30,0x6D,0x73
	.DB  0xD,0xA,0x0,0x54,0x5F,0x4C,0x5F,0x54
	.DB  0xD,0xA,0x0,0x54,0x69,0x63,0x6B,0x3D
	.DB  0x25,0x69,0xA,0x0,0x4F,0x6C,0x6F,0x6C
	.DB  0x6F,0x3D,0x29,0x0,0xD,0x20,0x45,0x52
	.DB  0x52,0x5F,0x55,0x4E,0x44,0x45,0x46,0x5F
	.DB  0x46,0x4C,0x41,0x47,0x20,0x0,0xD,0x20
	.DB  0x53,0x65,0x74,0x0,0xD,0x20,0x55,0x61
	.DB  0x72,0x74,0x0,0xD,0x20,0x4E,0x75,0x6D
	.DB  0x0,0xD,0x20,0x4D,0x6F,0x64,0x65,0x0
	.DB  0xD,0x4D,0x20,0x45,0x58,0x49,0x54,0x0
	.DB  0xD,0x20,0x0,0xD,0x20,0x55,0x61,0x72
	.DB  0x74,0x5F,0x69,0x6E,0x69,0x74,0x0,0xD
	.DB  0x20,0x53,0x70,0x69,0x0,0xD,0x53,0x20
	.DB  0x4E,0x75,0x6D,0x0,0xD,0x53,0x20,0x4D
	.DB  0x6F,0x64,0x65,0x2D,0x0,0xD,0x53,0x20
	.DB  0x50,0x72,0x65,0x73,0x63,0x2D,0x0,0xD
	.DB  0x53,0x20,0x50,0x68,0x61,0x50,0x6F,0x6C
	.DB  0x2D,0x0,0xD,0x53,0x20,0x53,0x70,0x69
	.DB  0x49,0x6E,0x69,0x74,0x0,0xD,0x20,0x49
	.DB  0x32,0x63,0x0,0xD,0x20,0x49,0x32,0x63
	.DB  0x5F,0x69,0x6E,0x69,0x74,0x0,0xD,0x20
	.DB  0x57,0x0,0xD,0x20,0x55,0x20,0x44,0x3E
	.DB  0x54,0x58,0x20,0x0,0xD,0x20,0x53,0x20
	.DB  0x44,0x3E,0x54,0x58,0x20,0x0,0xD,0x20
	.DB  0x53,0x20,0x44,0x3C,0x52,0x58,0x20,0x0
	.DB  0xD,0x20,0x49,0x32,0x43,0x20,0x44,0x3E
	.DB  0x54,0x58,0x20,0x0,0xD,0x20,0x49,0x32
	.DB  0x43,0x20,0x44,0x3C,0x52,0x58,0x20,0x0
	.DB  0x79,0x0,0x6E,0x0,0x61,0x0,0x73,0x0
	.DB  0x45,0x0
_0x20003:
	.DB  0x1
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  __SRAM_START
	.DW  __DSTACK_END_INIT*2

	.DW  0x09
	.DW  0x10EC
	.DW  __HSTACK_END_INIT*2

	.DW  0x01
	.DW  _temp_control
	.DW  _0xE*2

	.DW  0x01
	.DW  _bias
	.DW  _0xF*2

	.DW  0x01
	.DW  _Vop
	.DW  _0x10*2

	.DW  0x01
	.DW  _disp_config
	.DW  _0x11*2

	.DW  0x01
	.DW  _d
	.DW  _0x14E*2

	.DW  0x02
	.DW  _MasterOutFunc
	.DW  _0x178*2

	.DW  0x02
	.DW  _SlaveOutFunc
	.DW  _0x179*2

	.DW  0x02
	.DW  _ErrorOutFunc
	.DW  _0x17A*2

	.DW  0x05
	.DW  _0x1C2
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x1C2+5
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x1C2+11
	.DW  _0x0*2+11

	.DW  0x05
	.DW  _0x1C2+16
	.DW  _0x0*2+16

	.DW  0x05
	.DW  _0x1C2+21
	.DW  _0x0*2+21

	.DW  0x07
	.DW  _0x1CB
	.DW  _0x0*2+26

	.DW  0x10
	.DW  _0x1CB+7
	.DW  _0x0*2+33

	.DW  0x06
	.DW  _0x1CB+23
	.DW  _0x0*2+49

	.DW  0x08
	.DW  _0x1CB+29
	.DW  _0x0*2+55

	.DW  0x09
	.DW  _0x1CB+37
	.DW  _0x0*2+63

	.DW  0x0B
	.DW  _0x1CB+46
	.DW  _0x0*2+72

	.DW  0x0F
	.DW  _0x1CB+57
	.DW  _0x0*2+83

	.DW  0x05
	.DW  _0x1CB+72
	.DW  _0x0*2+98

	.DW  0x08
	.DW  _0x1CB+77
	.DW  _0x0*2+55

	.DW  0x0E
	.DW  _0x1CB+85
	.DW  _0x0*2+103

	.DW  0x0B
	.DW  _0x1CB+99
	.DW  _0x0*2+72

	.DW  0x0A
	.DW  _0x1D2
	.DW  _0x0*2+117

	.DW  0x10
	.DW  _0x1D2+10
	.DW  _0x0*2+33

	.DW  0x06
	.DW  _0x1D2+26
	.DW  _0x0*2+49

	.DW  0x08
	.DW  _0x1D2+32
	.DW  _0x0*2+55

	.DW  0x09
	.DW  _0x1D2+40
	.DW  _0x0*2+63

	.DW  0x0B
	.DW  _0x1D2+49
	.DW  _0x0*2+72

	.DW  0x0F
	.DW  _0x1D2+60
	.DW  _0x0*2+83

	.DW  0x05
	.DW  _0x1D2+75
	.DW  _0x0*2+98

	.DW  0x08
	.DW  _0x1D2+80
	.DW  _0x0*2+55

	.DW  0x0E
	.DW  _0x1D2+88
	.DW  _0x0*2+103

	.DW  0x0B
	.DW  _0x1D2+102
	.DW  _0x0*2+72

	.DW  0x0B
	.DW  _0x1D9
	.DW  _0x0*2+127

	.DW  0x0B
	.DW  _0x1D9+11
	.DW  _0x0*2+138

	.DW  0x0E
	.DW  _0x1EA
	.DW  _0x0*2+149

	.DW  0x08
	.DW  _0x1EB
	.DW  _0x0*2+163

	.DW  0x08
	.DW  _0x1EB+8
	.DW  _0x0*2+180

	.DW  0x12
	.DW  _0x1F6
	.DW  _0x0*2+188

	.DW  0x06
	.DW  _0x216
	.DW  _0x0*2+206

	.DW  0x07
	.DW  _0x216+6
	.DW  _0x0*2+212

	.DW  0x06
	.DW  _0x216+13
	.DW  _0x0*2+219

	.DW  0x07
	.DW  _0x216+19
	.DW  _0x0*2+225

	.DW  0x08
	.DW  _0x216+26
	.DW  _0x0*2+232

	.DW  0x03
	.DW  _0x216+34
	.DW  _0x0*2+240

	.DW  0x08
	.DW  _0x216+37
	.DW  _0x0*2+232

	.DW  0x0C
	.DW  _0x216+45
	.DW  _0x0*2+243

	.DW  0x06
	.DW  _0x216+57
	.DW  _0x0*2+255

	.DW  0x07
	.DW  _0x216+63
	.DW  _0x0*2+261

	.DW  0x09
	.DW  _0x216+70
	.DW  _0x0*2+268

	.DW  0x0A
	.DW  _0x216+79
	.DW  _0x0*2+277

	.DW  0x0B
	.DW  _0x216+89
	.DW  _0x0*2+287

	.DW  0x0B
	.DW  _0x216+100
	.DW  _0x0*2+298

	.DW  0x06
	.DW  _0x216+111
	.DW  _0x0*2+309

	.DW  0x06
	.DW  _0x216+117
	.DW  _0x0*2+219

	.DW  0x07
	.DW  _0x216+123
	.DW  _0x0*2+225

	.DW  0x08
	.DW  _0x216+130
	.DW  _0x0*2+232

	.DW  0x03
	.DW  _0x216+138
	.DW  _0x0*2+240

	.DW  0x08
	.DW  _0x216+141
	.DW  _0x0*2+232

	.DW  0x0B
	.DW  _0x216+149
	.DW  _0x0*2+315

	.DW  0x04
	.DW  _0x216+160
	.DW  _0x0*2+326

	.DW  0x0A
	.DW  _0x216+164
	.DW  _0x0*2+330

	.DW  0x0A
	.DW  _0x216+174
	.DW  _0x0*2+340

	.DW  0x0A
	.DW  _0x216+184
	.DW  _0x0*2+350

	.DW  0x0C
	.DW  _0x216+194
	.DW  _0x0*2+360

	.DW  0x0C
	.DW  _0x216+206
	.DW  _0x0*2+372

	.DW  0x01
	.DW  _timers_cnt_tail_G001
	.DW  _0x20003*2

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
;                       /*****************************************************
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
;//#include "my_debug.h"     //Upd-8 in folder
;
;
;#include "D_Globals/global_defines.h"     //Upd-8 in folder
;#include "D_Globals/global_variables.h"   //Upd-8 in folder

	.DSEG
;#include "D_usart/usart.h"
;#include "RTOS/EERTOS.h"
;#include "RTOS/EERTOSHAL.h"
;#include "D_Tasks/task_list.h"
;
;#define LogBufSize 512 //������ ������� ��� �����
;static volatile char WorkLog[LogBufSize];
;static volatile uint16_t LogIndex = 0;
;
;/////// ���������� �����.
;//����� ���� ������ ��������� �������� � ����� ������, � �����.
;//�� ��������� ������ ����� UART �� ����
;
;void WorkLogPutChar(unsigned char symbol)
; 0000 000F {

	.CSEG
_WorkLogPutChar:
;__disable_interrupts();
;	symbol -> Y+0
	IN   R30,0x3F
	STS  _saved_state_G000,R30
	cli
;if (LogIndex <LogBufSize)            // ���� ��� �� ����������
	CALL SUBOPT_0x0
	BRSH _0x7
;{
;        WorkLog[LogIndex]= symbol;    // ����� ������ � ���
	CALL SUBOPT_0x1
	LD   R26,Y
	CALL SUBOPT_0x2
;        LogIndex++;
;}
; __restore_interrupts();
_0x7:
	CALL SUBOPT_0x3
;}
	ADIW R28,1
	RET
;
;void Put_In_LogFl (unsigned char __flash* data){
;  while(*data)
;	*data -> Y+0
;  {
;    WorkLogPutChar(*data++);
;  }
;}
;
;//#warning  -�������� ����� ������� ����� ����������� \r\n ��� �������� ���
;void Put_In_Log (unsigned char * data)
;{
_Put_In_Log:
;  while(*data)
;	*data -> Y+0
_0xB:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xD
;  {
;    WorkLogPutChar(*data++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _WorkLogPutChar
;  }
	RJMP _0xB
_0xD:
;  /// WorkLogPutChar(10);//\r
;   //WorkLogPutChar(13);//\n
;}
	RJMP _0x20C000C
;
;void LogOut(void)				// ������ �����
;{
_LogOut:
;StopRTOS();
	CALL _StopRTOS
;
;WorkLog[LogIndex]= '+';
	CALL SUBOPT_0x1
	LDI  R26,LOW(43)
	CALL SUBOPT_0x2
;LogIndex++;
;USART_Send_Str(SYSTEM_USART, WorkLog);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_WorkLog_G000)
	LDI  R31,HIGH(_WorkLog_G000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _USART_Send_Str
;
;RunRTOS();
	CALL _RunRTOS
;
;FLAG_SET(g_tcf, FLUSH_WORKLOG);//SetTimerTask(Task_Flush_WorkLog,25,0);//������� ��� �������
	CALL SUBOPT_0x4
	ORI  R30,4
	CALL SUBOPT_0x5
;LogIndex = 0;
	LDI  R30,LOW(0)
	STS  _LogIndex_G000,R30
	STS  _LogIndex_G000+1,R30
;}
	RET
;
;void Timer_3_start(void)
;{
;   TCCR3B =(1<<CS31)|(1<<CS30);//presc = 64
;//TIMSK |=0x04; //Tim1 ovrflow Interrupt  ON
;}
;
;void Timer_3_stop(void)
;{
;ICR3H=0x00;     ICR3L=0x00;
;OCR3AH=0x00;    OCR3AL=0x00;
;OCR3BH=0x00;    OCR3BL=0x00;
;OCR3CH=0x00;    OCR3CL=0x00;
;TCNT3H=0x00;    TCNT3L=0x00;
;TCCR3A=0x00;    TCCR3B==0x00;
;//TIMSK &=~0x04; //Tim1 ovrflow Interrupt  OFF
;}
;
;uint16_t Timer_3_get_val (void)
;{
;uint16_t val = 0;
;//__disable_interrupts();
; val = TCNT3H;
;	val -> R16,R17
;//__restore_interrupts();
;return val;
;}
;/////////////
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
;#warning - ��������� � �������
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
;uint8_t temp_control = 3;  	//������������� �����������, 0..3

	.DSEG
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
;void LcdTextBufClean (void);							//������� ���������� ������
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
;  #warning a lot of nulls -need to compressed!
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
;0x7E, 0x11, 0x11, 0x11, 0x7E,// C0 �
;0x7F, 0x49, 0x49, 0x49, 0x31,// C1 �
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
;        {

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
	BREQ _0x14
	SBI  0x1B,0
;         else LCD_DC_PORT.LCD_DC_PIN = 0;
	RJMP _0x17
_0x14:
	CBI  0x1B,0
;
;        #ifdef SOFT_SPI
;        for (i=0;i<8;i++)
_0x17:
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,8
	BRSH _0x1C
;          {
;            	if ((data&mask)!=0) LCD_MOSI_PORT.LCD_MOSI_PIN = 1;
	MOV  R30,R16
	LDD  R26,Y+3
	AND  R30,R26
	BREQ _0x1D
	SBI  0x1B,3
;                else LCD_MOSI_PORT.LCD_MOSI_PIN = 0;
	RJMP _0x20
_0x1D:
	CBI  0x1B,3
;        	mask = mask/2;
_0x20:
	LSR  R16
;        	LCD_CLK_PORT.LCD_CLK_PIN = 1;
	SBI  0x1B,4
;            LCD_CLK_PORT.LCD_CLK_PIN = 0;
	CBI  0x1B,4
;          }
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
;        #endif
;
;        #ifndef SOFT_SPI
;        SPDR = data;                            //Send data to display controller
;        while ( (SPSR & 0x80) != 0x80 ){};        //Wait until Tx register empty
;        #endif
;
;        LCD_CPORT.LCD_CPIN = 1;                //Disable display controller
	SBI  0x1B,1
;        }
	RJMP _0x20C000D
;
;#warning need 7.05ms(!) to execute
;void LcdUpdate (void)   //Copies the LCD cache into the device RAM
;        {
_LcdUpdate:
;        int i;
;	#ifdef china
;	char j;
;	#endif
;
;        LcdSend(0x80, LCD_CMD);		//������� ��������� ��������� ������ ������� �� 0,0
	CALL SUBOPT_0x6
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;
;    #ifdef china                    		//���� ��������� ������� - ������ ������ ������
;		for (j = Cntr_X_RES; j>0; j--) LcdSend(0, LCD_DATA);
;	#endif
;
;        for (i = 0; i < LCD_CACHSIZE; i++)		//������ ������
_0x2A:
	__CPWRN 16,17,504
	BRGE _0x2B
;                {
;                LcdSend(LcdCache[i], LCD_DATA);
	LDI  R26,LOW(_LcdCache)
	LDI  R27,HIGH(_LcdCache)
	ADD  R26,R16
	ADC  R27,R17
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
	RJMP _0x2A
_0x2B:
;        }
	RJMP _0x20C000E
;
;void LcdClear (void)    //Clears the display
;{
_LcdClear:
;        int i;
;	for (i = 0; i < LCD_CACHSIZE; i++) LcdCache[i] = 0;	//�������� ��� ������ 0
	CALL SUBOPT_0x7
;	i -> R16,R17
_0x2D:
	__CPWRN 16,17,504
	BRGE _0x2E
	LDI  R26,LOW(_LcdCache)
	LDI  R27,HIGH(_LcdCache)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x2D
_0x2E:
	RCALL _LcdUpdate
;}
_0x20C000E:
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
	CALL SUBOPT_0x8
;        	#ifndef SOFT_SPI
;        //SPCR = SPCR_val;
;        //SPSR = SPSR_val;
;        	#endif
;        LCD_RST_PORT.LCD_RST_PIN = 0;       //������� �����
	CBI  0x1B,2
;        delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x8
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
	CALL SUBOPT_0x9
;        LcdSend( 0b00000100+temp_control, LCD_CMD ); 	//Set Temp coefficent   //! �� 128 - ������
	LDS  R30,_temp_control
	SUBI R30,-LOW(4)
	CALL SUBOPT_0x9
;#ifdef china
;        LcdSend( 0b00001000|SPI_invert<<3, LCD_CMD ); 	//������� ����� � SPI
;#endif
;        LcdSend( 0b00010000+bias, LCD_CMD ); 			//LCD bias mode 1:48
	LDS  R30,_bias
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x9
;#ifdef china
;        LcdSend( 0b01000000+shift, LCD_CMD ); 			//������ ������ ���� ������, ���������� �� ������
;#endif
;	    LcdSend( 0b10000000+Vop, LCD_CMD ); 			//Set LCD Vop (Contrast)
	LDS  R30,_Vop
	SUBI R30,-LOW(128)
	CALL SUBOPT_0x9
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
	CALL SUBOPT_0x9
;#endif
;        LcdSend( 0b00001000|((disp_config<<1|disp_config)&0b00000101), LCD_CMD ); 	//LCD mode
	LDS  R30,_disp_config
	LSL  R30
	LDS  R26,_disp_config
	OR   R30,R26
	ANDI R30,LOW(0x5)
	ORI  R30,8
	CALL SUBOPT_0x9
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
	CALL SUBOPT_0x6
;	*imageData -> Y+2
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;        for (i = 0; i < LCD_CACHSIZE; i++) LcdCache[i] = imageData[i];	//������ ������
_0x46:
	__CPWRN 16,17,504
	BRSH _0x47
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
	RJMP _0x46
_0x47:
_0x20C000D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
; void LcdImageRam (unsigned char *imageData)	//����� �����������
;        {
;        unsigned int i;
;
;        LcdSend(0x80, LCD_CMD);		//������ ��������� �� 0,0
;	*imageData -> Y+2
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;        for (i = 0; i < LCD_CACHSIZE; i++) LcdCache[i] = imageData[i];	//������ ������
;
;
;void LcdPixel (unsigned char x, unsigned char y, unsigned char mode)     //Displays a pixel at given absolute (x, y) location, mode -> Off, On or Xor
;        {
;        int index;
;        unsigned char offset, data;
;
;        if ( x > LCD_X_RES ) return;	//���� �������� � ������� ���� - �������
;	x -> Y+6
;	y -> Y+5
;	mode -> Y+4
;	index -> R16,R17
;	offset -> R19
;	data -> R18
;        if ( y > LCD_Y_RES ) return;
;
;        index = (((int)(y)/8)*84)+x;    //������� ����� ����� � ������� ������ �������
;        offset  = y-((y/8)*8);          //������� ����� ���� � ���� �����
;
;        data = LcdCache[index];         //����� ���� �� ���������� �������
;
;        if ( mode == PIXEL_OFF ) data &= ( ~( 0x01 << offset ) );	//����������� ��� � ���� �����
;                else if ( mode == PIXEL_ON ) data |= ( 0x01 << offset );
;                        else if ( mode  == PIXEL_XOR ) data ^= ( 0x01 << offset );
;
;        LcdCache[index] = data;		//��������� ���� �����
;        }
;
;void LcdLine (int x1, int y1, int x2, int y2, unsigned char mode)  	//Draws a line between two points on the display - �� �����������
;        {
;        signed int dy = 0;
;        signed int dx = 0;
;        signed int stepx = 0;
;        signed int stepy = 0;
;        signed int fraction = 0;
;
;        if (x1>LCD_X_RES || x2>LCD_X_RES || y1>LCD_Y_RES || y2>LCD_Y_RES) return;
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
;
;        dy = y2 - y1;
;        dx = x2 - x1;
;        if (dy < 0)
;                {
;                dy = -dy;
;                stepy = -1;
;                }
;                else stepy = 1;
;        if (dx < 0)
;                {
;                dx = -dx;
;                stepx = -1;
;                }
;                else stepx = 1;
;        dy <<= 1;
;        dx <<= 1;
;        LcdPixel(x1,y1,mode);
;        if (dx > dy)
;                {
;                fraction = dy - (dx >> 1);
;                while (x1 != x2)
;                   {
;                        if (fraction >= 0)
;                                {
;                                y1 += stepy;
;                                fraction -= dx;
;                                }
;                        x1 += stepx;
;                        fraction += dy;
;                        LcdPixel(x1,y1,mode);
;                   }
;                }
;                else
;                        {
;                        fraction = dx - (dy >> 1);
;                        while (y1 != y2)
;                                {
;                                if (fraction >= 0)
;                                        {
;                                        x1 += stepx;
;                                        fraction -= dy;
;                                        }
;                                y1 += stepy;
;                                fraction += dx;
;                                LcdPixel(x1,y1,mode);
;                                }
;                        }
;        }
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
;}  */
;
;/*
; * ��� : LcdRect
; * �������� : ������ ������������� �������������
; * ��������(�) : x1 -> ���������� ���������� x ������ �������� ����
; * y1 -> ���������� ���������� y ������ �������� ����
; * x2 -> ���������� ���������� x ������� ������� ����
; * y2 -> ���������� ���������� y ������� ������� ����
; * mode -> Off, On ��� Xor. ������ enum � n3310.h
; * ������������ �������� : ������ ������������ �������� � n3310lcd.h
; */
;
; /*
;byte LcdRect ( byte x1, byte y1, byte x2, byte y2, LcdPixelMode mode )    //not tested!
;{
;byte tmpIdx;
;
;// �������� ������
;if ( ( x1 >= LCD_X_RES) || ( x2 >= LCD_X_RES) || ( y1 >= LCD_Y_RES) || ( y2 >= LCD_Y_RES) )
;return OUT_OF_BORDER;
;
;if ( ( x2 > x1 ) && ( y2 > y1 ) )
;{
;// ������ �������������� �����
;for ( tmpIdx = x1; tmpIdx <= x2; tmpIdx++ )
;{
;LcdPixel( tmpIdx, y1, mode );
;LcdPixel( tmpIdx, y2, mode );
;}
;
;// ������ ������������ �����
;for ( tmpIdx = y1; tmpIdx <= y2; tmpIdx++ )
;{
;LcdPixel( x1, tmpIdx, mode );
;LcdPixel( x2, tmpIdx, mode );
;}
;
;// ��������� ����� ��������� ����
;UpdateLcd = TRUE;
;}
;return OK;
;}
;
;
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
	BRSH _0x74
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRLO _0x75
_0x74:
	RJMP _0x73
_0x75:
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
	STS  _LcdCacheIdx,R30
	STS  _LcdCacheIdx+1,R31
;        }
_0x73:
_0x20C000C:
	ADIW R28,2
	RET
;
;void LcdTextBufClean (void)	//������� ���������� ������
;	{
_LcdTextBufClean:
;	char i;
;	for (i=0; i<14; i++) lcd_buf[i] = 0;
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x77:
	CPI  R17,14
	BRSH _0x78
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0x77
_0x78:
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
_0x7A:
	CPI  R17,5
	BRSH _0x7B
	CALL SUBOPT_0xB
	MOVW R22,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12
	MOVW R26,R30
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_table*2)
	SBCI R31,HIGH(-_table*2)
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	SUBI R17,-1
	RJMP _0x7A
_0x7B:
	CALL SUBOPT_0xB
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 	}
	LDD  R17,Y+0
	RJMP _0x20C000A
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
	BRSH _0x80
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRLO _0x7F
_0x80:
	LDD  R17,Y+0
	RJMP _0x20C000A
;	LcdGotoXYFont (x, y);
_0x7F:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _LcdGotoXYFont
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChr (lcd_buf[i]);
	LDI  R17,LOW(0)
_0x83:
	LDD  R26,Y+2
	LDI  R30,LOW(15)
	SUB  R30,R26
	CP   R17,R30
	BRSH _0x84
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x85
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	LD   R30,Z
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LcdChr
;	LcdTextBufClean();
_0x85:
	SUBI R17,-1
	RJMP _0x83
_0x84:
	RCALL _LcdTextBufClean
;	}
	LDD  R17,Y+0
	RJMP _0x20C000A
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
;	LcdTextBufClean();
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
;	LcdTextBufClean();
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
;	LcdTextBufClean();
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
;/*
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
; */
;
; flash unsigned char rad1Image[] = {
;  12,  0,  1,128,  1,192,  1,224,  1,240,  2,248,
;  2,252,  2,254,  2,255,  1,254,  1,252,  1,248,
;  1,240,  1,224,  1,192,  1,128, 22,  0,  1,128,
;  1,192,  1,224,  1,240,  1,248,  1,252,  1,254,
;  2,255,  3,254,  1,252,  2,248,  1,240,  1,224,
;  1,192,  1,128, 20,  0,  1,224,  1,248,  1,254,
; 21,255,  1,254,  1,252,  1,248,  1,240,  1,224,
;  1, 64,  8,  0,  1, 64,  1,224,  1,240,  1,248,
;  1,252,  1,254, 21,255,  1,254,  1,248,  1,224,
; 14,  0,  1,120, 25,127,  1, 15,  1,  3,  1,  1,
;  1,240,  1,248,  2,252,  6,254,  2,252,  1,248,
;  1,240,  1,  1,  1,  3,  1, 15, 25,127,  1,120,
; 39,  0,  1,128,  1,192,  1,225,  1,227,  1,231,
;  1,199,  1,207,  4,143,  1,207,  1,199,  1,231,
;  1,227,  1,225,  1,192,  1,128, 58,  0,  1,128,
;  1,192,  1,224,  1,240,  1,248,  1,252,  1,254,
; 20,255,  1,254,  1,252,  1,248,  1,240,  1,224,
;  1,192,  1,128, 47,  0,  1, 12,  1, 14,  3, 31,
;  4, 63,  3,127, 16,255,  3,127,  4, 63,  3, 31,
;  1, 14,  1, 12, 22,  0};
;
;
;
;
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
;//***************************************************************************
;//
;//  Author(s)...: Pashgan    http://ChipEnable.Ru
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
;
;void UartTxBufOvf_Handler(void) //���������� ������������ ����������� ������ UART
;{
_UartTxBufOvf_Handler:
;    PORTD.7=1;
	SBI  0x12,7
;}
	RET
;
;
;uint16_t Calk_safe_baud(uint8_t mode, uint16_t input_baud)   //�������� ����������� ����� �� ������� ��������
;{
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
; if(tmp1 > max_total_err){tmp1 = 48;} //��� ������� ������������� ������ �������� (>2.1%) - �������� ����� 4800baud (�� �������� ������ �� ����� ��������)
; else {tmp1 = input_baud;} //���� �� ��, ������� �������� ��������
;return tmp1;
;}
;
;
; void USART_Init (uint8_t sel, uint8_t mode, uint16_t baudRate) //������������� usart`a
;{
_USART_Init:
;uint16_t ubrrValue;
;#warning �������� ���� ��������� ����������� baudRate!
;__disable_interrupts();
	ST   -Y,R17
	ST   -Y,R16
;	sel -> Y+5
;	mode -> Y+4
;	baudRate -> Y+2
;	ubrrValue -> R16,R17
	IN   R30,0x3F
	STS  _saved_state_G000,R30
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
;
; if (mode == USART_NORMAL)
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0xAA
; {
;   ubrrValue = (F_CPU+8UL*baudRate)/(16UL*baudRate) - 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	__ADDD1N 16000000
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	__GETD2N 0x10
	CALL __MULD12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RJMP _0x278
; }    //Upd-12
;  else
_0xAA:
;  {
;    ubrrValue = (F_CPU+4UL*baudRate)/(8UL*baudRate) - 1; //doubles speed
	CALL SUBOPT_0xC
	MOVW R0,R30
	MOVW R24,R22
	CALL __LSLD1
	CALL __LSLD1
	__ADDD1N 16000000
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R0
	MOVW R22,R24
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x278:
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
;  } //Upd-12
;
;
;if(sel==USART_0)    //for USART_0
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0xAC
;{
;  Usart0_txBufTail = 0;  Usart0_txBufHead = 0;
	LDI  R30,LOW(0)
	STS  _Usart0_txBufTail_G000,R30
	STS  _Usart0_txBufTail_G000+1,R30
	CALL SUBOPT_0xE
;  Usart0_rxBufTail = 0;  Usart0_rxBufHead = 0;
	STS  _Usart0_rxBufTail_G000,R30
	STS  _Usart0_rxBufTail_G000+1,R30
	LDI  R30,LOW(0)
	STS  _Usart0_rxBufHead_G000,R30
	STS  _Usart0_rxBufHead_G000+1,R30
;  Usart0_rxCount = 0;
	STS  _Usart0_rxCount_G000,R30
	STS  _Usart0_rxCount_G000+1,R30
;  UCSR0A = 0; // USART0 disabled
	OUT  0xB,R30
;  UCSR0B = 0;  UCSR0C = 0;
	OUT  0xA,R30
	STS  149,R30
;
;    if (mode != USART_NORMAL){ UCSR0A = (1<<U2X0);}//doubles speed  //Upd-12
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0xAD
	LDI  R30,LOW(2)
	OUT  0xB,R30
;
;  // Communication Parameters: 8 Data, 1 Stop, No Parity
;  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
;  UBRR0H = (uint8_t)(ubrrValue >> 8);
_0xAD:
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
;else             //for USART_1
	RJMP _0xAE
_0xAC:
;{
;  Usart1_txBufTail = 0;  Usart1_txBufHead = 0;
	LDI  R30,LOW(0)
	STS  _Usart1_txBufTail_G000,R30
	STS  _Usart1_txBufTail_G000+1,R30
	CALL SUBOPT_0xF
;  Usart1_rxBufTail = 0;  Usart1_rxBufHead = 0;
	STS  _Usart1_rxBufTail_G000,R30
	STS  _Usart1_rxBufTail_G000+1,R30
	LDI  R30,LOW(0)
	STS  _Usart1_rxBufHead_G000,R30
	STS  _Usart1_rxBufHead_G000+1,R30
;  Usart1_rxCount = 0;
	STS  _Usart1_rxCount_G000,R30
	STS  _Usart1_rxCount_G000+1,R30
;  UCSR1A = 0;  // USART1 disabled
	STS  155,R30
;  UCSR1B = 0;  UCSR1C = 0;
	STS  154,R30
	STS  157,R30
;
;    if (mode != USART_NORMAL) { UCSR1A = (1<<U2X1);}//doubles speed
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0xAF
	LDI  R30,LOW(2)
	STS  155,R30
;
;  // Communication Parameters: 8 Data, 1 Stop, No Parity
;  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
;  UBRR1H = (uint8_t)(ubrrValue >> 8);
_0xAF:
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
_0xAE:
;__restore_interrupts();
	CALL SUBOPT_0x3
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000B
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
;__disable_interrupts();
;	sel -> Y+0
;v_u32_TX_CNT=0;
;
; switch (sel)
; {
;   case USART_0:
;Usart_0_flush:
;  Usart0_txBufTail = 0;
;  Usart0_txBufHead = 0;
;   break;
;   case USART_1:
;  Usart1_txBufTail = 0;
;  Usart1_txBufHead = 0;
;   break;
;     default:
; goto Usart_0_flush;
;   break;
;}
;__restore_interrupts();
;}
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
	BRNE _0xBD
; Usart_0:
_0xBE:
;       // if(((UCSR0A & (1<<UDRE0)) == 1)) {UDR0 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
;       //  else {                                                           //����� ������ ����� � ������� UDR
;               if((uint16_t)(Tmp_0 - Usart0_txBufTail ) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
	LDS  R26,_Usart0_txBufTail_G000
	LDS  R27,_Usart0_txBufTail_G000+1
	MOVW R30,R16
	CALL SUBOPT_0x10
	BRSH _0xBF
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
	STS  _saved_state_G000,R30
	cli
;               Usart0_txBufHead = Tmp_0;
	__PUTWMRN _Usart0_txBufHead_G000,0,16,17
;               UCSR0B |= (1 << UDRIE0);
	SBI  0xA,5
;               } else {UartTxBufOvf_Handler();} //if TX buf ovverflowed, go to ovrf handler
	RJMP _0xC3
_0xBF:
	RCALL _UartTxBufOvf_Handler
_0xC3:
;         //    }
;   break;
	RJMP _0xBC
;   case USART_1:
_0xBD:
	CPI  R30,LOW(0x1)
	BRNE _0xCA
;      //  if(((UCSR1A & (1<<UDRE1)) == 1)) {UDR1 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
;       //  else {                                                           //����� ������ ����� � ������� UDR
;               if((uint16_t)(Tmp_1 - Usart1_txBufTail) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
	LDS  R26,_Usart1_txBufTail_G000
	LDS  R27,_Usart1_txBufTail_G000+1
	MOVW R30,R18
	CALL SUBOPT_0x10
	BRSH _0xC5
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
	STS  _saved_state_G000,R30
	cli
;               Usart1_txBufHead = Tmp_1;
	__PUTWMRN _Usart1_txBufHead_G000,0,18,19
;               UCSR1B |= (1 << UDRIE1);
	LDS  R30,154
	ORI  R30,0x20
	STS  154,R30
;               }else {UartTxBufOvf_Handler();} //if TX buf ovverflowed, go to ovrf handler
	RJMP _0xC9
_0xC5:
	RCALL _UartTxBufOvf_Handler
_0xC9:
;          //   }
;   break;
	RJMP _0xBC
;     default:
_0xCA:
;     goto Usart_0;
	RJMP _0xBE
;     break;
; }
_0xBC:
; __restore_interrupts();
	CALL SUBOPT_0x3
;}
	CALL __LOADLOCR4
_0x20C000B:
	ADIW R28,6
	RET
;
;
;
;void USART_Send_Str(uint8_t sel, unsigned char * data)//������� ���������� ������ �� usart`�
;{
_USART_Send_Str:
;  while(*data)
;	sel -> Y+2
;	*data -> Y+0
_0xCB:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xCD
;  {
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
	RJMP _0xCB
_0xCD:
;}
	RJMP _0x20C000A
;
;void USART_Send_StrFl(uint8_t sel, unsigned char __flash * data) //������� ���������� ������ �� ����� �� usart`�
;{
_USART_Send_StrFl:
;  while(*data)
;	sel -> Y+2
;	*data -> Y+0
_0xCE:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xD0
;  {
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
	RJMP _0xCE
_0xD0:
;}
	RJMP _0x20C000A
;
;
;  //Optimised
;//���������� ���������� �� ���������� ��������
;interrupt [USART0_DRE] void usart0_dre_my(void)  //USART Data Register Empty Interrupt
;{
_usart0_dre_my:
	CALL SUBOPT_0x11
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
	BREQ _0xD1
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
;       else
	RJMP _0xD2
_0xD1:
;       {
;    // PORTD.7=0;
;         Usart0_txBufHead = 0; Usart0_txBufTail = 0;
	CALL SUBOPT_0xE
	STS  _Usart0_txBufTail_G000,R30
	STS  _Usart0_txBufTail_G000+1,R30
;        UCSR0B &= ~(1 << UDRIE0); // disable this int
	CBI  0xA,5
;       }
_0xD2:
;#ifdef DEBUG
;v_u32_TX_CNT++;
	LDI  R26,LOW(_v_u32_TX_CNT)
	LDI  R27,HIGH(_v_u32_TX_CNT)
	CALL SUBOPT_0x12
;#endif
;}
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x291
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
;
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
	CALL SUBOPT_0x13
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xD3
;       {
;       //PORTD.7=0;
;         Usart1_txBufHead = 0; Usart1_txBufTail = 0;
	CALL SUBOPT_0xF
	STS  _Usart1_txBufTail_G000,R30
	STS  _Usart1_txBufTail_G000+1,R30
;        UCSR1B &= ~(1 << UDRIE1); // disable this int
	LDS  R30,154
	ANDI R30,0xDF
	STS  154,R30
;       }
;#ifdef DEBUG
;//v_u32_TX_CNT++;
;#endif
;}
_0xD3:
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
;return  sel ? Usart1_rxCount : Usart0_rxCount;
;	sel -> Y+0
;}
;
;void USART_FlushRxBuf(uint8_t sel)//"�������" �������� �����
;{
;  // uint8_t saved_state;
;   v_u32_RX_CNT = 0;
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
;char USART_Get_Char(uint8_t Uart_sel) //������ ������
;{
;  unsigned char symbol;
;  uint8_t saved_state;
;if(!Uart_sel)
;	Uart_sel -> Y+2
;	symbol -> R17
;	saved_state -> R16
;{
;  if (Usart0_rxCount > 0)        //���� �������� ����� �� ������
;  {
;    symbol = Usart0_RX_buf[Usart0_rxBufHead];        //��������� �� ���� ������
;    Usart0_rxBufHead++;                        //���������������� ������ ������ ������
;    if (Usart0_rxBufHead == SIZE_BUF_RX) Usart0_rxBufHead = 0;
;__disable_interrupts();
;    Usart0_rxCount--;                          //��������� ������� ��������
;__restore_interrupts();
;    return symbol;                         //������� ����������� ������
;  }
;  return 0;
;}
;  else
;  {
;   if (Usart1_rxCount > 0)        //���� �������� ����� �� ������
;  {
;    symbol = Usart1_RX_buf[Usart1_rxBufHead];        //��������� �� ���� ������
;    Usart1_rxBufHead++;                        //���������������� ������ ������ ������
;    if (Usart1_rxBufHead == SIZE_BUF_RX) Usart1_rxBufHead = 0;
;__disable_interrupts();
;    Usart1_rxCount--;                          //��������� ������� ��������
;__restore_interrupts();
;    return symbol;                         //������� ����������� ������
;  }
;  return 0;
;  }
;}
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
;#warning ���������, ������������� �� ����� ���������� ��� ����� Tail � �� Head!
; interrupt [USART0_RXC] void usart0_rxc(void) //����������� �� ���������� �������
;{
_usart0_rxc:
	CALL SUBOPT_0x11
;char data;
;data =  UDR0;// read to clear RxC flag
;	data -> R17
	IN   R17,12
;    if (Usart0_rxCount < SIZE_BUF_RX) //���� � ����� �� � ����
	LDS  R26,_Usart0_rxCount_G000
	LDS  R27,_Usart0_rxCount_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0xE8
;    {
;       Usart0_RX_buf[Usart0_rxBufTail] = data;//������� ������ �� ������
	LDS  R30,_Usart0_rxBufTail_G000
	LDS  R31,_Usart0_rxBufTail_G000+1
	SUBI R30,LOW(-_Usart0_RX_buf_G000)
	SBCI R31,HIGH(-_Usart0_RX_buf_G000)
	ST   Z,R17
;      Usart0_rxBufTail++;                    //�������� ������ ���� ������
	LDI  R26,LOW(_Usart0_rxBufTail_G000)
	LDI  R27,HIGH(_Usart0_rxBufTail_G000)
	CALL SUBOPT_0x14
;      Usart0_rxCount++;
	LDI  R26,LOW(_Usart0_rxCount_G000)
	LDI  R27,HIGH(_Usart0_rxCount_G000)
	CALL SUBOPT_0x14
;#warning ��������� ������������� ���������� �����
;     if (Usart0_rxBufTail == SIZE_BUF_RX)
	LDS  R26,_Usart0_rxBufTail_G000
	LDS  R27,_Usart0_rxBufTail_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xE9
;      {
;       Usart0_rxBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart0_rxBufTail_G000,R30
	STS  _Usart0_rxBufTail_G000+1,R30
;      }
;    }
_0xE9:
;#ifdef DEBUG
;v_u32_RX_CNT++;
_0xE8:
	LDI  R26,LOW(_v_u32_RX_CNT)
	LDI  R27,HIGH(_v_u32_RX_CNT)
	CALL SUBOPT_0x12
;#endif
;}
	LD   R17,Y+
_0x291:
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
	CALL SUBOPT_0x15
;char data;//!
;data =  UDR1;//! read to clear RxC flag!
	ST   -Y,R17
;	data -> R17
	LDS  R17,156
;if(!U1_in_buf_flag)
	LDS  R30,_U1_in_buf_flag
	CPI  R30,0
	BRNE _0xEA
;  {
;    if (Usart1_rxCount < SIZE_BUF_RX) //���� � ������ ��� ���� �����
	LDS  R26,_Usart1_rxCount_G000
	LDS  R27,_Usart1_rxCount_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0xEB
;    {
;       Usart1_RX_buf[Usart1_rxBufTail] = data;//!    //������� ������  � �����
	LDS  R30,_Usart1_rxBufTail_G000
	LDS  R31,_Usart1_rxBufTail_G000+1
	SUBI R30,LOW(-_Usart1_RX_buf_G000)
	SBCI R31,HIGH(-_Usart1_RX_buf_G000)
	ST   Z,R17
;      Usart1_rxBufTail++;                    //��������� ������ ������ ��������� ������
	LDI  R26,LOW(_Usart1_rxBufTail_G000)
	LDI  R27,HIGH(_Usart1_rxBufTail_G000)
	CALL SUBOPT_0x14
;      Usart1_rxCount++;                      //��������� ������� �������� ��������
	LDI  R26,LOW(_Usart1_rxCount_G000)
	LDI  R27,HIGH(_Usart1_rxCount_G000)
	CALL SUBOPT_0x14
;#warning ��������� ������������� ���������� �����
;    if (Usart1_rxBufTail == SIZE_BUF_RX)
	LDS  R26,_Usart1_rxBufTail_G000
	LDS  R27,_Usart1_rxBufTail_G000+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0xEC
;      {
;       Usart1_rxBufTail = 0;
	LDI  R30,LOW(0)
	STS  _Usart1_rxBufTail_G000,R30
	STS  _Usart1_rxBufTail_G000+1,R30
;      }
;     }  //TODO - �������� ������� �� ���������� ������������ �������!
_0xEC:
;  }
_0xEB:
; else   //��� ����� - ������ � ����� ���������� ����� � ����� �� �����!
	RJMP _0xED
_0xEA:
; {      //�������� ����� ��������� ������ ������ �����! ��������!
;    if((uint16_t)(Usart1_txBufHead - Usart1_txBufTail) <= (uint16_t) SIZE_BUF_TX) //���� � ������ ��� ���� �����
	LDS  R26,_Usart1_txBufTail_G000
	LDS  R27,_Usart1_txBufTail_G000+1
	CALL SUBOPT_0x13
	CALL SUBOPT_0x10
	BRSH _0xEE
;    {
;      Usart0_TX_buf[Usart1_txBufHead & (SIZE_BUF_TX - 1)] = data;//!    //������� ������  � �����
	CALL SUBOPT_0x13
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_Usart0_TX_buf_G000)
	SBCI R31,HIGH(-_Usart0_TX_buf_G000)
	ST   Z,R17
;      Usart0_txBufHead++;     //��������� ������   ������
	LDI  R26,LOW(_Usart0_txBufHead_G000)
	LDI  R27,HIGH(_Usart0_txBufHead_G000)
	CALL SUBOPT_0x14
;      #warning �������� �� ������, � �����!! ���������!
;      //UCSR0B |= (1 << UDRIE0); // TX int - on
;      }
; }
_0xEE:
_0xED:
;}
	LD   R17,Y+
	CALL SUBOPT_0x16
	RETI
;
;/*
;*/
;
;//������� ���-�� ������ � ��������� ������
; uint16_t usart_calc_BufData (uint16_t BufTail, uint16_t BufHead)
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
;
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
;uint8_t devider_f = 0;
;
;void PARSER_Init(void)
;{
_PARSER_Init:
;  argc = 0;
	LDI  R30,LOW(0)
	STS  _argc,R30
;  argv[0] = buf;
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	STS  _argv,R30
	STS  _argv+1,R31
;  devider_f = FALSE;
	LDI  R30,LOW(0)
	STS  _devider_f,R30
;  i = 0;
	STS  _i,R30
;}
	RET
;
;void PARS_Parser(char symbol)
;{
;   if (symbol !='\r')    //'\r' //end of string
;	symbol -> Y+0
;   {
;     if (i < SIZE_RECEIVE_BUF - 1)
;     {
;        if (symbol != ' ')
;         {
;           if (!argc)
;           {
;              argv[0] = buf;
;              argc++;
;           }
;
;           if (devider_f)
;           {
;              if (argc < AMOUNT_PAR)
;              {
;                 argv[argc] = &buf[i];
;                 argc++;
;              }
;              devider_f = FALSE;
;            }
;
;            buf[i] = symbol;
;            i++;
;         }
;        else
;         {                 // "space" - is divider
;           if (!devider_f)
;           {
;              buf[i] = 0;
;              i++;
;              devider_f = TRUE;
;           }
;         }
;     }
;     buf[i] = 0;
;     return;
;   }
;   else
;   {
;      buf[i] = 0;
;        if (argc)
;           {
;                PARS_Handler(argc, argv);
;           }
;      argc = 0;
;      devider_f = FALSE;
;      i = 0;
;   }
;}
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
;   uint8_t value = 0;
;  // while(*s == '0'){s++;} // For what?
;   while(*s)
;	*s -> Y+1
;	value -> R17
;   {
;      value += (*s - 0x30);
;      s++;
;      if (*s){
;         value *= 10;
;      }
;   };
;
;  return value;
;}
;
;//atoi
;uint16_t PARS_StrToUint(char *s)
;{
;   uint16_t value = 0;
;   //while(*s == '0'){s++;}
;   while(*s)
;	*s -> Y+2
;	value -> R16,R17
;   {
;      value += (*s - 0x30);
;      s++;
;      if (*s){
;         value *= 10;
;      }
;   };
;
;  return value;
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
	RJMP _0x20C0009
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
	BRNE _0x124
;           SPSR = (1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0xE,R30
;          break;
	RJMP _0x123
;          case 4:
_0x124:
	CPI  R30,LOW(0x4)
	BRNE _0x125
;           SPCR = (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(0)
	RJMP _0x279
;          break;
;          case 8:
_0x125:
	CPI  R30,LOW(0x8)
	BRNE _0x126
;           SPSR |= (1<<SPI2X);
	SBI  0xE,0
;           SPCR |= (1<<SPR0);
	SBI  0xD,0
;          break;
	RJMP _0x123
;          case 16:
_0x126:
	CPI  R30,LOW(0x10)
	BREQ _0x27A
;            SPCR = (1<<SPR0);
;          break;
;          case 32:
	CPI  R30,LOW(0x20)
	BRNE _0x128
;           SPSR = (1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0xE,R30
;           SPCR = (1<<SPR1);
	LDI  R30,LOW(2)
	RJMP _0x279
;          break;
;          case 64:
_0x128:
;           SPCR = (1<<SPR0);
;          break;
;          case 128:
;            SPCR = (1<<SPR0) | (1<<SPR0);
;          break;
;          default:
;            SPCR = (1<<SPR0);
_0x27A:
	LDI  R30,LOW(1)
_0x279:
	OUT  0xD,R30
;          break;
;        }
_0x123:
;SPCR = (1<<SPE)|(1<<MSTR);
	LDI  R30,LOW(80)
	OUT  0xD,R30
;}
_0x20C000A:
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
	BRNE _0x132
;   SPCR = 0;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;   SPSR = 0;
	OUT  0xE,R30
;     if(mode == SPI_MASTER)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x130
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
	RJMP _0x131
_0x130:
;     {
;       Hard_SPI_Slave_Init();
	RCALL _Hard_SPI_Slave_Init
;     }
_0x131:
;  break;
	RJMP _0x12E
;  /*
;   case SPI_1:  //soft spi
;   break;
;  */
;  default:
_0x132:
;  Hard_SPI_Master_Init_default();
	RCALL _Hard_SPI_Master_Init_default
;  break;
; }
_0x12E:
;}
	ADIW R28,5
	RET
;
;#warning can be optimized!
;void SPI_RW_Buf(uint8_t num, uint8_t *data_tx, uint8_t *data_rx)   //SPI write-read
;{
;uint8_t i=0; //char data;
;   SPI_PORTX &= ~(1<<SPI_SS);
;	num -> Y+5
;	*data_tx -> Y+3
;	*data_rx -> Y+1
;	i -> R17
;/*
;while(num)
;{
;      SPDR = data_tx[i];  data_tx[i] = 0;
;      while(!(SPSR & (1<<SPIF))){};
;      data_rx[i] = SPDR;
;      // *data_tx++; *data_rx++;
;       --num;
;        i++;
;}  */
;
;
; while(*data_tx)
;  {
;      SPDR = *data_tx++;  //data_tx[i] = 0;
;      while(!(SPSR & (1<<SPIF)));
;      if(i<SIZE_SPI_BUF_RX){data_rx[i] = SPDR;}
;      i++;
;  }
;   SPI_PORTX |= (1<<SPI_SS);
;  SetTask(Task_SPI_ClrBuf); //��������
;}
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
_0x20C0009:
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
;  PORTD.7^=1;
	LDI  R26,0
	SBIC 0x12,7
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x13A
	CBI  0x12,7
	RJMP _0x13B
_0x13A:
	SBI  0x12,7
_0x13B:
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
;  /*
;interrupt [SPI_STC] void spi_isr(void)
;{
;char data;
;uint8_t Tmp = Spi0_txBufTail; // use local variable instead of volatile
; SPCR = (1<<MSTR);  //Master
;////////RX
;data =  SPDR;
;    if (Spi0_rxCount < SIZE_SPI_BUF_RX) //���� � ����� � ����
;    {
;       Spi0_RX_buf[Spi0_rxBufTail] = data;//!    //������� ������ � SPDR � �����
;       Spi0_rxBufTail++;
;      if (Spi0_rxBufTail == SIZE_BUF_RX)
;      {
;       Spi0_rxBufTail = 0;
;      }
;      Spi0_rxCount++;
;    }
;///////////
;//////////TX
; if(Tmp != Spi0_txBufHead) // all transmitted
;  {
;   ++Tmp;
;   Spi0_txBufTail = Tmp;
;   SPDR = Spi0_TX_buf[Tmp & (SIZE_SPI_BUF_TX - 1)];
;  }
;/////////
;}
;  */
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
;	while (!(TWCR & (1 << TWINT))){};
;    //�������� ����� ����� ��������  TWSTA
;}
;
;void hard_twi_write_byte(char byte) {
;	TWDR = byte;
;	byte -> Y+0
;	TWCR = (1 << TWINT) | (1 << TWEN); // start address transmission
;	while (!(TWCR & (1 << TWINT))){};
;}
;
;char hard_twi_read_byte() {
;	TWCR = (1 << TWINT) | (1 << TWEA) | (1 << TWEN); // start data reception, transmit ACK
;	while (!(TWCR & (1 << TWINT))){};
;	return TWDR;
;}
;
;char hard_twi_read_last_byte() {
;	TWCR = (1 << TWINT) | (1 << TWEN); // start data reception
;	while (!(TWCR & (1 << TWINT))){};
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
;    while ((TWCR & (1<<TWINT)) == 0){};
;    return TWDR;
;}
;//read byte with NACK
;uint8_t hard_twi_read_NACK(void)
;{
;    TWCR = (1<<TWINT)|(1<<TWEN);
;    while ((TWCR & (1<<TWINT)) == 0){};
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
;interrupt [ADC_INT] void adc_isr(void)// ADC interrupt service routine
;{

	.CSEG
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
;void ADC_init(void){ // ADC initialization  //Upd-6
_ADC_init:
;PORTF=0x00; DDRF=0x00;
	CALL SUBOPT_0x17
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
;void ADC_use (void)
;{
;  ADMUX |=0x01;
;  ADCSRA=0b11011111;  //���
;};
;
;
;//-----------������� �������������� ���-----------------   //Upd-7
;void ADC_calibrate (void)   //����� ������������ ���������� Vref
;{
_ADC_calibrate:
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
_0x150:
	LDS  R26,_adc_calib_cnt
	LDS  R27,_adc_calib_cnt+1
	CALL __CPW02
	BRSH _0x151
;  {
;    ADCSRA |= 0x40;        //������ ������ ��������� ���
	SBI  0x6,6
;    while (ADCSRA & 0x40){};   //�������� ��������� ������
_0x152:
	SBIC 0x6,6
	RJMP _0x152
;    volt += ADCL;    //������ ������� 8 ����� ����������
	IN   R30,0x4
	CALL SUBOPT_0x18
	LDI  R31,0
	CALL SUBOPT_0x19
;    volt += ((int)ADCH << 8);    //���� ��� ������� ����
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
;  }                   //��������� 100 ������� ����������
	LDI  R26,LOW(_adc_calib_cnt)
	LDI  R27,HIGH(_adc_calib_cnt)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x150
_0x151:
;  for (avcc=4750; avcc<5250; avcc++) //�������� AVCC, ��
	LDI  R30,LOW(4750)
	LDI  R31,HIGH(4750)
	STS  _avcc,R30
	STS  _avcc+1,R31
_0x156:
	LDS  R26,_avcc
	LDS  R27,_avcc+1
	CPI  R26,LOW(0x1482)
	LDI  R30,HIGH(0x1482)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x157
;  {
;     adc_tmp = volt*avcc/1024; //������� �������� ��� (1,23�)
	LDS  R30,_avcc
	LDS  R31,_avcc+1
	CALL SUBOPT_0x18
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
	BRLO _0x158
	LDS  R30,_adc_tmp
	LDS  R31,_adc_tmp+1
	SUBI R30,LOW(1298)
	SBCI R31,HIGH(1298)
	RJMP _0x27B
;     else delta=ION-adc_tmp;           //������������� ��������
_0x158:
	LDS  R26,_adc_tmp
	LDS  R27,_adc_tmp+1
	LDI  R30,LOW(1298)
	LDI  R31,HIGH(1298)
	SUB  R30,R26
	SBC  R31,R27
_0x27B:
	STS  _delta,R30
	STS  _delta+1,R31
;     if (delta < d){d=delta; vref=avcc;} //���� ������ ����������� �������� - ��������� ����� ����������� �������� � ����������� ���������� Vref
	LDS  R30,_d
	LDS  R31,_d+1
	LDS  R26,_delta
	LDS  R27,_delta+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x15A
	LDS  R30,_delta
	LDS  R31,_delta+1
	STS  _d,R30
	STS  _d+1,R31
	LDS  R30,_avcc
	LDS  R31,_avcc+1
	STS  _vref,R30
	STS  _vref+1,R31
;  }                                      //��������� ���������� ����� ��������, ��������� ������ ������������ ���������� Vref
_0x15A:
	LDI  R26,LOW(_avcc)
	LDI  R27,HIGH(_avcc)
	CALL SUBOPT_0x14
	RJMP _0x156
_0x157:
;}                 //��������� ������� �������������� ���
	RET
;
;uint16_t ADC_get_volt(void)
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
;          while (ADCSRA & 0x40){};   //�������� ��������� ������ =21
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
;						{ while (!(ADCSRA & 0x10)){};   //�������� ��������� =40
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
;		  while (ADCSRA & 0x40){};   //�������� ��������� ������ =29
;		} while (ADCH > 0xCC){}; //���������, ���� ������� > 4 � =30
;		lcd_com(0x0C); //���������� ������� ��� ������ ������� =31
;		for (a=0; a<450; a++) //���� ���������� ������� ������ =32
;		{ for (c=d=0, b=TIME; b>0; b--)   //���������� ������� =33
;		  { ADMUX &=0xF4; ADMUX |=0x04; ADCSRA |=0x40; //���.4 =34
;		    while (ADCSRA & 0x40){}; //�������� ��������� ������ =35
;		    c += ADCH;  //���������� ��������� ��� �� ������-4 =36
;				  ADMUX &=0xF5; ADMUX |=0x05; ADCSRA |=0x40; //���.5 =37
;		    while (ADCSRA & 0x40){}; //�������� ��������� ������ =38
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
;#include "RTC.h"
;
;	time_t rtc;
;
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
;inline void RTC_init(void)
;{
_RTC_init:
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
_0x15B:
	IN   R30,0x30
	ANDI R30,LOW(0x7)
	BRNE _0x15B
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
	CALL SUBOPT_0x1A
;	if (++rtc.second==60)        //keep track of time, date, month, and year
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,0
	CALL SUBOPT_0x1B
	BREQ PC+3
	JMP _0x15E
;	{
;		rtc.second=0;
	LDS  R30,_rtc
	ANDI R30,LOW(0xC0)
	STS  _rtc,R30
;		if (++rtc.minute==60)
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,6
	CALL SUBOPT_0x1B
	BREQ PC+3
	JMP _0x15F
;		{
;			rtc.minute=0;
	LDS  R30,_rtc
	LDS  R31,_rtc+1
	ANDI R30,LOW(0xF03F)
	ANDI R31,HIGH(0xF03F)
	STS  _rtc,R30
	STS  _rtc+1,R31
;			if (++rtc.hour==24)
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,12
	CALL SUBOPT_0x1C
	__CPD1N 0x18
	BREQ PC+3
	JMP _0x160
;			{
;				rtc.hour=0;
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	CALL __GETD1P_INC
	__ANDD1N 0xFFFE0FFF
	CALL __PUTDP1_DEC
;				if (++rtc.date==32)
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,17
	CALL SUBOPT_0x1C
	__CPD1N 0x20
	BREQ _0x27C
;				{
;					rtc.month++;
;					rtc.date=1;
;				}
;				else if (rtc.date==31)
	CALL SUBOPT_0x1D
	CPI  R30,LOW(0x1F)
	BRNE _0x163
;				{
;					if ((rtc.month==4) || (rtc.month==6) || (rtc.month==9) || (rtc.month==11))
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x4)
	BREQ _0x165
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x6)
	BREQ _0x165
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x9)
	BREQ _0x165
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0xB)
	BRNE _0x164
_0x165:
;					{
;						rtc.month++;
	CALL SUBOPT_0x1F
;						rtc.date=1;
;					}
;				}
_0x164:
;				else if (rtc.date==30)
	RJMP _0x167
_0x163:
	CALL SUBOPT_0x1D
	CPI  R30,LOW(0x1E)
	BRNE _0x168
;				{
;					if(rtc.month==2)
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x2)
	BRNE _0x169
;					{
;						rtc.month++;
	CALL SUBOPT_0x1F
;						rtc.date=1;
;					}
;				}
_0x169:
;				else if (rtc.date==29)
	RJMP _0x16A
_0x168:
	CALL SUBOPT_0x1D
	CPI  R30,LOW(0x1D)
	BRNE _0x16B
;				{
;					if((rtc.month==2) && (not_leap()))
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x2)
	BRNE _0x16D
	RCALL _not_leap_G000
	CPI  R30,0
	BRNE _0x16E
_0x16D:
	RJMP _0x16C
_0x16E:
;					{
;						rtc.month++;
_0x27C:
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,22
	__GETD1N 0xF
	CALL __POSTINC_BITFD
;						rtc.date=1;
	__GETB1MN _rtc,2
	ANDI R30,LOW(0xC1)
	ORI  R30,2
	__PUTB1MN _rtc,2
;					}
;				}
_0x16C:
;				if (rtc.month==13)
_0x16B:
_0x16A:
_0x167:
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0xD)
	BRNE _0x16F
;				{
;					rtc.month=1;
	__GETW1MN _rtc,2
	ANDI R30,LOW(0xFC3F)
	ANDI R31,HIGH(0xFC3F)
	ORI  R30,0x40
	__PUTW1MN _rtc,2
;					rtc.year++;    // HAPPY NEW YEAR !  :)
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,26
	__GETD1N 0x3F
	CALL __POSTINC_BITFD
;				}
;			}
_0x16F:
;		}
_0x160:
;	}
_0x15F:
;	//PORTB=~(((t.second&0x01)|t.minute<<1)|t.hour<<7);
;}
_0x15E:
	RJMP _0x290
;
;static char not_leap(void)      //check for leap year
;{
_not_leap_G000:
;	if (!(rtc.year%100))
	CALL SUBOPT_0x20
	__GETD1N 0x64
	CALL __MODD21U
	CALL __CPD10
	BRNE _0x170
;	{
;		return (char)(rtc.year%400);
	CALL SUBOPT_0x20
	__GETD1N 0x190
	CALL __MODD21U
	RET
;	}
;	else
_0x170:
;	{
;		return (char)(rtc.year%4);
	LDS  R30,_rtc+3
	LSR  R30
	LSR  R30
	__ANDD1N 0x3
	RET
;	}
;}
	RET
;
;//**************************************************************
;// read RTC function
;void getRTC(time_t* stm)
; {
;  __disable_interrupts();     // evite erronated read because RTC is called from interrupt
;	*stm -> Y+0
;  memcpy(stm,&rtc,sizeof(time_t));
;  __restore_interrupts();
; }
;//**************************************************************
;// set RTC function
;/*
;void setRTC(u16 year, u08 mon, u08 day, u08 hour, u08 min, u08 sec)
; {
;  __disable_interrupts();
;  rtc.year=year;
;  rtc.month=mon;
;  rtc.date=day;
;  rtc.hour=hour;
;  rtc.minute=min;
;  rtc.second=sec;
;  __restore_interrupts();
; }*/
;
; void setRTC(time_t* rtc_p, u16 year, u08 mon, u08 day, u08 hour, u08 min, u08 sec)
; {
;  __disable_interrupts();
;	*rtc_p -> Y+7
;	year -> Y+5
;	mon -> Y+4
;	day -> Y+3
;	hour -> Y+2
;	min -> Y+1
;	sec -> Y+0
;  rtc_p->year=year;
;  rtc_p->month=mon;
;  rtc_p->date=day;
;  rtc_p->hour=hour;
;  rtc_p->minute=min;
;  rtc_p->second=sec;
;  __restore_interrupts();
; }
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
	CALL SUBOPT_0x1A
;#ifdef DEBUG
;//PORTB ^= 0x01;								// ������� ����� �����, ��� ������������� ����������� ����������� � ������� ������ TWI
;// ���������� �����. ����� ���� ������ ��������� �������� � ����� ������, � �����.
;//�� ��������� ������ ����� UART �� ����
;if (LogIndex <LogBufSize)							// ���� ��� �� ����������
	CALL SUBOPT_0x0
	BRSH _0x17B
;{
;	if (TWSR)								// ������ �������?
	LDS  R30,113
	CPI  R30,0
	BREQ _0x17C
;		{
;		WorkLog[LogIndex]= TWSR;			// ����� ������ � ���
	LDS  R26,_LogIndex_G000
	LDS  R27,_LogIndex_G000+1
	SUBI R26,LOW(-_WorkLog_G000)
	SBCI R27,HIGH(-_WorkLog_G000)
	LDS  R30,113
	ST   X,R30
;		LogIndex++;
	RJMP _0x27D
;		}
;	else
_0x17C:
;		{
;		WorkLog[LogIndex]= 0xFF;			// ���� ������ ������� �� ��������� FF
	CALL SUBOPT_0x1
	LDI  R26,LOW(255)
	STD  Z+0,R26
;		LogIndex++;
_0x27D:
	LDI  R26,LOW(_LogIndex_G000)
	LDI  R27,HIGH(_LogIndex_G000)
	CALL SUBOPT_0x14
;		}
;}
;#endif
;
;switch(TWSR & 0xF8)						// �������� ���� ����������
_0x17B:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
;	{
;	case 0x00:	// Bus Fail (������� ��������)
	CPI  R30,0
	BRNE _0x181
;			{
;			i2c_Do |= i2c_ERR_BF;
	LDS  R30,_i2c_Do
	ORI  R30,1
	CALL SUBOPT_0x21
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			MACRO_i2c_WhatDo_ErrorOut
;			break;
	RJMP _0x180
;			}
;
;	case 0x08:	// ����� ���, � ����� ��:
_0x181:
	CPI  R30,LOW(0x8)
	BRNE _0x182
;			{
;			if( (i2c_Do & i2c_type_msk)== i2c_sarp)							// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	BRNE _0x183
;				{
;				i2c_SlaveAddress |= 0x01;									// ���� Addr+R
	LDS  R30,_i2c_SlaveAddress
	ORI  R30,1
	RJMP _0x27E
;				}
;			else															// ���
_0x183:
;				{
;				i2c_SlaveAddress &= 0xFE;									// ���� Addr+W
	LDS  R30,_i2c_SlaveAddress
	ANDI R30,0xFE
_0x27E:
	STS  _i2c_SlaveAddress,R30
;				}
;
;			TWDR = i2c_SlaveAddress;													// ����� ������
	CALL SUBOPT_0x22
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			break;
	RJMP _0x180
;			}
;
;	case 0x10:	// ��������� ����� ���, � ����� ��
_0x182:
	CPI  R30,LOW(0x10)
	BRNE _0x185
;			{
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)						// � ����������� �� ������
	CALL SUBOPT_0x23
	BRNE _0x186
;				{
;				i2c_SlaveAddress |= 0x01;									// ���� Addr+R
	LDS  R30,_i2c_SlaveAddress
	ORI  R30,1
	RJMP _0x27F
;				}
;			else
_0x186:
;				{
;				i2c_SlaveAddress &= 0xFE;									// ���� Addr+W
	LDS  R30,_i2c_SlaveAddress
	ANDI R30,0xFE
_0x27F:
	STS  _i2c_SlaveAddress,R30
;				}
;
;			// To Do: �������� ���� ��������� ������
;
;			TWDR = i2c_SlaveAddress;													// ����� ������
	CALL SUBOPT_0x22
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;			break;
	RJMP _0x180
;			}
;
;	case 0x18:	// ��� ������ SLA+W �������� ACK, � �����:
_0x185:
	CPI  R30,LOW(0x18)
	BRNE _0x188
;			{
;			if( (i2c_Do & i2c_type_msk) == i2c_sawp)						// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x189
;				{
;				TWDR = i2c_Buffer[i2c_index];								// ���� ���� ������
	CALL SUBOPT_0x24
;				i2c_index++;												// ����������� ��������� ������
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  // Go!
;  				}
;
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)
_0x189:
	CALL SUBOPT_0x23
	BRNE _0x18A
;				{
;				TWDR = i2c_PageAddress[i2c_PageAddrIndex];					// ��� ���� ����� ������� (�� ���� ���� ���� ������)
	CALL SUBOPT_0x25
;				i2c_PageAddrIndex++;										// ����������� ��������� ������ ��������
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;	// Go!
	STS  116,R30
;				}
;			}
_0x18A:
;			break;
	RJMP _0x180
;
;	case 0x20:	// ��� ������ SLA+W �������� NACK - ����� ���� �����, ���� ��� ��� ����.
_0x188:
	CPI  R30,LOW(0x20)
	BRNE _0x18B
;			{
;			i2c_Do |= i2c_ERR_NA;															// ��� ������
	LDS  R30,_i2c_Do
	ORI  R30,0x10
	CALL SUBOPT_0x21
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// ���� ���� Stop
;
;			MACRO_i2c_WhatDo_ErrorOut 														// ������������ ������� ������;
;			break;
	RJMP _0x180
;			}
;
;	case 0x28: 	// ���� ������ �������, �������� ACK!  (���� sawp - ��� ��� ���� ������. ���� sawsarp - ���� ������ ��������)
_0x18B:
	CPI  R30,LOW(0x28)
	BRNE _0x18C
;			{	// � ������:
;			if( (i2c_Do & i2c_type_msk) == i2c_sawp)							// � ����������� �� ������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x18D
;				{
;				if (i2c_index == i2c_ByteCount)												// ���� ��� ���� ������ ���������
	LDS  R30,_i2c_ByteCount
	LDS  R26,_i2c_index
	CP   R30,R26
	BRNE _0x18E
;					{
;					TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;	// ���� Stop
	CALL SUBOPT_0x26
;
;					MACRO_i2c_WhatDo_MasterOut												// � ������� � ��������� �����
;
;					}
;				else
	RJMP _0x18F
_0x18E:
;					{
;					TWDR = i2c_Buffer[i2c_index];												// ���� ���� ��� ���� ����
	CALL SUBOPT_0x24
;					i2c_index++;
;					TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;  	// Go!
;					}
_0x18F:
;				}
;
;			if( (i2c_Do & i2c_type_msk) == i2c_sawsarp)						// � ������ ������ ��
_0x18D:
	CALL SUBOPT_0x23
	BRNE _0x190
;				{
;				if(i2c_PageAddrIndex == i2c_PageAddrCount)					// ���� ��������� ���� ������ ��������
	LDS  R30,_i2c_PageAddrCount
	LDS  R26,_i2c_PageAddrIndex
	CP   R30,R26
	BRNE _0x191
;					{
;					TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ��������� ��������� �����!
	LDI  R30,LOW(229)
	RJMP _0x280
;					}
;				else
_0x191:
;					{														// �����
;					TWDR = i2c_PageAddress[i2c_PageAddrIndex];				// ���� ��� ���� ����� ��������
	CALL SUBOPT_0x25
;					i2c_PageAddrIndex++;									// ����������� ������ �������� ������ �������
;					TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// Go!
_0x280:
	STS  116,R30
;					}
;				}
;			}
_0x190:
;			break;
	RJMP _0x180
;
;	case 0x30:	//���� ����, �� �������� NACK ������ ���. 1� �������� �������� ������� � ��� ����. 2� ����� �������.
_0x18C:
	CPI  R30,LOW(0x30)
	BRNE _0x193
;			{
;			i2c_Do |= i2c_ERR_NK;				// ������� ������ ������. ���� ��� �� ����, ��� ������.
	LDS  R30,_i2c_Do
	ORI  R30,2
	STS  _i2c_Do,R30
;
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ���� Stop
	CALL SUBOPT_0x26
;
;			MACRO_i2c_WhatDo_MasterOut													// ������������ ������� ������
;
;			break;
	RJMP _0x180
;			}
;
;	case 0x38:	//  �������� �� ����. ������� ��� �� ���������
_0x193:
	CPI  R30,LOW(0x38)
	BRNE _0x194
;			{
;			i2c_Do |= i2c_ERR_LP;			// ������ ������ ������ ����������
	LDS  R30,_i2c_Do
	ORI  R30,0x20
	CALL SUBOPT_0x27
;
;			// ����������� ������� ������.
;			i2c_index = 0;
;			i2c_PageAddrIndex = 0;
;
;			TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;		// ��� ������ ���� ����� ��������
	LDI  R30,LOW(229)
	STS  116,R30
;			break;																		// ��������� �������� �����.
	RJMP _0x180
;			}
;
;	case 0x40: // ������� SLA+R �������� ���. � ������ ����� �������� �����
_0x194:
	CPI  R30,LOW(0x40)
	BRNE _0x195
;			{
;			if(i2c_index+1 == i2c_ByteCount)								// ���� ����� �������� �� ���� �����, ��
	CALL SUBOPT_0x28
	BRNE _0x196
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ������� ����, � � ����� ����� ������ NACK(Disconnect)
	LDI  R30,LOW(133)
	RJMP _0x281
;				}															// ��� ���� ������ ������, ��� ��� ������ �����. � �� �������� ����
;			else
_0x196:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;	// ��� ������ ������ ���� � ������ ����� ACK
	LDI  R30,LOW(197)
_0x281:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x180
;			}
;
;	case 0x48: // ������� SLA+R, �� �������� NACK. ������ slave ����� ��� ��� ��� ����.
_0x195:
	CPI  R30,LOW(0x48)
	BRNE _0x198
;			{
;			i2c_Do |= i2c_ERR_NA;															// ��� ������ No Answer
	LDS  R30,_i2c_Do
	ORI  R30,0x10
	CALL SUBOPT_0x21
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// ���� Stop
;
;			MACRO_i2c_WhatDo_ErrorOut														// ������������ �������� �������� ������
;			break;
	RJMP _0x180
;			}
;
;	case 0x50: // ������� ����.
_0x198:
	CPI  R30,LOW(0x50)
	BRNE _0x199
;			{
;			i2c_Buffer[i2c_index] = TWDR;			// ������� ��� �� ������
	CALL SUBOPT_0x29
;			i2c_index++;
	LDS  R30,_i2c_index
	SUBI R30,-LOW(1)
	STS  _i2c_index,R30
;
;			// To Do: �������� �������� ������������ ������. � �� ���� �� ��� ���� ���������
;
;			if (i2c_index+1 == i2c_ByteCount)		// ���� ������� ��� ���� ���� �� ���, ��� �� ������ �������
	CALL SUBOPT_0x28
	BRNE _0x19A
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// ����������� ��� � ����� ������ NACK (Disconnect)
	LDI  R30,LOW(133)
	RJMP _0x282
;				}
;			else
_0x19A:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;		// ���� ���, �� ����������� ��������� ����, � � ����� ������ ���
	LDI  R30,LOW(197)
_0x282:
	STS  116,R30
;				}
;			break;
	RJMP _0x180
;			}
;
;	case 0x58:	// ��� �� ����� ��������� ����, ������� NACK ����� �������� � �����.
_0x199:
	CPI  R30,LOW(0x58)
	BRNE _0x19C
;			{
;			i2c_Buffer[i2c_index] = TWDR;													// ����� ���� � �����
	CALL SUBOPT_0x29
;			TWCR = 0<<TWSTA|1<<TWSTO|1<<TWINT|i2c_i_am_slave<<TWEA|1<<TWEN|1<<TWIE;			// �������� Stop
	CALL SUBOPT_0x26
;
;			MACRO_i2c_WhatDo_MasterOut														// ���������� ����� ������
;
;			break;
	RJMP _0x180
;			}
;
;// IIC  Slave ============================================================================
;
;	case 0x68:	// RCV SLA+W Low Priority							// ������� ���� ����� �� ����� �������� ��������
_0x19C:
	CPI  R30,LOW(0x68)
	BREQ _0x19E
;	case 0x78:	// RCV SLA+W Low Priority (Broadcast)				// ��� ��� ��� ����������������� �����. �� �����
	CPI  R30,LOW(0x78)
	BRNE _0x19F
_0x19E:
;			{
;			i2c_Do |= i2c_ERR_LP | i2c_Interrupted;					// ������ ���� ������ Low Priority, � ����� ���� ����, ��� ������� ��������
	LDS  R30,_i2c_Do
	ORI  R30,LOW(0xA0)
	CALL SUBOPT_0x27
;
;			// Restore Trans after.
;			i2c_index = 0;											// ����������� ��������� �������� ������
;			i2c_PageAddrIndex = 0;
;			}														// � ����� ������. ��������!!! break ��� ���, � ������ ���� � "case 60"
;
;	case 0x60: // RCV SLA+W  Incoming?								// ��� ������ �������� ���� �����
	RJMP _0x1A0
_0x19F:
	CPI  R30,LOW(0x60)
	BRNE _0x1A1
_0x1A0:
;	case 0x70: // RCV SLA+W  Incoming? (Broascast)					// ��� ����������������� �����
	RJMP _0x1A2
_0x1A1:
	CPI  R30,LOW(0x70)
	BRNE _0x1A3
_0x1A2:
;			{
;
;			i2c_Do |= i2c_Busy;										// �������� ����. ����� ������ �� ��������
	LDS  R30,_i2c_Do
	ORI  R30,0x40
	STS  _i2c_Do,R30
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
_0x283:
	STS  116,R30
;				}
;			break;
	RJMP _0x180
;			}
;
;	case 0x80:	// RCV Data Byte									// � ��� �� ������� ���� ����. ��� ��� �����������������. �� �����
_0x1A3:
	CPI  R30,LOW(0x80)
	BREQ _0x1A7
;	case 0x90:	// RCV Data Byte (Broadcast)
	CPI  R30,LOW(0x90)
	BRNE _0x1A8
_0x1A7:
;			{
;			i2c_InBuff[i2c_SlaveIndex] = TWDR;						// ������� ��� � �����.
	CALL SUBOPT_0x2A
;
;			i2c_SlaveIndex++;										// �������� ���������
	CALL SUBOPT_0x2B
;
;			if (i2c_SlaveIndex == i2c_MasterBytesRX-1) 				// �������� ����� ����� ��� ���� ����?
	CPI  R30,0
	BRNE _0x1A9
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;			// ������� ��� � ������� NACK!
	LDI  R30,LOW(133)
	RJMP _0x284
;				}
;			else
_0x1A9:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ����� ��� ������? ������� � ACK!
	LDI  R30,LOW(197)
_0x284:
	STS  116,R30
;				}
;			break;
	RJMP _0x180
;			}
;
;	case 0x88: // RCV Last Byte										// ������� ��������� ����
_0x1A8:
	CPI  R30,LOW(0x88)
	BREQ _0x1AC
;	case 0x98: // RCV Last Byte (Broadcast)
	CPI  R30,LOW(0x98)
	BRNE _0x1AD
_0x1AC:
;			{
;			i2c_InBuff[i2c_SlaveIndex] = TWDR;						// ������� ��� � �����
	CALL SUBOPT_0x2A
;
;			if (i2c_Do & i2c_Interrupted)							// ���� � ��� ��� ���������� ����� �� ����� �������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x80)
	BREQ _0x1AE
;				{
;				TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ������ � ���� ���� Start �������� � ������� ��� ���� �������
	LDI  R30,LOW(229)
	RJMP _0x285
;				}
;			else
_0x1AE:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ���� �� ���� ������ �����, �� ������ ��������� � ����� �����
	LDI  R30,LOW(197)
_0x285:
	STS  116,R30
;				}
;
;			MACRO_i2c_WhatDo_SlaveOut												// � ������ ���������� ��� �������� ���� ��� ������
	__CALL1MN _SlaveOutFunc,0
;			break;
	RJMP _0x180
;			}
;
;
;	case 0xA0: // ��, �� �������� ��������� �����. �� �� ��� � ��� ������?
_0x1AD:
	CPI  R30,LOW(0xA0)
	BRNE _0x1B0
;			{
;			// �����, �������, ������� ��������������� �������, ����� ������������ ��� � ������ ���������� �������, ������� ��������.
;			// �� � �� ���� ��������������. � ���� ������ �������� ��� ���.
;
;			TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ������ �������������, �������������� ���� �����
	LDI  R30,LOW(197)
	STS  116,R30
;			break;
	RJMP _0x180
;			}
;
;
;
;	case 0xB0:  // ������� ���� ����� �� ������ �� ����� �������� ��������
_0x1B0:
	CPI  R30,LOW(0xB0)
	BRNE _0x1B1
;			{
;			i2c_Do |= i2c_ERR_LP | i2c_Interrupted;			// �� ��, ���� ������ � ���� ��������� ��������.
	LDS  R30,_i2c_Do
	ORI  R30,LOW(0xA0)
	CALL SUBOPT_0x27
;
;			// ��������������� �������
;			i2c_index = 0;
;			i2c_PageAddrIndex = 0;
;			}												// Break ���! ���� ������
;
;	case 0xA8:	// // ���� ������ ������� ���� ����� �� ������
	RJMP _0x1B2
_0x1B1:
	CPI  R30,LOW(0xA8)
	BRNE _0x1B3
_0x1B2:
;			{
;			i2c_SlaveIndex = 0;								// ������� ��������� �������� �� 0
	LDI  R30,LOW(0)
	STS  _i2c_SlaveIndex,R30
;
;			TWDR = i2c_OutBuff[i2c_SlaveIndex];				// ����, ������� ���� �� ��� ��� ����.
	CALL SUBOPT_0x2C
;
;			if(i2c_MasterBytesTX == 1)
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ���� �� ���������, �� ��� �� NACK � ����� ��������
	LDI  R30,LOW(133)
;				}
;			else
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;	// � ���� ���, ��  ACK ����
_0x286:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x180
;			}
;
;
;	case 0xB8: // ������� ����, �������� ACK
_0x1B3:
	CPI  R30,LOW(0xB8)
	BRNE _0x1B6
;			{
;
;			i2c_SlaveIndex++;								// ������ ���������� ���������. ����� ��������� ����
	CALL SUBOPT_0x2B
;			TWDR = i2c_OutBuff[i2c_SlaveIndex];				// ���� ��� �������
	CALL SUBOPT_0x2C
;
;			if (i2c_SlaveIndex == i2c_MasterBytesTX-1)		// ���� �� ��������� ���, ��
	LDS  R30,_i2c_SlaveIndex
	CPI  R30,0
	BRNE _0x1B7
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;	// ���� ��� � ���� NACK
	LDI  R30,LOW(133)
	RJMP _0x287
;				}
;			else
_0x1B7:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|0<<TWEN|1<<TWIE;	// ���� ���, �� ���� � ���� ACK
	LDI  R30,LOW(193)
_0x287:
	STS  116,R30
;				}
;
;			break;
	RJMP _0x180
;			}
;
;	case 0xC0: // �� ������� ��������� ����, ������ � ��� ���, �������� NACK
_0x1B6:
	CPI  R30,LOW(0xC0)
	BREQ _0x1BA
;	case 0xC8: // ��� ACK. � ������ ������ ��� ���. �.�. ������ ������ � ��� ���.
	CPI  R30,LOW(0xC8)
	BRNE _0x1BE
_0x1BA:
;			{
;			if (i2c_Do & i2c_Interrupted)											// ���� ��� ���� ��������� �������� �������
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0x80)
	BREQ _0x1BC
;				{																	// �� �� ��� �� ������
;				i2c_Do &= i2c_NoInterrupted;										// ������ ���� �����������
	LDS  R30,_i2c_Do
	ANDI R30,0x7F
	STS  _i2c_Do,R30
;				TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// �������� ����� ����� �� ��� ������� ����.
	LDI  R30,LOW(229)
	RJMP _0x288
;				}
;			else
_0x1BC:
;				{
;				TWCR = 0<<TWSTA|0<<TWSTO|1<<TWINT|1<<TWEA|1<<TWEN|1<<TWIE;			// ���� �� ��� ����, �� ������ ������� ����
	LDI  R30,LOW(197)
_0x288:
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
_0x1BE:
;	}
_0x180:
;}
_0x290:
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
	JMP  _0x20C0006
;#include "D_i2c_AT24C_EEP/i2c_AT24C_EEP.h"
;
;
;#define HI(X) (X>>8)
;#define LO(X) (X & 0xFF)
;
;uint8_t i2c_eep_WriteByte(uint8_t SAddr,uint16_t Addr, uint8_t Byte, IIC_F WhatDo)
;{
;
;if (i2c_Do & i2c_Busy) return 0;
;	SAddr -> Y+5
;	Addr -> Y+3
;	Byte -> Y+2
;	*WhatDo -> Y+0
;
;i2c_index = 0;
;i2c_ByteCount = 3;
;
;i2c_SlaveAddress = SAddr;
;
;
;i2c_Buffer[0] = HI(Addr);
;i2c_Buffer[1] = LO(Addr);
;i2c_Buffer[2] = Byte;
;
;i2c_Do = i2c_sawp;
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
;#warning This file`ll be destroyed!
;
;#include <adapter.h>
;
;#include "D_usart/usart.h"
;//#include "D_usart/usart.c"
;
;#include "global_variables.h"
;
;
;
;
;
;/*   //������ ������������� ���������� ����!
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
;{
;v_u32_SYS_TICK++;
;   //  if (USART_Get_rxCount(USART_0) > 0) //���� � ������� ������ ���-�� ����
;   //    {
;   //     symbol = USART_Get_Char(USART_0);
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
;    Put_In_Log("porf"); //now \r\n concat in Put_In_Log
;   }
;else if (MCUCSR & (1<<EXTRF))// External Reset
;   {
;    Put_In_Log("extrf");
;   }
;else if (MCUCSR & (1<<BORF))// Brown-Out Reset
;   {
;   Put_In_Log("borf");
;   }
;else if (MCUCSR & (1<<WDRF))// Watchdog Reset
;   {
;    Put_In_Log("wdrf");
;   }
;else if (MCUCSR & (1<<JTRF))// JTAG Reset
;   {
;    Put_In_Log("JTRF");
;   }
;
;MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));//clear register
;return 0;
;}

	.DSEG
_0x1C2:
	.BYTE 0x1A
;
;
;void TIM2_ON(void){

	.CSEG
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
;StopRTOS();
;USART_Send_StrFl(SYSTEM_USART, help_mess_0);
;USART_Send_StrFl(SYSTEM_USART, help_mess_1);
;USART_Send_StrFl(SYSTEM_USART, help_mess_2);
;USART_Send_StrFl(SYSTEM_USART, help_mess_3);
;USART_Send_StrFl(SYSTEM_USART, help_mess_4);
;
;USART_Send_StrFl(SYSTEM_USART,help_Uart_0);
;USART_Send_StrFl(SYSTEM_USART,help_Uart_1);
;USART_Send_StrFl(SYSTEM_USART,help_Spi_0);
;USART_Send_StrFl(SYSTEM_USART,help_Spi_1);
;RunRTOS();
;}
;
;void print_settings_ram(void){
;uint8_t i = 0;
;char str[10];
;
;USART_Send_Str(SYSTEM_USART,"\r<RAM>");
;	i -> R17
;	str -> Y+1
;USART_Send_Str(SYSTEM_USART,"\rUART_SETTINGS\r");
;  for(i=0;i<COUNT_OF_UARTS;i++)
;    {
;    USART_Send_Str(SYSTEM_USART,"UART ");
;    itoa(i,str);
;    USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r Mode ");
;    itoa(RAM_settings.MODE_of_Uart[i],str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r Speed ");
;    itoa(RAM_settings.baud_of_Uart[i],str);
;    USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r--------\r");
;    }
;
;USART_Send_Str(SYSTEM_USART,"\rSPI_SETTINGS\r");
;  for(i=0;i<COUNT_OF_SPI;i++)
;    {
;    USART_Send_Str(SYSTEM_USART,"SPI ");
;    itoa(i,str);
;    USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r Mode ");
;    itoa(RAM_settings.MODE_of_Spi[i],str);
;    USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r Prescaller ");
;    itoa(RAM_settings.prescaller_of_Spi[i],str);
;    USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;    USART_Send_Str(SYSTEM_USART,"\r--------\r");
;    }
;//USART_FlushTxBuf(USART_0);
;}

	.DSEG
_0x1CB:
	.BYTE 0x6E
;
;void print_settings_eeprom(void){

	.CSEG
;uint8_t i = 0;
;char str[10];
;
;USART_Send_Str(USART_0,"\r<EEPROM>");
;	i -> R17
;	str -> Y+1
;USART_Send_Str(USART_0,"\rUART_SETTINGS\r");
;  for(i=0;i<COUNT_OF_UARTS;i++)
;    {
;    USART_Send_Str(USART_0,"UART ");
;    itoa(i,str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r Mode ");
;    itoa(EE_settings.MODE_of_Uart[i],str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r Speed ");
;    itoa(EE_settings.baud_of_Uart[i],str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r--------\r");
;    }
;
;USART_Send_Str(USART_0,"\rSPI_SETTINGS\r");
;  for(i=0;i<COUNT_OF_SPI;i++)
;    {
;    USART_Send_Str(USART_0,"SPI ");
;    itoa(i,str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r Mode ");
;    itoa(EE_settings.MODE_of_Spi[i],str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r Prescaller ");
;    itoa(EE_settings.prescaller_of_Spi[i],str);
;    USART_Send_Str(USART_0,str); //convert dec to str
;
;    USART_Send_Str(USART_0,"\r--------\r");
;    }
;//USART_FlushTxBuf(USART_0);
;}

	.DSEG
_0x1D2:
	.BYTE 0x71
;
;
;void print_sys(void)
;{

	.CSEG
;char str[5];
;USART_Send_Str(SYSTEM_USART,"\rButes_RX ");
;	str -> Y+0
;itoa(v_u32_RX_CNT,str);
;USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;
;USART_Send_Str(SYSTEM_USART,"\rButes_TX ");
;itoa(v_u32_TX_CNT,str);
;USART_Send_Str(SYSTEM_USART,str); //convert dec to str
;}

	.DSEG
_0x1D9:
	.BYTE 0x16
;
;
;void RingBuff_TX(void)
;{

	.CSEG
;  UCSR0B |= (1 << UDRIE0); // TX int - on
;}
;
;#warning TODO
;uint8_t get_curr_cpu_freq (void) //���������� �������� ������� ������� ������ ��
;{
;uint8_t freq = 0;
;  //TODO
;return freq;
;	freq -> R17
;}
;
;#warning ��������!
;void cust_delay_ms(uint16_t delay){ //����� ��������
;uint32_t timecnt = v_u32_SYS_TICK + delay;
;while (v_u32_SYS_TICK < timecnt){}
;	delay -> Y+4
;	timecnt -> Y+0
;}
;
;
;
;
;//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;//RLE_array pack/unpack funktions
;
;int RLE_pack (unsigned char* src,unsigned char* dst, uint16_t src_size)
;{
;uint8_t tmp_symb = src[0];
;uint16_t tmp_cnt = 1;
;uint16_t k = 0;
;uint16_t i = 1;
;
; for(i = 1; i<src_size+1; i++)
;	*src -> Y+12
;	*dst -> Y+10
;	src_size -> Y+8
;	tmp_symb -> R17
;	tmp_cnt -> R18,R19
;	k -> R20,R21
;	i -> Y+6
;    {
;       if(src[i] == tmp_symb){tmp_cnt++;}
;       else
;        {
;            dst[k] = tmp_cnt; k++;
;            dst[k] = tmp_symb; k++;
;
;            tmp_symb = src[i];
;            tmp_cnt = 1;
;       }
;    }
; return k;   //return new_sise
;}
;
;int RLE_unpack (flash unsigned char* src, unsigned char* dst, uint16_t src_size)
;{
;uint8_t tmp_symb = 0;
;uint8_t tmp_cnt = 0;
;uint16_t i;
;uint16_t j;
;uint16_t k=0;
;
; for(i = 0; i<src_size; i+=2)
;	*src -> Y+12
;	*dst -> Y+10
;	src_size -> Y+8
;	tmp_symb -> R17
;	tmp_cnt -> R16
;	i -> R18,R19
;	j -> R20,R21
;	k -> Y+6
;    {
;        tmp_cnt = src[i];
;        tmp_symb = src[i+1];
;        for(j = 0; j < tmp_cnt; j++)
;        {
;            dst[k++] = tmp_symb;
;        }
;    }
; return src_size+k;   //new_sise
;}
;//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
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
;
;DECLARE_TASK(Task_Initial) //�������� �����, ��������� ��� ������
;{
_Task_Initial:
;//SetTimerTask(Task_t_props_out,10);
;
;SetTimerTask(Task_Start,1000,10);     //blink led
	LDI  R30,LOW(_Task_Start)
	LDI  R31,HIGH(_Task_Start)
	CALL SUBOPT_0x2D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2E
;
;SetTimerTask(Task_LoadTest, 5000, 500); //������ ��������� ����� ��� �������� �������� ��
	LDI  R30,LOW(_Task_LoadTest)
	LDI  R31,HIGH(_Task_LoadTest)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x2E
;///-----------------Upd-7-----------------------------
;// ��������� ������ ���� �����
;//SetTimerTask(Task_pars_cmd,5,100); //Upd-6
;SetTimerTask(Task_DispatchFlags,100,100);
	LDI  R30,LOW(_Task_DispatchFlags)
	LDI  R31,HIGH(_Task_DispatchFlags)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
;
;#ifdef DEBUG                    //Upd-6
;SetTimerTask(Task_LogOut, 50, 50);
	LDI  R30,LOW(_Task_LogOut)
	LDI  R31,HIGH(_Task_LogOut)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
;SetTask(Task_LcdGreetImage);    //Upd-4
	LDI  R30,LOW(_Task_LcdGreetImage)
	LDI  R31,HIGH(_Task_LcdGreetImage)
	CALL SUBOPT_0x2F
;//SetTimerTask(Task_ADC_test,5000);   //Upd-6
;//SetTimerTask(Task_AdcOnLcd, 6000);
;//SetTimerTask(Task_BuffOut,5);
;#endif
;///---------------------------------------------------
; //SetTimerTask(Task_1ms, 55, 1);
; SetTimerTask(Task3_1ms, 250, 250);
	LDI  R30,LOW(_Task3_1ms)
	LDI  R31,HIGH(_Task3_1ms)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _0x20C0008
;
;
;}
;
;
;DECLARE_TASK(Task_ClearTS)//clr task test
;{
;ClearTimerTask(Task_Initial);
;ClearTimerTask(Task_LoadTest);
;ClearTimerTask(Task_LogOut);
;ClearTimerTask(Task_1ms);
;ClearTimerTask(Task3_1ms);
;ClearTimerTask(Task_ClearTS);
; SetTimerTask(Task_Initial, 1700, 1700);
;}
;
;DECLARE_TASK(Task_1ms)
;{
;LED_PORT.LED2^=1;
;//LED_PORT |= (1<<LED2);
;//SetTimerTask(Task_1ms,5,5); //������ �������-�������������
;//LED_PORT  &= ~(1<<LED2);
;}
;
;DECLARE_TASK(Task2_1ms)
;{
;//LED_PORT.LED2^=1;
;LED_PORT |= (1<<LED3);
;//SetTimerTask(Task2_1ms,5); //������ �������-�������������
;LED_PORT  &= ~(1<<LED3);
;}
;DECLARE_TASK(Task3_1ms)   //�� 4800 ��� - 15�������� ����� �� 50��
;{
_Task3_1ms:
;Put_In_Log("Task3_250ms\r\n");
	__POINTW1MN _0x1EA,0
	CALL SUBOPT_0x30
;//SetTimerTask(Task3_1ms,500, 500); //��� ����� ������ ����� ���������� ������� ��� ���������� �� ������� �� 5��
;}
	RET

	.DSEG
_0x1EA:
	.BYTE 0xE
;
;
;
;DECLARE_TASK(Task_LoadTest)    //8ms!
;{

	.CSEG
_Task_LoadTest:
; int Tick =0;
; Tick = v_u32_SYS_TICK;
	CALL SUBOPT_0x7
;	Tick -> R16,R17
	__GETWRMN 16,17,0,_v_u32_SYS_TICK
;
;Put_In_Log("T_L_T\r\n");
	__POINTW1MN _0x1EB,0
	CALL SUBOPT_0x30
;
;  //LcdClear();
;_LCD_SHOWVAL(Tick); // = sprintf (lcd_buf, "Tick=%i",v_u32_SYS_TICK);  // 500us
	LDI  R30,LOW(_lcd_buf)
	LDI  R31,HIGH(_lcd_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,171
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; LcdString(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _LcdString
;_LCD_STRINBUF("Ololo=)");
	LDI  R30,LOW(_lcd_buf)
	LDI  R31,HIGH(_lcd_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x1EB,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	CALL _strncpy
; LcdString(1,4);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _LcdString
; LcdUpdate();
	CALL _LcdUpdate
;//SetTimerTask(Task_LoadTest, 1000, 1000);; //������ ��������� ����� ��� �������� �������� ��
;}
	RJMP _0x20C0007

	.DSEG
_0x1EB:
	.BYTE 0x10
;
;DECLARE_TASK(Task_Start)
;{

	.CSEG
_Task_Start:
;LED_PORT.LED2^=1; //������ �������-�������������
	LDI  R26,0
	SBIC 0x12,7
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x1EC
	CBI  0x12,7
	RJMP _0x1ED
_0x1EC:
	SBI  0x12,7
_0x1ED:
;}
	RET
;
;DECLARE_TASK (Task_LedOff)
;{
;//SetTimerTask(Task_LedOn, 900, 900);
;LED_PORT  &= ~(1<<LED2);
;}
;
;DECLARE_TASK (Task_LedOn)
;{
;//SetTimerTask(Task_LedOff,100,100);
;LED_PORT  |= (1<<LED2);
;}
;
;DECLARE_TASK (Task_t_props_out)
;{  /*
;uint8_t index = 0;
;char tmp_str[10];
;SetTimerTask(Task_t_props_out,10);
;    // LED_PORT  &=~(1<<LED2);
;  for(index=0;index!=timers_cnt_tail;++index)	// ���� ������
;	{          //�������� ����
;    if((TTask[index].sys_tick_time > 0)) //���� ������ �����������, ����� ����� ������ � ������� ������ ������
;    // if((TTask[index].TaskStatus == DONE))
;    {
;     Put_In_Log("<");
;     itoa((int)TTask[index].hndl , tmp_str);
;     Put_In_Log(tmp_str); Put_In_Log(",");
;     itoa((int)TTask[index].TaskDelay , tmp_str);
;     Put_In_Log(tmp_str); Put_In_Log(",");
;     itoa((int)TTask[index].sys_tick_time , tmp_str);   TTask[index].sys_tick_time = 0;
;     Put_In_Log(tmp_str); Put_In_Log(",");
;     itoa((int)TTask[index].exec_time , tmp_str);       TTask[index].exec_time = 0;
;     Put_In_Log(tmp_str); Put_In_Log(",");
;     itoa((int)TTask[index].TaskStatus , tmp_str);            TTask[index].flag = 0;
;     Put_In_Log(tmp_str);
;     Put_In_Log(">\r\n");
;     }
;  }    */
; // LED_PORT  |=(1<<LED2);
;}
;
;DECLARE_TASK (Task_ADC_test) //Upd-6     //��� �������� ����������� ���������
; {
; #warning no Lcd_out// sprintf (lcd_buf, "DummyADC=%d ",volt);      // ����� �� ����� ����������
; LcdString(1,1);   LcdUpdate();
; //SetTimerTask(Task_ADC_test,5000, 5000);
; }
;
;
;void Task_LcdGreetImage (void) //Greeting image on start    //Upd-4
;{
_Task_LcdGreetImage:
;//SetTask(LcdClear);
;//SetTask(Task_LcdLines);
;
;#warning RLE_unpack doesn`t work
;//unsigned char tmp_unpk_buf[504];
;//unsigned char tmp_src_buf[504];
;//memcpy(tmp_unpk_buf,(void*)rad2Image,504);
;//RLE_unpack(rad1Image, LcdCache, 230);
;//LcdImageRam(tmp_unpk_buf);  SetTimerTask(LcdClear,1000,0);
;LcdImage(rad2Image);  SetTimerTask(LcdClear,1000,0);
	LDI  R30,LOW(_rad2Image*2)
	LDI  R31,HIGH(_rad2Image*2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _LcdImage
	LDI  R30,LOW(_LcdClear)
	LDI  R31,HIGH(_LcdClear)
	CALL SUBOPT_0x2D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x2E
; /*
; //sprintf (lcd_buf, "  Interface   ");
; strncpy (lcd_buf, "  Interface   ", 15);
; LcdStringBig(1,1);
;  strncpy(lcd_buf, " Monitor v2.1 ", 15);
; LcdString(1,3);
; strncpy (lcd_buf, " �����������  ", 15);
; LcdString(1,4);
; strncpy (lcd_buf, "  ���������   ", 15);
; LcdString(1,5);
; strncpy (lcd_buf, "  �� - 104    ", 15);
; LcdString(1,6);  */
;LcdUpdate();
	CALL _LcdUpdate
;SetTimerTask(LcdClear,2000,0);
	LDI  R30,LOW(_LcdClear)
	LDI  R31,HIGH(_LcdClear)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x31
_0x20C0008:
	ST   -Y,R31
	ST   -Y,R30
	CALL _SetTimerTask
;
;// sprintf (lcd_buf, "Wait comand...");      //�� ��������
;// LcdStringBig(1,3);
;// SetTimerTask(LcdUpdate,8000);
;}
	RET
;
;void Task_LcdLines (void)      //Upd-4       //������ ������!
;{
;    	for (i=0; i<84; i++)
;        {
;		LcdLine ( 0, 47, i, 0, 1);
;        LcdLine ( 84, 47, 84-i, 0, 1);
;		LcdUpdate();
;		}
;}
;
;void Task_AdcOnLcd (void)
;{
;//SetTask(LcdClear);
; /*sprintf (lcd_buf, "vref=%d ",vref);      // ����� �� ����� ����������
; LcdString(1,1);
;  sprintf (lcd_buf, "d=%d ",d);      // ����� �� ����� ����������
; LcdString(1,2);
;  sprintf (lcd_buf, "delta=%d ",delta);      // ����� �� ����� ����������
; LcdString(1,3);
;  sprintf (lcd_buf, "volt=%d ",volt);      // ����� �� ����� ����������
; LcdString(1,4);  */
; LcdClear();
; ADC_use();
;#warning disabled sprintf (lcd_buf, "���������� ��");
; LcdString(1,2);
;#warning disabled sprintf (lcd_buf, "  ������ 0");
; LcdString(1,3);
;#warning disabled sprintf (lcd_buf, "= %d ��",adc_result);
; LcdString(1,4);
;
; LcdUpdate();
;}
;
;//#error ���������!
;DECLARE_TASK (Task_pars_cmd)         //300us? empty buff
;{
;char scan_interval = 100;
;  if (USART_Get_rxCount(SYSTEM_USART) > 0) //���� � ������� ������ ���-�� ����
;	scan_interval -> R17
;       {
;        symbol = USART_Get_Char(SYSTEM_USART);
;        PARS_Parser(symbol);
;        //SetTask(Task_pars_cmd);  //���������!
;        scan_interval = 5;
;       }
;// else{scan_interval = 100;};
;SetTimerTask(Task_pars_cmd, 0, scan_interval); //25   //���������!
;}
;
;
;DECLARE_TASK (Task_DispatchFlags)
;{
_Task_DispatchFlags:
;  switch(g_tcf)
	CALL SUBOPT_0x4
;  {
;    case ERR_UNDEF_FLAG: Put_In_Log("\r ERR_UNDEF_FLAG "); FLAG_CLR(g_tcf,ERR_UNDEF_FLAG);
	SBIW R30,0
	BRNE _0x1F5
	__POINTW1MN _0x1F6,0
	CALL SUBOPT_0x30
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFFFE)
	CALL SUBOPT_0x5
;    //break;
;   case S_SPI_BUF_CLR: SetTask(Task_SPI_ClrBuf); FLAG_CLR(g_tcf,S_SPI_BUF_CLR);
	RJMP _0x1F7
_0x1F5:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F8
_0x1F7:
	LDI  R30,LOW(_Task_SPI_ClrBuf)
	LDI  R31,HIGH(_Task_SPI_ClrBuf)
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFFFD)
	CALL SUBOPT_0x5
;    //break;
;   case FLUSH_WORKLOG: SetTask(Task_Flush_WorkLog);FLAG_CLR(g_tcf,FLUSH_WORKLOG);
	RJMP _0x1F9
_0x1F8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1FB
_0x1F9:
	LDI  R30,LOW(_Task_Flush_WorkLog)
	LDI  R31,HIGH(_Task_Flush_WorkLog)
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFFFB)
	CALL SUBOPT_0x5
;    //break;
;    default:
_0x1FB:
;    FLAG_SET(g_tcf, ERR_UNDEF_FLAG);
	CALL SUBOPT_0x4
	ORI  R30,1
	CALL SUBOPT_0x5
;    break;
;    }
;}
	RET

	.DSEG
_0x1F6:
	.BYTE 0x12
;
;DECLARE_TASK (Task_LogOut)           //500us ?
;{

	.CSEG
_Task_LogOut:
;//SetTimerTask(Task_LogOut,50,50);
;if(LogIndex){LogOut();} //���� ���-�� ���� � ��� ������ - �������
	LDS  R30,_LogIndex_G000
	LDS  R31,_LogIndex_G000+1
	SBIW R30,0
	BREQ _0x1FC
	CALL _LogOut
;}
_0x1FC:
	RET
;
;
;void Task_Flush_WorkLog(void) //������� ��� �������
;{
_Task_Flush_WorkLog:
;uint16_t i = 0;
;//LED_PORT |= (1<<LED2);
;while(i<512){WorkLog[i] = 0; i++;};
	CALL SUBOPT_0x7
;	i -> R16,R17
_0x1FD:
	__CPWRN 16,17,512
	BRSH _0x1FF
	LDI  R26,LOW(_WorkLog_G000)
	LDI  R27,HIGH(_WorkLog_G000)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x1FD
_0x1FF:
;//LED_PORT &=~(1<<LED2);
;}
_0x20C0007:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void Task_SPI_ClrBuf (void){ //������� rx/tx �������� SPI
_Task_SPI_ClrBuf:
;uint8_t i;
;for(i=0;i<64;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x201:
	CPI  R17,64
	BRSH _0x202
; {
;Spi0_RX_buf[i] = 0;
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_Spi0_RX_buf_G000)
	SBCI R31,HIGH(-_Spi0_RX_buf_G000)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;Spi0_TX_buf[i] = 0;
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_Spi0_TX_buf_G000)
	SBCI R31,HIGH(-_Spi0_TX_buf_G000)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;  //if(i<=SIZE_SPI_BUF_TX){Spi0_TX_buf[i] = 0;}
; }
	SUBI R17,-1
	RJMP _0x201
_0x202:
;}
	JMP  _0x20C0003
;
; void Task_BuffOut  (void)  //������ �������� �� ����1 ��� ����� � ����������
; {
;  //SetTimerTask(Task_BuffOut,50,50);
;  RingBuff_TX();
; }
;
;//=================================================
;//////////////////////////I2C//////////////////////
;
;//============================================================================
;//������� �����
;//============================================================================
;
;// ���������� � ������ ����.
;void EEP_StartWrite(void)
;{
;if (!i2c_eep_WriteByte(0xA0,0x00FF,/*(char)Usart0_RX_buf[15]*/ 9,&EEP_Writed))    // ���� ���� �����������
;    {
;    SetTimerTask(EEP_StartWrite,50,50);                        // ��������� ������� ����� 50��
;    }
;}
;
;// ����� ������ �� �������� �� ������ � ������
;void EEP_Writed(void)
;{
;i2c_Do &= i2c_Free;                                            // ����������� ����
;
;if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))                        // ���� ������ �� �������
;    {
;    SetTimerTask(EEP_StartWrite,20,20);                        // ��������� �������
;    }
;else
;    {
;    SetTask(IIC_Send_Addr_ToSlave);        		// ���� ��� ��, �� ���� �� ���������
;	}											// ����� ������� - �������� ������ ������ 2
;}
;
;// ��������� � SLAVE �����������
;void IIC_Send_Addr_ToSlave(void)
;{
;if (i2c_Do & i2c_Busy)						// ���� ���������� �����
;		{
;		SetTimerTask(IIC_Send_Addr_ToSlave,100,100);	// �� ��������� ����� 100��
;		}
;
;i2c_index = 0;								// ����� �������
;i2c_ByteCount = 2;							// ���� ��� �����
;
;i2c_SlaveAddress = 0xB0;					// ����� ����������� 0xB0
;
;i2c_Buffer[0] = 0x00;						// �� ����� ��� �����, ��� �� ���� ������������
;i2c_Buffer[1] = 0xFF;
;
;i2c_Do = i2c_sawp;							// ����� = ������� ������, �����+��� ����� ������
;
;MasterOutFunc = &IIC_SendeD_Addr_ToSlave;			// ����� ������ �� �������� ���� ��� ������
;ErrorOutFunc = &IIC_SendeD_Addr_ToSlave;			// � ���� ��� �����.
;
;TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// �������!
;i2c_Do |= i2c_Busy;												// ���� ������!
;}
;
;
;// ����� �� �������� IIC
;void IIC_SendeD_Addr_ToSlave(void)
;{
;i2c_Do &= i2c_Free;							// ����������� ����
;
;if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))		// ���� ������� ��� �� ������� ��� ��� ���� �� �����
;	{
;	SetTimerTask(IIC_Send_Addr_ToSlave,20,20);		// ��������� �������
;	}
;}
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
	CALL SUBOPT_0x17
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
_0x209:
	CPI  R17,2
	BRSH _0x20A
;    {
;        RAM_settings.MODE_of_Uart[i] = EE_settings.MODE_of_Uart[i];
	__POINTW2MN _RAM_settings,4
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;        RAM_settings.baud_of_Uart[i] = EE_settings.baud_of_Uart[i];
	MOV  R30,R17
	LDI  R26,LOW(_RAM_settings)
	LDI  R27,HIGH(_RAM_settings)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	__POINTW2MN _EE_settings,2
	CALL SUBOPT_0xA
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;    }
	SUBI R17,-1
	RJMP _0x209
_0x20A:
;  for(i=0;i<COUNT_OF_SPI;i++)
	LDI  R17,LOW(0)
_0x20C:
	CPI  R17,2
	BRSH _0x20D
;    {
;        RAM_settings.MODE_of_Spi[i] = EE_settings.MODE_of_Spi[i];
	__POINTW2MN _RAM_settings,6
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	__POINTW2MN _EE_settings,6
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x33
;        RAM_settings.prescaller_of_Spi[i] =  EE_settings.prescaller_of_Spi[i];
	__POINTW2MN _RAM_settings,10
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	__POINTW2MN _EE_settings,10
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x33
;    }
	SUBI R17,-1
	RJMP _0x20C
_0x20D:
;}
	JMP  _0x20C0003
;
;inline void First_EE_init(void){ // settings transfer from eeprom to ram
_First_EE_init:
;uint8_t i = 0;
;  for(i=0;i<COUNT_OF_UARTS;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x20F:
	CPI  R17,2
	BRSH _0x210
;    {
;EE_settings.MODE_of_Uart[i] = USART_NORMAL;
	CALL SUBOPT_0x32
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
;    }
	SUBI R17,-1
	RJMP _0x20F
_0x210:
;    EE_settings.baud_of_Uart[0] = 576; //57600baud
	__POINTW2MN _EE_settings,2
	LDI  R30,LOW(576)
	LDI  R31,HIGH(576)
	CALL __EEPROMWRW
;    EE_settings.baud_of_Uart[1] = 288; //28800baud
	__POINTW2MN _EE_settings,4
	LDI  R30,LOW(288)
	LDI  R31,HIGH(288)
	CALL __EEPROMWRW
;  for(i=0;i<COUNT_OF_SPI;i++)
	LDI  R17,LOW(0)
_0x212:
	CPI  R17,2
	BRSH _0x213
;    {
;EE_settings.MODE_of_Spi[i] = 0;
	__POINTW2MN _EE_settings,6
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL __EEPROMWRB
;EE_settings.prescaller_of_Spi[i] = 16;
	__POINTW2MN _EE_settings,10
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LDI  R30,LOW(16)
	CALL __EEPROMWRB
;    }
	SUBI R17,-1
	RJMP _0x212
_0x213:
;}
	JMP  _0x20C0003
;
;
;void HARDWARE_init(void)
;{
_HARDWARE_init:
; GPIO_init();
	RCALL _GPIO_init
; ADC_init(); //Upd-6
	RCALL _ADC_init
; ADC_calibrate(); //Upd-7
	RCALL _ADC_calibrate
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
; RTC_init(); //Timer 0 used
	RCALL _RTC_init
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
;void SOFTWARE_init (void)
;{
_SOFTWARE_init:
;//#ifdef EEPROM_REINIT  //Upd-5
;if(null_ee != 0x42)	// ���� ������ ��������� - �������������� ���������� ������
	LDI  R26,LOW(_null_ee)
	LDI  R27,HIGH(_null_ee)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x42)
	BREQ _0x214
;   {
;    First_EE_init();  //��������� ������������� ������ (����������� 1 ���)
	RCALL _First_EE_init
;    null_ee = 0x42;
	LDI  R26,LOW(_null_ee)
	LDI  R27,HIGH(_null_ee)
	LDI  R30,LOW(66)
	CALL __EEPROMWRB
;   }
;//#endif
;settings_EE_cpy_R(); //�������� �������� �� ������
_0x214:
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
	CALL SUBOPT_0x34
;USART_Init(USART_1, RAM_settings.MODE_of_Uart[USART_1], RAM_settings.baud_of_Uart[USART_1]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB1MN _RAM_settings,5
	ST   -Y,R30
	__GETW1MN _RAM_settings,2
	CALL SUBOPT_0x34
;
;#ifdef DEBUG
;USART_Init(USART_0, 1, 576);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(576)
	LDI  R31,HIGH(576)
	CALL SUBOPT_0x34
;#endif
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
;
;PARSER_Init();
	CALL _PARSER_Init
;InitRTOS();			// �������������� ����
	RCALL _InitRTOS
;
;
;#ifdef DEBUG
;LogIndex=0;					// ��� � ������
	LDI  R30,LOW(0)
	STS  _LogIndex_G000,R30
	STS  _LogIndex_G000+1,R30
;WorkLog[LogIndex]=1;		// ���������� ����� ������
	CALL SUBOPT_0x1
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2
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
;	argc -> Y+18
;	argv -> Y+16
;	*response -> R16,R17
;	i -> R19
;	Interface_Num -> R18
;	tmp -> Y+12
;	Tmp_param_1 -> R21
;	Tmp_param_2 -> R20
;	str -> Y+6
; {
;#ifdef DEBUG
; Put_In_Log("\r Set");
;#endif
;   if (argc > 1)
;  {
;//////////////////////////////////////////////////////////////////
;/////////////////////UART_SET_START///////////////////////////////
;      if (!strcmpf(argv[1], Uart))
;     {
;#ifdef DEBUG
;   Put_In_Log("\r Uart");
;#endif
;
;       if (argc > 2)
;        {
;          tmp = PARS_StrToUint(argv[2]);//Get number of interface
;          if (tmp <= COUNT_OF_UARTS){Interface_Num = tmp; response = ok;
;#ifdef DEBUG
;  Put_In_Log("\r Num");
;#endif
;          }
;          else{response = largeValue; goto exit;}
;
;         if (argc > 3)    //Mode
;        {
;             if (!strcmpf(argv[3], Mode))
;             {
;               tmp = PARS_StrToUchar(argv[4]); //Get uart mode
;              if (tmp==1 || tmp==0){RAM_settings.MODE_of_Uart[Interface_Num] = tmp; response = ok;
;#ifdef DEBUG
;  Put_In_Log("\r Mode");
;#endif
;               i = 2; //go to next param "speed"
;               }
;              else{response = largeValue;
;#ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\rM EXIT");
; Put_In_Log("\rM EXIT");
;#endif
;            goto exit;}
;             }
;
;             if (!strcmpf(argv[3+i], Speed)) //may be 3 or 5th param
;             {
;              tmp = PARS_StrToUint(argv[4+i]); //get Baud Rate
;              if (tmp <= MAX_BAUD_RATE)
;              {
;              RAM_settings.baud_of_Uart[Interface_Num] = tmp;
;              response = ok; i = 0;
;#ifdef DEBUG
;  Put_In_Log("\r ");
;  Put_In_LogFl(Speed);
;#endif
;              }
;              else{response = largeValue;
;#ifdef DEBUG
; Put_In_Log("\rM EXIT");
;#endif
;             goto exit;}
;        }
;
;     USART_Init(Interface_Num, RAM_settings.MODE_of_Uart[Interface_Num], RAM_settings.baud_of_Uart[Interface_Num]);
;     Interface_Num = 0;
;
;     StopRTOS();
;     EE_settings.MODE_of_Uart[Interface_Num] = RAM_settings.MODE_of_Uart[Interface_Num];  //save to eeprom
;     EE_settings.baud_of_Uart[Interface_Num] = RAM_settings.baud_of_Uart[Interface_Num];
;     RunRTOS();
;#ifdef DEBUG          //�� ����������� ���������!!!
; Put_In_Log("\r Uart_init");
; //print_settings_ram();
;#endif
;      }
;     }
;#ifdef DEBUG
;       USART_FlushTxBuf(USART_0);
;#endif
;    }
;/////////////////////UART_SET_END////////////////////////////////
;/////////////////////////////////////////////////////////////////
;
;//////////////////////////////////////////////////////////////////
;/////////////////////SPI_SET_START////////////////////////////////
;     if (!strcmpf(argv[1], Spi))
;     {
;#ifdef DEBUG
;    Put_In_Log("\r Spi");
;#endif
;       if (argc > 2)
;        {
;#ifdef DEBUG
;  Put_In_Log("\rS Num");
;#endif
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface
;          if (tmp <= COUNT_OF_SPI){Interface_Num = tmp; response = ok;}
;          else{response = largeValue; goto exit;}
;
;      if (argc > 3)    //Mode
;      {
;         if (!strcmpf(argv[3], Mode))
;         {
;            tmp = PARS_StrToUchar(argv[4]); //Get spi mode
;            if (tmp==1 || tmp==0){RAM_settings.MODE_of_Spi[Interface_Num] = tmp;
;            i = 2; //go to next param "speed"
;            response = ok;
; #ifdef DEBUG
;Put_In_Log("\rS Mode-");
;#endif
;            }
;            else{response = largeValue; goto exit;}
;        }
;
;          if (!strcmpf(argv[3+i], Prescaller)) //Prescaller, may be 3 or 5th param
;         {
;            tmp = PARS_StrToUchar(argv[4+i]); //get SPI prescaller Rate
;            if (tmp <= MAX_SPI_PRESCALLER){RAM_settings.prescaller_of_Spi[Interface_Num] = tmp;
;            i += 2;
;            response = ok;
;#ifdef DEBUG
;Put_In_Log("\rS Presc-");
;#endif
;            }
;            else{response = largeValue; goto exit;}
;        }
;
;          if (!strcmpf(argv[3+i], PhaPol)) //may be 3 or 5 or 7th  param
;         {
;            tmp = PARS_StrToUchar(argv[4+i]);//get phase/polarity mode (0-3)
;           if (tmp>=0 && tmp <= 3)
;           {
;            switch(tmp){  //phase/polarity select
;             case 0:
;              Tmp_param_1 = 0; Tmp_param_2 = 0;
;             break;
;             case 1:
;              Tmp_param_1 = 0; Tmp_param_2 = 1;
;             break;
;             case 2:
;              Tmp_param_1 = 1; Tmp_param_2 = 0;
;             break;
;             case 3:
;              Tmp_param_1 = 1; Tmp_param_2 = 1;
;             break;
;             default:
;              Tmp_param_1 = 0; Tmp_param_2 = 0;
;             break;
;            } response = ok;
;#ifdef DEBUG
; Put_In_Log("\rS PhaPol-");
;#endif
;            RAM_settings.PhaPol_of_Spi[Interface_Num] = tmp; //Upd - 1
;           }
;           else{response = wrongValue; goto exit;}
;         }
;     SPI_init(Interface_Num, RAM_settings.MODE_of_Spi[Interface_Num], Tmp_param_2 ,Tmp_param_1, RAM_settings.prescaller_of_Spi[Interface_Num]);
;     i = 0; Tmp_param_1=0; Tmp_param_2=0;
;
;      EE_settings.MODE_of_Spi[Interface_Num] = RAM_settings.MODE_of_Spi[Interface_Num];
;      EE_settings.PhaPol_of_Spi[Interface_Num] = RAM_settings.PhaPol_of_Spi[Interface_Num];//Upd - 1
;     // Tmp_param_2 ,Tmp_param_1,
;      EE_settings.prescaller_of_Spi[Interface_Num] = RAM_settings.prescaller_of_Spi[Interface_Num];
;
;
;#ifdef DEBUG
; Put_In_Log("\rS SpiInit");
;#endif
;      }
;     }
;    }
;/////////////////////SPI_SET_END//////////////////////////////////
;//////////////////////////////////////////////////////////////////
;
;//////////////////////////////////////////////////////////////////
;/////////////////////I2C_SET_START///////////////////////////////
;      if (!strcmpf(argv[1], I2c))
;     {
;#ifdef DEBUG
;   Put_In_Log("\r I2c");
;#endif
;
;       if (argc > 2)
;        {
;          tmp = PARS_StrToUint(argv[2]);//Get number of interface
;          if (tmp <= COUNT_OF_UARTS){Interface_Num = tmp; response = ok;
;#ifdef DEBUG
;  Put_In_Log("\r Num");
;#endif
;          }
;          else{response = largeValue; goto exit;}
;
;         if (argc > 3)    //Mode
;        {
;             if (!strcmpf(argv[3], Mode))
;             {
;               tmp = PARS_StrToUchar(argv[4]); //Get uart mode
;              if (tmp==1 || tmp==0){RAM_settings.MODE_of_Uart[Interface_Num] = tmp; response = ok;
;#ifdef DEBUG
;  Put_In_Log("\r Mode");
;#endif
;               i = 2; //go to next param "speed"
;               }
;              else{response = largeValue;
;#ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\rM EXIT");
; Put_In_Log("\rM EXIT");
;#endif
;            goto exit;}
;             }
;
;             if (!strcmpf(argv[3+i], Speed)) //may be 3 or 5th param
;             {
;              tmp = PARS_StrToUint(argv[4+i]); //get Baud Rate
;              if (tmp <= MAX_BAUD_RATE)
;              {
;              RAM_settings.baud_of_Uart[Interface_Num] = tmp;
;              response = ok; i = 0;
;#ifdef DEBUG
;  Put_In_Log("\r ");
;  Put_In_LogFl(Speed);
;#endif
;              }
;              else{response = largeValue;
;#ifdef DEBUG
; Put_In_Log("\rM EXIT");
;#endif
;             goto exit;}
;        }
;
;     USART_Init(Interface_Num, RAM_settings.MODE_of_Uart[Interface_Num], RAM_settings.baud_of_Uart[Interface_Num]);
;     Interface_Num = 0; //?
;
;     EE_settings.MODE_of_Uart[Interface_Num] = RAM_settings.MODE_of_Uart[Interface_Num];  //save to eeprom
;     EE_settings.baud_of_Uart[Interface_Num] = RAM_settings.baud_of_Uart[Interface_Num];
;#ifdef DEBUG          //�� ����������� ���������!!!
; Put_In_Log("\r I2c_init");
; //print_settings_ram();
;#endif
;      }
;     }
;#ifdef DEBUG
;       USART_FlushTxBuf(USART_0);
;#endif
;    }
;/////////////////////I2C_SET_END////////////////////////////////
;/////////////////////////////////////////////////////////////////
;  }
; }
;
;/////////////////////WRITE_COMAND////////////////////////////////
;/////////////////////////////////////////////////////////////////
;if (!strcmpf(argv[0], W)) //Write
; {
; #ifdef DEBUG
; Put_In_Log("\r W");
;#endif
;  if (argc > 1)
;  {
;///////////////////////////////////////////////////////////////////
;/////////////////////UART_WRITE_START//////////////////////////////
;      if (!strcmpf(argv[1], Uart))
;     {
;       if (argc > 2)
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
;          if (tmp <= COUNT_OF_UARTS){Interface_Num = tmp; response = ok;}
;          else{response = largeValue;}
;      if (argc > 3)    //Data
;      {
;      StopRTOS; //��� ��� �������� �� UART-� ����� ���� ���������,RTOS �� ����� ����������� (��� ������� ��������� ������������)
;        USART_Send_Str(Interface_Num, argv[3]); //TODO ��������� �������� ��������
;      RunRTOS;
;      #ifdef DEBUG
;Put_In_Log("\r U D>TX ");
;  itoa(PARS_StrToUint(argv[3]),str);
;Put_In_Log(str); //convert dec to str
;     #endif
;      }
;     }
;    }
;/////////////////////UART_WRITE_END////////////////////////////////
;///////////////////////////////////////////////////////////////////
;
;///////////////////////////////////////////////////////////////////
;/////////////////////SPI_WRITE-READ_START//////////////////////////
;    if (!strcmpf(argv[1], Spi))
;     {
; #ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\r SPI ");
; #endif
;       if (argc > 2)
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
;          if (tmp <= COUNT_OF_SPI){Interface_Num = tmp; response = ok;
; #ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\r SPI num w ");
; #endif
;          }
;          else{response = largeValue;}
;
;      if (argc > 3)    //Data
;      {
;#ifdef DEBUG
;
;Put_In_Log("\r S D>TX ");
; itoa(PARS_StrToUint(argv[3]),str);  //�������� ������� �� > 65535
;Put_In_Log(str); //convert dec to str
; #endif
;
; SPI_RW_Buf(10/*array_size(argv[3])*/, argv[3], Spi0_RX_buf); //TODO ���������� ���-�� �������������
;
; #ifdef DEBUG
;Put_In_Log("\r S D<RX ");
;Put_In_Log(Spi0_RX_buf);
;
;#warning ������ �� ������, � ������ ���� ����, ��� ���� ���������� ������ ������� �������
;         //���� ����������� � ������� ������ � � ������������ ���������� ������ ��� �������� �����
;FLAG_SET(g_tcf,S_SPI_BUF_CLR);//  = SetTask(Task_SPI_ClrBuf);
;//SetTimerTask(Task_SPI_ClrBuf, 10);
; // USART_Send_Str(SYSTEM_USART, Spi0_RX_buf);
;  #endif
;      }
;     }
;    }
;/////////////////////SPI_WRITE-READ_END////////////////////////////
;///////////////////////////////////////////////////////////////////
;
;///////////////////////////////////////////////////////////////////
;/////////////////////I2C_WRITE_START//////////////////////////////
;    if (!strcmpf(argv[1], I2c))
;     {
; #ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\r I2c ");
; #endif
;       if (argc > 2)
;        {
;          tmp = PARS_StrToUchar(argv[2]);//Get number of interface to write
;          if (tmp <= COUNT_OF_I2C){Interface_Num = tmp; response = ok;
; #ifdef DEBUG
; //USART_Send_Str(SYSTEM_USART,"\r I2C num w ");
; #endif
;          }
;          else{response = largeValue;}
;
;      if (argc > 3)    //Data
;      {
;#ifdef DEBUG
;
;Put_In_Log("\r I2C D>TX ");
; itoa(PARS_StrToUint(argv[3]),str);  //�������� ������� �� > 65535
; USART_Send_Str(SYSTEM_USART,str); //convert dec to str
; #endif
;
; //I2C_RW_Buf(10/*array_size(argv[3])*/, argv[3], Spi0_RX_buf); //TODO ���������� ���-�� �������������
; //I2C_write(argv[3]);
;
;
; #ifdef DEBUG
;Put_In_Log("\r I2C D<RX ");
;  USART_Send_Str(SYSTEM_USART, Spi0_RX_buf);
;  #endif
;      }
;     }
;    }
;/////////////////////I2C_WRITE_END/////////////////////////////////
;///////////////////////////////////////////////////////////////////
;
;///////////////////////////////////////////////////////////////////
;/////////////////////READ_COMAND_START//////////////////////////////
;
;
;
;/////////////////////READ_COMAND_END//////////////////////////////
;///////////////////////////////////////////////////////////////////
;   }
; }
;
; /*
; ���������  ���� � uart1,
; �������� ��������� spi (� 1 ����������!!).
; �������� ���������� � ������,
;
; ������� �2�,
; �������� ����� ������������ �/�� �������� ���������.
; */
;
;if (!strcmpf(argv[0], "y")){  SetTask(Task_BuffOut);  U1_in_buf_flag = 1; response = ok;}
;if (!strcmpf(argv[0], "n")){  ClearTimerTask(Task_BuffOut);  U1_in_buf_flag = 0; response = ok;}
;if (!strcmpf(argv[0], "a")){  SetTask(Task_AdcOnLcd);  response = ok;}
;
;    if (!strcmpf(argv[0], Help)){ print_help(); response = ok; }
;    if (!strcmpf(argv[0], boot)){response = ok;#asm("call 0x1E00");}//Boot_reset "Goto bootloader"
;    if (!strcmpf(argv[0], reset)){response = ok;#asm("jmp 0x0000");} //reset
;    // dbg �� �������� ��������� ��-�� ���������� ����(�������� �������� �������������, � � help �� ��.)
;    if (!strcmpf(argv[0], dbg)){StopRTOS(); print_settings_eeprom(); print_settings_ram(); print_sys(); response = ok; RunRTOS();}//stop=15kbt
;    if (!strcmpf(argv[0], "s")){ print_sys(); response = ok;}
;    if (!strcmpf(argv[0], "E")){SetTask(EEP_StartWrite); response = ok;}  // ��������� ������� ������ � ������.
;
; //EE_settings = RAM_settings; //rewrite settings to EEPROM
;
;exit:
;  //USART_FlushTxBuf(SYSTEM_USART);
;  USART_Send_StrFl(SYSTEM_USART,response);
;#ifdef DEBUG
; // RunRTOS();
;#endif
;}

	.DSEG
_0x216:
	.BYTE 0xDA
;
;
;// G_vars are here
;volatile uint16_t tmp = 0;
;
;//TODO ���������� ������ ������ � �������� ������� ��� � http://habrahabr.ru/post/241941/
; //������������� �������� ������, ���� ����� � ����������� ����! (2-� ������)
;  //�������� �������������!
; //�������� ���������� SPI!
;
;void main(void)
; 0000 001E {

	.CSEG
_main:
; 0000 001F #ifdef DEBUG   //������������� � ���������
; 0000 0020     DDRD.LED2=1;LED_PORT |= (1<<LED2);  //Led VD2
	SBI  0x11,7
	SBI  0x12,7
; 0000 0021     delay_ms(35);
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CALL SUBOPT_0x8
; 0000 0022     DDRD.LED2=0;LED_PORT  &= ~(1<<LED2); //Led VD2
	CBI  0x11,7
	CBI  0x12,7
; 0000 0023 #endif
; 0000 0024 
; 0000 0025 HARDWARE_init();
	RCALL _HARDWARE_init
; 0000 0026 SOFTWARE_init();
	RCALL _SOFTWARE_init
; 0000 0027 
; 0000 0028 #ifdef DEBUG
; 0000 0029     DDRD.LED2=1;//PORTD.7=1;  //Led VD2
	SBI  0x11,7
; 0000 002A     DDRD.LED1=1;//PORTD.6=1;    //Led VD1
	SBI  0x11,6
; 0000 002B     DDRD.LED3=1;//PORTD.6=1;    //Led LED3
	SBI  0x11,5
; 0000 002C     USART_Send_StrFl(USART_1,start);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x35
; 0000 002D     USART_Send_StrFl(SYSTEM_USART,start);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x35
; 0000 002E #endif
; 0000 002F 
; 0000 0030 //sprintf(lcd_buf, "Z=%d", v_u32_SYS_TICK); ;LcdString(1,3); LcdUpdate();
; 0000 0031 //RunRTOS();			// ����� ����.
; 0000 0032 
; 0000 0033 // ������ ������� �����.
; 0000 0034 SetTask(Task_Initial);
	LDI  R30,LOW(_Task_Initial)
	LDI  R31,HIGH(_Task_Initial)
	CALL SUBOPT_0x2F
; 0000 0035 
; 0000 0036 RunRTOS();			// ����� ����.
	CALL _RunRTOS
; 0000 0037 while (1)
_0x271:
; 0000 0038  {
; 0000 0039 //wdt_reset();	// ����� ��������� �������
; 0000 003A TaskManager();	// ����� ����������
	RCALL _TaskManager
; 0000 003B  }
	RJMP _0x271
; 0000 003C } //END MAIN
_0x274:
	RJMP _0x274
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
;// Timer2 interrupt service routine
;interrupt [RTOS_ISR] void timer2_comp_isr(void)//RTOS Interrupt 1mS
; 0000 004B {
_timer2_comp_isr:
	CALL SUBOPT_0x1A
; 0000 004C  v_u32_SYS_TICK++;
	LDI  R26,LOW(_v_u32_SYS_TICK)
	LDI  R27,HIGH(_v_u32_SYS_TICK)
	CALL SUBOPT_0x12
; 0000 004D   TimerService();
	CALL _TimerService
; 0000 004E }
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
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0052 {
_timer1_ovf_isr:
	CALL SUBOPT_0x15
; 0000 0053 v_u16_TIM_1_OVR_FLAG++;
	LDI  R26,LOW(_v_u16_TIM_1_OVR_FLAG)
	LDI  R27,HIGH(_v_u16_TIM_1_OVR_FLAG)
	CALL SUBOPT_0x14
; 0000 0054 }
	CALL SUBOPT_0x16
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
;//#undef DEBUG
;/*
;-��������� ������ ��� ����� ��������, ���� ������ ���������� �� 50-100��� ��� 16���?
;
;DI HALT: 9 ������ 2012 � 21:08
;����� ����� ��������. ��� �������� ������ ����� ��������������,
;������� ���������� ����� ��������� ������ ������ ����� 600 ������.
;�� ��� ����� ����. ������� �� � ������� �������� ������� �������,
;��������� ������� ������� 700 ������, ��������� ������ ����� 400 ������.
;//=150uS - ����� �� �������������� ������ (��������� �� ��������. ���^)
;������� ������� ������� �� 500��� ,�� ������ ����� �������� ������, ����� ������ ������ �����.
;*/
;
;
;/*
;  UPDATE - ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� �����
;  ����������� ������ �� ������� TTask, ������� ��� "���������",
;  �������������� ���������� ���� ����� �����������.
;  MEMORY -58 WORDS
;*/
;
;  //���������� ������ � ������� - 290���
;  // SetTimerTask + TaskManager ��� 30 ����� = 312��� (�� ������� � ��������)
;
;// ������� �����, ��������.
;// ��� ������ - ��������� �� �������
;//volatile static TPTR	TaskQueue[TaskQueueSize+1];			// ������� ����������
;//update
;enum TASK_STATUS {WAIT, RDY, IN_PROC, DONE};
;#warning �������������� ��������� ��������� ��� ������ � ���������
;volatile static struct
;{
;                        TPTR GoToTask; 					// ��������� ��������
;                        uint16_t TaskDelay;				// �������� � �� ����� �������� ������
;                        uint16_t TaskPeriod;			// �������� � �� ����� ��������� ��������
;                        uint8_t TaskStatus;
;						//TODO �������� �������� � ��������
; #ifdef DEBUG
;  uint32_t sys_tick_time; // �������� ���������� ������� �� ������ ���������� ������ � �����
;  uint16_t exec_time;       // ������� ��������� ����� ���������� ������
;  uint8_t  flag;             // ��������� ����� (������������ �������, ������,..)
;  uint8_t hndl;
; #endif
;} TTask[MainTimerQueueSize+1];	// ������� ��������
;
; volatile uint32_t exec_task_addr = 0; //for debug
; volatile static uint8_t timers_cnt_tail = 1;

	.DSEG
;
;
;
;  void clear_duplicates (void); //not tested
;
; //===================================================================
;// RTOS ����������. ������� ��������
;  void InitRTOS(void)
; 0001 003C {

	.CSEG
_InitRTOS:
; 0001 003D uint8_t	index;
; 0001 003E       for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,21
	BREQ _0x20006
; 0001 003F     {
; 0001 0040 	    TTask[index].GoToTask = Idle;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0001 0041 	    TTask[index].TaskDelay = 0; //������, ��� ���������� �������� ���������
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
; 0001 0042 	 }
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0043 }
	RJMP _0x20C0003
;
;
;//������ ��������� - ������� ����.
;  void  Idle(void)
; 0001 0048 { //#warning ��������� �������� ������������
_Idle:
; 0001 0049 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0001 004A //clear_duplicates();//����� ������� ������� �� ���������� �����
; 0001 004B //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0001 004C #ifdef DEBUG
; 0001 004D 
; 0001 004E LED_PORT  &=~(1<<LED1);   //��� ������������ �������� �������
	CBI  0x12,6
; 0001 004F 
; 0001 0050 #endif
; 0001 0051 }
	RET
;
; //UPDATE
; void SetTask(TPTR TS){  // ��������� ������ � ������� ��� ������������ ����������
; 0001 0054 void SetTask(TPTR TS){
_SetTask:
; 0001 0055  SetTimerTask(TS,0,0);
;	*TS -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2E
; 0001 0056 }
_0x20C0006:
	ADIW R28,2
	RET
;
;
;//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
;// ����� �������� � ����� ���������� �������. ��������� ��� ������.
;
;void SetTimerTask(TPTR TS, unsigned int NewTime, unsigned int NewPeriod)    //1 task ~12words
; 0001 005D {
_SetTimerTask:
; 0001 005E uint8_t		index=0;
; 0001 005F static uint8_t		timers_cnt=0;
; 0001 0060 uint8_t		nointerrupted = 0;
; 0001 0061 
; 0001 0062 
; 0001 0063 if (STATUS_REG & (1<<Interrupt_Flag)) 			// �������� ������� ����������, ���������� ������� ����
	ST   -Y,R17
	ST   -Y,R16
;	*TS -> Y+6
;	NewTime -> Y+4
;	NewPeriod -> Y+2
;	index -> R17
;	nointerrupted -> R16
	LDI  R17,0
	LDI  R16,0
	IN   R30,0x3F
	SBRS R30,7
	RJMP _0x20007
; 0001 0064 	{
; 0001 0065 	_disable_interrupts();
	cli
; 0001 0066 	nointerrupted = 1;
	LDI  R16,LOW(1)
; 0001 0067 	}
; 0001 0068 // My UPDATE - optimized
; 0001 0069   for(index=0;index!=timers_cnt_tail;++index)	// ���� ����� ������ ������
_0x20007:
	LDI  R17,LOW(0)
_0x20009:
	LDS  R30,_timers_cnt_tail_G001
	CP   R30,R17
	BREQ _0x2000A
; 0001 006A   {
; 0001 006B         if (TTask[index].GoToTask == TS)
	CALL SUBOPT_0x36
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2000B
; 0001 006C 	{
; 0001 006D 		TTask[index].TaskDelay = NewTime;		// � ���� �������� �������
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3A
; 0001 006E         TTask[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
; 0001 006F         TTask[index].TaskStatus = WAIT;      //���� - ������� ����������!
; 0001 0070         if (nointerrupted) {_enable_interrupts();}	// ��������� ����������
	CPI  R16,0
	BREQ _0x2000C
	sei
; 0001 0071         return;									// �����.
_0x2000C:
	RJMP _0x20C0005
; 0001 0072 	}
; 0001 0073 	if (TTask[index].GoToTask == Idle)
_0x2000B:
	CALL SUBOPT_0x36
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(_Idle)
	LDI  R31,HIGH(_Idle)
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2000D
; 0001 0074 	{
; 0001 0075 		TTask[index].GoToTask = TS;			// ��������� ���� �������� ������
	CALL SUBOPT_0x36
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0001 0076 		TTask[index].TaskDelay = NewTime;		// � ���� �������� �������
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3A
; 0001 0077         TTask[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
; 0001 0078         TTask[index].TaskStatus = WAIT;      //���� - ������� ����������!
; 0001 0079                                   //������� �������������� ��������
; 0001 007A         timers_cnt_tail++; //����� �� ����������� ������ ����� �������
	LDS  R30,_timers_cnt_tail_G001
	SUBI R30,-LOW(1)
	STS  _timers_cnt_tail_G001,R30
; 0001 007B         if (nointerrupted) {_enable_interrupts();}	// ��������� ����������
	CPI  R16,0
	BREQ _0x2000E
	sei
; 0001 007C         return;									// �����.
_0x2000E:
	RJMP _0x20C0005
; 0001 007D 	}
; 0001 007E   }
_0x2000D:
	SUBI R17,-LOW(1)
	RJMP _0x20009
_0x2000A:
; 0001 007F // ��� ����� ������� return c ����� ������ - ��� ��������� ��������
; 0001 0080 }
_0x20C0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;/*=================================================================================
;��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.
;*/
;volatile uint8_t	tmp_adr;
;inline void TaskManager(void)
; 0001 0087 {
_TaskManager:
; 0001 0088 uint8_t		index=0;
; 0001 0089 char tmp_str[10];
; 0001 008A TPTR task;                 //TODO ������� ����������� ������������!
; 0001 008B 
; 0001 008C   for(index=0;index!=timers_cnt_tail;++index)   // ����������� ������� � ������� ������ ������
	SBIW R28,10
	CALL __SAVELOCR4
;	index -> R17
;	tmp_str -> Y+4
;	*task -> R18,R19
	LDI  R17,0
	LDI  R17,LOW(0)
_0x20010:
	LDS  R30,_timers_cnt_tail_G001
	CP   R30,R17
	BRNE PC+3
	JMP _0x20011
; 0001 008D 	{
; 0001 008E       if ((TTask[index].TaskStatus == RDY)) // ���������� ������ ������ � ��, ����� ������� ��� �� �������
	CALL SUBOPT_0x3B
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x20012
; 0001 008F 		{
; 0001 0090           LED_PORT |= (1<<LED1);   //��� ������������ �������� �������
	SBI  0x12,6
; 0001 0091           task=TTask[index].GoToTask;  // �������� ������ �.�. �� ����� ���������� ����� ���������� ������
	CALL SUBOPT_0x36
	LD   R18,Z
	LDD  R19,Z+1
; 0001 0092 
; 0001 0093 
; 0001 0094           if(TTask[index].TaskPeriod == 0) //���� ������ 0 - ������� ������ �� ������
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,4
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x20013
; 0001 0095            {
; 0001 0096                 ClearTimerTask(task);
	ST   -Y,R19
	ST   -Y,R18
	RCALL _ClearTimerTask
; 0001 0097            }
; 0001 0098            else
	RJMP _0x20014
_0x20013:
; 0001 0099            {
; 0001 009A                 TTask[index].TaskDelay = TTask[index].TaskPeriod; //���������� ��������
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R30
	__ADDW1MN _TTask_G001,2
	MOVW R22,R30
	__ADDW2MN _TTask_G001,4
	CALL __GETW1P
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0001 009B                 TTask[index].TaskStatus = WAIT;
	CALL SUBOPT_0x3B
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0001 009C            }
_0x20014:
; 0001 009D              //������ ��� �� ���������� ������
; 0001 009E 
; 0001 009F #ifdef DEBUG                                            //������ ��-��� ������ ��� ����
; 0001 00A0 	_disable_interrupts();
	cli
; 0001 00A1             tmp_adr =(uint8_t)task;     //���� ������ ��� ���������, �� ��� �� ����� ������!
	STS  _tmp_adr,R18
; 0001 00A2             TTask[index].hndl = tmp_adr;
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,14
	LDS  R26,_tmp_adr
	STD  Z+0,R26
; 0001 00A3             TTask[index].sys_tick_time = v_u32_SYS_TICK;
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,7
	LDS  R26,_v_u32_SYS_TICK
	LDS  R27,_v_u32_SYS_TICK+1
	LDS  R24,_v_u32_SYS_TICK+2
	LDS  R25,_v_u32_SYS_TICK+3
	CALL __PUTDZ20
; 0001 00A4 	_enable_interrupts();
	sei
; 0001 00A5 #endif
; 0001 00A6              v_u32_SYS_TICK_TMP1 = v_u32_SYS_TICK; //�������� ����� ��������� ������
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0001 00A7             _enable_interrupts();						// ��������� ����������
	sei
; 0001 00A8             (task)();								    // ��������� � ������
	MOVW R30,R18
	ICALL
; 0001 00A9              if((v_u32_SYS_TICK_TMP1 = v_u32_SYS_TICK - v_u32_SYS_TICK_TMP1)>=1){ itoa(v_u32_SYS_TICK_TMP1,tmp_str);Put_In_Log(tmp_str);}
	LDS  R26,_v_u32_SYS_TICK_TMP1
	LDS  R27,_v_u32_SYS_TICK_TMP1+1
	LDS  R24,_v_u32_SYS_TICK_TMP1+2
	LDS  R25,_v_u32_SYS_TICK_TMP1+3
	CALL SUBOPT_0x3C
	CALL __SUBD12
	CALL SUBOPT_0x3D
	__CPD1N 0x1
	BRLO _0x20015
	LDS  R30,_v_u32_SYS_TICK_TMP1
	LDS  R31,_v_u32_SYS_TICK_TMP1+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _itoa
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x30
; 0001 00AA             //�� ���������� �� ���� ������ ���� �� return!!!
; 0001 00AB            // TTask[index].TaskStatus = DONE;         //������ ������ ������ ������
; 0001 00AC /*#ifdef DEBUG
; 0001 00AD 	_disable_interrupts();
; 0001 00AE             Timer_3_stop();                            //��������� ������ ������� ����������
; 0001 00AF             TTask[index].exec_time = Timer_3_get_val();
; 0001 00B0             TTask[index].flag = v_u16_TIM_1_OVR_FLAG;
; 0001 00B1     _enable_interrupts();
; 0001 00B2 #endif*/
; 0001 00B3             return;                                     // ����� �� ���������� �����
_0x20015:
	RJMP _0x20C0004
; 0001 00B4 		}
; 0001 00B5 	}
_0x20012:
	SUBI R17,-LOW(1)
	RJMP _0x20010
_0x20011:
; 0001 00B6     _enable_interrupts();							// ��������� ����������
	sei
; 0001 00B7 	Idle();                                     // ������ ������, ������ ��� - �������
	RCALL _Idle
; 0001 00B8 }
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,14
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
; 0001 00C2 {
_TimerService:
; 0001 00C3 uint8_t index;
; 0001 00C4 
; 0001 00C5 for(index=0;index!=timers_cnt_tail;index++)		// ����������� ������� ��������
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x20017:
	LDS  R30,_timers_cnt_tail_G001
	CP   R30,R17
	BREQ _0x20018
; 0001 00C6 	{
; 0001 00C7          if( TTask[index].TaskStatus == WAIT) 		// ���� �� ����������� �
	CALL SUBOPT_0x3B
	LD   R30,Z
	CPI  R30,0
	BRNE _0x20019
; 0001 00C8            {
; 0001 00C9              if(TTask[index].TaskDelay > 0)  // ������ �� ��������, ��
	CALL SUBOPT_0x38
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	CALL __CPW02
	BRSH _0x2001A
; 0001 00CA               {
; 0001 00CB                 TTask[index].TaskDelay--;	// ������� ��� ���.
	CALL SUBOPT_0x38
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 00CC               }
; 0001 00CD               else                         //������ ���� ���������� � ����������
	RJMP _0x2001B
_0x2001A:
; 0001 00CE               {
; 0001 00CF                TTask[index].TaskStatus = RDY;
	CALL SUBOPT_0x3B
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0001 00D0               }
_0x2001B:
; 0001 00D1 		};
_0x20019:
; 0001 00D2 	}
	SUBI R17,-1
	RJMP _0x20017
_0x20018:
; 0001 00D3 }
_0x20C0003:
	LD   R17,Y+
	RET
;
;void ClearTimerTask(TPTR TS)  //��������� �������
; 0001 00D6 {
_ClearTimerTask:
	PUSH R15
; 0001 00D7 uint8_t	 index=0;
; 0001 00D8 bit nointerrupted = 0;
; 0001 00D9 if (STATUS_REG & (1<<Interrupt_Flag))
	ST   -Y,R17
;	*TS -> Y+1
;	index -> R17
;	nointerrupted -> R15.0
	CLR  R15
	LDI  R17,0
	IN   R30,0x3F
	SBRS R30,7
	RJMP _0x2001C
; 0001 00DA {
; 0001 00DB _disable_interrupts(); nointerrupted = 1;
	cli
	SET
	BLD  R15,0
; 0001 00DC }
; 0001 00DD     for(index=0; index<timers_cnt_tail; ++index)
_0x2001C:
	LDI  R17,LOW(0)
_0x2001E:
	LDS  R30,_timers_cnt_tail_G001
	CP   R17,R30
	BRLO PC+3
	JMP _0x2001F
; 0001 00DE     {
; 0001 00DF       if(TTask[index].GoToTask == TS)
	CALL SUBOPT_0x36
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+3
	JMP _0x20020
; 0001 00E0       {
; 0001 00E1            if(index != (timers_cnt_tail - 1))         // ��������� ��������� ������
	LDS  R30,_timers_cnt_tail_G001
	SUBI R30,LOW(1)
	CP   R30,R17
	BREQ _0x20021
; 0001 00E2          {                                            // �� ����� ���������
; 0001 00E3             TTask[index] = TTask[timers_cnt_tail - 1];
	CALL SUBOPT_0x36
	MOVW R22,R30
	CALL SUBOPT_0x3E
	MOVW R26,R22
	LDI  R24,15
	CALL __COPYMML
; 0001 00E4                          //��������� ��������� ������
; 0001 00E5             TTask[timers_cnt_tail - 1].GoToTask = Idle;
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x37
; 0001 00E6             TTask[timers_cnt_tail - 1].TaskDelay = 0; // �������� �����
	CALL SUBOPT_0x3F
	__ADDW1MN _TTask_G001,2
	CALL SUBOPT_0x39
; 0001 00E7             TTask[timers_cnt_tail - 1].TaskPeriod = 0; // �������� �����
	CALL SUBOPT_0x3F
	__ADDW1MN _TTask_G001,4
	CALL SUBOPT_0x39
; 0001 00E8             TTask[timers_cnt_tail - 1].TaskStatus = DONE; // �������� status
	CALL SUBOPT_0x3F
	RJMP _0x2002D
; 0001 00E9          }
; 0001 00EA            else
_0x20021:
; 0001 00EB          {
; 0001 00EC              //���� ������ ��������� � �������
; 0001 00ED             TTask[index].GoToTask = Idle;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0001 00EE             TTask[index].TaskDelay = 0; // �������� �����
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
; 0001 00EF             TTask[index].TaskPeriod = 0; // �������� �����
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,4
	CALL SUBOPT_0x39
; 0001 00F0             TTask[index].TaskStatus = DONE; // �������� status
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
_0x2002D:
	__ADDW1MN _TTask_G001,6
	LDI  R26,LOW(3)
	STD  Z+0,R26
; 0001 00F1          }
; 0001 00F2         timers_cnt_tail--;  //��������� ���-�� �����
	LDS  R30,_timers_cnt_tail_G001
	SUBI R30,LOW(1)
	STS  _timers_cnt_tail_G001,R30
; 0001 00F3         if (nointerrupted) _enable_interrupts();
	SBRS R15,0
	RJMP _0x20023
	sei
; 0001 00F4         return;
_0x20023:
	RJMP _0x20C0002
; 0001 00F5       }
; 0001 00F6     }
_0x20020:
	SUBI R17,-LOW(1)
	RJMP _0x2001E
_0x2001F:
; 0001 00F7 }
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	POP  R15
	RET
;
;
;  //TODO look at http://we.easyelectronics.ru/Soft/minimalistichnaya-ochered-zadach-na-c.html
; //TODO look at http://we.easyelectronics.ru/Soft/dispetcher-snova-dispetcher.html
;
; void clear_duplicates (void) //not tested
; 0001 00FE  {
; 0001 00FF   uint8_t		index=0;
; 0001 0100   bit		nointerrupted = 0;
; 0001 0101   TPTR task_src;
; 0001 0102 if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������
;	index -> R17
;	nointerrupted -> R15.0
;	*task_src -> R18,R19
; 0001 0103   for(index=0;index!=timers_cnt_tail;++index)
; 0001 0104   {
; 0001 0105      task_src = TTask[index].GoToTask;
; 0001 0106     for(index+1;index!=timers_cnt_tail;++index)
; 0001 0107       {
; 0001 0108        if (TTask[index].GoToTask == task_src) {TTask[index].GoToTask = Idle;}
; 0001 0109       }
; 0001 010A   }
; 0001 010B   if (nointerrupted){_enable_interrupts();}	// ��������� ����������
; 0001 010C  }
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
; 0002 0006 #asm("cli");      //Upd-11
	cli
; 0002 0007 TCCR2 = (1<<WGM21)|(1<<CS22)|(0<<CS20)|(0<<CS21); // Freq = CK/256 - ���������� ����� � ������������
	LDI  R30,LOW(12)
	OUT  0x25,R30
; 0002 0008 										         // ��������� ����� ���������� �������� ���������
; 0002 0009 TCNT2 = 0;								// ���������� ��������� �������� ���������
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0002 000A OCR2  = LO(TimerDivider); 				// ���������� �������� � ������� ���������
	LDI  R30,LOW(62)
	OUT  0x23,R30
; 0002 000B TIMSK = (0<<TOIE2)|(1<<OCIE2);
	LDI  R30,LOW(128)
	OUT  0x37,R30
; 0002 000C #asm("sei");                             // ��������� ���������� RTOS - ������ ��
	sei
; 0002 000D }
	RET
;
;  #warning �������������������� � ���������� TimerDivider � StopRTOS � � ����������� �� �����(�������� �� ����������)
;//RTOS ���������� ������������ ���������� �������
;  void StopRTOS (void)//���������� �������� ������� ���������� �������
; 0002 0012 {
_StopRTOS:
; 0002 0013 TCCR2 = (0<<CS21)|(1<<CS22)|(1<<CS20); // Freq = CK/1024
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0002 0014 }
	RET
;
;
;//RTOS ��������� ���������� �������
;  void FullStopRTOS (void)
; 0002 0019 {
; 0002 001A #asm("cli");
; 0002 001B TCCR2 = 0;                        // �������� ����� � ������������
; 0002 001C TIMSK = (0<<TOIE2)|(0<<OCIE2);	 // ��������� ���������� RTOS - ��������� ��
; 0002 001D #asm("sei");
; 0002 001E }

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
	CALL SUBOPT_0x14
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x14
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
	CALL SUBOPT_0x40
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x41
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x42
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x42
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x45
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
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
_strncpy:
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
___ds1820_scratch_pad:
	.BYTE 0x9
_saved_state_G000:
	.BYTE 0x1
_g_tcf:
	.BYTE 0x2
_U1_in_buf_flag:
	.BYTE 0x1
_symbol:
	.BYTE 0x1
_v_u32_SYS_TICK:
	.BYTE 0x4
_v_u32_SYS_TICK_TMP1:
	.BYTE 0x4
_v_u32_TX_CNT:
	.BYTE 0x4
_v_u32_RX_CNT:
	.BYTE 0x4
_v_u16_TIM_1_OVR_FLAG:
	.BYTE 0x2

	.ESEG
_null_ee:
	.BYTE 0x1
_EE_settings:
	.BYTE 0xC

	.DSEG
_RAM_settings:
	.BYTE 0xC
_WorkLog_G000:
	.BYTE 0x200
_LogIndex_G000:
	.BYTE 0x2
_lcd_buf:
	.BYTE 0xF
_temp_control:
	.BYTE 0x1
_bias:
	.BYTE 0x1
_Vop:
	.BYTE 0x1
_disp_config:
	.BYTE 0x1
_LcdCache:
	.BYTE 0x1F8
_LcdCacheIdx:
	.BYTE 0x2
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
_buf:
	.BYTE 0x80
_argv:
	.BYTE 0x14
_argc:
	.BYTE 0x1
_i:
	.BYTE 0x1
_devider_f:
	.BYTE 0x1
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
_rtc:
	.BYTE 0x4
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
_TTask_G001:
	.BYTE 0x13B
_timers_cnt_tail_G001:
	.BYTE 0x1
_tmp_adr:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R26,_LogIndex_G000
	LDS  R27,_LogIndex_G000+1
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R30,_LogIndex_G000
	LDS  R31,_LogIndex_G000+1
	SUBI R30,LOW(-_WorkLog_G000)
	SBCI R31,HIGH(-_WorkLog_G000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	STD  Z+0,R26
	LDI  R26,LOW(_LogIndex_G000)
	LDI  R27,HIGH(_LogIndex_G000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	IN   R30,0x3F
	LDS  R26,_saved_state_G000
	OR   R30,R26
	OUT  0x3F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDS  R30,_g_tcf
	LDS  R31,_g_tcf+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	STS  _g_tcf,R30
	STS  _g_tcf+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
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
SUBOPT_0x7:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_LcdCacheIdx)
	LDI  R27,HIGH(_LcdCacheIdx)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_LcdCache)
	SBCI R31,HIGH(-_LcdCache)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD2N 0x8
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  _Usart0_txBufHead_G000,R30
	STS  _Usart0_txBufHead_G000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _Usart1_txBufHead_G000,R30
	STS  _Usart1_txBufHead_G000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	SUB  R30,R26
	SBC  R31,R27
	CPI  R30,LOW(0x201)
	LDI  R26,HIGH(0x201)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
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
SUBOPT_0x12:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDS  R30,_Usart1_txBufHead_G000
	LDS  R31,_Usart1_txBufHead_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x14:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  98,R30
	STS  97,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDS  R26,_volt
	LDS  R27,_volt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ADD  R30,R26
	ADC  R31,R27
	STS  _volt,R30
	STS  _volt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1A:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	__GETD1N 0x3F
	CALL __PREINC_BITFD
	__CPD1N 0x3C
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD1N 0x1F
	CALL __PREINC_BITFD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDS  R30,_rtc+2
	LDS  R31,_rtc+3
	LSR  R31
	ROR  R30
	ANDI R30,LOW(0x1F)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1E:
	LDS  R26,_rtc+2
	LDS  R27,_rtc+3
	LDI  R30,LOW(6)
	CALL __LSRW12
	ANDI R30,LOW(0xF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_rtc)
	LDI  R27,HIGH(_rtc)
	LDI  R24,22
	__GETD1N 0xF
	CALL __POSTINC_BITFD
	__GETB1MN _rtc,2
	ANDI R30,LOW(0xC1)
	ORI  R30,2
	__PUTB1MN _rtc,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDS  R30,_rtc+3
	LSR  R30
	LSR  R30
	__ANDD1N 0x3F
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	STS  _i2c_Do,R30
	LDI  R30,LOW(213)
	STS  116,R30
	__CALL1MN _ErrorOutFunc,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDS  R30,_i2c_SlaveAddress
	STS  115,R30
	LDI  R30,LOW(197)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDS  R30,_i2c_Do
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
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
SUBOPT_0x26:
	LDI  R30,LOW(213)
	STS  116,R30
	__CALL1MN _MasterOutFunc,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	STS  _i2c_Do,R30
	LDI  R30,LOW(0)
	STS  _i2c_index,R30
	STS  _i2c_PageAddrIndex,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDS  R26,_i2c_index
	SUBI R26,-LOW(1)
	LDS  R30,_i2c_ByteCount
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDS  R26,_i2c_index
	LDI  R27,0
	SUBI R26,LOW(-_i2c_Buffer)
	SBCI R27,HIGH(-_i2c_Buffer)
	LDS  R30,115
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	LDS  R26,_i2c_SlaveIndex
	LDI  R27,0
	SUBI R26,LOW(-_i2c_InBuff)
	SBCI R27,HIGH(-_i2c_InBuff)
	LDS  R30,115
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	LDS  R30,_i2c_SlaveIndex
	SUBI R30,-LOW(1)
	STS  _i2c_SlaveIndex,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R31,0
	SUBI R30,LOW(-_i2c_OutBuff)
	SBCI R31,HIGH(-_i2c_OutBuff)
	LD   R30,Z
	STS  115,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SetTimerTask

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SetTask

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Put_In_Log

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EE_settings)
	SBCI R27,HIGH(-_EE_settings)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _USART_Init

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	ST   -Y,R30
	LDI  R30,LOW(_start*2)
	LDI  R31,HIGH(_start*2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _USART_Send_StrFl

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_TTask_G001)
	SBCI R31,HIGH(-_TTask_G001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	MOVW R26,R30
	LDI  R30,LOW(_Idle)
	LDI  R31,HIGH(_Idle)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,4
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,6
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(15)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _TTask_G001,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDS  R30,_v_u32_SYS_TICK
	LDS  R31,_v_u32_SYS_TICK+1
	LDS  R22,_v_u32_SYS_TICK+2
	LDS  R23,_v_u32_SYS_TICK+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	STS  _v_u32_SYS_TICK_TMP1,R30
	STS  _v_u32_SYS_TICK_TMP1+1,R31
	STS  _v_u32_SYS_TICK_TMP1+2,R22
	STS  _v_u32_SYS_TICK_TMP1+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDS  R30,_timers_cnt_tail_G001
	SUBI R30,LOW(1)
	LDI  R26,LOW(15)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_TTask_G001)
	SBCI R31,HIGH(-_TTask_G001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	LDS  R30,_timers_cnt_tail_G001
	SUBI R30,LOW(1)
	LDI  R26,LOW(15)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
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
SUBOPT_0x41:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
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
SUBOPT_0x44:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
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

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__GET_BITFD:
	MOV  R0,R24
	MOVW R16,R30
	MOVW R18,R22
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	MOV  R1,R0
	TST  R1
	BREQ __GET_BITFD1
__GET_BITFD0:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R1
	BRNE __GET_BITFD0
__GET_BITFD1:
	AND  R30,R16
	AND  R31,R17
	AND  R22,R18
	AND  R23,R19
	RET

__PUT_BITFD:
	AND  R30,R16
	AND  R31,R17
	AND  R22,R18
	AND  R23,R19
	MOVW R20,R30
	MOVW R24,R22
	TST  R0
	BREQ __PUT_BITFD1
__PUT_BITFD0:
	LSL  R16
	ROL  R17
	ROL  R18
	ROL  R19
	LSL  R20
	ROL  R21
	ROL  R24
	ROL  R25
	DEC  R0
	BRNE __PUT_BITFD0
__PUT_BITFD1:
	COM  R16
	COM  R17
	COM  R18
	COM  R19
	LD   R1,X
	LD   R0,-X
	AND  R0,R18
	AND  R1,R19
	LD   R19,-X
	LD   R18,-X
	AND  R18,R16
	AND  R19,R17
	OR   R18,R20
	OR   R19,R21
	OR   R0,R24
	OR   R1,R25
	ST   X+,R18
	ST   X+,R19
	ST   X+,R0
	ST   X,R1
	RET

__PREINC_BITFD:
	PUSH R16
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	PUSH R21
	RCALL __GET_BITFD
	ADIW R30,1
	ADC  R22,R1
	ADC  R23,R1
	RCALL __PUT_BITFD
	POP  R21
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R16
	RET

__POSTINC_BITFD:
	PUSH R16
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	PUSH R21
	RCALL __GET_BITFD
	PUSH R30
	PUSH R31
	PUSH R22
	PUSH R23
	ADIW R30,1
	ADC  R22,R1
	ADC  R23,R1
	RCALL __PUT_BITFD
	POP  R23
	POP  R22
	POP  R31
	POP  R30
	POP  R21
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R16
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

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
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
