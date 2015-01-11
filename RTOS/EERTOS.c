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


  //���������� ������ � ������� - 290���
  // SetTimerTask + TaskManager ��� 30 ����� = 312��� (�� ������� � ��������)




enum TASK_STATUS {WAIT, RDY, IN_PROC, DONE, DEAD};

enum SetTimerTask_Status {QUEUE_FULL, TASK_REWRITTEN, TASK_ADDED, DEAD_TASK};

#warning �������������� ��������� ��������� ��� ������ �� ���������
typedef  struct 
{
                        TPTR GoToTask; 					// ��������� ��������
                        uint16_t TaskDelay;				// �������� � �� ����� �������� ������    
                        uint16_t TaskPeriod;			// �������� � �� ����� ��������� �������� 
                        uint8_t TaskStatus; 
						//TODO �������� �������� � ��������
 #ifdef DEBUG  
  uint32_t sys_tick_time;  // �������� ���������� ������� �� ������ ������� ������ � �����
  uint8_t exec_time;       // ������� ��������� ����� ���������� ������
  //uint8_t  flag;           // ��������� ����� (������������ �������, ������,..) 
 #endif
}TASK_STRUCT;// ��������� ������������ �������-������

#define QUEUE_SORTING_PERIOD 100 //ticks(!)  //����� ���������, ���� �� ������� Idle-������
volatile static uint16_t DeadTaskTimeout = 10;

 volatile static TASK_STRUCT  TTask[MainTimerQueueSize+1];	// ������� ��������
 volatile static uint8_t timers_cnt_tail = 1; 
 volatile bit InfiniteLoopFlag = 1; //���� ������ �������� - �� � ���������� �� ���� ������ � ������� �� ��������!
        
		
//+++++++++++++PRIVATE RTOS SERVICES++++++++++++++++++++++++++++++
  void KERNEL_Sort_TaskQueue (void); //���������� ����� �� ������� (����������� �����)
  void clear_duplicates (void); //not tested    
  inline void dbg_out (char index);
  void SheikerSort(uint8_t *a, int n);
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  
//===============================================================================================
  void  Idle(void)  //������ ��������� - ������� ����.
{ 
	#ifdef DEBUG
	LED_PORT  &=~(1<<LED1);   //��� ������������ �������� �������   
	#endif  
	if(v_u32_SYS_TICK % QUEUE_SORTING_PERIOD == 0){KERNEL_Sort_TaskQueue();}; //������������� �������������� ����� �� ����������� ��������
}
//===============================================================================================
  
  
//=============================================================================================== 
  void InitRTOS(void) // RTOS ����������. ������� ��������
{
uint8_t	index;
RTOS_timer_init(); //Hardware!

      for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
    {
	    TTask[index].GoToTask = Idle;
	    TTask[index].TaskDelay = 0; //������, ��� ���������� �������� ���������
	 }
}
//===============================================================================================


//===============================================================================================
 void SetTask(TPTR TS)  // ��������� ������ � ������� ��� ������������ ����������
{
 SetTimerTask(TS,0,0);
}
//===============================================================================================



//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
// ����� �������� � ����� ���������� �������. ��������� ��� ������.
//===============================================================================================
uint8_t SetTimerTask(TPTR TS, unsigned int NewTime, unsigned int NewPeriod)    //1 task ~12words
{
uint8_t		index=0;
uint8_t		result = QUEUE_FULL;
bit			nointerrupted = 0;

if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������

  for(index=0;index!=timers_cnt_tail;++index)	
  {  
	if (TTask[index].GoToTask == TS)			// ���� ������� ������
	{
		if(TTask[index].TaskStatus != DEAD)				// ���� ������ �� �������� ��� ������(��������) �������� CorpseService()
		{
			TTask[index].TaskDelay  = NewTime;		    // � ���� �������� �������    
			TTask[index].TaskPeriod = NewPeriod;	    // � ���� ������� �������
			TTask[index].TaskStatus = WAIT;             // ���� - ������� ����������!
			result = TASK_REWRITTEN; 
			goto exit;			// �����.
		}	else{result = DEAD_TASK; goto exit;}		//������������� �� ���������� ������� ������ ������!											
	  }	  
  } 
    // ���� �� ������� - ������ �� �����
	if(timers_cnt_tail < MainTimerQueueSize)// � � ������� ���� ����� - ��������� ������ � ����� �������
	{
			TTask[timers_cnt_tail].GoToTask   = TS;			    // ��������� ���� �������� ������
			TTask[timers_cnt_tail].TaskDelay  = NewTime;		// � ���� �������� �������        
			TTask[timers_cnt_tail].TaskPeriod = NewPeriod;	    // � ���� ������� �������
			TTask[timers_cnt_tail].TaskStatus = WAIT;           // ���� - ������� ����������!
			timers_cnt_tail++;                          		// ����������� ���-�� (�����) ��������			
			result = TASK_ADDED; 
			goto exit;			    							// �����.
	}		
  
exit:  
  if (nointerrupted) {_enable_interrupts();}			// ��������� ����������    
  return result; // return c ����� ������ - ��� ��������� ��������, ������ ����������� ��� �������� ��� �����	
}
//===============================================================================================


/*
������ �������� ����. ������ ���������� �� ���������� ��� � 1��. ���� ����� ����� ����������� � ����������� �� ������

TODO: �������� � ����������� ��������� ������������ ������� ��������. ����� ����� ����� ��������� �� ����� ������.
� ����� ������������ ��� ������� ������������ �������.� ���� ������ �� ������ �������� �������� ����������.
*/
//===============================================================================================
inline void TimerService(void)
{
uint8_t index;

for(index=0;index!=timers_cnt_tail;index++)		// ����������� ������� ��������
	{
         if((TTask[index].TaskStatus == WAIT) || (TTask[index].TaskStatus == DONE))// ���� �� ����������� ��� �����������
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


//===============================================================================================
//��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������
//===============================================================================================
inline void TaskManager(void) //� ���������� ����� ����������� ������ �� ������� TTask, ������� ��� "���������"
{
uint8_t		index=0;
char 		tmp_str[10];
bit 		task_exist = 1;// ���������� �� ������ �� ���
TPTR 		CurrentTask;               

  for(index=0;index!=timers_cnt_tail;++index)   // ����������� ������� �����
	{	
      if ((TTask[index].TaskStatus == RDY)) // ���� ������ �������� � ���������� (���������� ������ � ��, ����� ������� ��� �� �������)
		{
          LED_PORT |= (1<<LED1);   //��� ������������ �������� �������
          CurrentTask=TTask[index].GoToTask;  // �������� ������ �.�. �� ����� ���������� ����� ���������� ������

           if(TTask[index].TaskPeriod == 0) //���� ������ 0 - ������� ������ �� ������
           {
                ClearTimerTask(CurrentTask);  task_exist = 0;// ������ ������ �� ����������
           } 
           else 
           {
                TTask[index].TaskDelay = TTask[index].TaskPeriod; //���������� ��������
                TTask[index].TaskStatus = IN_PROC;  //������ � �������� ����������     
#ifdef DEBUG                                            //������ ��-��� ������ ��� ����
                TTask[index].sys_tick_time = v_u32_SYS_TICK; //����� ������ ����������                                  
#endif       
           }     
             //������ ��� �� ���������� ������
 //----------------------------------------------------------------------------------------------------    
            v_u8_SYS_TICK_TMP1 = (uint8_t)v_u32_SYS_TICK; //�������� ����� ���������� ������
            _enable_interrupts();						// ��������� ����������
            (CurrentTask)();					        // ������� � ������!    
            
InfiniteLoopFlag = 0; //���� ������ �������� - �� � ���������� �� ���� ������ � ������� �� ��������!
 //----------------------------------------------------------------------------------------------------
		
            if(task_exist)//���� ������ ����� �� ���������  
			{  
			   if(TTask[index].TaskStatus != DEAD) //���� ������ �� ���� �������� � ���������� ��� ��������
			   {
				TTask[index].TaskStatus = DONE; //������ ������ - ������������ �����������! 
			   }      
				v_u8_SYS_TICK_TMP1 = (uint8_t)v_u32_SYS_TICK - v_u8_SYS_TICK_TMP1;   
                TTask[index].exec_time = v_u8_SYS_TICK_TMP1;//������� ����� � ����������
#ifdef DEBUG 				
				 if(v_u8_SYS_TICK_TMP1)
				 {
					itoa(v_u8_SYS_TICK_TMP1,tmp_str);
					Put_In_Log(tmp_str);Put_In_Log("%\r");
				 }
#endif  			 
             }  

            //�� ���������� �� ���� ������ ���� �� return!!!
            return;                                     // ����� �� ���������� �����
		}
	}
    _enable_interrupts();							// ��������� ����������
	Idle();  // ������ ������, ������ ��� - �������, ���������� ������� �����, ��� �� ���������� ���������� �������...
}
//===============================================================================================


//===============================================================================================
void ClearTimerTask(TPTR TS)  //��������� �������, ������� ������
{
uint8_t	 	index=0;
bit 		nointerrupted = 0;

if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts(); nointerrupted = 1;}

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
         
        --timers_cnt_tail;  //��������� ���-�� �����     
        if (nointerrupted){ _enable_interrupts();}
        return;
      }
    }
}
//===============================================================================================


//===============================================================================================
  void KERNEL_Sort_TaskQueue (void) //���������a ����� �� ������� ���������� (�������� ������ - ����� � ������ �������!)  
 {     
  TASK_STRUCT 	tmp;        
  int8_t 		l, r, k, index;   
  bit			nointerrupted = 0;

 if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������	
 
  //+++++++++++++  //��������� ����������    
           k = l = 0;
           r = timers_cnt_tail - 2; //        
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
 //===============================================================================================
 
 
 //===============================================================================================
 inline void CorpseService(void) //��������� �������� �����
{
 static TPTR 		DeadTask_prev, DeadTask_curr;
 static uint16_t 	Timeout_delay = 0;
 static uint8_t 	coins = 0; //����������
 uint8_t			index = 0;   
 static bit 		suspect_flag = 0;  
 bit				nointerrupted = 0;
  
  if(InfiniteLoopFlag == 0) //��������� ������� ����, ������ ������ �����������
  {   
	goto EXIT;
  }
  else  //���� �� ������� - ����������� �����-�� ������! �������� ��� ����� ��� ������ �������
  {
	if (STATUS_REG & (1<<Interrupt_Flag)){_disable_interrupts();nointerrupted = 1;}	// �������� ������� ����������	

	for(index=0; index<timers_cnt_tail; ++index)	//����� �������� (���� ��� ������ ����������!)
			 {   
				if(TTask[index].TaskStatus == IN_PROC) //TODO �������� ������ ����� �� �������������
				{
					if(suspect_flag == 0)//��� ������ ������
					{
						DeadTask_prev = TTask[index].GoToTask;
						suspect_flag = 1; //�������� �����������
						Timeout_delay = (uint16_t)v_u32_SYS_TICK; //������� �������
						return;
					}
					else //��� ������ ������
					{	
						DeadTask_curr = TTask[index].GoToTask;	
						if(DeadTask_curr == DeadTask_prev)	//������������ �������������
							{
							    coins++;
								if((v_u32_SYS_TICK - Timeout_delay >= DeadTaskTimeout)&&(coins>=4))
								{      
                                   TTask[index].TaskStatus = DEAD;	//��������� ����� (���������� � �������)
								  //ClearTimerTask(DeadTask_curr);	//��� ������ �������� �� �������!	
							     
								  InfiniteLoopFlag = 1; //��������� �� ����. ���������
                                  suspect_flag = 0;Timeout_delay = 0;					
							      DeadTask_curr = DeadTask_prev = 0; coins = 0;  
								  //�� goto EXIT; ������ �.�.
                                  //TODO ������ ���� �������� ���������� ������� (���� �� �����������)     
								  
									//FLAG_SET(g_tcf,DEAD_TASK_DELETED);								  
									//TaskManager();
									//#asm("JMP 0x0000");	      
									// #asm("call TaskManager");         
									//goto DEAD_TASK_DETECTED;								  
								}
							}
							else //������������ �� ������������� (�� ���������� ������ ������ ������)
							{
EXIT:							
									InfiniteLoopFlag = 1; //��������� �� ����. ��������� � �����
									suspect_flag = 0;Timeout_delay = 0;					
									DeadTask_curr = DeadTask_prev = 0; coins = 0; 
							}
					
					}
				}
			 }
  }
 if (nointerrupted){_enable_interrupts();}	// ��������� ����������     
}   
//===============================================================================================
 

 //TODO look at http://we.easyelectronics.ru/Soft/minimalistichnaya-ochered-zadach-na-c.html
 //TODO look at http://we.easyelectronics.ru/Soft/dispetcher-snova-dispetcher.html
 
 
 //===============================================================================================
 //===============================================================================================
 //===============================================================================================
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
 //RunRTOS();
}

inline void dbg_out (char index)
{
char tmp_str[10];
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
     Put_In_Log(">\r\n");  
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