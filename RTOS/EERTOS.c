#include "RTOS/EERTOS.h"
#include "RTOS/EERTOSHAL.h"


/*
��������� ������ ��� ����� ��������, ���� ������ ���������� �� 50-100��� ��� 16���?

DI HALT:
9 ������ 2012 � 21:08
����� ����� ��������. ��� �������� ������ ����� ��������������,
������� ���������� ����� ��������� ������ ������ ����� 600 ������.
�� ��� ����� ����. ������� �� � ������� �������� ������� �������,
��������� ������� ������� 700 ������, ��������� ������ ����� 400 ������.
������� ������� ������� �� 500��� ,�� ������ ����� ������� ������, ����� ������ ������ �����.
*/


/*
  UPDATE - ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� �����
  ����������� ������ �� ������� MainTimer, ������� ��� "���������",
  �������������� ���������� ���� ����� �����������.
  MEMORY -58 WORDS
*/



// ������� �����, ��������.
// ��� ������ - ��������� �� �������
//volatile static TPTR	TaskQueue[TaskQueueSize+1];			// ������� ����������
//update
#warning �������������� ��������� ��������� ��� ������ � ���������
volatile static struct
						{     
                            uint16_t Time;					// �������� � ��
						    TPTR GoToTask; 						// ��������� ��������		
                            //TODO �������� �������� � ��������				    
						}
						MainTimer[MainTimerQueueSize+1];	// ������� ��������


// RTOS ����������. ������� ��������
  void InitRTOS(void)
{
uint8_t	index;

      for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
    {
	    MainTimer[index].GoToTask = Idle;
	    MainTimer[index].Time = 0;
	 }
}


//������ ��������� - ������� ����.
  void  Idle(void)
{
  #warning ��������� �������� ������������
}

 //UPDATE
 void SetTask(TPTR TS){  // ��������� ������ � ������� ��� ������������ ����������
 SetTimerTask(TS,0);
}


//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
// ����� �������� � ����� ���������� �������. ��������� ��� ������.

void SetTimerTask(TPTR TS, unsigned int NewTime)    //1 task ~12words
{
uint8_t		index=0;
uint8_t		nointerrupted = 0;

if (STATUS_REG & (1<<Interrupt_Flag)) 			// �������� ������� ����������, ���������� ������� ����
	{
	_disable_interrupts()
	nointerrupted = 1;
	}
//====================================================================
// My UPDATE - not optimized
  for(index=0;index!=MainTimerQueueSize+1;++index)	//����������� ������� ��������
	{
	if(MainTimer[index].GoToTask == TS)				// ���� ��� ���� ������ � ����� �������
		{
		MainTimer[index].Time = NewTime;			// �������������� �� ��������
		if (nointerrupted) 	_enable_interrupts()	// ��������� ���������� ���� �� ���� ���������.
		return;										// �������. ������ ��� ��� �������� ��������. ���� �����
		}
	}
  for(index=0;index!=MainTimerQueueSize+1;++index)	// ���� �� ������� ������� ������, �� ���� ����� ������
	{
	if (MainTimer[index].GoToTask == Idle)
		{
		MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
		MainTimer[index].Time = NewTime;		// � ���� �������� �������
		if (nointerrupted) 	_enable_interrupts()	// ��������� ����������
		return;									// �����.
		}

	}
//====================================================================
/*
  for(index=0;index!=MainTimerQueueSize+1;++index)	//����������� ������� ��������
	{
	if(MainTimer[index].GoToTask == TS)				// ���� ��� ���� ������ � ����� �������
		{
		MainTimer[index].Time = NewTime;			// �������������� �� ��������
		if (nointerrupted) 	_enable_interrupts()		// ��������� ���������� ���� �� ���� ���������.
		return;										// �������. ������ ��� ��� �������� ��������. ���� �����
		}
	}
  for(index=0;index!=MainTimerQueueSize+1;++index)	// ���� �� ������� ������� ������, �� ���� ����� ������
	{
	if (MainTimer[index].GoToTask == Idle)
		{
		MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
		MainTimer[index].Time = NewTime;		// � ���� �������� �������
		if (nointerrupted) 	_enable_interrupts()	// ��������� ����������
		return;									// �����.
		}

	}	*/								// ��� ����� ������� return c ����� ������ - ��� ��������� ��������
}

/*=================================================================================
��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.
*/

inline void TaskManager(void)
{
uint8_t		index=0;
TPTR task;                 //TODO ������� ����������� ������������!

  for(index=0;index!=MainTimerQueueSize+1;++index) {  // ����������� ������� � ������� ������ ������
		if ((MainTimer[index].GoToTask != Idle)&&(MainTimer[index].Time==0)) // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		{
            task=MainTimer[index].GoToTask;             // �������� ������
		    MainTimer[index].GoToTask = Idle;           // ������ �������
            _enable_interrupts()							// ��������� ����������
            (task)();								    // ��������� � ������
            return;                                     // ����� �� ���������� �����
		}
	}
    _enable_interrupts()							// ��������� ����������
	Idle();                                     // ������ ������, ������ ��� - �������
}

/*
������ �������� ����. ������ ���������� �� ���������� ��� � 1��. ���� ����� ����� ����������� � ����������� �� ������

To DO: �������� � ����������� ��������� ������������ ������� ��������. ����� ����� ����� ��������� �� ����� ������.
� ����� ������������ ��� ������� ������������ �������.
� ���� ������ �� ������ �������� �������� ����������.
*/
inline void TimerService(void)
{
uint8_t index;

for(index=0;index!=MainTimerQueueSize+1;index++)		// ����������� ������� ��������
	{
//==========================================================================
//UPDATE
         if((MainTimer[index].GoToTask != Idle) && 		    // ���� �� �������� �
           (MainTimer[index].Time > 0)) {					// ������ �� ��������, ��
            MainTimer[index].Time--;						// ������� ��� ���.
		};
	}
}

//���������� �� sniuk 7.1.14
void ClearTimerTask(TPTR TS)  //��������� �������
{
uint8_t	 index=0;
uint8_t nointerrupted = 0;
if (STATUS_REG & (1<<Interrupt_Flag))
{
_disable_interrupts();
nointerrupted = 1;
}
    for(index=0; index!=MainTimerQueueSize+1; ++index)
    {
        if(MainTimer[index].GoToTask == TS)
        {
            MainTimer[index].GoToTask = Idle;
            MainTimer[index].Time = 0; // �������� �����
            if (nointerrupted) _enable_interrupts();
            return;
        }
    }
}


  //TODO look at http://we.easyelectronics.ru/Soft/minimalistichnaya-ochered-zadach-na-c.html