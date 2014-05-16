#ifndef ADC_H
#define ADC_H

#include <adapter.h>

#define ADC_VREF_TYPE 0xC0
#define ION 1298 //���������� ����������� ��� (1,23) � �� 
#define RIZM 200  //������������� �����. ��������� � ���� (��� ����)

volatile uint16_t adc_result = 0;
uint16_t vref=0,volt,watt,delta,adc_tmp,d=200,avcc;    
unsigned int adc_calib_cnt;                //��������������� ������� 

void ADC_init(void);
void ADC_start(char channel);



#endif