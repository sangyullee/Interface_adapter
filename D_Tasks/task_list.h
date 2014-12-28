#include "adapter.h"

#define DECLARE_TASK(t_name)         void t_name (void)

// ��������� ����� ============================================================
DECLARE_TASK(Task_LoadTest);
DECLARE_TASK(Task_1ms);
DECLARE_TASK(Task3_1ms);
DECLARE_TASK (Task_t_props_out);


DECLARE_TASK(Task_Start);    //new syntax
//void Task_Start (void);    //old syntax

DECLARE_TASK(Task_LedOff);
DECLARE_TASK(Task_LedOn);
DECLARE_TASK(Task_ADC_test);      //Upd-6
DECLARE_TASK(Task_LcdGreetImage);
DECLARE_TASK(Task_LcdLines);
DECLARE_TASK(Task_AdcOnLcd);

DECLARE_TASK(Task_pars_cmd);      //������ �������
DECLARE_TASK(Task_LogOut);        // ������ �����
DECLARE_TASK(Task_BuffOut);       // ����� ����������� ���������� �������
DECLARE_TASK(Task_Flush_WorkLog);  //������� ��� �������
DECLARE_TASK(Task_SPI_ClrBuf);    //������� rx/tx �������� SPI

//======================I2C===================================
// ��������� ����� ============================================================
void EEP_Writed(void);
void EEP_StartWrite(void);
void IIC_Send_Addr_ToSlave(void);
void IIC_SendeD_Addr_ToSlave(void);
void SlaveControl(void);
