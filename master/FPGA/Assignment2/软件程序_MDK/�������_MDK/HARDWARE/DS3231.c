#include "DS3231.h"
#include "i2c_soft.h"
#include "delay.h"
#include "common.h"

Calendar_OBJ calendar;
#define DS3231_WriteAddress        0xD0  
#define DS3231_ReadAddress        0xD1

u8 test1,test2,test3;
u8 alarm1_flag;
u8 alarm_hour,alarm_min,alarm_sec,alarm_week;
extern alarm_s eepAlarms[ALARM_COUNT];

u8 BCD2HEX(u8 val)
{
    u8 i;
    i= val&0x0f;
    val >>= 4;
    val &= 0x0f;
    val *= 10;
    i += val;
    
    return i;
}
u16 B_BCD(u8 val)
{
    u8 i,j,k;
    i=val/10;
    j=val%10;
    k=j+(i<<4);
    return k;
}
void DS3231_WR_Byte(u8 addr,u8 bytedata)
{
    I2C_Start();
    I2C_SendByte(DS3231_WriteAddress);
    I2C_WaitAck();
    I2C_SendByte(addr);
    I2C_WaitAck();
    I2C_SendByte(bytedata);
    I2C_WaitAck();
    I2C_Stop();
}    
u8 DS3231_RD_Byte(u8 addr)
{
    u8 Dat=0;
  
    I2C_Start();
    I2C_SendByte(DS3231_WriteAddress);
    I2C_WaitAck();
    I2C_SendByte(addr);
    I2C_WaitAck();
    I2C_Start();
    I2C_SendByte(DS3231_ReadAddress);
    I2C_WaitAck();
    Dat=I2C_ReceiveByte();
    I2C_Stop();
    
    return Dat;
}

void DS3231_Init(void)
{
    I2C_GPIO_Config();
    DS3231_WR_Byte(0x0e,0x1f);
    delay_ms(2);
    DS3231_WR_Byte(0x0f,0x00);
    delay_ms(2);
	DS3231_WR_Byte(0x0e,0x20);//用于打开温度转换标志
	delay_ms(2);
}

void Set_DS3231_Time(void)
{
    u8 temp=0;
    temp=B_BCD(timeDate.time.hour);
    DS3231_WR_Byte(0x02,temp);
  
    temp=B_BCD(timeDate.time.mins);
    DS3231_WR_Byte(0x01,temp);
  
    temp=B_BCD(timeDate.time.secs);
    DS3231_WR_Byte(0x00,temp);
    
    
}


void Set_DS3231_date(void)
{
	u8 temp=0;
 
    temp=B_BCD(timeDate.date.year);
    DS3231_WR_Byte(0x06,temp);
  
    temp=B_BCD(timeDate.date.month);
    DS3231_WR_Byte(0x05,temp);
  
    temp=B_BCD(timeDate.date.date);
    DS3231_WR_Byte(0x04,temp);
	
	temp=B_BCD(timeDate.date.day);
    DS3231_WR_Byte(0x03,temp);
}

void Date_init(void)
{
	timeDate.date.date=11;
	timeDate.date.day=5;
	timeDate.date.month=2;
	timeDate.date.year=22;
}

float DS3231_Temp;

void Get_DS3231_Time(void)
{
    calendar.w_year=DS3231_RD_Byte(0x06);  
    timeDate.date.year=BCD2HEX(calendar.w_year);
    calendar.w_month=DS3231_RD_Byte(0x05);
    timeDate.date.month=BCD2HEX(calendar.w_month);
    calendar.w_date=DS3231_RD_Byte(0x04);  
    timeDate.date.date=BCD2HEX(calendar.w_date);
    
    calendar.hour=DS3231_RD_Byte(0x02);
  //  calendar.hour&=0x3f;                  
    timeDate.time.hour=BCD2HEX(calendar.hour);
    calendar.min=DS3231_RD_Byte(0x01);
    timeDate.time.mins=BCD2HEX(calendar.min);
    calendar.sec=DS3231_RD_Byte(0x00);
    timeDate.time.secs=BCD2HEX(calendar.sec);
    
    calendar.week=DS3231_RD_Byte(0x03);
    timeDate.date.day=BCD2HEX(calendar.week);
	
	
    /*************读取3231芯片温度***************************************/
    
    calendar.temper_H=DS3231_RD_Byte(0x11);
    calendar.temper_L=(DS3231_RD_Byte(0x12)>>6)*25;
	DS3231_Temp=(float)calendar.temper_H+(float)calendar.temper_L/100;
}
/************************************************************************************************************/
//待开发   预计改成闹钟复位功能
void DS3231Alarm_Config(void)
{
	
 //DS3231_WR_Byte(0x0e,0x1f);//alarm1 enable	
	//DS3231_WR_Byte(0x0f,0x00);//alarm1 enable		
} 
/*********************************************************************************************************************************************/
//闹钟设定函数，内部已设定为按照时，分，秒匹配闹钟。
//可选择是否匹配星期
//
//void Set_DS3231_alarm1(void)
//{
//	u8 temp_a=0;

///**************************闹钟1星期0~7位设定********************************************************************************/	
////0X0A用于星期计数时8位应满足 x1xx xxxx
//// &0x0f；      //数据变为：0000 xxxx//由于0X0A里用于星期计数时只有低四位有效，故通过&0x0f屏蔽高四位的设定，（同时会导致高四位为0，当0X0A第6位为0时变更为日期闹钟计数，0X0A第7位为0）故有以下办法
//// &0x0f|(1<<6);//数据变为：0100 xxxx//将0X0A第6位置1，则将按星期闹钟计数，当第7位A1M4为1时该位无影响，此时闹钟只有在星期也匹配后才会响
//// &0x0f|(3<<6);//数据变为：1100 xxxx//0X0A第7位A1M4为1，第6位在闹钟配置里失效，只要时间匹配闹钟就会响
// 
//  	//temp_a=B_BCD(eepAlarms[0])&0x0f|(1<<6);
//    //DS3231_WR_Byte(0x0a,temp_a);
//	
///**********************************************************************************************************/	
////&0X3F  //数据变为：00xx xxxx
////0X09中第6位为0时采用24h制，第7位A1M3为0时,启用A1M3
////  
//    temp_a=B_BCD(eepAlarms[0].hour)&0X3F;
//    DS3231_WR_Byte(0x09,temp_a);

////通过&0x7f屏蔽最高第七位的标志位,启用A1M2
////数据变为：0xxx xxxx
//    temp_a=B_BCD(eepAlarms[0].min)&0x7f;//
//    DS3231_WR_Byte(0x08,temp_a);
///**********************************************************************************************************/	  	
////通过&0x7f屏蔽最高第七位的标志位,启用A1M1
////数据变为：0xxx xxxx	

//   	temp_a=B_BCD(0)&0x7f;
//    DS3231_WR_Byte(0x07,temp_a);
//	  
//}
//void Get_DS3231_alarm1(void)//获取闹钟1各参数
//{
//	/**********闹钟调试用*************/ 
//	 test1=DS3231_RD_Byte(0x07);//test变量用于显示寄存器中的值，转换进制后用于核对使用，可观察已修改寄存器内数据
//	 test2=DS3231_RD_Byte(0x0e);
//	 test3=DS3231_RD_Byte(0x0f);
//	/********************************/ 
//	
//	  calendar.alarm_week=DS3231_RD_Byte(0x0A)&0x0f;//获取0X0A中的星期数据，低四位为所需数据，通过&运算屏蔽高四位
//	  calendar.alarm_week=BCD2HEX(calendar.alarm_week);
//	 
//	
//	 
//	  calendar.alarm_hour=DS3231_RD_Byte(0x09);
//	  calendar.alarm_hour&=0x3f;	//屏蔽0X09中最高位（闹钟A1M3标志位）
//    calendar.alarm_hour=BCD2HEX(calendar.alarm_hour);
//	
//	
//    calendar.alarm_min=DS3231_RD_Byte(0x08);
//    calendar.alarm_min=BCD2HEX(calendar.alarm_min);
//    calendar.alarm_sec=DS3231_RD_Byte(0x07);
//    calendar.alarm_sec=BCD2HEX(calendar.alarm_sec);
//	
//	
//   
// }
//void get_alarm1_status(void)//检测0X0F闹钟标志位A1F是否触发，触发则显示1，否则默认为0
// {
//	 u8 a;
//	 a=DS3231_RD_Byte(0x0f);
//	 if(a&0x01)
//		 alarm1_flag=1;
//	 else 
//		 alarm1_flag=0;
//		 
// }
//void enable_alarm1(void)
//{
//	 
//	DS3231_WR_Byte(0x0E,0x1f);
//}
//void reset_alarm1(void)
//{
//	u8 a;
//	a=DS3231_RD_Byte(0x0E);
//	DS3231_WR_Byte(0x0E,a&0xfe);
//	 a=DS3231_RD_Byte(0x0f);
//	DS3231_WR_Byte(0x0f,a&0xfe);
//}
