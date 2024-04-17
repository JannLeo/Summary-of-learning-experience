#include "i2c_soft.h"
#include "delay.h"

void I2C_GPIO_Config(void)  
{  
    GPIO_InitTypeDef  GPIO_InitStructure;  
          
    RCC_APB2PeriphClockCmd(SCL_RCC_CLOCK | SDA_RCC_CLOCK ,ENABLE);  
          
    //��ʼ��SCL�ܽ�  
    GPIO_InitStructure.GPIO_Pin =  SCL_PIN;  
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;  
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;    
    GPIO_Init(SCL_PORT, &GPIO_InitStructure);  
          
    //��ʼ��SDA�ܽ�  
    GPIO_InitStructure.GPIO_Pin =  SDA_PIN;  
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;  
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;  
    GPIO_Init(SDA_PORT, &GPIO_InitStructure);  
}

/**************************************************************************  
* ������: void I2C_delay(void)
* ����  : ������ʱ
* ����  : ��
* ���  : ��
* ˵��  : �ڲ������i�����Ż��ٶȣ���������͵�5����д��
***************************************************************************/  
static void I2C_delay(void)  
{    
    delay_us(3);
	  
}
/**************************************************************************
* ������: void I2C_Start(void)
* ����  : ��ʼ�ź�
* ����  : ��
* ���  : ��
* ˵��  :  
***************************************************************************/
int I2C_Start(void)
{
    SDA_H;
	SCL_H;
	I2C_delay();
	if(!SDA_read)return 0;	//SDA��Ϊ�͵�ƽ������æ,�˳�
	SDA_L;
	I2C_delay();
	if(SDA_read) return 0;	//SDA��Ϊ�ߵ�ƽ�����߳���,�˳�
	SDA_L;
	I2C_delay();
	return 1;
}
/**************************************************************************
* ������: I2C_Stop(void)
* ����  : ��ֹ�ź�
* ����  : ��
* ���  : ��
* ˵��  :  
***************************************************************************/
void I2C_Stop(void)
{
    SDA_L;    I2C_delay();
    SCL_H;    I2C_delay();
    SDA_H;    I2C_delay();
}
/**************************************************************************
* ������: void I2C_Ack(void)
* ����  : Ӧ���ź�
* ����  : ��
* ���  : ��
* ˵��  :  
***************************************************************************/
void I2C_Ack(void)  
{    
    SCL_L;  I2C_delay();  
    SDA_L;  I2C_delay();  
    SCL_H;  I2C_delay();  
    SCL_L;  I2C_delay();  
}
/**************************************************************************
* ������: void I2C_NoAck(void)
* ����  : ��Ӧ���ź�
* ����  : ��
* ���  : ��
* ˵��  :  
***************************************************************************/
void I2C_NoAck(void)  
{    
    SCL_L;  I2C_delay();  
    SDA_H;  I2C_delay();  
    SCL_H;  I2C_delay();  
    SCL_L;  I2C_delay();  
}  
/**************************************************************************
* ������: u8 I2C_WaitAck(void)
* ����  : �ȴ�Ӧ���ź�
* ����  : ��
* ���  : TRUE : ��Ӧ��
           FALSE : ��Ӧ��
* ˵��  :  
***************************************************************************/
int I2C_WaitAck(void)    
{  
    u8 ucErrTime=0;
    SCL_L;  I2C_delay();  
    SDA_H;  I2C_delay();  
    SCL_H;  I2C_delay();  
    while(SDA_read)  
    {  
        ucErrTime++;
        if(ucErrTime>250)
        {
            I2C_Stop();
            return 0;
        }
    }  
    SCL_L;  
    return 1;  
} 

//�ȴ�Ӧ���źŵ���
//����ֵ��1������Ӧ��ʧ��
//        0������Ӧ��ɹ�
int MPU_I2C_WaitAck(void)    
{  
    u8 ucErrTime=0;
    SCL_L;  I2C_delay();  
    SDA_H;  I2C_delay();  
    SCL_H;  I2C_delay();  
    while(SDA_read)  
    {  
        ucErrTime++;
        if(ucErrTime>250)
        {
            I2C_Stop();
            return 1;
        }
    }  
    SCL_L;  
    return 0;  
}  
/**************************************************************************  
* ������: void I2C_SendByte(u8 SendByte)  
* ����  : ����һ���ֽ�
* ����  : SendByte : �ֽ�����
* ���  : ��
* ˵��  : ���ݴӸ�λ����λ
***************************************************************************/
void I2C_SendByte(u8 SendByte)  
{  
    u8 i=8;  
    while(i--)  
    {  
        SCL_L;  
        I2C_delay();
        
        if(SendByte & 0x80)  
            SDA_H;    
        else  
            SDA_L;    
        SendByte<<=1;  
        I2C_delay();
        
        SCL_H;  
        I2C_delay();  
    }  
    SCL_L;  
}
/**************************************************************************
* ������: u8 I2C_ReceiveByte(void)  
* ����  : ��ȡһ���ֽ�
* ����  : ��  
* ���  : �ֽ�����
* ˵��  : ReceiveByte : ���ݴӸ�λ����λ
***************************************************************************/
u8 I2C_ReceiveByte(void)    
{  
    u8 i=8;  
    u8 ReceiveByte=0;  
          
    SDA_H;                
    while(i--)  
    {  
        ReceiveByte<<=1;        
        SCL_L;  
        I2C_delay();  
        SCL_H;
        I2C_delay();      
        if(SDA_read)  
        {  
            ReceiveByte|=0x01;  
        }  
    }  
    SCL_L;  
    return ReceiveByte;  
}

//ZRX          
//���ֽ�д��*******************************************

int Single_Write(unsigned char SlaveAddress,unsigned char REG_Address,unsigned char REG_data)		     //void
{
  	if(!I2C_Start())return 0;
    I2C_SendByte(SlaveAddress);   //�����豸��ַ+д�ź�//I2C_SendByte(((REG_Address & 0x0700) >>7) | SlaveAddress & 0xFFFE);//���ø���ʼ��ַ+������ַ 
    if(!I2C_WaitAck()){I2C_Stop(); return 0;}
    I2C_SendByte(REG_Address );   //���õ���ʼ��ַ      
    I2C_WaitAck();	
    I2C_SendByte(REG_data);
    I2C_WaitAck();   
    I2C_Stop(); 
    delay_ms(5);
    return 1;
}

//���ֽڶ�ȡ*****************************************
unsigned char Single_Read(unsigned char SlaveAddress,unsigned char REG_Address)
{   unsigned char REG_data;     	
	if(!I2C_Start())return 0;
    I2C_SendByte(SlaveAddress); //I2C_SendByte(((REG_Address & 0x0700) >>7) | REG_Address & 0xFFFE);//���ø���ʼ��ַ+������ַ 
    if(!I2C_WaitAck()){I2C_Stop(); return 0;}
    I2C_SendByte((u8) REG_Address);   //���õ���ʼ��ַ      
    I2C_WaitAck();
    I2C_Start();
    I2C_SendByte(SlaveAddress+1);
    I2C_WaitAck();

	REG_data= I2C_ReceiveByte();
    I2C_NoAck();
    I2C_Stop();
    //return TRUE;
	return REG_data;

}	

