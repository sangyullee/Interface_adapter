//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru
//
//  Compiler....: CodeVision 2.04
//
//  Description.: USART/UART. ���������� ��������� �����
//
//  Data........: 3.01.10
//
//***************************************************************************
#ifndef USART_H
#define USART_H


#include <adapter.h>

#define COUNT_OF_UARTS 2

#define SYSTEM_USART  0

#define USART_NORMAL  0
#define USART_DOUBLED 1

#define USART_0  0
#define USART_1  1

// must be power of 2
#define SIZE_BUF_RX 256      //������ ������ ��������� ������� - <255
#define SIZE_BUF_TX 512


#define MAX_BAUD_RATE 1152


#ifndef F_CPU
#error "F_CPU is not defined"
#endif

//---------------------------------------------------  Upd-12
#warning  �� ��������
// ������� ���������� 
#define BAUDRATE        9600L 
 
// ���������� ������ (� ���������) 
#define SPBRG_CONST    ((F_CPU + BAUDRATE*8) / (BAUDRATE*16) - 1) 
#define REAL_BAUDRATE  ((F_CPU + (SPBRG_CONST+1)*8)/((SPBRG_CONST + 1)*16)) 
#define BAUDRATE_ERROR (100L * ((BAUDRATE - REAL_BAUDRATE) + BUADRATE/2) / BAUDRATE) 
 
// �������� ������ �� �������� -2%..+2% 
#if BAUDRATE_ERROR < -2 || BAUDRATE_ERROR > 2 
    #error " �����������   ������   ���������  BAUDRATE" 
#endif  
//------------------------------------------------------



//****************************************************************************
void USART_Init(uint8_t sel, uint8_t mode, uint16_t baudRate); //������������� usart`a

uint8_t USART_Get_txCount(uint8_t sel);                     //����� ����� �������� ����������� ������
void USART_FlushTxBuf(uint8_t sel);                        //�������� ���������� �����
void USART_PutChar(uint8_t sel,char symbol);                    //�������� ������ � �����
void USART_Send_Str(uint8_t sel,char * data);                    //������� ������ �� ��� �� usart`�
void USART_Send_StrFl(uint8_t sel,char __flash * data);          //������� ������ �� ����� �� usart`�

     
uint8_t USART_Get_rxCount(uint8_t sel);                     //����� ����� �������� � �������� ������
void USART_FlushRxBuf(uint8_t sel);                        //�������� �������� �����
char USART_Get_Char(uint8_t sel);                           //��������� �������� ����� usart`a
void USART_GetBuf(uint8_t num, char *buf);          //����������� �������� ����� usart`a

uint16_t usart_calc_BufData (uint16_t BufTail, uint16_t BufHead);  //������� ���-�� ������ � ��������� ������
void UartTxBufOvf_Handler(void); //���������� ������������ ����������� ������ UART //TODO add parameter
#endif //USART_H