#include <adapter.h>

#include "D_usart/usart.h"
//#include "D_usart/usart.c"  

#include "global_variables.h" 

interrupt [ADC_INT] void adc_isr(void)// ADC interrupt service routine
{
 adc_result=ADCW*3-ADCW/7; //�������� ����� �������� �� � ������� ��������� �����������       
  ADCSRA=0;  //����
}






/*   //������ ������������� ���������� ����!
// Timer2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
SYS_TICK++; 
   //  if (USART_Get_rxCount(USART_0) > 0) //���� � ������� ������ ���-�� ����
   //    {
   //     symbol = USART_GetChar(USART_0);
   //     --Parser_req_state_cnt; //  ��������� �������� ������ �������

            #warning not_optimized
   //      if(Parser_req_state_cnt % 5 != 0) //������ ������ �������� ����..
   //      {
   //        _set(fl.Parser_Req);  //- �������� ������ � ������� �����,..
   //      }
   //      else //..�� 1 ��� � 5 ���������� �� �������������� ����� �����..
   //      { 
   //         PARS_Parser(symbol);//..���� ����� ������� ���� �����
   //      }
   //    }    
}
     */
