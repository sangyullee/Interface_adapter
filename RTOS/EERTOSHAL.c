#include "RTOS/EERTOSHAL.h"

//RTOS ������ ���������� �������
void RTOS_timer_init (void)
{     
	TCNT2 = 0;                                // ���������� ��������� �������� ���������
	OCR2  = LO(RtosTimerDivider);         		// ���������� �������� � ������� ���������
	TIMSK = (0<<TOIE2)|(1<<OCIE2);
}

void RunRTOS (void)
{
	#asm("cli");     
	TCCR2 = (1<<WGM21)|(1<<CS22)|(0<<CS20)|(0<<CS21);    // Freq = CK/256 - ���������� ����� � ������������
	#asm("sei");// ��������� ���������� RTOS - ������ �� // ��������� ����� ���������� �������� ���������
}                             


  #warning �������������������� � ���������� RtosTimerDivider � StopRTOS � � ����������� �� �����(�������� �� ����������)
//RTOS ���������� ������������ ���������� �������
void StopRTOS (void)//���������� �������� ������� ���������� �������
{
	#asm("cli");
	TCCR2 = (0<<CS21)|(1<<CS22)|(1<<CS20); // Freq = CK/1024
	#asm("sei");
}


//RTOS ��������� ���������� �������
void FullStopRTOS (void)
{
	#asm("cli");
	TCCR2 = 0;                        // �������� ����� � ������������
	TIMSK = (0<<TOIE2)|(0<<OCIE2);	 // ��������� ���������� RTOS - ��������� ��
	#asm("sei");
}


void DeadTimerInit (void)
{
	TCCR0 = (1<<WGM01)|(1<<CS02)|(0<<CS00)|(0<<CS01);
	TCNT0=0x00;
	OCR0=LO(DeadTimerDivider);
	TIMSK = (0<<TOIE0)|(1<<OCIE0);
}      