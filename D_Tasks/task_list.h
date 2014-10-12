#include "adapter.h"


// ��������� ����� ============================================================
void Task_Start (void);
void Task_LedOff (void);
void Task_LedOn (void);
void Task_ADC_test (void); //Upd-6
void Task5 (void);
void Task6 (void);
void Task7 (void);
void Task8 (void);
void Task9 (void);

void Task_LcdGreetImage (void);
void Task_LcdLines (void);


void Task_pars_cmd (void);      //������ �������
void Task_LogOut (void);        // ������ �����
void Task_BuffOut (void);       // ����� ����������� ���������� �������
void Task_Flush_WorkLog(void);  //������� ��� �������
void Task_SPI_ClrBuf (void);    //������� rx/tx �������� SPI

//======================I2C===================================
// ��������� ����� ============================================================
void EEP_Writed(void);
void EEP_StartWrite(void);
void IIC_Send_Addr_ToSlave(void);
void IIC_SendeD_Addr_ToSlave(void);
void SlaveControl(void);
