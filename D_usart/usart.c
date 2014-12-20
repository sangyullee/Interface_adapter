//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru
//
//  Compiler....: CodeVision 2.04
//
//  Description.: USART/UART. ���������� ��������� �����
//
//  Data........: 3.01.10
//
//***************************************************************************
#include "usart.h"


#warning �������� �� ���������+ ���������� �� Usart_rxCount!
/*
  struct {
	u08 buff[TX_BUFFER_SIZE];
	u08 head;
	u08 tail;
} TX_buff;

struct {
	u08 buff[RX_BUFFER_SIZE];
	u08 head;
	u08 tail;
} RX_buff;
*/
//���������� �����
static volatile char Usart0_TX_buf[SIZE_BUF_TX];
static volatile uint16_t Usart0_txBufTail = 0;
static volatile uint16_t Usart0_txBufHead = 0;
//static volatile uint16_t Usart0_txCount = 0;

static volatile char Usart1_TX_buf[SIZE_BUF_TX];
static volatile uint16_t Usart1_txBufTail = 0;
static volatile uint16_t Usart1_txBufHead = 0;
//static volatile uint16_t Usart1_txCount = 0;
 #warning  Usart0_txCount not used


//�������� �����
static volatile char Usart0_RX_buf[SIZE_BUF_RX];
static volatile uint16_t Usart0_rxBufTail = 0;
static volatile uint16_t Usart0_rxBufHead = 0;
static volatile uint16_t Usart0_rxCount = 0;

static volatile char Usart1_RX_buf[SIZE_BUF_RX];
static volatile uint16_t Usart1_rxBufTail = 0;
static volatile uint16_t Usart1_rxBufHead = 0;
static volatile uint16_t Usart1_rxCount = 0;


void UartTxBufOvf_Handler(void) //���������� ������������ ����������� ������ UART
{
    PORTD.7=1;
}


uint16_t Calk_safe_baud(uint8_t mode, uint16_t input_baud)   //�������� ����������� ����� �� ������� ��������
{
 uint8_t max_total_err = 52; //����� ������, ���� ������ - ����������� ����������. 52 ������������� 2.1%

 uint32_t tmp0 = 0;
 uint16_t tmp1 = 0;

 if (mode == USART_NORMAL){tmp0 = 16UL*input_baud;}
 else {tmp0 = 8UL*input_baud;}

 tmp1 = (F_CPU/100)/tmp0;   //{ubrrValue = F_CPU/(16UL*baudRate) - 1;}
 tmp1 = tmp1*tmp0;
 tmp1 = ((F_CPU/100) - tmp1);
 tmp1 = tmp1>>5; // /32
 if(tmp1 > max_total_err){tmp1 = 48;} //��� ������� ������������� ������ �������� (>2.1%) - �������� ����� 4800baud (�� �������� ������ �� ����� ��������)
 else {tmp1 = input_baud;} //���� �� ��, ������� �������� ��������
return tmp1;
}


 void USART_Init (uint8_t sel, uint8_t mode, uint16_t baudRate) //������������� usart`a
{
uint16_t ubrrValue;
#warning �������� ���� ��������� ����������� baudRate!
__disable_interrupts();

#ifdef UART_BAUD-ERR-CONTROL_EN
baudRate = Calk_safe_baud(mode, baudRate);// �������� ����������� ��� �������� �������� (������� �� F_CPU)
#endif
baudRate = baudRate * 100;

 if (mode == USART_NORMAL)
 {
   ubrrValue = (F_CPU+8UL*baudRate)/(16UL*baudRate) - 1;
 }    //Upd-12
  else
  {
    ubrrValue = (F_CPU+4UL*baudRate)/(8UL*baudRate) - 1; //doubles speed
  } //Upd-12


if(sel==USART_0)    //for USART_0
{
  Usart0_txBufTail = 0;  Usart0_txBufHead = 0;
  Usart0_rxBufTail = 0;  Usart0_rxBufHead = 0;
  Usart0_rxCount = 0;
  UCSR0A = 0; // USART0 disabled
  UCSR0B = 0;  UCSR0C = 0;

    if (mode != USART_NORMAL){ UCSR0A = (1<<U2X0);}//doubles speed  //Upd-12

  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
  UBRR0H = (uint8_t)(ubrrValue >> 8);
  UBRR0L = (uint8_t)ubrrValue;
  UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0); //����. ������ ��� ������ � ��������, ���� ������, ���� ��������.
  UCSR0C = (1<<UCSZ01)|(1<<UCSZ00); //������ ����� 8 ��������
}
else             //for USART_1
{
  Usart1_txBufTail = 0;  Usart1_txBufHead = 0;
  Usart1_rxBufTail = 0;  Usart1_rxBufHead = 0;
  Usart1_rxCount = 0;
  UCSR1A = 0;  // USART1 disabled
  UCSR1B = 0;  UCSR1C = 0;

    if (mode != USART_NORMAL) { UCSR1A = (1<<U2X1);}//doubles speed

  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART1 Receiver: On //Transmitter: On //Mode: Asynchronous
  UBRR1H = (uint8_t)(ubrrValue >> 8);
  UBRR1L = (uint8_t)ubrrValue;
  UCSR1B = (1<<RXCIE1)|(1<<RXEN1)|(1<<TXEN1); //����. ������ ��� ������ � ��������, ���� ������, ���� ��������.
  UCSR1C = (1<<UCSZ11)|(1<<UCSZ10); //������ ����� 8 ��������
}
__restore_interrupts();
}


//______________________________________________________________________________
 /*
unsigned char USART_Get_txCount(void) //���������� ����������� �������� ����������� ������
{
  return Usart_txCount;
}
*/
void USART_FlushTxBuf(uint8_t sel) //"�������" ���������� �����
{
__disable_interrupts();
v_u32_TX_CNT=0;

 switch (sel)
 {
   case USART_0:
Usart_0_flush:
  Usart0_txBufTail = 0;
  Usart0_txBufHead = 0;
   break;
   case USART_1:
  Usart1_txBufTail = 0;
  Usart1_txBufHead = 0;
   break;
     default:
 goto Usart_0_flush;
   break;
}
__restore_interrupts();
}


//OPTIMISED!
//�������� ������ � �����, ���������� ������ ��������

void USART_PutChar(uint8_t sel, unsigned char symbol) //�������� ������ � �����, ���������� ������ ��������
{
 uint16_t Tmp_0 = Usart0_txBufHead;
 uint16_t Tmp_1 = Usart1_txBufHead;

 switch (sel)
 {
   case USART_0:
 Usart_0:
       // if(((UCSR0A & (1<<UDRE0)) == 1)) {UDR0 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
       //  else {                                                           //����� ������ ����� � ������� UDR
               if((uint16_t)(Tmp_0 - Usart0_txBufTail ) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
               Usart0_TX_buf[Tmp_0 & (SIZE_BUF_TX - 1)] = symbol;
               ++Tmp_0;
               __disable_interrupts();
               Usart0_txBufHead = Tmp_0;
               UCSR0B |= (1 << UDRIE0);
               } else {UartTxBufOvf_Handler();} //if TX buf ovverflowed, go to ovrf handler
         //    }
   break;
   case USART_1:
      //  if(((UCSR1A & (1<<UDRE1)) == 1)) {UDR1 = symbol;} //���� ������ usart �������� //((UCSRA & (1<<UDRE)) == 1) && (Usart0_txCount == 0)
       //  else {                                                           //����� ������ ����� � ������� UDR
               if((uint16_t)(Tmp_1 - Usart1_txBufTail) <= (uint16_t) SIZE_BUF_TX){ // buffer full, wait until symbol transmitted in interrupt
               Usart1_TX_buf[Tmp_1 & (SIZE_BUF_TX - 1)] = symbol;
               ++Tmp_1;
               __disable_interrupts();
               Usart1_txBufHead = Tmp_1;
               UCSR1B |= (1 << UDRIE1);
               }else {UartTxBufOvf_Handler();} //if TX buf ovverflowed, go to ovrf handler
          //   }
   break;
     default:
     goto Usart_0;
     break;
 }
 __restore_interrupts();
}



void USART_Send_Str(uint8_t sel, unsigned char * data)//������� ���������� ������ �� usart`�
{
  while(*data)
  {
   USART_PutChar(sel, *data++);//Optimized
  }
}

void USART_Send_StrFl(uint8_t sel, unsigned char __flash * data) //������� ���������� ������ �� ����� �� usart`�
{
  while(*data)
  {
    USART_PutChar(sel, *data++);
  }
}


  //Optimised
//���������� ���������� �� ���������� ��������
interrupt [USART0_DRE] void usart0_dre_my(void)  //USART Data Register Empty Interrupt
{
uint16_t Tmp = Usart0_txBufTail; // use local variable instead of volatile

      if(Tmp != Usart0_txBufHead) // Not all transmitted
       {
       UDR0 = Usart0_TX_buf[Tmp & (SIZE_BUF_TX - 1)];
       ++Tmp;
       Usart0_txBufTail = Tmp;
       }
       else
       {
    // PORTD.7=0;
         Usart0_txBufHead = 0; Usart0_txBufTail = 0;
        UCSR0B &= ~(1 << UDRIE0); // disable this int
       }
#ifdef DEBUG
v_u32_TX_CNT++;
#endif
}

//���������� ���������� �� ���������� ��������
interrupt [USART1_DRE] void usart1_dre_my(void)  //USART Data Register Empty Interrupt
{
uint16_t Tmp = Usart1_txBufTail; // use local variable instead of volatile

        UDR1 = Usart1_TX_buf[Tmp & (SIZE_BUF_TX - 1)];
       ++Tmp;
       Usart1_txBufTail = Tmp;
      if(Tmp == Usart1_txBufHead) // all transmitted
       {
       //PORTD.7=0;
         Usart1_txBufHead = 0; Usart1_txBufTail = 0;
        UCSR1B &= ~(1 << UDRIE1); // disable this int
       }
#ifdef DEBUG
//v_u32_TX_CNT++;
#endif
}
/*
ISR (USART_TXC_vect) {
	if (TX_buff.head!=TX_buff.tail) {
		UDR = TX_buff.buff[TX_buff.head];
		TX_buff.head = (TX_buff.head+1)&(TX_BUFFER_SIZE-1);
	} else {
		UART_message = UART_TX_COMPLETE;
		SendMessageWParam(MSG_UART, &UART_message);
	}
}
*/
//______________________________________________________________________________

unsigned char USART_Get_rxCount(uint8_t sel) //���������� ����������� �������� ����������� � �������� ������
{
return  sel ? Usart1_rxCount : Usart0_rxCount;
}

void USART_FlushRxBuf(uint8_t sel)//"�������" �������� �����
{
  // uint8_t saved_state;
   v_u32_RX_CNT = 0;
__disable_interrupts();
if(!sel){
  Usart0_rxBufTail = 0;
  Usart0_rxBufHead = 0;
  Usart0_rxCount = 0;
} else{
  Usart1_rxBufTail = 0;
  Usart1_rxBufHead = 0;
  Usart1_rxCount = 0;
}
__restore_interrupts();
}


char USART_Get_Char(uint8_t Uart_sel) //������ ������
{
  unsigned char symbol;
  uint8_t saved_state;
if(!Uart_sel)
{
  if (Usart0_rxCount > 0)        //���� �������� ����� �� ������
  {
    symbol = Usart0_RX_buf[Usart0_rxBufHead];        //��������� �� ���� ������
    Usart0_rxBufHead++;                        //���������������� ������ ������ ������
    if (Usart0_rxBufHead == SIZE_BUF_RX) Usart0_rxBufHead = 0;
__disable_interrupts();
    Usart0_rxCount--;                          //��������� ������� ��������
__restore_interrupts();
    return symbol;                         //������� ����������� ������
  }
  return 0;
}
  else
  {
   if (Usart1_rxCount > 0)        //���� �������� ����� �� ������
  {
    symbol = Usart1_RX_buf[Usart1_rxBufHead];        //��������� �� ���� ������
    Usart1_rxBufHead++;                        //���������������� ������ ������ ������
    if (Usart1_rxBufHead == SIZE_BUF_RX) Usart1_rxBufHead = 0;
__disable_interrupts();
    Usart1_rxCount--;                          //��������� ������� ��������
__restore_interrupts();
    return symbol;                         //������� ����������� ������
  }
  return 0;
  }
}


/*
  ISR (USART_RXC_vect) {
	u08 tmp = 0;
	tmp = UDR;
	if (((RX_buff.tail - RX_buff.head + 256) & (RX_BUFFER_SIZE-1)) < (RX_BUFFER_SIZE-1)) {
		RX_buff.buff[RX_buff.tail] = tmp;
		RX_buff.tail = (RX_buff.tail+1)&(RX_BUFFER_SIZE-1);
		if (tmp == 0x0D) {										// found end string classifier
			RX_buff.tail = (RX_buff.tail-1)&(RX_BUFFER_SIZE-1); // remove string end classifier from buffer
			///RX_buff.buff[RX_buff.tail] = '\0';				// replace string end delimiter with C standard string end
			UART_message = UART_RX_COMPLETE;
			SendMessageWParam(MSG_UART, &UART_message);
		}
	} else {
		sys_error = SYS_ERR_RX_BUF_FULL;
	}
}
*/
#warning ���������, ������������� �� ����� ���������� ��� ����� Tail � �� Head!
 interrupt [USART0_RXC] void usart0_rxc(void) //����������� �� ���������� �������
{
char data;
data =  UDR0;// read to clear RxC flag
    if (Usart0_rxCount < SIZE_BUF_RX) //���� � ����� �� � ����
    {
       Usart0_RX_buf[Usart0_rxBufTail] = data;//������� ������ �� ������
      Usart0_rxBufTail++;                    //�������� ������ ���� ������
      Usart0_rxCount++;
#warning ��������� ������������� ���������� �����
     if (Usart0_rxBufTail == SIZE_BUF_RX)
      {
       Usart0_rxBufTail = 0;
      }
    }
#ifdef DEBUG
v_u32_RX_CNT++;
#endif
}




 interrupt [USART1_RXC] void usart1_rxc(void) //���������� �� ���������� ������
{
char data;//!
data =  UDR1;//! read to clear RxC flag!

if(!U1_in_buf_flag)
  {
    if (Usart1_rxCount < SIZE_BUF_RX) //���� � ������ ��� ���� �����
    {
       Usart1_RX_buf[Usart1_rxBufTail] = data;//!    //������� ������  � �����
      Usart1_rxBufTail++;                    //��������� ������ ������ ��������� ������
      Usart1_rxCount++;                      //��������� ������� �������� ��������
#warning ��������� ������������� ���������� �����
    if (Usart1_rxBufTail == SIZE_BUF_RX)
      {
       Usart1_rxBufTail = 0;
      }
     }
  }
 else   //��� ����� - ������ � ����� ���������� ����� � ����� �� �����!
 {
    if((uint16_t)(Usart1_txBufHead - Usart1_txBufTail) <= (uint16_t) SIZE_BUF_TX) //���� � ������ ��� ���� �����
    {
      Usart0_TX_buf[Usart1_txBufHead & (SIZE_BUF_TX - 1)] = data;//!    //������� ������  � �����
      Usart0_txBufHead++;                    //��������� ������   ������
      //UCSR0B |= (1 << UDRIE0); // TX int - on
      }
 }
}

/*
*/

//������� ���-�� ������ � ��������� ������
 uint16_t usart_calc_BufData (uint16_t BufTail, uint16_t BufHead)
{
    if (BufTail >=  BufHead)
        return (BufTail -  BufHead);
    else
        return ((SIZE_BUF_TX -  BufHead) + BufTail);
}










