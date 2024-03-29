#include <adapter.h>

#include "RTOS/EERTOS.h"
#include "RTOS/EERTOSHAL.h"
 #include "D_Tasks/task_list.h"
/*
���������� ���������� �������.(������)
��� ������� ���������� �������� ����� ���������
������������������, �� ��� ������� ������ ���� ��
������ �����.�������� ��� ������� ������ �� �����
*/



/*
void red_blink(void){
char t=4;
    do{
    LED_RED_ON;
    delay_ms(100);
    LED_RED_OFF;
    delay_ms(200);
    }while(--t);
}  */


uint8_t check_after_pow_on(void)     /*need optimisation*/
{
//uint8_t state = 0;

/*#1 check periferie*/
//if (PINA!=0){printf("P_A=%d\r",PINA);}
//if (PINB!=0){printf("P_B=%d\r",PINB);}
//if (PINC!=0){printf("P_C=%d\r",PINC);}
//if (PIND!=0){printf("P_D=%d\r\n",PIND);}


/*#2 check reset source*/
/*The MCU Control and Status Register provides
information on which reset source caused an MCU Reset*/
if (MCUCSR & (1<<PORF))// Power-on Reset
   {
    Put_In_Log("porf"); //now \r\n concat in Put_In_Log
   }
else if (MCUCSR & (1<<EXTRF))// External Reset
   {
    Put_In_Log("extrf");
   }
else if (MCUCSR & (1<<BORF))// Brown-Out Reset
   {
   Put_In_Log("borf");
   }
else if (MCUCSR & (1<<WDRF))// Watchdog Reset
   {
    Put_In_Log("wdrf");
   }
else if (MCUCSR & (1<<JTRF))// JTAG Reset
   {
    Put_In_Log("JTRF");
   }

MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));//clear register
return 0;
}


void TIM2_ON(void){
//TCCR2 |= (1<<CS21)|(1<<CS20);
TCCR2 |= (1<<CS22)|(1<<CS21)|(1<<CS20);

}

void TIM2_OFF(void){
//TCCR2 &= ~((1<<CS21)|(1<<CS20));
TCCR2 &= ~((1<<CS22)|(1<<CS21)|(1<<CS20));
}

void Sys_timer_init(void){ //USED BY RTOS (DONT TOUCH!)
//Settings for Timer2
OCR2 = 125; //125000 /125 = 1000 compare interruptes per second
TCCR2 |= (1<<CS21)|(1<<CS20);//START timer (8Mhz div 64 = 125000)   //Upd-5 ������ 16���
TIMSK |= (1<<OCIE2); //compare interrupt EN
}


void print_help(void){
StopRTOS();
USART_Send_StrFl(SYSTEM_USART, help_mess_0);
USART_Send_StrFl(SYSTEM_USART, help_mess_1);
USART_Send_StrFl(SYSTEM_USART, help_mess_2);
USART_Send_StrFl(SYSTEM_USART, help_mess_3);
USART_Send_StrFl(SYSTEM_USART, help_mess_4);

USART_Send_StrFl(SYSTEM_USART,help_Uart_0);
USART_Send_StrFl(SYSTEM_USART,help_Uart_1);
USART_Send_StrFl(SYSTEM_USART,help_Spi_0);
USART_Send_StrFl(SYSTEM_USART,help_Spi_1);
RunRTOS();
}

void print_settings_ram(void){
uint8_t i = 0;
char str[10];

USART_Send_Str(SYSTEM_USART,"\r<RAM>");
USART_Send_Str(SYSTEM_USART,"\rUART_SETTINGS\r");
  for(i=0;i<COUNT_OF_UARTS;i++)
    {
    USART_Send_Str(SYSTEM_USART,"UART ");
    itoa(i,str);
    USART_Send_Str(SYSTEM_USART,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r Mode ");
    itoa(RAM_settings.MODE_of_Uart[i],str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r Speed ");
    itoa(RAM_settings.baud_of_Uart[i],str);
    USART_Send_Str(SYSTEM_USART,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r--------\r");
    }

USART_Send_Str(SYSTEM_USART,"\rSPI_SETTINGS\r");
  for(i=0;i<COUNT_OF_SPI;i++)
    {
    USART_Send_Str(SYSTEM_USART,"SPI ");
    itoa(i,str);
    USART_Send_Str(SYSTEM_USART,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r Mode ");
    itoa(RAM_settings.MODE_of_Spi[i],str);
    USART_Send_Str(SYSTEM_USART,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r Prescaller ");
    itoa(RAM_settings.prescaller_of_Spi[i],str);
    USART_Send_Str(SYSTEM_USART,str); //convert dec to str

    USART_Send_Str(SYSTEM_USART,"\r--------\r");
    }
//USART_FlushTxBuf(USART_0);
}

void print_settings_eeprom(void){
uint8_t i = 0;
char str[10];

USART_Send_Str(USART_0,"\r<EEPROM>");
USART_Send_Str(USART_0,"\rUART_SETTINGS\r");
  for(i=0;i<COUNT_OF_UARTS;i++)
    {
    USART_Send_Str(USART_0,"UART ");
    itoa(i,str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r Mode ");
    itoa(EE_settings.MODE_of_Uart[i],str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r Speed ");
    itoa(EE_settings.baud_of_Uart[i],str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r--------\r");
    }

USART_Send_Str(USART_0,"\rSPI_SETTINGS\r");
  for(i=0;i<COUNT_OF_SPI;i++)
    {
    USART_Send_Str(USART_0,"SPI ");
    itoa(i,str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r Mode ");
    itoa(EE_settings.MODE_of_Spi[i],str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r Prescaller ");
    itoa(EE_settings.prescaller_of_Spi[i],str);
    USART_Send_Str(USART_0,str); //convert dec to str

    USART_Send_Str(USART_0,"\r--------\r");
    }
//USART_FlushTxBuf(USART_0);
}


void print_sys(void)
{
char str[5];
USART_Send_Str(SYSTEM_USART,"\rButes_RX ");
itoa(v_u32_RX_CNT,str);
USART_Send_Str(SYSTEM_USART,str); //convert dec to str

USART_Send_Str(SYSTEM_USART,"\rButes_TX ");
itoa(v_u32_TX_CNT,str);
USART_Send_Str(SYSTEM_USART,str); //convert dec to str
}


void RingBuff_TX(void)
{ 
  UCSR0B |= (1 << UDRIE0); // TX int - on
}

#warning TODO
uint8_t get_curr_cpu_freq (void) //���������� �������� ������� ������� ������ ��
{
uint8_t freq = 0;
  //TODO
return freq;
}

#warning ��������!
void cust_delay_ms(uint16_t delay){ //����� ��������
uint32_t timecnt = v_u32_SYS_TICK + delay;
while (v_u32_SYS_TICK < timecnt){}
}




//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//RLE_array pack/unpack funktions

int RLE_pack (unsigned char* src,unsigned char* dst, uint16_t src_size)
{
uint8_t tmp_symb = src[0];
uint16_t tmp_cnt = 1;
uint16_t k = 0;
uint16_t i = 1;

 for(i = 1; i<src_size+1; i++)
    {
       if(src[i] == tmp_symb){tmp_cnt++;}
       else
        {
            dst[k] = tmp_cnt; k++;
            dst[k] = tmp_symb; k++;

            tmp_symb = src[i];
            tmp_cnt = 1;
       }
    }
 return k;   //return new_sise
}

int RLE_unpack (flash unsigned char* src, unsigned char* dst, uint16_t src_size)
{
uint8_t tmp_symb = 0;
uint8_t tmp_cnt = 0;
uint16_t i;
uint16_t j;
uint16_t k=0;

 for(i = 0; i<src_size; i+=2)
    {
        tmp_cnt = src[i];
        tmp_symb = src[i+1];
        for(j = 0; j < tmp_cnt; j++)
        {
            dst[k++] = tmp_symb;
        }
    }
 return src_size+k;   //new_sise
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


/**
void cust_ltoa(long int n, char *str;)
{
unsigned long i;
unsigned char j,p;
i=1000000000L;
p=0;
if (n<0)
   {
   n=-n;
   *str++='-';
   };
do
  {
  j=(unsigned char) (n/i);
  if (j || p || (i==1))
     {
     *str++=j+'0';
     p=1;
     }
  n%=i;
  i/=10L;
  } while (i!=0);
   *str = 0;
}
*/

void SheikerSort(uint8_t *a, int n)  // 114words - 50elem=5ms; 100elem=20ms
{
           int8_t l, r, i, k;     
           int tmp;
           k = l = 0;
           r = n - 2;   
           
           while(l <= r)
           {
              for(i = l; i <= r; ++i)
              {
                 if (a[i] > a[i+1])
                 {   
                 tmp = a[i];
                 a[i] = a[i+1];
                 a[i+1] = tmp;
                   /* a[i] ^= a[i+1]; //More memory and time!
                    a[i+1] ^= a[i];
                    a[i] ^= a[i+1]; */
                    k = i;
                 }
              }
              r = k - 1;

              for(i = r; i >= l; --i)
               {
                 if (a[i] > a[i+1])
                 {     
                 tmp = a[i];
                 a[i] = a[i+1];
                 a[i+1] = tmp;
                    /*a[i] ^= a[i+1]; //More memory and time!
                    a[i+1] ^= a[i];
                    a[i] ^= a[i+1];*/
                    k = i;
                 }
               }
              l = k + 1;
           }            
}

void BubbleSort(uint8_t *arr, int n) //89words - 50elem=6,4ms; 100elem=26ms
{    
      bit swapped = true;  
      int i = 0;
      int j = 0;
      int tmp;

      while (swapped) 
      {      
            swapped = false;  
            j++;            
            for (i = 0; i < n - j; i++) 
            {  
                  if (arr[i] > arr[i + 1]) 
                  {
                        tmp = arr[i];  
                        arr[i] = arr[i + 1];
                        arr[i + 1] = tmp;
                        swapped = true;  
                  }

            }

      }
}