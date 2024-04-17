//3.6 mode �²�ͬ���
#include "common.h"
#include "mpu6050.h"
#include "menu.h"
#include "string.h"
#include "stdio.h"
#define OPTION_COUNT getItemCount()



#define UPT_MOVE_NONE	0
#define UPT_MOVE_UP		1
#define UPT_MOVE_DOWN	2
#define UPT_MOVE_RIGHT	1     //�����ƶ�
#define UPT_MOVE_LEFT	2     //�����ƶ�

static bool btnDown(void);
static bool btnUp(void);
static byte uptMove;


extern bool keep_on;
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


//static bool btnExit()
//{
//
//	animation_start(display_load, ANIM_MOVE_OFF);keep_on=0;
//	return true;
//}

static prev_menu_s prevMenuData;

static void mOpen(void);
static void mSelect(void);
static void itemLoader(byte);

extern int MODE;
static uint8_t getItemCount()
{
    uint8_t cnt = 2;

    if (MODE == 1)
    {

        #if COMPILE_GAME1 || COMPILE_GAME2 || COMPILE_GAME3
        ++cnt;
        #endif
        #if COMPILE_STOPWATCH
        ++cnt;
        #endif
        #if COMPILE_TORCH
        ++cnt;
        #endif
        #if COMPILE_BTRCCAR
        ++cnt;
        #endif
        #if COMPILE_TUNEMAKER
        ++cnt;
        #endif
    }
    else if (MODE == 3)
    {

        cnt = 5;
    }
    else if( MODE == 2)
    {
////        #if COMPILE_GAME1 || COMPILE_GAME2 || COMPILE_GAME3
////        ++cnt;
////        #endif
//        #if COMPILE_STOPWATCH
//        ++cnt;
//        #endif
//        #if COMPILE_TORCH
//        ++cnt;
//        #endif
//        #if COMPILE_BTRCCAR
//        ++cnt;
//        #endif
////        #if COMPILE_TUNEMAKER
////        ++cnt;
////        #endif
        cnt = 3;
    }

    return cnt;
}
extern bool keep_on;

void mMainOpen()
{
    srand(millis());
    keep_on = 1;
    uptMove = UPT_MOVE_NONE;
    buttons_setFuncs(NULL, menu_select, NULL);
    beginAnimation(mOpen);  //�رն�����ʼ����ִ�д����˵�

}

//�����˵�
extern int MODE;
static void mOpen()
{
    display_setDrawFunc(menu_draw);  //�󶨻��ƺ���Ϊmenu_draw


    buttons_setFuncs(menu_up, menu_select, menu_down);  //�󶨰������ܺ���
	//if(MODE==3)buttons_setFuncs(menu_select, menu_select, menu_down);

    setMenuInfo(OPTION_COUNT, MENU_TYPE_ICON, PSTR(STR_MAINMENU));   //��ȡ��ǰ�˵���Ϣ��ѡ��������˵����������ֻ���ͼ�꣩
    setMenuFuncs(MENUFUNC_NEXT, mSelect, MENUFUNC_PREV, itemLoader);  //�󶨲˵��ĺ���,��ǰ������ѡ��ȷ��

    setPrevMenuOpen(&prevMenuData, mOpen);  //�����ϼ��˵�

    beginAnimation2(NULL);      //�������ȶ���

}

static void mSelect()
{
    setPrevMenuExit(&prevMenuData);  //������һ�β˵���ѡ��
    doAction(true);
}

static void itemLoader(byte num)
{
    if ( MODE == 1)
    {
        //7
        num = 0;
        setMenuOption_P(num++, PSTR(STR_ALARMS), menu_alarm, mAlarmsOpen);
        #if COMPILE_TORCH
        setMenuOption_P(num++, PSTR(STR_FLASHLIGHT), menu_torch, torch_open);
        #endif
        #if COMPILE_STOPWATCH
        setMenuOption_P(num++, PSTR(STR_STOPWATCH), menu_stopwatch, stopwatch_open);
        #endif
        #if COMPILE_BTRCCAR
        setMenuOption_P(num++, PSTR(STR_BTRCCAR), menu_stopwatch, btrccar_open);
        #endif
        #if COMPILE_TUNEMAKER
        setMenuOption_P(num++, PSTR(STR_TUNEMAKER), menu_tunemaker, tunemakerOpen);
        #endif
        #if COMPILE_GAME1 || COMPILE_GAME2 || COMPILE_GAME3
        setMenuOption_P(num++, PSTR(STR_GAMES), menu_games, mGamesOpen);
        #endif
        //setMenuOption_P(num++, PSTR(STR_CALCULATORS), menu_calc, calcOpen);
        setMenuOption_P(num++, PSTR(STR_SETTINGS), menu_settings, mSettingsOpen);
        setMenuOption_P(OPTION_COUNT, PSTR(STR_EXIT), menu_exit, menu_close);
    }
    else if ( MODE == 2)
    {
        //4
        num = 0;
        setMenuOption_P(num++, PSTR(STR_ALARMS), menu_alarm, mAlarmsOpen);
//        #if COMPILE_TORCH
//        setMenuOption_P(num++, PSTR(STR_FLASHLIGHT), menu_torch, torch_open);
//        #endif
        #if COMPILE_STOPWATCH
        setMenuOption_P(num++, PSTR(STR_STOPWATCH), menu_stopwatch, stopwatch_open);
        #endif
        #if COMPILE_BTRCCAR
        setMenuOption_P(num++, PSTR(STR_BTRCCAR), menu_stopwatch, btrccar_open);
        #endif
//        #if COMPILE_TUNEMAKER
//        setMenuOption_P(num++, PSTR(STR_TUNEMAKER), menu_tunemaker, tunemakerOpen);
//        #endif
//        #if COMPILE_GAME1 || COMPILE_GAME2 || COMPILE_GAME3
//        setMenuOption_P(num++, PSTR(STR_GAMES), menu_games, mGamesOpen);
//        #endif
        //setMenuOption_P(num++, PSTR(STR_CALCULATORS), menu_calc, calcOpen);
        setMenuOption_P(num++, PSTR(STR_SETTINGS), menu_settings, mSettingsOpen);
        setMenuOption_P(OPTION_COUNT, PSTR(STR_EXIT), menu_exit, menu_close);
    }
    else  if ( MODE == 3)
    {
        //6
        num = 0;
        setMenuOption_P(num++, PSTR(STR_ALARMS), menu_alarm, mAlarmsOpen);
        #if COMPILE_TORCH
        setMenuOption_P(num++, PSTR(STR_FLASHLIGHT), menu_torch, torch_open);
        #endif
        #if COMPILE_STOPWATCH
        setMenuOption_P(num++, PSTR(STR_STOPWATCH), menu_stopwatch, stopwatch_open);
        #endif
        #if COMPILE_BTRCCAR
        setMenuOption_P(num++, PSTR(STR_BTRCCAR), menu_stopwatch, btrccar_open);
        #endif
        #if COMPILE_TUNEMAKER
        setMenuOption_P(num++, PSTR(STR_TUNEMAKER), menu_tunemaker, tunemakerOpen);
        #endif
//        #if COMPILE_GAME1 || COMPILE_GAME2 || COMPILE_GAME3
//        setMenuOption_P(num++, PSTR(STR_GAMES), menu_games, mGamesOpen);
//        #endif
        //setMenuOption_P(num++, PSTR(STR_CALCULATORS), menu_calc, calcOpen);
        setMenuOption_P(num++, PSTR(STR_SETTINGS), menu_settings, mSettingsOpen);
        setMenuOption_P(OPTION_COUNT, PSTR(STR_EXIT), menu_exit, menu_close);
    }
}
