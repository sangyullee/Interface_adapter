//����������� ���� ����� ��� RTOS

#include "task_list.h"
//============================================================================
//������� �����
//============================================================================

void Task_Start (void)
{
LED_PORT  |=1<<LED1;
SetTimerTask(Task_LedOff,50); //������ �������-�������������
}

void Task_LedOff (void)
{
SetTimerTask(Task_LedOn,500);
LED_PORT  &= ~(1<<LED1);
}

void Task_LedOn (void)
{
SetTimerTask(Task_LedOff,50);
LED_PORT  |= (1<<LED1);
}

void Task_ADC_test (void) //Upd-6     //��� �������� ����������� ���������
 {

 SetTimerTask(Task_ADC_test,5000);
 }
void Task_LcdGreetImage (void) //Greeting image on start    //Upd-4
{
SetTask(LcdClear);
 LcdImage(rad1Image);
SetTask(LcdUpdate);
SetTimerTask(LcdClear,2000);
SetTimerTask(Task_LcdLines,3000);
}

void Task_LcdLines (void)      //Upd-4       //������ ������!
{
    	for (i=0; i<84; i++){
		LcdLine ( 0, 47, i, 0, 1);
        LcdLine ( 84, 47, 84-i, 0, 1);
		LcdUpdate();
		}
SetTimerTask(LcdClear,2000);
}

void Task_AdcOnLcd (void)
{
 sprintf (lcd_buf, "vref=%d ",vref);      // ����� �� ����� ����������
 LcdString(1,1);      
  sprintf (lcd_buf, "d=%d ",d);      // ����� �� ����� ����������
 LcdString(1,2);
  sprintf (lcd_buf, "delta=%d ",delta);      // ����� �� ����� ����������
 LcdString(1,3);
  sprintf (lcd_buf, "volt=%d ",volt);      // ����� �� ����� ����������
 LcdString(1,4);
 LcdUpdate();
}

void Task_pars_cmd (void)
{
  if (USART_Get_rxCount(SYSTEM_USART) > 0) //���� � ������� ������ ���-�� ����
       {
        symbol = USART_Get_Char(SYSTEM_USART);
        PARS_Parser(symbol);
       }
SetTimerTask(Task_pars_cmd, 25);
}


void Task_LogOut (void)
{
SetTimerTask(Task_LogOut,50);
if(LogIndex){LogOut();} //���� ���-�� ���� � ��� ������ - �������
}


void Task_Flush_WorkLog(void){ //������� ��� �������
uint16_t i = 0;
while(i<512){WorkLog[i] = 0; i++;};
PORTD.7^=1;
}

/*
void Task_Uart_ByfSend(void){ //������� ��� �������

}*/

void Task_SPI_ClrBuf (void){ //������� rx/tx �������� SPI
uint8_t i;
for(i=0;i<64;i++)
 {
Spi0_RX_buf[i] = 0;
Spi0_TX_buf[i] = 0;
  //if(i<=SIZE_SPI_BUF_TX){Spi0_TX_buf[i] = 0;}
 }
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
    SetTimerTask(EEP_StartWrite,50);                        // ��������� ������� ����� 50��
    }
}

// ����� ������ �� �������� �� ������ � ������
void EEP_Writed(void)
{
i2c_Do &= i2c_Free;                                            // ����������� ����

if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))                        // ���� ������ �� �������
    {
    SetTimerTask(EEP_StartWrite,20);                        // ��������� �������
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
		SetTimerTask(IIC_Send_Addr_ToSlave,100);	// �� ��������� ����� 100��
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
	SetTimerTask(IIC_Send_Addr_ToSlave,20);		// ��������� �������
	}
}


// ���� ������� ���� ����� � ������� ������
void SlaveControl(void)
{
i2c_Do &= i2c_Free;				// ����������� ����
UDR0 = i2c_InBuff[0];			// ��������� �������� ����
}

//==============================================================================
