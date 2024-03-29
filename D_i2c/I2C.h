//***************************************************************************
//
//  Author(s)...:
//
//  Target(s)...: Mega
//
//  Compiler....:
//
//  Description.: ������� I2C
//
//  Data........:
//
//***************************************************************************
#ifndef I2C_H
#define I2C_H

//#include <i2c.h>
//#include <1wire.h>

#include <compilers.h>
#include "D_Globals/global_defines.h"


#define COUNT_OF_I2C 2
#define MAX_I2C_SPEED //_MCU_CLOCK_FREQUENCY_/2
#define MAX_I2C_PRESCALLER 64


#define SCL_FREQ (F_CPU/((2*TWI_BITRATE)*PRESCALLER+16))

//SOFTWARE
// I2C Bus functions    //???
#asm
   .equ __i2c_port=0x1B ;PORTA
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm

//#define I2C_PORTX   PORTE
//#define I2C_DDRX    DDRE

//#define SDA    1
//#define SCL    0


//HARDWARE
#define DDR_I2C    DDRD
#define PORT_I2C   PORTD

#define _SDA    1
#define _SCL    0



#define I2C_0 0
#define I2C_1 1
#define I2C_2 2

#define I2C_SLAVE 0
#define I2C_MASTER 1




#define SIZE_I2C_BUF_TX  128
#define SIZE_I2C_BUF_RX  128
/*____________�������____________________*/

 void hard_twi_init(void);
void hard_twi_start(void);
void hard_twi_stop(void);
unsigned char hard_twi_read(unsigned char ack);
unsigned char hard_twi_write(unsigned char data);


void I2C_FlushTxBuf(uint8_t sel); //"�������" ���������� ����� (����� ���� �� ������������)

/*������������� TWI/I2C ������*/
void Soft_I2C_Master_Init(void);
void Hard_I2C_Master_Init_default(void);
void Hard_I2C_Master_Init(bool phase, bool polarity, uint8_t prescaller);


void Hard_I2C_Slave_Init(void);
//void cust_I2C_init(char sel);

#endif //I2C_H




/*
����� �� ������
http://we.easyelectronics.ru/AVR/sniffer-emulyator-i2c-i-1-wire.html

TODO

I2C ������.
��� ������� �� ����� ������� �� ������ ����:
0x1 � ����� ��������
0x2 � ���� ��������
0x4 � ���� + ACK
0xC � ���� + NACK

������� ��� i2c ������-������ ����� ���� �����:
0x05 � ����� (��� ��������)
0x02 � ����
0x07 � �������� ����. (�� ������ ����� � ������, ������� ����� ��������)
0x10 � ��������� ����, �������� ACK
0x11 � ��������� ����, �������� NACK

���� �������:
0x05 � ������� start-condition
0x02 � ������� stop-condition
0x07 � �������� ����, ��� �������� ACK
0x08 � �������� ����, � ����� � NACK
0x10 � ��������� ����, ������� ACK
0x11 � ��������� ����, ������� NACK

1-Wire ������.

��� ������ � 1-Wire ���� 5 ������:
0x01 � ������� RESET �������, � ��������� PRESENSE.
0x03 � ��������� ����
0x06 � �������� ����
0x12 � ���������� �������������� ������� �� ����� Dq
0x13 � ��������� �������������� �������.

����� ���������� ������, �������� ����� ������ ��� ����� ����:
0x01 � �������� RESET, ������� PRESENSE �������.
0x04 � �������� RESET, �� PRESENSE �� ����.
0x06 � ���� ��������
0x09 � ���� �������
0x12 � �������������� ������� ����������
0x13 � �������������� ������� ���������


��� iWire ������� � ������� �� ������� �������/�������� 1 ����- ����-
����������, ��������, ��� ������ ������ ������� ����������� ds1820, ���
��� ������ ��������� rw1990.2- ��� ���� ������� ������ �����, ���� �������
���������� (>10��) ����� ����- ������� �� ����� ������ ����

*/