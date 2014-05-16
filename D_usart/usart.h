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

//#define COUNT_OF_UARTS 2
#define USART_0  0
#define USART_1  1

// must be power of 2
#define SIZE_BUF_RX 256      //������ ������ ��������� ������� - <255
#define SIZE_BUF_TX 512


#define MAX_BAUD_RATE 1152
//****************************************************************************
void USART_Init(uint8_t sel, uint8_t mode, uint16_t baudRate); //������������� usart`a

uint8_t USART_Get_txCount(uint8_t sel);                     //����� ����� �������� ����������� ������
void USART_FlushTxBuf(uint8_t sel);                        //�������� ���������� �����
void USART_PutChar(uint8_t sel,char symbol);                    //�������� ������ � �����
void USART_SendStr(uint8_t sel,char * data);                    //������� ������ �� ��� �� usart`�
void USART_SendStrFl(uint8_t sel,char __flash * data);          //������� ������ �� ����� �� usart`�

     
uint8_t USART_Get_rxCount(uint8_t sel);                     //����� ����� �������� � �������� ������
void USART_FlushRxBuf(uint8_t sel);                        //�������� �������� �����
char USART_GetChar(uint8_t sel);                           //��������� �������� ����� usart`a
void USART_GetBuf(uint8_t num, char *buf);          //����������� �������� ����� usart`a

#endif //USART_H