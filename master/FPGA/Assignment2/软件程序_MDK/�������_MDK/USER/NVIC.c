#include "common.h"
#include "NVIC.h"
#include "DS3231.h"
#include "oled_driver.h"

bool DeepSleepFlag = 0;

void KEY_INT_INIT (void){	 //�����жϳ�ʼ��
	NVIC_InitTypeDef  NVIC_InitStruct;	//����ṹ�����
	EXTI_InitTypeDef  EXTI_InitStruct;

   RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB,ENABLE); //����GPIOʱ�� ����Ҫ�븴��ʱ��һͬ������     
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO , ENABLE);//���ö˿��ж���Ҫ���ø���ʱ��

	GPIO_EXTILineConfig(GPIO_PortSourceGPIOB, GPIO_PinSource5);  //���� GPIO  �ж�
	
	EXTI_InitStruct.EXTI_Line=EXTI_Line5;  //�����ж���
	EXTI_InitStruct.EXTI_LineCmd=ENABLE;              //�ж�ʹ��
	EXTI_InitStruct.EXTI_Mode=EXTI_Mode_Interrupt;     //�ж�ģʽΪ �ж�
	EXTI_InitStruct.EXTI_Trigger=EXTI_Trigger_Falling;   //�½��ش���
	
	EXTI_Init(& EXTI_InitStruct);
	
	NVIC_InitStruct.NVIC_IRQChannel=EXTI9_5_IRQn;   //�ж���     
	NVIC_InitStruct.NVIC_IRQChannelCmd=ENABLE;  //ʹ���ж�
	NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority=2;  //��ռ���ȼ� 2
	NVIC_InitStruct.NVIC_IRQChannelSubPriority=4;     //�����ȼ�  2
	NVIC_Init(& NVIC_InitStruct);
}


//void DS3231_INT_INIT (void){	 //�����жϳ�ʼ��
//	GPIO_InitTypeDef  GPIO_InitStructure;
//	EXTI_InitTypeDef  EXTI_InitStruct;
//	NVIC_InitTypeDef  NVIC_InitStruct;	//����ṹ�����
//	
//  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE); //����GPIOʱ�� ����Ҫ�븴��ʱ��һͬ������  
//	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;//PA2
// 	GPIO_InitStructure.GPIO_Mode =GPIO_Mode_IPU; 		 //�ڲ���������
//	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;//�ٶ�50MHz
// 	GPIO_Init(GPIOA, &GPIO_InitStructure);	
//	
//  	
//	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO , ENABLE);//���ö˿��ж���Ҫ���ø���ʱ��

//	GPIO_EXTILineConfig(GPIO_PortSourceGPIOA, GPIO_PinSource2);  //���� GPIO  �ж�
//	
//	EXTI_InitStruct.EXTI_Line=EXTI_Line2;  //�����ж���
//	EXTI_InitStruct.EXTI_LineCmd=ENABLE;              //�ж�ʹ��
//	EXTI_InitStruct.EXTI_Mode=EXTI_Mode_Interrupt;     //�ж�ģʽΪ �ж�
//	EXTI_InitStruct.EXTI_Trigger=EXTI_Trigger_Falling;   //�½��ش���
//	
//	EXTI_Init(& EXTI_InitStruct);
//	
//	NVIC_InitStruct.NVIC_IRQChannel=EXTI2_IRQn ;   //�ж���     
//	NVIC_InitStruct.NVIC_IRQChannelCmd=ENABLE;  //ʹ���ж�
//	NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority=2;  //��ռ���ȼ� 2
//	NVIC_InitStruct.NVIC_IRQChannelSubPriority=3;     //�����ȼ�  2
//	NVIC_Init(& NVIC_InitStruct);

//}
//�ⲿ�ж�9~5�������
//IO���� PB5 ����SW3
void  EXTI9_5_IRQHandler(void)
{
	if(EXTI_GetITStatus(EXTI_Line5)!=RESET)
	{
		if(KEY1==0&&DeepSleepFlag==1)
		{
			delay_ms(80);
			if(KEY1==0)
			{//�ж�ĳ�����ϵ��ж��Ƿ��� 
				RCC_Configuration();
				DeepSleepFlag=0;
				OLED_ON();
				animation_start(display_load, ANIM_MOVE_OFF);
				EXTI_ClearITPendingBit(EXTI_Line5);   //��� LINE �ϵ��жϱ�־λ
			}  
		}		
		else
			EXTI_ClearITPendingBit(EXTI_Line5);   //��� LINE �ϵ��жϱ�־λ
	}
			
}
//void  EXTI2_IRQHandler(void){
//	
//	 
//	if(EXTI_GetITStatus(EXTI_Line2)!=RESET)
//	{//�ж�ĳ�����ϵ��ж��Ƿ���
//    		
//		INT_MARK=1;//��־λ��1����ʾ�а����ж�
//		 RCC_Configuration();
//		 power_off=0;
//		OLED_Display_On();
//		EXTI_ClearITPendingBit(EXTI_Line2);   //��� LINE �ϵ��жϱ�־λ
//    
//	 
//	}     
//}

void RCC_Configuration(void)
	{ //RCCʱ�ӵ�����  
	ErrorStatus HSEStartUpStatus;   
	RCC_DeInit();              /* RCC system reset(for debug purpose) RCC�Ĵ����ָ���ʼ��ֵ*/   
	RCC_HSEConfig(RCC_HSE_ON); /* Enable HSE ʹ���ⲿ���پ���*/   
	HSEStartUpStatus = RCC_WaitForHSEStartUp(); /* Wait till HSE is ready �ȴ��ⲿ���پ���ʹ�����*/   
	if(HSEStartUpStatus == SUCCESS){   
		/*����PLLʱ��Դ����Ƶϵ��*/   
		RCC_PLLConfig(RCC_PLLSource_HSE_Div1, RCC_PLLMul_9); //RCC_PLLMul_x��ö��2~16���Ǳ�Ƶֵ����HSE=8MHZ,RCC_PLLMul_9ʱPLLCLK=72MHZ   
		/*����AHBʱ�ӣ�HCLK��*/   
		RCC_HCLKConfig(RCC_SYSCLK_Div1); //RCC_SYSCLK_Div1����AHBʱ�� = ϵͳʱ��(SYSCLK) = 72MHZ���ⲿ����8HMZ��   
		/*ע��˴������ã����ʹ��SYSTICK����ʱ���򣬴�ʱSYSTICK(Cortex System timer)=HCLK/8=9MHZ*/   
		RCC_PCLK1Config(RCC_HCLK_Div2); //���õ���AHBʱ�ӣ�PCLK1��,RCC_HCLK_Div2����APB1ʱ�� = HCLK/2 = 36MHZ���ⲿ����8HMZ��   
		RCC_PCLK2Config(RCC_HCLK_Div1); //���ø���AHBʱ�ӣ�PCLK2��,RCC_HCLK_Div1����APB2ʱ�� = HCLK = 72MHZ���ⲿ����8HMZ��   
		/*ע��AHB��Ҫ�����ⲿ�洢��ʱ�ӡ�APB2����AD��I/O���߼�TIM������1��APB1����DA��USB��SPI��I2C��CAN������2��3��4��5����ͨTIM */  
		//FLASH_SetLatency(FLASH_Latency_2); //����FLASH�洢����ʱʱ��������   
		/*FLASHʱ���ӳټ������ڣ��ȴ�����ͬ��������   
		�Ƽ����յ�Ƭ��ϵͳ����Ƶ�ʣ�
		0��24MHzʱ��ȡLatency_0��   
		24��48MHzʱ��ȡLatency_1��   
		48~72MHzʱ��ȡLatency_2*/   
		//FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable); //ѡ��FLASHԤȡָ�����ģʽ��Ԥȡָ����ʹ��   
		RCC_PLLCmd(ENABLE);	//ʹ��PLL
		while(RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET); //�ȴ�PLL����ȶ�   
		RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK); //ѡ��SYSCLKʱ��ԴΪPLL
		while(RCC_GetSYSCLKSource() != 0x08); //�ȴ�PLL��ΪSYSCLKʱ��Դ   
	}  
	/*��ʼʹ�ܳ�������Ҫʹ�õ�����ʱ��*/   
	RCC_APB2PeriphClockCmd( RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB|RCC_APB2Periph_ADC1, ENABLE); //APB2����ʱ��ʹ��        	 
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);    
} 





