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
  ����������� ������ �� ������� TTask, ������� ��� "���������",
  �������������� ���������� ���� ����� �����������.
  MEMORY -58 WORDS
*/

  //���������� ������ � ������� - 290���
  // SetTimerTask + TaskManager ��� 30 ����� = 312��� (�� ������� � ��������)

// ������� �����, ��������.
// ��� ������ - ��������� �� �������
//volatile static TPTR	TaskQueue[TaskQueueSize+1];			// ������� ����������
//update
enum TASK_STATUS {WAIT, RDY, IN_PROC, DONE};
#warning �������������� ��������� ��������� ��� ������ � ���������
volatile static struct
{
                        TPTR GoToTask; 					// ��������� ��������
                        uint16_t TaskDelay;				// �������� � �� ����� �������� ������    
                        uint16_t TaskPeriod;			// �������� � �� ����� ��������� �������� 
                        uint8_t TaskStatus; 
						//TODO �������� �������� � ��������
 #ifdef DEBUG  
  uint32_t sys_tick_time; // �������� ���������� ������� �� ������ ���������� ������ � �����
  uint16_t exec_time;       // ������� ��������� ����� ���������� ������
  uint8_t  flag;             // ��������� ����� (������������ �������, ������,..) 
  uint8_t hndl;
 #endif
} TTask[MainTimerQueueSize+1];	// ������� ��������

 volatile uint32_t exec_task_addr = 0; //for debug
 volatile static uint8_t timers_cnt_tail = 1;

          
 
  void clear_duplicates (void); //not tested
  
 //===================================================================
// RTOS ����������. ������� ��������
  void InitRTOS(void)
{
uint8_t	index;
      for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
    {
	    TTask[index].GoToTask = Idle;
	    TTask[index].TaskDelay = 0; //������, ��� ���������� �������� ���������
	 }
}


//������ ��������� - ������� ����.
  void  Idle(void)
{ //#warning ��������� �������� ������������ 
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//clear_duplicates();//����� ������� ������� �� ���������� ����� 
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
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
  for(index=0;index!=timers_cnt_tail;++index)	// ���� ����� ������ ������
  {  
        if (TTask[index].GoToTask == TS)
	{
		TTask[index].TaskDelay = NewTime;		// � ���� �������� �������    
        TTask[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
        TTask[index].TaskStatus = WAIT;      //���� - ������� ����������!
        if (nointerrupted) {_enable_interrupts();}	// ��������� ����������
        return;									// �����.
	}
	if (TTask[index].GoToTask == Idle)
	{
		TTask[index].GoToTask = TS;			// ��������� ���� �������� ������
		TTask[index].TaskDelay = NewTime;		// � ���� �������� �������        
        TTask[index].TaskPeriod = NewPeriod;	// � ���� ������� �������
        TTask[index].TaskStatus = WAIT;      //���� - ������� ����������!
                                  //������� �������������� ��������
        timers_cnt_tail++; //����� �� ����������� ������ ����� �������
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

  for(index=0;index!=timers_cnt_tail;++index)   // ����������� ������� � ������� ������ ������
	{	
      if ((TTask[index].TaskStatus == RDY)) // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		{
          LED_PORT |= (1<<LED1);   //��� ������������ �������� �������
            task=TTask[index].GoToTask;             // �������� ������ �.�. �� ����� ���������� ����� ���������� ������
              
            
          if(TTask[index].TaskPeriod == 0) //���� ������ 0 - ������� ������ �� ������
           {
                ClearTimerTask(task);
           } 
           else 
           {
                TTask[index].TaskDelay = TTask[index].TaskPeriod; //���������� ��������
                TTask[index].TaskStatus = WAIT;
           }     
             //������ ��� �� ���������� ������
     
#ifdef DEBUG                                            //������ ��-��� ������ ��� ����
	_disable_interrupts();            
            tmp_adr =(uint8_t)task;
            TTask[index].hndl = tmp_adr;
            TTask[index].sys_tick_time = v_u32_SYS_TICK;
           // Timer_3_start();                           //�������� ������ ������� ����������
	_enable_interrupts();
#endif  
            //TTask[index].TaskStatus = IN_PROC;         //������ ������ ������
            _enable_interrupts();						// ��������� ����������
            (task)();								    // ��������� � ������     
            //�� ���������� �� ���� ������ ���� �� return!!!
           // TTask[index].TaskStatus = DONE;         //������ ������ ������ ������
/*#ifdef DEBUG
	_disable_interrupts();            
            Timer_3_stop();                            //��������� ������ ������� ����������
            TTask[index].exec_time = Timer_3_get_val();
            TTask[index].flag = v_u16_TIM_1_OVR_FLAG;
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

for(index=0;index!=timers_cnt_tail;index++)		// ����������� ������� ��������
	{
         if( TTask[index].TaskStatus == WAIT) 		// ���� �� ����������� �
           {
             if(TTask[index].TaskDelay > 0)  // ������ �� ��������, ��
              {					
                TTask[index].TaskDelay--;	// ������� ��� ���.   
              }  
              else                         //������ ���� ���������� � ���������
              {
               TTask[index].TaskStatus = RDY;
              }      
		};
	}
}

void ClearTimerTask(TPTR TS)  //��������� �������
{
uint8_t	 index=0;
bit nointerrupted = 0;
if (STATUS_REG & (1<<Interrupt_Flag))
{
_disable_interrupts(); nointerrupted = 1;
}
    for(index=0; index<timers_cnt_tail; ++index)
    {
        if(TTask[index].GoToTask == TS)
        {                                         
             //�������� ����� ������� ���
           if(index != (timers_cnt_tail - 1))         // ��������� ��������� ������
         {                                            // �� ����� ���������
            TTask[index] = TTask[timers_cnt_tail - 1];      
                         //�� ������ ������ ��������� ��������� ������
            TTask[timers_cnt_tail - 1].GoToTask = Idle;
            TTask[timers_cnt_tail - 1].TaskDelay = 0; // �������� �����      
            TTask[timers_cnt_tail - 1].TaskPeriod = 0; // �������� �����     
            TTask[timers_cnt_tail - 1].TaskStatus = DONE; // �������� status
         }
           else
         {
             //���� ������ ��������� � �������
            TTask[index].GoToTask = Idle;
            TTask[index].TaskDelay = 0; // �������� �����      
            TTask[index].TaskPeriod = 0; // �������� �����  
            TTask[index].TaskStatus = DONE; // �������� status
         }  
          timers_cnt_tail--;  //��������� ���-�� �����     
          if (nointerrupted) _enable_interrupts();
            return;
        }
    }
}


  //TODO look at http://we.easyelectronics.ru/Soft/minimalistichnaya-ochered-zadach-na-c.html
 //TODO look at http://we.easyelectronics.ru/Soft/dispetcher-snova-dispetcher.html
 
 void clear_duplicates (void) //not tested
 {
  uint8_t		index=0;
  bit		nointerrupted = 0;
  TPTR task_src;
if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������	
  for(index=0;index!=timers_cnt_tail;++index)	
  {       
     task_src = TTask[index].GoToTask;
    for(index+1;index!=timers_cnt_tail;++index)	
      { 
       if (TTask[index].GoToTask == task_src) {TTask[index].GoToTask = Idle;}
      } 
  }
  if (nointerrupted){_enable_interrupts();}	// ��������� ����������     
 }