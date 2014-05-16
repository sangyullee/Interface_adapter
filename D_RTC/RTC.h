#ifndef RTC_H
#define RTC_H

//#include "compilers.h"

static void rtc_init(void);
static char not_leap(void);

//orig struct  = 6 bytes

typedef struct TIME {
    unsigned char second;
    unsigned char minute;
    unsigned char hour;
    unsigned char date;
    unsigned char month;
    unsigned char year;
    }time;


/*
typedef struct TIME {
    uint32_t second:7; //7
    uint32_t minute:7; //7
    uint32_t hour:6;   //6
    uint32_t date:6;   //6
    uint32_t month:4;  //4
    uint32_t year:2;   //2 //�� �������
    }time;
*/


#endif