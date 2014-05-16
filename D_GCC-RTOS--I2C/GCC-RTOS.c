#include <HAL.h>
#include <EERTOS.h>


// ��������� ����� ============================================================
void Writed2EEP(void);
void StartWrite2EPP(void);
void SendAddrToSlave(void);
void SendedAddrToSlave(void);
void SlaveControl(void);

// void LogOut(void);
// Global Variables

u08 UART_RX;


//RTOS Interrupt
ISR(RTOS_ISR)
{
TimerService();						// ���������� ���� ����������
}
//..........................................................................

ISR(USART_RXC_vect)
{
UART_RX = UDR;						// �������� �������� ���� � �����
SetTask(StartWrite2EPP);			// ��������� ������� ������ � ������.
}



//============================================================================
//������� �����
//============================================================================

// ���������� � ������ ����. 
void StartWrite2EPP(void)
{
if (!i2c_eep_WriteByte(0xA0,0x00FF,UART_RX,&Writed2EEP))	// ���� ���� �����������
	{
	SetTimerTask(StartWrite2EPP,50);						// ��������� ������� ����� 50��
	}
}

// ����� ������ �� �������� �� ������ � ������
void Writed2EEP(void)
{
i2c_Do &= i2c_Free;											// ����������� ����

if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))						// ���� ������ �� �������
	{
	SetTimerTask(StartWrite2EPP,20);						// ��������� �������
	}
else
	{
	SetTask(SendAddrToSlave);								// ���� ��� ��, �� ���� �� ���������
	}														// ����� ������� - �������� ������ ������ 2
}



// ��������� � SLAVE �����������
void SendAddrToSlave(void)
{
if (i2c_Do & i2c_Busy)						// ���� ���������� �����
		{
		SetTimerTask(SendAddrToSlave,100);	// �� ��������� ����� 100��
		}

i2c_index = 0;								// ����� �������
i2c_ByteCount = 2;							// ���� ��� �����

i2c_SlaveAddress = 0xB0;					// ����� ����������� 0xB0

i2c_Buffer[0] = 0x00;						// �� ����� ��� �����, ��� �� ���� ������������
i2c_Buffer[1] = 0xFF;

i2c_Do = i2c_sawp;							// ����� = ������� ������, �����+��� ����� ������

MasterOutFunc = &SendedAddrToSlave;			// ����� ������ �� �������� ���� ��� ������
ErrorOutFunc = &SendedAddrToSlave;			// � ���� ��� �����. 

TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// �������!

i2c_Do |= i2c_Busy;												// ���� ������!
}


// ����� �� �������� IIC
void SendedAddrToSlave(void)
{
i2c_Do &= i2c_Free;							// ����������� ����


if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))		// ���� ������� ��� �� ������� ��� ��� ���� �� �����
	{										
	SetTimerTask(SendAddrToSlave,20);		// ��������� �������
	}
}


// ���� ������� ���� ����� � ������� ������
void SlaveControl(void)
{
i2c_Do &= i2c_Free;				// ����������� ����
UDR = i2c_InBuff[0];			// ��������� �������� ����
}

/*
void LogOut(void)				// ������ �����
{
u08 i;

WorkLog[WorkIndex]= 0xFF;
WorkIndex++;

for(i=0;i!=WorkIndex+1;i++)
	{
	UDR = WorkLog[i];
	_delay_ms(30);
	}
}
*/

//==============================================================================
int main(void)
{
InitAll();						// �������������� ���������
Init_i2c();						// ��������� � ������������� i2c
Init_Slave_i2c(&SlaveControl);	// ����������� ������� ������ ��� �������� ��� Slave

/*
WorkIndex=0;					// ��� � ������
WorkLog[WorkIndex]=1;			// ���������� ����� ������
WorkIndex++;					
*/

InitRTOS();			// �������������� ����
RunRTOS();			// ����� ����. 

_delay_ms(1);		// ��������� ��������, ����� ������ ���������� ����� ������ �� ���������


while(1) 		// ������� ���� ����������
{
wdt_reset();	// ����� ��������� �������
TaskManager();	// ����� ����������
}

return 0;
}



