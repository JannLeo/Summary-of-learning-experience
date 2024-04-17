//#include "common.h"
//#include "delay.h"
//#include "oled_driver.h"
//#include "NVIC.h"
//#include "bme280.h"
//#include "mpu_task.h"
//#include "altitude_display.h"

//#define STR_WIFICMDMENU  "< Mode Menu >"

//#define OPTION_COUNT2 3

//#define MODE1_NAME "Entertainment"
//#define MODE2_NAME "Study"
//#define MODE3_NAME "Sport"
//#define CMD5_NAME "Back"
// int MODE = 1;

//static void mSelect()
//{
//	doAction(false);  //执行指令
//	//menuData.isOpen = false;  //关闭菜单
//}


//void changemode1(void)
//{
//	MODE=1;
//}

//void changemode2(void)
//{
//	MODE=2;
//}

//void changemode3(void)
//{
//	MODE=3;
//}

//void modeback(void)
//{
//	animation_start(display_load, ANIM_MOVE_OFF);
//	menuData.isOpen = false;  //关闭菜单
//}

//static void modeLoader(byte numode)
//{
//	
//	numode = 0;
//	setMenuOption_P(numode++, PSTR(MODE1_NAME), NULL, changemode1);

//	setMenuOption_P(numode++, PSTR(MODE1_NAME), NULL, changemode2);
//	
//	setMenuOption_P(numode++, PSTR(MODE1_NAME), NULL, changemode3);
//	
//	setMenuOption_P(numode++, PSTR(CMD5_NAME), NULL, modeback);
//}

//void Change_mode(void)
//{
//	menuData.isOpen = true;  //打开菜单
//	
//	display_setDrawFunc(menu_draw);  //绑定绘制函数为menu_draw

//	buttons_setFuncs(menu_up,menu_select, menu_down);  //绑定按键功能函数

//	setMenuInfo(OPTION_COUNT2, MENU_TYPE_STR, PSTR(STR_WIFICMDMENU));   //获取当前菜单信息（选项个数，菜单类型是文字还是图标）
//	setMenuFuncs(MENUFUNC_NEXT, mSelect, MENUFUNC_PREV, modeLoader);  //绑定菜单的函数,如前进后退选择确认
//	beginAnimation2(NULL);   
//	
//}






