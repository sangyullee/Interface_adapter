#include "RTOS/EERTOS.h"
#include "RTOS/EERTOSHAL.h"


//#undef DEBUG
/*
-��������� ������ ��� ����� ��������, ���� ������ ���������� �� 50-100��� ��� 16���?

DI HALT: 9 ������ 2012 � 21:08
����� ����� ��������. ��� �������� ������ ����� ��������������,
������� ���������� ����� ��������� ������ ������ ����� 600 ������.
�� ��� ����� ����. ������� �� � ������� �������� ������� �������,
��������� ������� ������� 700 ������, ��������� ������ ����� 400 ������.
//=150uS - ����� �� �������������� ������ (��������� �� ��������. ���^)
������� ������� ������� �� 500��� ,�� ������ ����� �������� ������, ����� ������ ������ �����.
*/


/*
  UPDATE - ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� �����
  ����������� ������ �� ������� MainTimer, ������� ��� "���������",
  �������������� ���������� ���� ����� �����������.
  MEMORY -58 WORDS
*/

  //���������� ������ � ������� - 290���
  // SetTimerTask + TaskManager ��� 30 ����� = 312��� (�� ������� � ��������)

// ������� �����, ��������.
// ��� ������ - ��������� �� �������
//volatile static TPTR	TaskQueue[TaskQueueSize+1];			// ������� ����������
//update
enum TASK_STATUS {WAIT, RDY,IN_PROC, DONE};
#warning �������������� ��������� ��������� ��� ������ � ���������
volatile static struct
{
                        TPTR GoToTask; 					// ��������� ��������
                        uint16_t TaskDelay;				// �������� � �� ����� �������� ������    
                        uint16_t TaskPeriod;			// �������� � �� ����� ��������� �������� 
                        uint8_t Task_status; 
						//TODO �������� �������� � ��������
 #ifdef DEBUG  
  uint32_t sys_tick_time; // �������� ���������� ������� �� ������ ���������� ������ � �����
  uint16_t exec_time;       // ������� ��������� ����� ���������� ������
  uint8_t  flag;             // ��������� ����� (������������ �������, ������,..) 
  uint8_t hndl;
 #endif
} MainTimer[MainTimerQueueSize+1];	// ������� ��������

 volatile uint32_t exec_task_addr = 0; //for debug
 volatile static uint8_t timers_cnt_search_lim = 1;


 //===================================================================
// RTOS ����������. ������� ��������
  void InitRTOS(void)
{
uint8_t	index;
      for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
    {
	    MainTimer[index].GoToTask = Idle;
	    MainTimer[index].TaskDelay = 0;
	 }
}


//������ ��������� - ������� ����.
  void  Idle(void)
{ //#warning ��������� �������� ������������ 
#ifdef DEBUG

LED_PORT  &=~(1<<LED1);   //��� ������������ �������� �������   

#endif
}

 //UPDATE
 void SetTask(TPTR TS){  // ��������� ������ � ������� ��� ������������ ����������
 SetTimerTask(TS,0,0);
}


//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
// ����� �������� � ����� ���������� �������. ��������� ��� ������.

void SetTimerTask(TPTR TS, unsigned int NewTime, unsigned int NewPeriod)    //1 task ~12words
{
uint8_t		index=0;
static uint8_t		timers_cnt=0;
uint8_t		nointerrupted = 0;


if (STATUS_REG & (1<<Interrupt_Flag)) 			// �������� ������� ����������, ���������� ������� ����
	{
	_disable_interrupts();
	nointerrupted = 1;
	}
// My UPDATE - optimized
  for(index=0;index!=timers_cnt_search_lim;++index)	// ���� ����� ������ ������
  {  
        if (MainTimer[index].GoToTask == TS)
	{
		MainTimer[index].TaskDelay = NewTime;		// � ���� �������� �������    
        MainTimer[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
        MainTimer[index].Task_status = WAIT;      //���� - ������� ����������!
        if (nointerrupted) {_enable_interrupts();}	// ��������� ����������
        return;									// �����.
	}
  
	if (MainTimer[index].GoToTask == Idle)
	{
		MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
		MainTimer[index].TaskDelay = NewTime;		// � ���� �������� �������        
        MainTimer[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
        MainTimer[index].Task_status = WAIT;      //���� - ������� ����������!
                                  //������� �������������� ��������
        timers_cnt_search_lim++; //����� �� ����������� ������ ����� �������
        if (nointerrupted) {_enable_interrupts();}	// ��������� ����������
        return;									// �����.
	}
  }
// ��� ����� ������� return c ����� ������ - ��� ��������� ��������
}

/*=================================================================================
��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.
*/
volatile uint8_t	tmp_adr;
inline void TaskManager(void)
{
uint8_t		index=0;

TPTR task;                 //TODO ������� ����������� ������������!

  for(index=0;index!=timers_cnt_search_lim;++index)   // ����������� ������� � ������� ������ ������
	{	if ((MainTimer[index].Task_status == RDY)) // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		{
          LED_PORT |= (1<<LED1);   //��� ������������ �������� �������
            task=MainTimer[index].GoToTask;             // �������� ������ �.�. �� ����� ���������� ����� ���������� ������
#ifdef DEBUG                                            //������ ��-��� ������ ��� ����
	_disable_interrupts();            
            tmp_adr =(uint8_t)task;
            MainTimer[index].hndl = tmp_adr;
            MainTimer[index].sys_tick_time = v_u32_SYS_TICK;
           // Timer_3_start();                           //�������� ������ ������� ����������
	_enable_interrupts();
#endif
		    //MainTimer[index].GoToTask = Idle;           // ������ �������   
            MainTimer[index].Task_status = IN_PROC;         //������ ������ ������ ������
            _enable_interrupts();						// ��������� ����������
            (task)();								    // ��������� � ������     
            //�� ���������� �� ���� ������ ���� �� return!!!
           // MainTimer[index].Task_status = DONE;         //������ ������ ������ ������
/*#ifdef DEBUG
	_disable_interrupts();            
            Timer_3_stop();                            //��������� ������ ������� ����������
            MainTimer[index].exec_time = Timer_3_get_val();
            MainTimer[index].flag = v_u16_TIM_1_OVR_FLAG;
    _enable_interrupts();
#endif*/
            return;                                     // ����� �� ���������� �����
		}
	}
    _enable_interrupts();							// ��������� ����������
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

for(index=0;index!=timers_cnt_search_lim;index++)		// ����������� ������� ��������
	{
         if( MainTimer[index].Task_status == WAIT) 		// ���� �� ����������� �
           {
             if(MainTimer[index].TaskDelay > 0)  // ������ �� ��������, ��
              {					
                MainTimer[index].TaskDelay--;	// ������� ��� ���.   
              }  
              else                         //������ ���� ���������� � ���������
              {
               MainTimer[index].Task_status = RDY;
              }      
		};
	}
}

void ClearTimerTask(TPTR TS)  //��������� �������
{
uint8_t	 index=0;
uint8_t nointerrupted = 0;
if (STATUS_REG & (1<<Interrupt_Flag))
{
_disable_interrupts();
nointerrupted = 1;
}
    for(index=0; index!=timers_cnt_search_lim; ++index)
    {
        if(MainTimer[index].GoToTask == TS)
        {                                         
        /*     //�������� ����� ������� ���
           if(i != (arrayTail - 1))                     // ��������� ��������� ������
         {                                            // �� ����� ���������
            TaskArray[i] = TaskArray[arrayTail - 1];
         }
        */
            MainTimer[index].GoToTask = Idle;
            MainTimer[index].TaskDelay = 0; // �������� �����  
            timers_cnt_search_lim--;  //��������� ���-�� �����
            if (nointerrupted) _enable_interrupts();
            return;
        }
    }
}


  //TODO look at http://we.easyelectronics.ru/Soft/minimalistichnaya-ochered-zadach-na-c.html
 //TODO look at http://we.easyelectronics.ru/Soft/dispetcher-snova-dispetcher.html