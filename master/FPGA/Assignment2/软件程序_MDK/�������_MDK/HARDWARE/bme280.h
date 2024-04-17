#ifndef _BME280_H_
#define _BME280_H_

#include "stm32f10x.h"
#include "i2c_soft.h"
//#include "spi.h"
#include "sys.h"
#include "delay.h"
#include "usart.h"
#include <math.h>

typedef struct str
{
	u8 id;		// ID
	float P;	//air pressure
	float T;	//temperature
	float H;	//hudimity
}BME280_Data;

typedef struct 
{
	u16 dig_T1;   //校准 T1 数据
	s16 dig_T2;   //校准 T2 数据
	s16 dig_T3;   //校准 T3 数据 
	u16 dig_P1;   //校准 P1 数据 
	s16 dig_P2;   //校准 P2 数据 
	s16 dig_P3;   //校准 P3 数据 
	s16 dig_P4;   //校准 P4 数据 
	s16 dig_P5;   //校准 P5 数据
	s16 dig_P6;   //校准 P6 数据 
	s16 dig_P7;   //校准 P7 数据 
	s16 dig_P8;   //校准 P8 数据 
	s16 dig_P9;   //校准 P9 数据 
	u8  dig_H1;   //校准 H1 数据 
	s16 dig_H2;   //校准 H2 数据 
	u8  dig_H3;   //校准 H3 数据 
	s16 dig_H4;   //校准 H4 数据 
	s16 dig_H5;   //校准 H5 数据 
	u8  dig_H6;   //校准 H6 数据 
	s32 t_fine;   //校准 t_fine 数据 
} Bme280_Calib;

extern Bme280_Calib bme280_cal;
extern BME280_Data  bme280_data;



#define BME280_WRITE_ADDR		0xEC
#define BME280_READ_ADDR		0xED

#define BME280_DEFAULT_CHIP_ID	0x60

#define BME280_CHIP_ID				0xD0    //芯片身份证登记 
#define BME280_RST_REG				0xE0    //软件复位 
#define BME280_CTRL_HUM       0xF2    //湿度控制寄存器 
#define BME280_STAT_REG				0xF3    //状态寄存器 
#define BME280_CTRL_MEAS_REG	0xF4    //测量控制寄存器 
#define BME280_CONFIG_REG			0xF5    //配置寄存器 
#define BME280_PRES_MSB_REG		0xF7    //压力 MSB 寄存器 
#define BME280_PRES_LSB_REG		0xF8    //压力 LSB 寄存器 
#define BME280_PRES_XLSB_REG	0xF9    //压力 XLSB 寄存器 
#define BME280_TEMP_MSB_REG		0xFA    //温度 MSB 寄存器 
#define BME280_TEMP_LSB_REG		0xFB    //温度 MSB 寄存器 
#define BME280_TEMP_XLSB_REG	0xFC    //温度 XLSB 寄存器 
#define BME280_HUMI_MSB_REG		0xFD    //湿度 MSB 寄存器 
#define BME280_HUMI_LSB_REG		0xFE    //湿度 LSB 寄存器 

#define BME280_SLEEP_MODE			0x00		//睡眠模式
#define BME280_FORCED_MODE		0x01		//强制模式
#define BME280_NORMAL_MODE		0x03		//正常模式

#define BME280_TEMP_CALIB_DIG_T1_LSB_REG    0x88
#define BME280_PRES_TEMP_CALIB_DATA_LENGTH  32
#define BME280_DATA_FRAME_SIZE		4

#define BME280_OVERSAMP_SKIP	0x00
#define BME280_OVERSAMP_1X		0x01
#define BME280_OVERSAMP_2X		0x02
#define BME280_OVERSAMP_4X		0x03
#define BME280_OVERSAMP_8X		0x04
#define BME280_OVERSAMP_16X		0x05

void Bme280_Init(void);
void readTrim(void);
void Bme280_WriteData(u8 addr,u8 data);
u8 Bme280_ReadData(u8 addr);
void bme280GetPressure(void);
void bme280CompensateT(void);
void bme280CompensateP(void);
void bme280CompensateH(void);
void presssureFilter(float* in,float* out);
void display_altitude(void);

//void OLED_Set_Pos(unsigned char x, unsigned char y);
//void OLED_ShowChar(u8 x,u8 y,u8 chr,u8 Char_Size);
//void OLED_ShowString(u8 x,u8 y,u8 *chr,u8 Char_Size);

#endif
