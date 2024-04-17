#ifndef __DS3231_H_
#define __DS3231_H_

#include "sys.h"
typedef struct
{
    u8    hour;
    u8    min;
    u8    sec;            
    u8 w_year;
    u8  w_month;
    u8  w_date;
    u8  week;        
    u8    temper_H;
    u8    temper_L;
//	  u8 alarm_week;
//	  u8 alarm_hour;
//	  u8 alarm_min;
//	  u8 alarm_sec;
	
}Calendar_OBJ;
extern Calendar_OBJ calendar;    //日历结构体
extern u8 const mon_table[12];    //月份日期数据表

extern u8 yea,mon,day,hou,min,sec,week;
extern u8 alarm_week,alarm_hour,alarm_min,alarm_sec;
extern u8 alarm1_flag;

extern u8 test1,test2,test3;//调试时观察寄存器数值用

/******************************************************************************
                              参数寄存器地址宏定义                    
******************************************************************************/

#define Address_second					0x00	//秒
#define Address_minute					0x01	//分
#define Address_hour					0x02	//时
#define Address_week					0x03	//星期
#define Address_date					0x04	//日
#define Address_month					0x05	//月
#define Address_year					0x06	//年

#define Address_second_Alarm1			0x07	//秒闹铃
#define Address_minute_Alarm1			0x08	//分闹铃
#define Address_hour_Alarm1				0x09	//时闹铃
#define Address_week_Alarm1				0x0a	//日闹铃、星期闹铃

#define Address_minute_Alarm2			0x0b	//分闹铃
#define Address_hour_Alarm2				0x0c	//时闹铃
#define Address_week_Alarm2				0x0d	//日闹铃、星期闹铃


#define Address_control					0x0e	//控制
#define Address_control_status			0x0f	//控制和状态标志

#define Address_offset					0x10	//Aging Offset

#define Address_temp_MSB				0x11	//温度高8位
#define Address_temp_LSB				0x12	//温度低8位

/******************************************************************************
                             时间参数屏蔽无效位宏定义                 
******************************************************************************/

#define Shield_secondBit			0x7f
#define Shield_minuteBit			0x7f
#define Shield_hourBit				0x3f
#define Shield_weekBit				0x07
#define Shield_dateBit				0x3f
#define Shield_monthBit				0x1f

/******************************************************************************
                                 参数命令定义                      
******************************************************************************/

//小时寄存器
#define Hour_Mode12					(1<<6)	//12小时格式
#define Hour_Mode24					(0<<6)	//24小时格式

//秒闹铃寄存器1
#define Alarm_second_open			(1<<7)	//秒闹铃开
#define Alarm_second_close			(0<<7)	//秒闹铃关

//分闹铃寄存器1&2
#define Alarm_minute_open			(1<<7)	//分闹铃开
#define Alarm_minute_close			(0<<7)	//分闹铃关

//时闹铃寄存器1&2（可设置为12小时模式或者24小时模式）
#define Alarm_hour_open12			(3<<6)	//时闹铃开，12小时格式
#define Alarm_hour_close12			(1<<6)	//时闹铃关，12小时格式

#define Alarm_hour_open24			(2<<6)	//时闹铃开，24小时格式
#define Alarm_hour_close24			(0<<6)	//时闹铃关，24小时格式

//星期、日闹铃寄存器1&2（可选择星期闹铃或则日期闹铃）
#define Alarm_week_open				(3<<6)	//星期闹铃开
#define Alarm_week_close			(1<<6)	//星期闹铃关

#define Alarm_date_open				(2<<6)	//日期闹铃开
#define Alarm_date_close			(0<<6)	//日期闹铃关


//晶振控制寄存器
#define OSC_Enable					(0<<7)	//启动晶振
#define OSC_Disable					(1<<7)	//停止晶振

#define SET_BBSQW					(1<<6)	//Vbat pin
#define RESET_BBSQW					(0<<6)	//int/sqw高阻

#define Temp_CONV_SET				(1<<5)	//强制温度转换位数字码
#define Temp_CONV_Clear				(0<<5)

#define SQW_OUT1Hz					(0<<3)	//1Hz
#define SQW_OUT1024Hz				(1<<3)	//1.024KHz
#define SQW_OUT4096Hz				(2<<3)	//4.096KHz
#define SQW_OUT8192Hz				(3<<3)	//8.192KHz

#define OUTPUT_INTSQW				(0<<2)	//输出方波，上电该位置1（INTCN位）

#define A2IE_Enable					(1<<1)	//enable alarm 2
#define A2IE_Disable				(0<<1)	//disable alarm 2

#define A1IE_Enable					(1<<0)	//enable alarm 1
#define A1IE_Disable				(0<<0)	//disable alarm 1

//控制、状态寄存器
#define Clear_OSF_Flag				(0<<7)	//clear OSF flag

#define Enable_OSC32768				(1<<3)	//EN32KHz EN
#define Disable_OSC32768			(0<<3)	//EN32KHz高阻

#define Clear_A2IE_Flag				(0<<1)	//清除闹铃2中断标志
#define Clear_A1IE_Flag				(0<<0)	//清除闹铃2中断标志

void DS3231_Init(void);
void Get_DS3231_Time(void);      
//u8 RTC_Get_Week(u16 year,u8 month,u8 day);
void Set_DS3231_Time(void);//设置时间   
void Set_DS3231_date(void);//设置日期
void Date_init(void);
void DS3231Alarm_Config(void);//
void Set_DS3231_alarm1(void);
void Get_DS3231_alarm1(void);
void get_alarm1_status(void);

void enable_alarm1(void);
void reset_alarm1(void);//复位闹钟1
#endif
