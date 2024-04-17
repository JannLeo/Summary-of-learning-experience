/*
   Project: N|Watch
   Author: Zak Kemble, contact@zakkemble.co.uk
   Copyright: (C) 2013 by Zak Kemble
   License: GNU GPL v3 (see License.txt)
   Web: http://blog.zakkemble.co.uk/diy-digital-wristwatch/
*/
#include "buttons.h"
#include "common.h"
#include "sys.h"
#include "led.h"


#define BTN_IS_PRESSED	4
#define BTN_NOT_PRESSED	4

#define UPT_MOVE_NONE	0
#define UPT_MOVE_UP		1
#define UPT_MOVE_DOWN	2
#define UPT_MOVE_RIGHT	1     //�����ƶ�
#define UPT_MOVE_LEFT	2     //�����ƶ�

static bool btnDown(void);
static bool btnUp(void);
static byte uptMove;



static bool btnDown()
{
    uptMove = UPT_MOVE_DOWN;
    return true;
}

static bool btnUp()
{
    uptMove = UPT_MOVE_UP;
    return true;
}



//void MPU_setFuncs(button_f btn1, button_f btn2, button_f btn3)
//{
//    u8 pitch_detect;

//        // MPU change button
//        pitch_detect = MPU_Pitch_Detect();

//        if(pitch_detect == 2) uptMove = UPT_MOVE_UP;

//        if(pitch_detect == 1) uptMove = UPT_MOVE_DOWN;

//        if(uptMove == UPT_MOVE_UP)
//            btn1;
//        else if(uptMove == UPT_MOVE_DOWN)
//            isPressed[BTN_3] = 1;

//        uptMove = UPT_MOVE_NONE;
//}


typedef struct
{
    millis_t pressedTime;	// Time of press
    bool processed;			// Time of press has been stored (don't store again until next press)
    byte counter;			// Debounce counter
    bool funcDone;			// Function has been ran (don't run again until next press)
    button_f onPress;		// Function to run when pressed
    const ulong* tune;		// Tune to play when pressed
} s_button;

static s_button buttons[BTN_COUNT];

static void processButtons(void);
static void processButton(s_button*, BOOL);
static byte bitCount(byte);

//EMPTY_INTERRUPT(PCINT0_vect);

void buttons_init()
{
    buttons_startup();

    //�������Ĳ�������
    // Assign tunes
    buttons[BTN_1].tune = tuneBtn1;
    buttons[BTN_2].tune = tuneBtn2;
    buttons[BTN_3].tune = tuneBtn3;

    // Set up interrupts
//#ifdef __AVR_ATmega32U4__
//  SET_BITS(PCMSK0, PCINT4, PCINT6, PCINT7);
//#else
//  SET_BITS(PCMSK1, PCINT9, PCINT10, PCINT11);
//#endif
//  BTN_INT_ON();
}

void buttons_update()
{
    static millis8_t lastUpdate;

    // Update every 10ms
    millis8_t now = millis();

    if ((millis8_t)(now - lastUpdate) >= 10)
    {
        // printf("1");
        lastUpdate = now;
        processButtons();
    }
}

//������ʼ������
// Sets button pins to INPUT with PULLUP
void buttons_startup()
{

    GPIO_InitTypeDef  GPIO_InitStructure;

    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB | RCC_APB2Periph_AFIO, ENABLE);	//��GPIO��ʱ�ӣ��ȴ򿪸��ò����޸ĸ��ù���
    GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE); //Ҫ�ȿ�ʱ�ӣ�����ӳ�䣻����ʾ�ر�jtag��ʹ��swd��


    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);	         //SW1, SW3, SW2
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14 | GPIO_Pin_5 | GPIO_Pin_10; //PB14 PB5  PB10
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU; 		 //�ڲ���������
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;//�ٶ�50MHz
    GPIO_Init(GPIOB, &GPIO_InitStructure);
}

// Sets button pins to OUTPUT LOW
// This stops them wasting current through the pull-up resistor when pressed
void buttons_shutdown()
{
    //�������sleep����������رհ�����������

//  pinPullup(BTN_1_P,	PU_DIS);
//  pinPullup(BTN_2_P,	PU_DIS);
//  pinPullup(BTN_3_P,	PU_DIS);

//  pinMode(BTN_1_P,	OUTPUT);
//  pinMode(BTN_2_P,	OUTPUT);
//  pinMode(BTN_3_P,	OUTPUT);
}
extern int MODE;


float findmiddle(){
	float MiddlePitch3;
	float temp3;
	mpu_dmp_get_data(&MiddlePitch3,&temp3,&temp3);
	return MiddlePitch3;
}
static void processButtons()
{
    float MiddlePitch3;
    float temp3;
	MiddlePitch3= findmiddle();
    BOOL pitch_detect;
	
	BOOL isPressed[BTN_COUNT];
	BOOL roll_direction;
    // Get button pressed states
    if( MODE == 1 || MODE == 2)
    {
        
        isPressed[BTN_1] = KEY0;  //rightһ�����¼���
        isPressed[BTN_2] = KEY1;
        isPressed[BTN_3] = KEY2;  //left
    }

    else if (MODE == 3)
    {

       
        pitch_detect = MPU3_Pitch_Detect();
		roll_direction = MPU3_Roll_Detect(MiddlePitch3);


		isPressed[BTN_1] = pitch_detect;//right
		isPressed[BTN_2] = roll_direction;	
        isPressed[BTN_3] = KEY2;
    }

    // Process each button

    LOOPR(BTN_COUNT, i)
    processButton(&buttons[i], !isPressed[i]);
}

static void processButton(s_button* button, BOOL isPressed)
{
    button->counter <<= 1;

    if (isPressed)
    {
        // Set debounce counter bit
        button->counter |= 1;

        // Are enough bits set to count as pressed?//�൱�ڰ�������
        if (bitCount(button->counter) >= BTN_IS_PRESSED)
        {
            // Store time of press
            if (!button->processed)
            {
                button->pressedTime = millis();
                button->processed = true;
            }

            // Run function
            if (!button->funcDone && button->onPress != NULL && button->onPress())
            {
                button->funcDone = true;
                tune_play(button->tune, VOL_UI, PRIO_UI);

                //led_flash(LED_GREEN, LED_FLASH_FAST, LED_BRIGHTNESS_MAX);
                //LED1=!LED1;

            }
        }
    }
    else // Not pressed
    {
        // Has button been not pressed for long enough?
        if (bitCount(button->counter) <= BTN_NOT_PRESSED)
        {
            button->processed = false;
            button->funcDone = false;
        }
    }
}

// Count set bits in value
static byte bitCount(byte val)
{
    byte count = 0;

    for (; val; val >>= 1)
        count += val & 1;

    return count;
}

//����һ�����غ���ָ��ĺ���
// Set new function to run when button is pressed and return the old function
button_f buttons_setFunc(btn_t btn, button_f func)
{
    button_f old = buttons[btn].onPress;
    buttons[btn].onPress = func;
    return old;
}

// Set functions to run for each button
void buttons_setFuncs(button_f btn1, button_f btn2, button_f btn3)
{
    buttons[BTN_1].onPress = btn1;
    buttons[BTN_2].onPress = btn2;
    buttons[BTN_3].onPress = btn3;
}

/*
  // Get how long a button has been pressed for
  millis_t buttons_pressTime(btn_t btn) // set max press time to 1 min!!!
  {
	s_button* button = &buttons[btn];
	if(button->pressed == BTN_NOT_PRESSED)
		return 0;
	return (millis() - button->pressedTime);
  }
*/

// See if a button has been pressed in the past x milliseconds
bool buttons_isActive()
{
//  // If sleep has been disabled then just say that the buttons are always active
    if (!appConfig.sleepTimeout)
        return true;

//  // Get timeout val in ms
    uint timeout = (appConfig.sleepTimeout * 5) * 1000;
//  uint timeout =  1000;

    // See if a button has been pressed within that timeout
    LOOPR(BTN_COUNT, i)
    {
        if (millis() - buttons[i].pressedTime < timeout)
            return true;
    }

    return false;
}

// Set button status to pressed, processed etc but don't run their functions
void buttons_wake()
{
    LOOPR(BTN_COUNT, i)
    {
        buttons[i].funcDone		= true;
        buttons[i].processed	= true;
        buttons[i].counter		= BTN_IS_PRESSED;
        buttons[i].pressedTime	= millis();
    }
}
