#warning This file`ll be destroyed!

#include <adapter.h>

#include "D_usart/usart.h"
//#include "D_usart/usart.c"

#include "global_variables.h"





/*   //������ ������������� ���������� ����!
// Timer2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
v_u32_SYS_TICK++;
   //  if (USART_Get_rxCount(USART_0) > 0) //���� � ������� ������ ���-�� ����
   //    {
   //     symbol = USART_Get_Char(USART_0);
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
