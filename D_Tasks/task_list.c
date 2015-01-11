//����������� ���� ����� ��� RTOS

#include "task_list.h"
//============================================================================
//������� �����
//============================================================================


DECLARE_TASK(Task_Initial) //�������� ������, ��������� ��� ������
{
//SetTimerTask(Task_t_props_out,10);


SetTimerTask(Task_Start,700,10);     //blink led
SetTimerTask(Task_LoadTest, 900, 500); //������ ��������� ����� ��� �������� �������� ��      
///-----------------Upd-7-----------------------------
// ��������� ������ ���� �����
//SetTimerTask(Task_pars_cmd,5,100); //Upd-6

#ifdef DEBUG                    //Upd-6
SetTimerTask(Task_LogOut, 50, 50);
SetTask(Task_LcdGreetImage);    //Upd-4
//SetTimerTask(Task_ADC_test,5000);   //Upd-6
//SetTimerTask(Task_AdcOnLcd, 6000);
//SetTimerTask(Task_BuffOut,5);
#endif
///---------------------------------------------------
 SetTimerTask(Task_1ms, 55, 10);
 SetTimerTask(Task3_1ms, 250, 250);   

  
 SetTimerTask(Task_ADC_test, 200, 440); 
 //SetTimerTask(Task_AdcOnLcd, 230, 77); //�������� 100%!!
 SetTimerTask(Task_BuffOut, 180,  333);
 
 SetTimerTask(Task_t_props_out,1000,42); 
} 



DECLARE_TASK(Task_ClearTS)//clr task test
{
ClearTimerTask(Task_Initial);
ClearTimerTask(Task_LoadTest);
ClearTimerTask(Task_LogOut);
ClearTimerTask(Task_1ms);
ClearTimerTask(Task3_1ms);
ClearTimerTask(Task_ClearTS);
 SetTimerTask(Task_Initial, 1700, 1700);
}

DECLARE_TASK(Task_1ms)
{
SetTaskDeadtime(Task_1ms,0);
delay_ms(26);

//LED_PORT.LED2^=1;
//Put_In_Log("Task_10ms\r\n");
//LED_PORT |= (1<<LED2);
//SetTimerTask(Task_1ms,5,5); //������ �������-�������������
//LED_PORT  &= ~(1<<LED2);
}  

DECLARE_TASK(Task2_1ms)
{
//LED_PORT.LED2^=1;
LED_PORT |= (1<<LED3);
//SetTimerTask(Task2_1ms,5); //������ �������-�������������
LED_PORT  &= ~(1<<LED3);
}  
DECLARE_TASK(Task3_1ms)   //�� 4800 ��� - 15�������� ����� �� 50�� 
{
//Put_In_Log("Task3_250ms\r\n");
//SetTimerTask(Task3_1ms,500, 500); //��� ����� ������ ����� ���������� ������� ��� ���������� �� ������� �� 5��
}  


 
DECLARE_TASK(Task_LoadTest)    //8ms!
{
 int Tick =0;
 Tick = v_u32_SYS_TICK;

//Put_In_Log("T_L_T\r\n");

  //LcdClear();      
_LCD_SHOWVAL(Tick); // = sprintf (lcd_buf, "Tick=%i",v_u32_SYS_TICK);  // 500us
 LcdString(1,2);    
_LCD_STRINBUF("Ololo=)");
 LcdString(1,4);
 LcdUpdate();
//SetTimerTask(Task_LoadTest, 1000, 1000);; //������ ��������� ����� ��� �������� �������� ��

}

DECLARE_TASK(Task_Start)
{
LED_PORT.LED2^=1; //������ �������-�������������
}

DECLARE_TASK (Task_LedOff)
{
//SetTimerTask(Task_LedOn, 900, 900);
LED_PORT  &= ~(1<<LED2);
}

DECLARE_TASK (Task_LedOn)
{
//SetTimerTask(Task_LedOff,100,100);
LED_PORT  |= (1<<LED2);
}

/*
DECLARE_TASK (Task_t_props_out)
{ 
uint8_t index = 0;
char tmp_str[10];

 FullStopRTOS();
    // LED_PORT  &=~(1<<LED2);
  for(index=0;index!=timers_cnt_tail;++index)	// ���� ������
	{          //�������� ����
     Put_In_Log("\r\n<");    
     itoa((int)TTask[index].hndl , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].TaskDelay , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(","); 
     itoa((int)TTask[index].TaskPeriod , tmp_str);
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].sys_tick_time , tmp_str);   TTask[index].sys_tick_time = 0;
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].exec_time , tmp_str);       TTask[index].exec_time = 0;
     Put_In_Log(tmp_str); Put_In_Log(",");
     itoa((int)TTask[index].TaskStatus , tmp_str);            TTask[index].flag = 0;
     Put_In_Log(tmp_str);
     Put_In_Log(">");       
  }    
 // LED_PORT  |=(1<<LED2); 
 Put_In_Log("\r\n");
 Task_LogOut();  
 RunRTOS();
}
*/

DECLARE_TASK (Task_ADC_test) //Upd-6     //��� �������� ����������� ���������
 {
 #warning no Lcd_out// sprintf (lcd_buf, "DummyADC=%d ",volt);      // ����� �� ����� ����������
 LcdString(1,1);   LcdUpdate();
 //SetTimerTask(Task_ADC_test,5000, 5000);
 }  
 
                  
void Task_LcdGreetImage (void) //Greeting image on start    //Upd-4
{
//SetTask(LcdClear);
//SetTask(Task_LcdLines);

#warning RLE_unpack doesn`t work
//unsigned char tmp_unpk_buf[504];
//unsigned char tmp_src_buf[504];
//memcpy(tmp_unpk_buf,(void*)rad2Image,504);          
//RLE_unpack(rad1Image, LcdCache, 230);
//LcdImageRam(tmp_unpk_buf);  SetTimerTask(LcdClear,1000,0);
LcdImage(rad2Image);  SetTimerTask(LcdClear,1000,0);
 /*
 //sprintf (lcd_buf, "  Interface   ");
 strncpy (lcd_buf, "  Interface   ", 15);
 LcdStringBig(1,1);
  strncpy(lcd_buf, " Monitor v2.1 ", 15);
 LcdString(1,3);
 strncpy (lcd_buf, " �����������  ", 15);
 LcdString(1,4);
 strncpy (lcd_buf, "  ���������   ", 15);
 LcdString(1,5);
 strncpy (lcd_buf, "  �� - 104    ", 15);
 LcdString(1,6);  */
LcdUpdate();
SetTimerTask(LcdClear,2000,0);

// sprintf (lcd_buf, "Wait comand...");      //�� ��������
// LcdStringBig(1,3);
// SetTimerTask(LcdUpdate,8000);
}

void Task_LcdLines (void)      //Upd-4       //������ ������!
{
    	for (i=0; i<84; i++)
        {
		LcdLine ( 0, 47, i, 0, 1);
        LcdLine ( 84, 47, 84-i, 0, 1);
		LcdUpdate();
		}
}

void Task_AdcOnLcd (void)
{
//SetTask(LcdClear);
 /*sprintf (lcd_buf, "vref=%d ",vref);      // ����� �� ����� ����������
 LcdString(1,1);
  sprintf (lcd_buf, "d=%d ",d);      // ����� �� ����� ����������
 LcdString(1,2);
  sprintf (lcd_buf, "delta=%d ",delta);      // ����� �� ����� ����������
 LcdString(1,3);
  sprintf (lcd_buf, "volt=%d ",volt);      // ����� �� ����� ����������
 LcdString(1,4);  */
 LcdClear();
 ADC_use();
#warning disabled sprintf (lcd_buf, "���������� ��");
 LcdString(1,2);
#warning disabled sprintf (lcd_buf, "  ������ 0");
 LcdString(1,3);
#warning disabled sprintf (lcd_buf, "= %d ��",adc_result);
 LcdString(1,4);

 LcdUpdate();
}

//#error ���������!
DECLARE_TASK (Task_pars_cmd)         //300us? empty buff
{
char scan_interval = 100;
  if (USART_Get_rxCount(SYSTEM_USART) > 0) //���� � ������� ������ ���-�� ����
       {
        symbol = USART_Get_Char(SYSTEM_USART);
        PARS_Parser(symbol);
        //SetTask(Task_pars_cmd);  //���������!
        scan_interval = 5;
       }
// else{scan_interval = 100;};
SetTimerTask(Task_pars_cmd, 0, scan_interval); //25   //���������!
}


DECLARE_TASK (Task_FlagsHandler)
{
char tmp_str[5];
  switch(g_tcf)
  { 
    case ERR_UNDEF_FLAG: 
                        Put_In_Log(" ERR_UNDEF_FLAG\r"); 
                        itoa(g_tcf,tmp_str);Put_In_Log(tmp_str); 
                        FLAG_CLR(g_tcf,ERR_UNDEF_FLAG);
    //break;
   case S_SPI_BUF_CLR: SetTask(Task_SPI_ClrBuf); FLAG_CLR(g_tcf,S_SPI_BUF_CLR);
    //break;
   case FLUSH_WORKLOG: SetTask(Task_Flush_WorkLog);FLAG_CLR(g_tcf,FLUSH_WORKLOG);
    //break; 
   // case DEAD_TASK_DELETED: Put_In_Log(" DEAD_TASK_DELETED\r");FLAG_CLR(g_tcf,DEAD_TASK_DELETED);
    //break; 
    default:  
    FLAG_SET(g_tcf, ERR_UNDEF_FLAG);
    break;
    }                                   
}


DECLARE_TASK (Task_LogOut)           //500us ?
{
//SetTimerTask(Task_LogOut,50,50);
if(LogIndex){LogOut();} //���� ���-�� ���� � ��� ������ - �������
}


void Task_Flush_WorkLog(void) //������� ��� �������
{
uint16_t i = 0;
//LED_PORT |= (1<<LED2);
while(i<512){WorkLog[i] = 0; i++;};
//LED_PORT &=~(1<<LED2);
}


void Task_SPI_ClrBuf (void){ //������� rx/tx �������� SPI
uint8_t i;
for(i=0;i<64;i++)
 {
Spi0_RX_buf[i] = 0;
Spi0_TX_buf[i] = 0;
  //if(i<=SIZE_SPI_BUF_TX){Spi0_TX_buf[i] = 0;}
 }
}

 void Task_BuffOut  (void)  //������ �������� �� ����1 ��� ����� � ����������
 {
  //SetTimerTask(Task_BuffOut,50,50);
  RingBuff_TX();
 }

//=================================================
//////////////////////////I2C//////////////////////

//============================================================================
//������� �����
//============================================================================

// ���������� � ������ ����.
void EEP_StartWrite(void)
{
if (!i2c_eep_WriteByte(0xA0,0x00FF,/*(char)Usart0_RX_buf[15]*/ 9,&EEP_Writed))    // ���� ���� �����������
    {
    SetTimerTask(EEP_StartWrite,50,50);                        // ��������� ������� ����� 50��
    }
}

// ����� ������ �� �������� �� ������ � ������
void EEP_Writed(void)
{
i2c_Do &= i2c_Free;                                            // ����������� ����

if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))                        // ���� ������ �� �������
    {
    SetTimerTask(EEP_StartWrite,20,20);                        // ��������� �������
    }
else
    {
    SetTask(IIC_Send_Addr_ToSlave);        		// ���� ��� ��, �� ���� �� ���������
	}											// ����� ������� - �������� ������ ������ 2
}

// ��������� � SLAVE �����������
void IIC_Send_Addr_ToSlave(void)
{
if (i2c_Do & i2c_Busy)						// ���� ���������� �����
		{
		SetTimerTask(IIC_Send_Addr_ToSlave,100,100);	// �� ��������� ����� 100��
		}

i2c_index = 0;								// ����� �������
i2c_ByteCount = 2;							// ���� ��� �����

i2c_SlaveAddress = 0xB0;					// ����� ����������� 0xB0

i2c_Buffer[0] = 0x00;						// �� ����� ��� �����, ��� �� ���� ������������
i2c_Buffer[1] = 0xFF;

i2c_Do = i2c_sawp;							// ����� = ������� ������, �����+��� ����� ������

MasterOutFunc = &IIC_SendeD_Addr_ToSlave;			// ����� ������ �� �������� ���� ��� ������
ErrorOutFunc = &IIC_SendeD_Addr_ToSlave;			// � ���� ��� �����.

TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// �������!
i2c_Do |= i2c_Busy;												// ���� ������!
}


// ����� �� �������� IIC
void IIC_SendeD_Addr_ToSlave(void)
{
i2c_Do &= i2c_Free;							// ����������� ����

if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))		// ���� ������� ��� �� ������� ��� ��� ���� �� �����
	{
	SetTimerTask(IIC_Send_Addr_ToSlave,20,20);		// ��������� �������
	}
}


// ���� ������� ���� ����� � ������� ������
void SlaveControl(void)
{
i2c_Do &= i2c_Free;				// ����������� ����
UDR0 = i2c_InBuff[0];			// ��������� �������� ����
}

//==============================================================================
