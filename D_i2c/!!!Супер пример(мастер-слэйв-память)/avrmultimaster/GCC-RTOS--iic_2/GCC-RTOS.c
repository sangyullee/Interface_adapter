#include <HAL.h>
#include <EERTOS.h>


// ��������� ����� ============================================================
void Writed2EEP(void);
void StartWrite2EPP(void);
void SendByteToSlave(void);
void SendedByteToSlave(void);
void ReadEEPROM(void);
void SlaveControl(void);
void EepromReaded(void);

//void LogOut(void);

// Global Variables

u08 ReadedByte;						// ���� �������� �� ������


//RTOS Interrupt
ISR(RTOS_ISR)
{
TimerService();						// ���������� ���� ����������
}
//..........................................................................





//============================================================================
//������� �����
//============================================================================
void SlaveControl(void)						// ����� ������ �� �������� ������
{
i2c_Do &= i2c_Free;							// ������������ ����
SetTask(ReadEEPROM);						// ������� ������ � ������
}



void ReadEEPROM(void)									// ������ �� ������
{
u16 Addr;

Addr = (i2c_InBuff[0]<<8)|(i2c_InBuff[1]);				// ����� ������� �� ������ ������

if (!i2c_eep_ReadByte(0xA0,Addr,1,&EepromReaded) )		// ������
	{
	SetTimerTask(ReadEEPROM,50);						// ���� ������� �� ����� (���� ������), �� ������ ����� 50��.
	}
}

void EepromReaded(void)					// ���� ������� ������
{
i2c_Do &= i2c_Free;						// ����������� ����

if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))	// ������ ��� ������ ����?
	{
	SetTimerTask(ReadEEPROM,20);		// ����� ������
	}
else
	{
	ReadedByte = i2c_Buffer[0];			// ����� �������� ���� �� ������ �������� � ����������
	SetTask(SendByteToSlave);			// � ��������� ������� �� ����������� 1
	}
}


void SendByteToSlave(void)			// ���������� ����������� 1 ��� ����
{
if (i2c_Do & i2c_Busy)				// ���� ���� ������
		{
		SetTimerTask(SendByteToSlave,100);			// �� ��������� �������
		}

i2c_index = 0;							// ����� �������
i2c_ByteCount = 1;						// ���� 1 ����

i2c_SlaveAddress = 0x32;				// ����� ����������� 1 �� ����

i2c_Buffer[0] = ReadedByte+1;			// ��������� � ����� �����, �������� ��� �� 1.
										// +1 ����� ������, ��� ����� ������ ����� �� � ���� ���������� 


i2c_Do = i2c_sawp;						// ����� - ������� ������

MasterOutFunc = &SendedByteToSlave;		// ������ ����� ������
ErrorOutFunc = &SendedByteToSlave;

TWCR = 1<<TWSTA|0<<TWSTO|1<<TWINT|0<<TWEA|1<<TWEN|1<<TWIE;		// �������!

i2c_Do |= i2c_Busy;												// ���� ��������� ��������
}


void SendedByteToSlave(void)				// ���� ��� ������
{
i2c_Do &= i2c_Free;							// ����������� ����


if(i2c_Do & (i2c_ERR_NA|i2c_ERR_BF))		// ���� ������� �� �������
	{
	SetTimerTask(SendByteToSlave,20);		// ������� ��� ���. 
	}
}											// ���� ��� ��, �� �������������. 


/*
void LogOut(void)
{
u08 i;

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
InitAll();							// �������������� ���������
Init_i2c();							// ��������� ������ �����
Init_Slave_i2c(&SlaveControl);		// ��������� ����� �����

/*
WorkLog[WorkIndex]=1;
WorkIndex++;
*/

InitRTOS();			// �������������� ����
RunRTOS();			// ����� ����. 



while(1) 		// ������� ���� ����������
{
wdt_reset();	// ����� ��������� �������
TaskManager();	// ����� ����������
}

return 0;
}



