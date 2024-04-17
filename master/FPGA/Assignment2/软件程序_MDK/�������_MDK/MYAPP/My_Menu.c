#include "common.h"
#include "delay.h"
#include "oled_driver.h"
#include "NVIC.h"
#include "bme280.h"
#include "mpu_task.h"
#include "altitude_display.h"
//#include "MODECHANGE.h"


#define STR_WIFICMDMENU  "< My Menu >"
#define CMD1_NAME "Init MPU"
#define CMD2_NAME "Deep Sleep"
#define CMD3_NAME "MPU_Display"

//#define CMD4_1_NAME "Entertainment"
//#define CMD4_2_NAME "Study"
//#define CMD4_3_NAME "Sport"
//#define CMD4_NAME "History_Data"
#define CMD5_NAME "Back"

#define OPTION_COUNT 5


static void mSelect()
{
    doAction(false);  //ִ��ָ��
    //menuData.isOpen = false;  //�رղ˵�
}

extern int reset;
void ShutDown(void)
{
    //display_startCRTAnim(CRTANIM_CLOSE);
    reset=2;
}

extern bool DeepSleepFlag;
void cmd2(void)
{
    DeepSleepFlag = 1;
    OLED_OFF();
    menuData.isOpen = false;  //�رղ˵�
    PWR_EnterSTOPMode(PWR_Regulator_LowPower, PWR_STOPEntry_WFI); //����ͣ��ģʽ
}

void cmd3(void)
{
    animation_start(display_load, ANIM_MOVE_OFF);
    menuData.isOpen = false;  //�رղ˵�
}
extern u8 log_time;

static void LogTimeUpdate()
{
//	battery_updateNow();
    log_time += 2;

    if(log_time > 15)
        log_time = 0;
}

extern int MODE;


//static char CMD4_NAME[] = "Entertainment";
char CMD4_NAME[15] = "Entertainment";

static void  Change_mode()
{
    if(MODE < 3)
    {
        MODE++;
    }
    else
    {
        MODE = 1;
    }
	if(MODE == 1)
    {
        strcpy( CMD4_NAME, "Entertainment");
    }
    else if(MODE == 2)
    {
		 strcpy( CMD4_NAME, "Study");
    }
    else if(MODE == 3)
    {
		 strcpy( CMD4_NAME, "Sport");
    }
		
}


static void itemLoader(byte num)
{
    char buff[20];
    char buff2[30];
    num = 0;


	
    setMenuOption_P(num++, PSTR(CMD1_NAME), NULL, ShutDown); // init MPU

    setMenuOption_P(num++, PSTR(CMD2_NAME), NULL, cmd2);// Deep Sleep

    setMenuOption_P(num++, PSTR(CMD3_NAME), NULL, mpu_open); //MPU display

//    setMenuOption_P(num++, PSTR(CMD4_NAME), NULL, history_display);
    sprintf_P((char *)buff2, PSTR("Mode:%s"),CMD4_NAME);
    setMenuOption_P(num++, buff2, NULL, Change_mode);
	
    sprintf_P((char *)buff, PSTR("Log Time  %d min"), log_time);
    setMenuOption_P(num++, buff, NULL, LogTimeUpdate);

    setMenuOption_P(num++, PSTR(CMD5_NAME), NULL, cmd3); //exit
}

extern int MODE;

bool my_menu_open(void)
{
    menuData.isOpen = true;  //�򿪲˵�

    display_setDrawFunc(menu_draw);  //�󶨻��ƺ���Ϊmenu_draw

    buttons_setFuncs( menu_up, menu_select,menu_down);  //�󶨰������ܺ���
	if(MODE==3)buttons_setFuncs(menu_select, menu_select, menu_down);

    setMenuInfo(OPTION_COUNT, MENU_TYPE_STR, PSTR(STR_WIFICMDMENU));   //��ȡ��ǰ�˵���Ϣ��ѡ��������˵����������ֻ���ͼ�꣩
    setMenuFuncs(MENUFUNC_NEXT, mSelect, MENUFUNC_PREV, itemLoader);  //�󶨲˵��ĺ���,��ǰ������ѡ��ȷ��
    beginAnimation2(NULL);
    return true;
}



