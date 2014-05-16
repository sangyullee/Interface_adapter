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
volatile static struct 	
						{									
						    TPTR GoToTask; 						// ��������� ��������
						    uint16_t Time;					// �������� � ��
						} 
						MainTimer[MainTimerQueueSize+1];	// ������� ��������


// RTOS ����������. ������� ��������
  void InitRTOS(void)
{
uint8_t	index;    

/*   //UPDATE
    for(index=0;index!=TaskQueueSize+1;index++)	// �� ��� ������� ���������� Idle
	    {
	    TaskQueue[index] = Idle;
	 }
*/
      for(index=0;index!=MainTimerQueueSize+1;index++) // �������� ��� �������.
    	{
	    MainTimer[index].GoToTask = Idle;
	    MainTimer[index].Time = 0;
	 }
}


//������ ��������� - ������� ����. 
  void  Idle(void) 
{

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

//UPDATE
TPTR task;
//TPTR	GoToTask = Idle;		// �������������� ����������

_disable_interrupts()				// ��������� ����������!!!
//UPDATE
//================================================================================================
  for(index=0;index!=MainTimerQueueSize+1;++index) {  // ����������� ������� � ������� ������ ������
		if ((MainTimer[index].GoToTask != Idle)&&(MainTimer[index].Time==0)) { // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		    task=MainTimer[index].GoToTask;             // �������� ������
		    MainTimer[index].GoToTask = Idle;           // ������ �������
            _enable_interrupts()							// ��������� ����������
            (task)();								    // ��������� � ������
            return;                                     // ����� �� ���������� �����
		}
	}
    _enable_interrupts()							// ��������� ����������
	Idle();                                     // ������ ������, ������ ��� - �������
//====================================================================================================    
/* //UPDATE
GoToTask = TaskQueue[0];		// ������� ������ �������� �� �������
if (GoToTask==Idle) 			// ���� ��� �����
	{_enable_interrupts()			// ��������� ����������
	(Idle)(); 					// ��������� �� ��������� ������� �����
	}
else
	{ for(index=0;index!=TaskQueueSize;index++)	// � ��������� ������ �������� ��� �������
		{  
		TaskQueue[index]=TaskQueue[index+1];
		}        
	TaskQueue[TaskQueueSize]= Idle;				// � ��������� ������ ������ �������
_enable_interrupts()							// ��������� ����������
	(GoToTask)();								// ��������� � ������
	} 
 */   
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


    #warning ������� �� ���� ����!
/*

����� www.google.com-accounts-o8-id-id-AItOawmi18Y12U8R4bYF3i0GRgR
����: C++
������������ 8 ������ 2011 ���� � 00:05
���������� 1067
������� � ���� 5 ������ :) ��������� �� ������� ����� TaskQueue, ������ ����� � ���������� ����� ����������� ������ �� ������� MainTimer, ������� ��� "���������", �������������� ���������� ���� ����� �����������. ������� ������ ��� eertos.c
#include "eertos.h"
 
// ������� �����.
volatile static struct	{
	TPTR GoToTask; 						// ��������� ��������
	uint16_t Time;							// �������� � ��
} MainTimer[MainTimerQueueSize+1];	// ������� ��������
 
// RTOS ����������. ������� ��������
inline void InitRTOS(void)
{
    uint8_t	index;
 
    for(index=0;index!=MainTimerQueueSize+1;index++) { // �������� ��� �������.
		MainTimer[index].GoToTask = Idle;
        MainTimer[index].Time = 0;
	}
}
 
//������ ��������� - ������� ����.
void  Idle(void) {
 
}
 
//������� ��������� ������ �� �������. ������������ ��������� - ��������� �� �������,
// ����� �������� � ����� ���������� �������. ��������� ��� ������.
void SetTimerTask(TPTR TS, uint16_t NewTime) {
 
    uint8_t		index=0;
    uint8_t		nointerrupted = 0;
 
    if (STATUS_REG & (_BV(Interrupt_Flag))) { 			// �������� ������� ����������, ���������� ������� ����
        Disable_Interrupt
        nointerrupted = 1;
	}
 
    for(index=0;index!=MainTimerQueueSize+1;++index) {	//����������� ������� ��������
        if(MainTimer[index].GoToTask == TS) {			// ���� ��� ���� ������ � ����� �������
            MainTimer[index].Time = NewTime;			// �������������� �� ��������
            if (nointerrupted) 	Enable_Interrupt		// ��������� ���������� ���� �� ���� ���������.
            return;										// �������. ������ ��� ��� �������� ��������. ���� �����
		}
	}
 
    for(index=0;index!=MainTimerQueueSize+1;++index) {	// ���� �� ������� ������� ������, �� ���� ����� ������
		if (MainTimer[index].GoToTask == Idle) {
			MainTimer[index].GoToTask = TS;			// ��������� ���� �������� ������
            MainTimer[index].Time = NewTime;		// � ���� �������� �������
            if (nointerrupted) 	Enable_Interrupt	// ��������� ����������
            return;									// �����.
		}
	}												// ��� ����� ������� return c ����� ������ - ��� ��������� ��������
}
 
void SetTask(TPTR TS) {                             // ��������� ������ � ������� ��� ������������ ����������
    SetTimerTask(TS,0);
}
 
//=================================================================================
��������� ����� ��. �������� �� ������� ������ � ���������� �� ����������.

 
inline void TaskManager(void) {
 
uint8_t		index=0;
TPTR task;
 
    Disable_Interrupt				// ��������� ����������!!!
    for(index=0;index!=MainTimerQueueSize+1;++index) {  // ����������� ������� � ������� ������ ������
		if ((MainTimer[index].GoToTask != Idle)&&(MainTimer[index].Time==0)) { // ���������� ������ ������ � ��, ����� ������� ��� �� �������
		    task=MainTimer[index].GoToTask;             // �������� ������
		    MainTimer[index].GoToTask = Idle;           // ������ �������
            Enable_Interrupt							// ��������� ����������
            (task)();								    // ��������� � ������
            return;                                     // ����� �� ���������� �����
		}
	}
    Enable_Interrupt							// ��������� ����������
	Idle();                                     // ������ ������, ������ ��� - �������
}
 

//������ �������� ����. ������ ���������� �� ���������� ��� � 1��. ���� ����� ����� ����������� � ����������� �� ������

inline void TimerService(void) {
 
uint8_t index;
 
    for(index=0;index!=MainTimerQueueSize+1;index++) {		// ����������� ������� ��������
        if((MainTimer[index].GoToTask != Idle) && 		    // ���� �� �������� �
           (MainTimer[index].Time > 0)) {					// ������ �� ��������, ��
            MainTimer[index].Time--;						// ������� ��� ���.
		};
	}
}

*/