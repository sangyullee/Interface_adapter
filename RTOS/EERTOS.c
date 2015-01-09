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

typedef  struct 
{
                        TPTR GoToTask; 					// ��������� ��������
                        uint16_t TaskDelay;				// �������� � �� ����� �������� ������    
                        uint16_t TaskPeriod;			// �������� � �� ����� ��������� �������� 
                        uint8_t TaskStatus; 
						//TODO �������� �������� � ��������
 #ifdef DEBUG  
  uint32_t sys_tick_time; // �������� ���������� ������� �� ������ ���������� ������ � �����
  uint8_t exec_time;       // ������� ��������� ����� ���������� ������
  uint8_t  flag;             // ��������� ����� (������������ �������, ������,..) 
  uint8_t hndl;
 #endif
}TASK_STRUCT;// ��������� ������������ �������-������

 volatile static TASK_STRUCT  TTask[MainTimerQueueSize+1];	// ������� ��������
 volatile static uint8_t timers_cnt_tail = 1;
 volatile uint32_t exec_task_addr = 0; //for debug
          
 
  void clear_duplicates (void); //not tested    
  void SheikerSort(uint8_t *a, int n);
  
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
#ifdef DEBUG

LED_PORT  &=~(1<<LED1);   //��� ������������ �������� �������   
//if(v_u32_SYS_TICK%2600){KERNEL_Sort_TaskQueue();};
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
char tmp_str[10];
bit task_exist = 1;// ���������� �� ������ �� ���

TPTR task;                 //TODO ������� ����������� ������������!

  for(index=0;index!=timers_cnt_tail;++index)   // ����������� ������� � ������� ������ ������
	{	
      if ((TTask[index].TaskStatus == RDY)) // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		{
          LED_PORT |= (1<<LED1);   //��� ������������ �������� �������
          task=TTask[index].GoToTask;  // �������� ������ �.�. �� ����� ���������� ����� ���������� ������
              
            
          if(TTask[index].TaskPeriod == 0) //���� ������ 0 - ������� ������ �� ������
           {
                ClearTimerTask(task);  task_exist = 0;// ������ ������ �� ����������
           } 
           else 
           {
                TTask[index].TaskDelay = TTask[index].TaskPeriod; //���������� ��������
                TTask[index].TaskStatus = WAIT;
           }     
             //������ ��� �� ���������� ������
     
#ifdef DEBUG                                            //������ ��-��� ������ ��� ����
	_disable_interrupts();            
          if(task_exist){ TTask[index].sys_tick_time = v_u32_SYS_TICK;}  //���� ������ �� ���������                                    
	_enable_interrupts();
#endif  
             v_u8_SYS_TICK_TMP1 = (uint8_t)v_u32_SYS_TICK; //�������� ����� ��������� ������
            _enable_interrupts();						// ��������� ����������
            (task)();								    // ��������� � ������    
            if(task_exist){  //���� ������ �� ���������  
             if((v_u8_SYS_TICK_TMP1 = (uint8_t)v_u32_SYS_TICK - v_u8_SYS_TICK_TMP1)>=1){itoa(v_u8_SYS_TICK_TMP1,tmp_str);Put_In_Log(tmp_str);Put_In_Log("%\r");}
              TTask[index].exec_time = v_u8_SYS_TICK_TMP1;//�� ������� ����� � ����������
             }
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
              else                         //������ ���� ���������� � ����������
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
           if(index != (timers_cnt_tail - 1))         // ��������� ��������� ������
         {                                            // �� ����� ���������
            TTask[index] = TTask[timers_cnt_tail - 1];      
                         //��������� ��������� ������
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


  void KERNEL_Sort_TaskQueue (void) //���������a ����� �� ������� ���������� (�������� ������ - ����� � ������ �������!)  
 {
  bit		nointerrupted = 0;
  int8_t l, r, k, index;       
  TASK_STRUCT tmp;        
  
 if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������	
  //+++++++++++++      
           k = l = 0;
           r = timers_cnt_tail - 3; //In original = 2!            
           while(l <= r)
           {
              for(index = l; index <= r; index++)
              {
                 if (TTask[index].TaskPeriod > TTask[index+1].TaskPeriod)
                 {   
                 tmp = TTask[index];
                 TTask[index] = TTask[index+1];
                 TTask[index+1] = tmp;
                    k = index;
                 }
              }
              r = k - 1;

              for(index = r; index >= l; index--)
               {
                 if (TTask[index].TaskPeriod > TTask[index+1].TaskPeriod)
                 {   
                 tmp = TTask[index];
                 TTask[index] = TTask[index+1];
                 TTask[index+1] = tmp;
                    k = index;
                 }
               }
              l = k + 1;
           }           
 //-------------
  if (nointerrupted){_enable_interrupts();}	// ��������� ����������     
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
 

void Task_t_props_out (void)
{ 
uint8_t index = 0;
char tmp_str[10];

 FullStopRTOS();
    // LED_PORT  &=~(1<<LED2);
  for(index=0;index!=timers_cnt_tail;++index)	// ���� ������
	{         
     Put_In_Log("\r\n<");    
     itoa((int)TTask[index].GoToTask , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].TaskDelay , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(","); 
     itoa((int)TTask[index].TaskPeriod , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].sys_tick_time , tmp_str);      
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].exec_time , tmp_str);      
     Put_In_Log(tmp_str);Put_In_Log(",");     
     itoa((int)TTask[index].TaskStatus , tmp_str);  
     Put_In_Log(tmp_str); 
     Put_In_Log(">");       
  }    
 // LED_PORT  |=(1<<LED2); 
 Put_In_Log("\r\n"); 
 #asm("sei");
 Task_LogOut();  
 RunRTOS();
}

/*
TPTR GoToTask; 					// ��������� ��������
uint16_t TaskDelay;				// �������� � �� ����� �������� ������    
uint16_t TaskPeriod;			// �������� � �� ����� ��������� �������� 
uint8_t TaskStatus; 
  uint32_t sys_tick_time; // �������� ���������� ������� �� ������ ���������� ������ � �����
  uint8_t exec_time;       // ������� ��������� ����� ���������� ������
  uint8_t hndl;
*/

//TPTR> Delay> Period> tick> exec Status>

/*2400
<3720,8,10,2404,0,0>
<4295,0,0,0,0,3>
<3759,0,33,0,0,1>
<3674,107,500,2013,46,0>
<3835,48,50,2404,1,0>
<3882,33,333,2106,0,0>
<3666,0,10,2363,0,1>
<3673,0,250,2148,1,1>
<3663,97,0,0,0,0>
<3727,0,3,2363,41,1>
+ */

/*2700 
<4295,0,0,0,0,3>
<3674,298,500,2533,44,0>
<3727,0,3,2698,37,1>
<3720,0,10,2578,0,1>
<3666,0,10,2580,0,1>
<3759,0,33,0,0,1>
<3835,0,50,2578,1,1>
<3673,0,250,2406,0,1>
<3882,47,333,2449,0,0>
+*/
/* 
<4295,0,0,0,0,3>
<3674,294,500,2534,45,0>
<3727,0,3,2703,37,1>
<3720,0,10,2624,0,1>
<3666,0,10,2624,0,1>
<3759,0,33,0,0,1>
<3835,0,50,2580,1,1>
<3673,0,250,2406,0,1>
<3882,42,333,2449,0,0>
+*/