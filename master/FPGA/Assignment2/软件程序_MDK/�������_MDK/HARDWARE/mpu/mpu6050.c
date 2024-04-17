#include "mpu6050.h"
#include "sys.h"
#include "delay.h"
#include "usart.h"
#include "common.h"

u8 MPU_Init(void)
{
    u8 res;


    //MPU_AD0_CTRL=0;			//����MPU6050��AD0��Ϊ�͵�ƽ,�ӻ���ַΪ:0X68
    I2C_GPIO_Config();
    //MPU_IIC_Init();//��ʼ��IIC����
    MPU_Write_Byte(MPU_PWR_MGMT1_REG, 0X80);	//��λMPU6050
    delay_ms(100);
    MPU_Write_Byte(MPU_PWR_MGMT1_REG, 0X00);	//����MPU6050
    MPU_Set_Gyro_Fsr(3);					//�����Ǵ�����,��2000dps
    MPU_Set_Accel_Fsr(0);					//���ٶȴ�����,��2g
    MPU_Set_Rate(50);						//���ò�����50Hz
    MPU_Write_Byte(MPU_INT_EN_REG, 0X00);	//�ر������ж�
    MPU_Write_Byte(MPU_USER_CTRL_REG, 0X00);	//I2C��ģʽ�ر�
    MPU_Write_Byte(MPU_FIFO_EN_REG, 0X00);	//�ر�FIFO
    MPU_Write_Byte(MPU_INTBP_CFG_REG, 0X80);	//INT���ŵ͵�ƽ��Ч
    res = MPU_Read_Byte(MPU_DEVICE_ID_REG);

    if(res == MPU_ADDR) //����ID��ȷ
    {
        MPU_Write_Byte(MPU_PWR_MGMT1_REG, 0X01);	//����CLKSEL,PLL X��Ϊ�ο�
        MPU_Write_Byte(MPU_PWR_MGMT2_REG, 0X00);	//���ٶ��������Ƕ�����
        MPU_Set_Rate(50);						//���ò�����Ϊ50Hz
    }
    else return 1;

    return 0;
}
//����MPU6050�����Ǵ����������̷�Χ
//fsr:0,��250dps;1,��500dps;2,��1000dps;3,��2000dps
//����ֵ:0,���óɹ�
//    ����,����ʧ��
u8 MPU_Set_Gyro_Fsr(u8 fsr)
{
    return MPU_Write_Byte(MPU_GYRO_CFG_REG, fsr << 3); //���������������̷�Χ
}
//����MPU6050���ٶȴ����������̷�Χ
//fsr:0,��2g;1,��4g;2,��8g;3,��16g
//����ֵ:0,���óɹ�
//    ����,����ʧ��
u8 MPU_Set_Accel_Fsr(u8 fsr)
{
    return MPU_Write_Byte(MPU_ACCEL_CFG_REG, fsr << 3); //���ü��ٶȴ����������̷�Χ
}
//����MPU6050�����ֵ�ͨ�˲���
//lpf:���ֵ�ͨ�˲�Ƶ��(Hz)
//����ֵ:0,���óɹ�
//    ����,����ʧ��
u8 MPU_Set_LPF(u16 lpf)
{
    u8 data = 0;

    if(lpf >= 188)data = 1;
    else if(lpf >= 98)data = 2;
    else if(lpf >= 42)data = 3;
    else if(lpf >= 20)data = 4;
    else if(lpf >= 10)data = 5;
    else data = 6;

    return MPU_Write_Byte(MPU_CFG_REG, data); //�������ֵ�ͨ�˲���
}
//����MPU6050�Ĳ�����(�ٶ�Fs=1KHz)
//rate:4~1000(Hz)
//����ֵ:0,���óɹ�
//    ����,����ʧ��
u8 MPU_Set_Rate(u16 rate)
{
    u8 data;

    if(rate > 1000)rate = 1000;

    if(rate < 4)rate = 4;

    data = 1000 / rate - 1;
    data = MPU_Write_Byte(MPU_SAMPLE_RATE_REG, data);	//�������ֵ�ͨ�˲���
    return MPU_Set_LPF(rate / 2);	//�Զ�����LPFΪ�����ʵ�һ��
}

//�õ��¶�ֵ
//����ֵ:�¶�ֵ(������100��)
short MPU_Get_Temperature(void)
{
    u8 buf[2];
    short raw;
    float temp;
    MPU_Read_Len(MPU_ADDR, MPU_TEMP_OUTH_REG, 2, buf);
    raw = ((u16)buf[0] << 8) | buf[1];
    temp = 36.53 + ((double)raw) / 340;
    return temp * 100;;
}
//�õ�������ֵ(ԭʼֵ)
//gx,gy,gz:������x,y,z���ԭʼ����(������)
//����ֵ:0,�ɹ�
//    ����,�������
u8 MPU_Get_Gyroscope(short *gx, short *gy, short *gz)
{
    u8 buf[6], res;
    res = MPU_Read_Len(MPU_ADDR, MPU_GYRO_XOUTH_REG, 6, buf);

    if(res == 0)
    {
        *gx = ((u16)buf[0] << 8) | buf[1];
        *gy = ((u16)buf[2] << 8) | buf[3];
        *gz = ((u16)buf[4] << 8) | buf[5];
    }

    return res;;
}
//�õ����ٶ�ֵ(ԭʼֵ)
//gx,gy,gz:������x,y,z���ԭʼ����(������)
//����ֵ:0,�ɹ�
//    ����,�������
u8 MPU_Get_Accelerometer(short *ax, short *ay, short *az)
{
    u8 buf[6], res;
    res = MPU_Read_Len(MPU_ADDR, MPU_ACCEL_XOUTH_REG, 6, buf);

    if(res == 0)
    {
        *ax = ((u16)buf[0] << 8) | buf[1];
        *ay = ((u16)buf[2] << 8) | buf[3];
        *az = ((u16)buf[4] << 8) | buf[5];
    }

    return res;
}
//IIC����д
//addr:������ַ
//reg:�Ĵ�����ַ
//len:д�볤��
//buf:������
//����ֵ:0,����
//    ����,�������
u8 MPU_Write_Len(u8 addr, u8 reg, u8 len, u8 *buf)
{
    u8 i;
    I2C_Start();
    I2C_SendByte((addr << 1) | 0); //����������ַ+д����

    if(MPU_I2C_WaitAck())	//�ȴ�Ӧ��
    {
        I2C_Stop();
        return 1;
    }

    I2C_SendByte(reg);	//д�Ĵ�����ַ
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��

    for(i = 0; i < len; i++)
    {
        I2C_SendByte(buf[i]);	//��������

        if(MPU_I2C_WaitAck())		//�ȴ�ACK
        {
            I2C_Stop();
            return 1;
        }
    }

    I2C_Stop();
    return 0;
}
//IIC������
//addr:������ַ
//reg:Ҫ��ȡ�ļĴ�����ַ
//len:Ҫ��ȡ�ĳ���
//buf:��ȡ�������ݴ洢��
//����ֵ:0,����
//    ����,�������
u8 MPU_Read_Len(u8 addr, u8 reg, u8 len, u8 *buf)
{
    I2C_Start();
    I2C_SendByte((addr << 1) | 0); //����������ַ+д����

    if(MPU_I2C_WaitAck())	//�ȴ�Ӧ��
    {
        I2C_Stop();
        return 1;
    }

    I2C_SendByte(reg);	//д�Ĵ�����ַ
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��
    I2C_Start();
    I2C_SendByte((addr << 1) | 1); //����������ַ+������
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��

    while(len)
    {
        if(len == 1)
        {
            *buf = I2C_ReceiveByte();    //������,����nACK
            I2C_NoAck();
        }
        else
        {
            *buf = I2C_ReceiveByte();    //������,����ACK
            I2C_Ack();
        }

        len--;
        buf++;
    }

    I2C_Stop();	//����һ��ֹͣ����
    return 0;
}
//IICдһ���ֽ�
//reg:�Ĵ�����ַ
//data:����
//����ֵ:0,����
//    ����,�������
u8 MPU_Write_Byte(u8 reg, u8 data)
{
    I2C_Start();
    I2C_SendByte((MPU_ADDR << 1) | 0); //����������ַ+д����

    if(MPU_I2C_WaitAck())	//�ȴ�Ӧ��
    {
        I2C_Stop();
        return 1;
    }

    I2C_SendByte(reg);	//д�Ĵ�����ַ
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��
    I2C_SendByte(data);//��������

    if(MPU_I2C_WaitAck())	//�ȴ�ACK
    {
        I2C_Stop();
        return 1;
    }

    I2C_Stop();
    return 0;
}
//IIC��һ���ֽ�
//reg:�Ĵ�����ַ
//����ֵ:����������
u8 MPU_Read_Byte(u8 reg)
{
    u8 res;
    I2C_Start();
    I2C_SendByte((MPU_ADDR << 1) | 0); //����������ַ+д����
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��
    I2C_SendByte(reg);	//д�Ĵ�����ַ
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��
    I2C_Start();
    I2C_SendByte((MPU_ADDR << 1) | 1); //����������ַ+������
    MPU_I2C_WaitAck();		//�ȴ�Ӧ��
    res = I2C_ReceiveByte();
    I2C_NoAck();//��ȡ����,����nACK
    I2C_Stop();			//����һ��ֹͣ����
    return res;
}

u8 MPU_Roll_Detect(float middle)
{
	float pitch_a,roll_a,yaw_a;
	
	mpu_dmp_get_data(&pitch_a,&roll_a,&yaw_a);
	if(pitch_a-middle<-20)
		return 2;
	else if(pitch_a-middle>20)
		return 1;
	return 0;
}

bool MPU3_Roll_Detect(float middle)
{
	
    float pitch_a, roll_a, yaw_a;
	static bool left_flag = 0;
    static bool right_flag = 0;
    mpu_dmp_get_data(&pitch_a, &roll_a, &yaw_a);

//    if(pitch_a - middle < -5)
//        return true;
//    else if(pitch_a - middle > 5)
//        return false;

//    return true;
	
	if(pitch_a - middle < -10)
    {
        left_flag = 1;
        right_flag = 0;
    }
    else if(pitch_a - middle > 10)
    {
        right_flag = 1;
        left_flag = 0;
    }
    else
    {
        if(left_flag && !right_flag)
        {
            left_flag = 0;
            return true;
        }

        if(right_flag && !left_flag)
        {
            right_flag = 0;
            return false;
        }
		
		//return false;
        left_flag = 0;
        right_flag = 0;
    }




   // return false;
}

extern int MODE;
u8 MPU_Pitch_Detect(void)
{
    short pitch_a, roll_a, yaw_a;

    static bool left_flag = 0;
    static bool right_flag = 0;

    MPU_Get_Gyroscope(&pitch_a, &roll_a, &yaw_a);

    if(pitch_a > 3000)
    {
        left_flag = 1;
        right_flag = 0;
    }
    else if(pitch_a < -3000)
    {
        right_flag = 1;
        left_flag = 0;
    }
    else
    {
        if(left_flag && !right_flag)
        {
            left_flag = 0;
            return 1;
        }

        if(right_flag && !left_flag)
        {
            right_flag = 0;
            return 2;
        }

        left_flag = 0;
        right_flag = 0;
    }



    return 0;
}
bool MPU3_Pitch_Detect(void)
{
    short pitch_a, roll_a, yaw_a;

    static bool left_flag = 0;
    static bool right_flag = 0;

    MPU_Get_Gyroscope(&pitch_a, &roll_a, &yaw_a);

    if(pitch_a > 3500)
    {
        left_flag = 1;
        right_flag = 0;
    }
    else if(pitch_a < -3500)
    {
        right_flag = 1;
        left_flag = 0;
    }
    else
    {
        if(left_flag && !right_flag)
        {
            left_flag = 0;
            return true;
        }

        if(right_flag && !left_flag)
        {
            right_flag = 0;
            return false;
        }
		
		return true;
        left_flag = 0;
        right_flag = 0;
    }




    return false;
}

