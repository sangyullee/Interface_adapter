#include <HAL.h>
#include <EERTOS.h>



//RTOS Interrupt
ISR(RTOS_ISR)
{
TimerService();



// ��������� ����� ============================================================
void Task1 (void);
void Task2 (void);
void Task3 (void);
//============================================================================
//������� �����
//============================================================================

void Task1 (void)
{
SetTimerTask(Task2,100);
LED_PORT  ^=1<<LED1;
}

void Task2 (void)
{
SetTimerTask(Task1,100);
LED_PORT  &= ~(1<<LED1);
}



//==============================================================================
int main(void)
{
InitAll();			// �������������� ���������
InitRTOS();			// �������������� ����
RunRTOS();			// ����� ����. 

// ������ ������� �����.
SetTask(Task1);


while(1) 		// ������� ���� ����������
{
wdt_reset();	// ����� ��������� �������
TaskManager();	// ����� ����������
}

return 0;
}
