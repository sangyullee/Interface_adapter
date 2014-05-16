
#include <mega128.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <io.h>

#include "RTOS/HAL.h"
#include "RTOS/EERTOS.h"
#include "RTOS/EERTOSHAL.h"

//RTOS Interrupt
// Timer2 overflow interrupt service routine
interrupt [RTOS_ISR] void timer2_comp_isr(void)
{
 //DDRB.4^=1; 
 TimerService();
}

// ��������� ����� ============================================================
void Task1 (void);
void Task2 (void);
void Task3 (void);
void Task4 (void);

void Task5 (void);
void Task6 (void);
//============================================================================
//������� �����
//============================================================================

void Task1 (void)     
{
SetTimerTask(Task2,500);
LED_PORT  |=1<<LED1;
}

void Task2 (void)
{
SetTimerTask(Task1,500);
LED_PORT  &= ~(1<<LED1);
}

void Task3 (void)
{
SetTimerTask(Task4,1000);
LED_PORT  |= (1<<LED2);
}
void Task4 (void)
{
SetTimerTask(Task3,1000);
LED_PORT  &=~ (1<<LED2);
}





// Declare your global variables here

void main(void)
{
InitAll();			// �������������� ���������
InitRTOS();			// �������������� ����
RunRTOS();			// ����� ����. 

// ������ ������� �����.
SetTask(Task1);     //290uS (50/50) and (10/10)   �� ��� 1/1 ���� 1 ������ 
SetTask(Task3);    //290us  
 
  //SetTask(Task5);    //��� ���������� ������ 285us ����� �� 11��, � ���� - 2.5(!)

while(1) 		// ������� ���� ����������
{
//wdt_reset();	// ����� ��������� �������
TaskManager();	// ����� ����������
}
}
//290uS (50/50) and (10/10)   �� ��� 1/1 ���� 1 ������:
// (1 �� ���� 10.1 ����� ��������� � �������� ��� ���� 1 � 2)
//��� ���-�� �����  6 ����� �������� ���������� ������ �� �������� ~285uS
                                                                       