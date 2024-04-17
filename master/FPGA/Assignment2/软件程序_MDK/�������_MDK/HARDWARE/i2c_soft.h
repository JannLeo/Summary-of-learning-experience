#ifndef __I2C_SOFT_H  
#define __I2C_SOFT_H  
#include "sys.h"    
#define SCL_PIN        GPIO_Pin_8  //
#define SDA_PIN        GPIO_Pin_9  //
#define SCL_PORT       GPIOB  
#define SDA_PORT       GPIOB  
#define SCL_RCC_CLOCK  RCC_APB2Periph_GPIOB  
#define SDA_RCC_CLOCK  RCC_APB2Periph_GPIOB  
      
#define SCL_H         GPIOB->BSRR = GPIO_Pin_8  //SCL=PB(8)
#define SCL_L         GPIOB->BRR  = GPIO_Pin_8  //SDA=PB(9)
        
#define SDA_H         GPIOB->BSRR = GPIO_Pin_9  
#define SDA_L         GPIOB->BRR  = GPIO_Pin_9  
      
#define SCL_read      GPIOB->IDR  & GPIO_Pin_8  
#define SDA_read      GPIOB->IDR  & GPIO_Pin_9  
   



//#define I2C_PageSize  8  //24C02Ã¿Ò³8×Ö½Ú  
void I2C_GPIO_Config(void);
int I2C_Start(void);
void I2C_Stop(void);
void I2C_Ack(void);
void I2C_NoAck(void);
int       I2C_WaitAck(void);
void I2C_SendByte(u8 SendByte);
u8    I2C_ReceiveByte(void);
//bool I2C_WriteByte(u8 SendByte, u16 WriteAddress, u8 DeviceAddress);  
//bool I2C_BufferWrite(u8* pBuffer, u8 length, u16 WriteAddress, u8 DeviceAddress);  
//void I2C_PageWrite(u8* pBuffer, u8 length, u16 WriteAddress, u8 DeviceAddress);  
//bool I2C_ReadByte(u8* pBuffer, u8 length, u16 ReadAddress, u8 DeviceAddress);  
//void I2C_Test(void);  
 
 int Single_Write(unsigned char SlaveAddress,unsigned char REG_Address,unsigned char REG_data);		     //void
unsigned char Single_Read(unsigned char SlaveAddress,unsigned char REG_Address);

int MPU_I2C_WaitAck(void);
 
#endif







