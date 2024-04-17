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
	u16 dig_T1;   //У׼ T1 ����
	s16 dig_T2;   //У׼ T2 ����
	s16 dig_T3;   //У׼ T3 ���� 
	u16 dig_P1;   //У׼ P1 ���� 
	s16 dig_P2;   //У׼ P2 ���� 
	s16 dig_P3;   //У׼ P3 ���� 
	s16 dig_P4;   //У׼ P4 ���� 
	s16 dig_P5;   //У׼ P5 ����
	s16 dig_P6;   //У׼ P6 ���� 
	s16 dig_P7;   //У׼ P7 ���� 
	s16 dig_P8;   //У׼ P8 ���� 
	s16 dig_P9;   //У׼ P9 ���� 
	u8  dig_H1;   //У׼ H1 ���� 
	s16 dig_H2;   //У׼ H2 ���� 
	u8  dig_H3;   //У׼ H3 ���� 
	s16 dig_H4;   //У׼ H4 ���� 
	s16 dig_H5;   //У׼ H5 ���� 
	u8  dig_H6;   //У׼ H6 ���� 
	s32 t_fine;   //У׼ t_fine ���� 
} Bme280_Calib;

extern Bme280_Calib bme280_cal;
extern BME280_Data  bme280_data;



#define BME280_WRITE_ADDR		0xEC
#define BME280_READ_ADDR		0xED

#define BME280_DEFAULT_CHIP_ID	0x60

#define BME280_CHIP_ID				0xD0    //оƬ���֤�Ǽ� 
#define BME280_RST_REG				0xE0    //�����λ 
#define BME280_CTRL_HUM       0xF2    //ʪ�ȿ��ƼĴ��� 
#define BME280_STAT_REG				0xF3    //״̬�Ĵ��� 
#define BME280_CTRL_MEAS_REG	0xF4    //�������ƼĴ��� 
#define BME280_CONFIG_REG			0xF5    //���üĴ��� 
#define BME280_PRES_MSB_REG		0xF7    //ѹ�� MSB �Ĵ��� 
#define BME280_PRES_LSB_REG		0xF8    //ѹ�� LSB �Ĵ��� 
#define BME280_PRES_XLSB_REG	0xF9    //ѹ�� XLSB �Ĵ��� 
#define BME280_TEMP_MSB_REG		0xFA    //�¶� MSB �Ĵ��� 
#define BME280_TEMP_LSB_REG		0xFB    //�¶� MSB �Ĵ��� 
#define BME280_TEMP_XLSB_REG	0xFC    //�¶� XLSB �Ĵ��� 
#define BME280_HUMI_MSB_REG		0xFD    //ʪ�� MSB �Ĵ��� 
#define BME280_HUMI_LSB_REG		0xFE    //ʪ�� LSB �Ĵ��� 

#define BME280_SLEEP_MODE			0x00		//˯��ģʽ
#define BME280_FORCED_MODE		0x01		//ǿ��ģʽ
#define BME280_NORMAL_MODE		0x03		//����ģʽ

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
