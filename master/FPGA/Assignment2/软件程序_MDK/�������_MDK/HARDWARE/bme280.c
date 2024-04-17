#include "bme280.h"
#include "common.h"
#include "oled_driver.h"
#include "oled_font.h"

BME280_Data  bme280_data;
Bme280_Calib bme280_cal;
float P_standard=1015.0;
uint difference_P;
int altitude;

/*bme280 气压和温度过采样 工作模式*/
#define BME280_PRES_OSR	(BME280_OVERSAMP_8X)
#define BME280_TEMP_OSR	(BME280_OVERSAMP_8X)
#define BME280_HUMI_OSR (BME280_OVERSAMP_8X)
#define BME280_MODE			(BME280_PRES_OSR<<2|BME280_TEMP_OSR<<5|BME280_FORCED_MODE)

/*
函数功能：
硬件连接：
					SPI2_SCK 	 PB13
					SPI2_MISO	 PB14
					SPI2_MOSI  PB15
					SPI2_BMECS PC12
*/

void Bme280_Init()
{
	
	
	Bme280_WriteData(0xE0,0xB6);
	delay_ms(20);	
	bme280_data.id=Bme280_ReadData(0xD0);
    Bme280_WriteData(BME280_CTRL_HUM,BME280_HUMI_OSR);
	Bme280_WriteData(BME280_CTRL_MEAS_REG,0xFF);
	Bme280_WriteData(BME280_CONFIG_REG,0x04);	
	readTrim();
	
}

void readTrim(void)
{
	bme280_cal.dig_T1=(Bme280_ReadData(0x89)<<8)|Bme280_ReadData(0x88);
	bme280_cal.dig_T2=(Bme280_ReadData(0x8B)<<8)|Bme280_ReadData(0x8A);
	bme280_cal.dig_T3=(Bme280_ReadData(0x8D)<<8)|Bme280_ReadData(0x8C);
	bme280_cal.dig_P1=(Bme280_ReadData(0x8F)<<8)|Bme280_ReadData(0x8E);
	bme280_cal.dig_P2=(Bme280_ReadData(0x91)<<8)|Bme280_ReadData(0x90);
	bme280_cal.dig_P3=(Bme280_ReadData(0x93)<<8)|Bme280_ReadData(0x92);
	bme280_cal.dig_P4=(Bme280_ReadData(0x95)<<8)|Bme280_ReadData(0x94);
	bme280_cal.dig_P5=(Bme280_ReadData(0x97)<<8)|Bme280_ReadData(0x96);
	bme280_cal.dig_P6=(Bme280_ReadData(0x99)<<8)|Bme280_ReadData(0x98);
	bme280_cal.dig_P7=(Bme280_ReadData(0x9B)<<8)|Bme280_ReadData(0x9A);
	bme280_cal.dig_P8=(Bme280_ReadData(0x9D)<<8)|Bme280_ReadData(0x9C);
	bme280_cal.dig_P9=(Bme280_ReadData(0x9F)<<8)|Bme280_ReadData(0x9E);
	bme280_cal.dig_H1=Bme280_ReadData(0xA1);
	bme280_cal.dig_H2=(Bme280_ReadData(0xE2)<<8)|Bme280_ReadData(0xE1);
	bme280_cal.dig_H3=Bme280_ReadData(0xE3);
	bme280_cal.dig_H4=(Bme280_ReadData(0xE4)<<4)|(0x0F&Bme280_ReadData(0xE5));
	bme280_cal.dig_H5=(Bme280_ReadData(0xE6)<<4)|((Bme280_ReadData(0x5E)>>4)&0x0F);
	bme280_cal.dig_H6=Bme280_ReadData(0xE7);   
	delay_ms(200);	
}

void Bme280_WriteData(u8 addr,u8 data)
{
    I2C_Start();
    I2C_SendByte(BME280_WRITE_ADDR);
    I2C_WaitAck();
    I2C_SendByte(addr);
    I2C_WaitAck();
    I2C_SendByte(data);
    I2C_WaitAck();
    I2C_Stop();
}


u8 Bme280_ReadData(u8 addr)
{
	
	
	u8 tx_data=0;
			
    I2C_Start();
    I2C_SendByte(BME280_WRITE_ADDR);
    I2C_WaitAck();
    I2C_SendByte(addr);
    I2C_WaitAck();
    I2C_Start();
    I2C_SendByte(BME280_READ_ADDR);
    I2C_WaitAck();
    tx_data=I2C_ReceiveByte();
    I2C_Stop();
    
   
	return tx_data;
}

// 在DegC中返回温度，分辨率为0.01 DegC。输出值“5123”等于51.23 DegC
// t_fine携带fine温度作为全局值
void bme280CompensateT(void)
{
    s32 Temp=0;
		s32 var1, var2; 
		Temp=(s32)((((u32)Bme280_ReadData(0xFA))<<12)|(((u32)(Bme280_ReadData(0xFB)))<<4)|((u32)Bme280_ReadData(0xFC)>>4));		
		var1  = ((((Temp>>3)-((s32)bme280_cal.dig_T1<<1))) * ((s32)bme280_cal.dig_T2)) >> 11;	
		var2  = (((((Temp>>4)-((s32)bme280_cal.dig_T1))*((Temp>>4)-((s32)bme280_cal.dig_T1))) >> 12)*((s32)bme280_cal.dig_T3)) >> 14;	
		bme280_cal.t_fine= var1 + var2; 
		bme280_data.T=(float)(((bme280_cal.t_fine * 5 + 128)>>8)/100.0);			
}

// 返回压力在Pa作为无符号32位整数在Q24.8格式(24整数位和8小数位)
// “24674867”的输出值为24674867/256 = 96386.2 Pa = 963.862 hPa
void bme280CompensateP(void)
{
		s32 var1, var2,Pres=0;
		u32 p;
		float q;
		Pres=(s32)((((u32)Bme280_ReadData(0xF7))<<12)|(((u32)(Bme280_ReadData(0xF8)))<<4)|((u32)Bme280_ReadData(0xF9)>>4));
		var1=(((s32)bme280_cal.t_fine)>>1)-(s32)64000; 
		var2=(((var1>>2) * (var1>>2)) >> 11 ) * ((s32)bme280_cal.dig_P6);  
		var2=var2 + ((var1*((s32)bme280_cal.dig_P5))<<1); 
		var2=(var2>>2)+(((s32)bme280_cal.dig_P4)<<16);  
		var1=(((bme280_cal.dig_P3*(((var1>>2)*(var1>>2))>>13))>>3)+((((s32)bme280_cal.dig_P2)*var1)>>1))>>18;
		var1 =((((32768+var1))*((s32)bme280_cal.dig_P1))>>15);  
		if (var1 == 0) 
		{   
			return ;	// avoid exception caused by division by zero
		} 
		p = (((u32)(((s32)1048576)-Pres)-(var2>>12)))*3125; 
		if(p<0x80000000) 
		{ 
			p =(p<<1)/((u32)var1);
		}   
		else   
		{  
			p=(p/(u32)var1)*2; 
		} 
		var1=(((s32)bme280_cal.dig_P9)*((s32)(((p>>3)*(p>>3))>>13)))>>12; 
		var2=(((s32)(p>>2)) * ((s32)bme280_cal.dig_P8))>>13; 
		p=(u32)((s32)p+((var1+var2+bme280_cal.dig_P7)>>4));
		q=(float)(p/100.0+0);//修改此处0即可对气压值进行补偿，其他参数类似
		presssureFilter(&q,&bme280_data.P);		
}

void bme280CompensateH(void)
{
	s32 Humi=0;
	double var_H;
	Humi=(s32)((((u32)(Bme280_ReadData(0xFD)))<<8)|(u32)(Bme280_ReadData(0xFE))); 
	var_H=(((double)bme280_cal.t_fine)-76800.0);  
	var_H=(Humi-(((double)bme280_cal.dig_H4)*64.0+((double)bme280_cal.dig_H5)/16384.0*var_H))*(((double)bme280_cal.dig_H2)/65536.0*(1.0+((double)bme280_cal.dig_H6) / 67108864.0 * var_H *  (1.0 + ((double)bme280_cal.dig_H3) / 67108864.0 * var_H))); 
	var_H=var_H*(1.0-((double)bme280_cal.dig_H1)*var_H / 524288.0);  
  if (var_H>100.0)var_H=100.0; 
	else if(var_H<0.0)var_H=0.0;
	bme280_data.H=(float)(((double)(var_H))/1.0);	
	altitude=(P_standard-bme280_data.P)*100/9;//高度计算，每升高1m气压下降9pa
}

#define FILTER_NUM	20
#define FILTER_A	0.1f

/*限幅平均滤波法*/
void presssureFilter(float* in,float* out)
{	
	u8 i=0;
	float filter_buf[FILTER_NUM]={0.0};
	double filter_sum=0.0;
	u8 cnt=0;	
	float deta;

	if(filter_buf[i]==0.0f)
	{
		filter_buf[i]=*in;
		*out=*in;
		if(++i>=FILTER_NUM)	
			i=0;
	} 
	else 
	{
		if(i)
			deta=*in-filter_buf[i-1];
		else 
			deta=*in-filter_buf[FILTER_NUM-1];
		
		if(fabs(deta)<FILTER_A)
		{
			filter_buf[i]=*in;
			if(++i>=FILTER_NUM)	
				i=0;
		}
		for(cnt=0;cnt<FILTER_NUM;cnt++)
		{
			filter_sum+=filter_buf[cnt];
		}
		*out=filter_sum /FILTER_NUM;
	}
}


void display_altitude(void)//计算相对于基准气压的高度
{
	char height[1]; //该数组用于存放float数据
	char p[1];
	
	
	draw_string("Now_P:",NOINVERT,0,16);
	sprintf((char *)p,"%.1f", bme280_data.P);//气压
	draw_string(p,NOINVERT,50,16);  
	draw_string("hPa",NOINVERT,100,16);
	
	
	draw_string("Std_P:",NOINVERT,0,0);
	sprintf((char *)height,"%.1f", P_standard);//基准气压
	draw_string(height,NOINVERT,50,0);
	draw_string("hpa",NOINVERT,100,0);
	
	
	difference_P=(P_standard-bme280_data.P)*100;
	
	
//	if(difference_P>0)
//	 	OLED_ShowChar(116,6,13,16);//气压用上升箭头
//    else if(difference_P<0)
//	    OLED_ShowChar(116,6,14,16); //气压用下降箭头
//	
	
	draw_string("dif:",NOINVERT,0,32);
	sprintf((char *)height,"%7d", difference_P);//气压差
	draw_string(height,NOINVERT,30,32);
	draw_string("Pa",NOINVERT,100,32);
	
	sprintf((char *)height,"%d", 0);
	draw_string("Alt:",NOINVERT,0,48);
	altitude=(P_standard-bme280_data.P)*100/9;//高度计算，每升高1m气压下降9pa
	sprintf((char *)height,"%d", altitude);//高度
	draw_string(height,NOINVERT,45,48);
	draw_string("Meter",NOINVERT,85,48);	
	sprintf((char *)height,"%d", 0);
	
}

//void OLED_Set_Pos(unsigned char x, unsigned char y) 
//{ 
//	WriteCmd(0xb0+y);
//	WriteCmd((((x+2)&0xf0)>>4)|0x10);
//	WriteCmd(((x+2)&0x0f));
//}    
////在指定位置显示一个字符,包括部分字符
////x:0~127
////y:0~63
////mode:0,反白显示;1,正常显示				 
////size:选择字体 16/12 
//void OLED_ShowChar(u8 x,u8 y,u8 chr,u8 Char_Size)
//{      	
//	unsigned char c=0,i=0;	
//		c=chr;//得到偏移后的值			
//		if(x>FRAME_WIDTH-1){x=0;y=y+2;}
//		if(Char_Size ==16)
//			{
//			OLED_Set_Pos(x,y);	
//			for(i=0;i<8;i++)
//				WriteDat(F8X16[c*16+i]);
//			OLED_Set_Pos(x,y+1);
//			for(i=0;i<8;i++)
//				WriteDat(F8X16[c*16+i+8]);
//			}
//			// else {	
//			// 	OLED_Set_Pos(x,y);
//			// 	for(i=0;i<6;i++)
//			// 		WriteDat(F6x8[c][i]);	
//			// }
//}

////显示一个字符号串
//void OLED_ShowString(u8 x,u8 y,u8 *chr,u8 Char_Size)
//{
//	unsigned char j=0;
//	while (chr[j]!='\0')
//	{		OLED_ShowChar(x,y,chr[j]-13-' ',Char_Size);
//			x+=8;
//		if(x>120){x=0;y+=2;}
//			j++;
//	}
//}


//		// 在DegC中返回温度，分辨率为0.01 DegC。输出值“5123”等于51.23 DegC
//// t_fine携带fine温度作为全局值
//void bme280CompensateT(void)
//{
//    s32 var1,var2,Temp=0;
//		Temp=(s32)((((u32)Bme280_ReadData(0xFA))<<12)|(((u32)(Bme280_ReadData(0xFB)))<<4)|((u32)Bme280_ReadData(0xFC)>>4));	
//		var1=((((Temp>>3)-((s32)bme280_cal.dig_T1<<1)))*((s32)bme280_cal.dig_T2))>>11;
//    var2=(((((Temp>>4)-((s32)bme280_cal.dig_T1))*((Temp>>4)-((s32)bme280_cal.dig_T1)))>>12)*((s32)bme280_cal.dig_T3))>>14;
//    bme280_cal.t_fine=var1+var2;
//    bme280_data.T=(float)(((bme280_cal.t_fine*5+128)>>8)/100.0);			
//}

//// 返回压力在Pa作为无符号32位整数在Q24.8格式(24整数位和8小数位)
//// “24674867”的输出值为24674867/256 = 96386.2 Pa = 963.862 hPa
//void bme280CompensateP(void)
//{
//		int64_t Pres=0,var1, var2;
//		float q;
//		u32 p;
//		Pres=(s32)((((u32)Bme280_ReadData(0xF7))<<12)|(((u32)(Bme280_ReadData(0xF8)))<<4)|((u32)Bme280_ReadData(0xF9)>>4));
//		var1=((int64_t)bme280_cal.t_fine)-128000;
//    var2=var1*var1*(int64_t)bme280_cal.dig_P6;
//    var2=var2+((var1*(int64_t)bme280_cal.dig_P5)<<17);
//    var2=var2+(((int64_t)bme280_cal.dig_P4)<<35);
//    var1=((var1*var1*(int64_t)bme280_cal.dig_P3)>>8)+((var1*(int64_t)bme280_cal.dig_P2)<<12);
//    var1=(((((int64_t)1)<<47)+var1))*((int64_t)bme280_cal.dig_P1)>>33;
//    if (var1==0)
//        return;
//    p=1048576-Pres;
//    p=(((p<<31)-var2)*3125)/var1;
//    var1=(((int64_t)bme280_cal.dig_P9)*(p>>13)*(p>>13))>>25;
//    var2=(((int64_t)bme280_cal.dig_P8)*p)>>19;
//    p=((p+var1+var2)>>8)+(((int64_t)bme280_cal.dig_P7)<<4);	
//		q=(float)(((u32)p)/25600.0);	
//		presssureFilter(&q,&(bme280_data.P));
//			
//}

//// 以无符号32位整数的形式返回%RH中的湿度在Q22.10格式(22个整数位和10个小数位)中将%RH中的湿度作为无符号32位整数返回。
//// 输出值“47445”表示47445/1024=46.333% RH
//void bme280CompensateH(void)
//{
//	s32 var,Humi=0;
//	Humi=(s32)((((u32)(Bme280_ReadData(0xFD)))<<8)|(u32)(Bme280_ReadData(0xFE)));
//	Humi=47445;
//	var=(bme280_cal.t_fine-((s32)76800));
//	var=(((((Humi<<14)-(((s32)bme280_cal.dig_H4)<<20)-(((s32)bme280_cal.dig_H5)*var))+((s32)16384))>>15)*(((((((var*(
//	(s32)bme280_cal.dig_H6))>>10)*(((var*((s32)bme280_cal.dig_H3))>>11)+((s32)32768)))>>10)+((s32)2097152))*((s32)
//	bme280_cal.dig_H2)+8192)>>14));
//	var=(var-(((((var>>15)*(var>>15))>>7)*((s32)bme280_cal.dig_H1))>>4));
//	var=(var<0?0:var);
//	var=(var>419430400?419430400:var);
//	bme280_data.H=(float)(((u32)(var>>12))/1024.0);
//}
