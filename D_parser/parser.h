//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru
//
//  Target(s)...: mega16
//
//  Compiler....: IAR, GCC, CodeVision
//
//  Description.: ������ ������
//
//  Data........: 14.10.13
//
//***************************************************************************

#ifndef PARSER_H
#define PARSER_H

#include <stdint.h>

#ifdef __GNUC__
#include <avr/pgmspace.h>
#endif


#define TRUE   1
#define FALSE  0

#warning � ������ - ���������
#define SIZE_RECEIVE_BUF  128 /*����������� ��������� ������*/
#define AMOUNT_PAR 10 /*���������� ����������� ����*/

/*������� �������*/
void PARSER_Init(void);
void PARS_Parser(char symbol);

/*���������� ���������� ������. �� ������������ � ������ �����*/
/*argc - ���������� ����, argv[] - ������ ���������� �� �����*/
extern void PARS_Handler(uint8_t argc, char *argv[]);

/*�������������� ������� ��� ������ �� ��������*/
uint8_t PARS_EqualStr(char *s1, char *s2);
uint8_t PARS_StrToUchar(char *s);
uint16_t PARS_StrToUint(char *s);

#ifdef __GNUC__
uint8_t PARS_EqualStrFl(char *s1, char const *s2);
#else
uint8_t PARS_EqualStrFl(char *s1, char __flash *s2);
#endif

#endif //PARSER_H