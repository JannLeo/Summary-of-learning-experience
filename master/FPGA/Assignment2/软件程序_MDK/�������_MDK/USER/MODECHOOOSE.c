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
//	doAction(false);  //ִ��ָ��
//	//menuData.isOpen = false;  //�رղ˵�
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
//	menuData.isOpen = false;  //�رղ˵�
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
//	menuData.isOpen = true;  //�򿪲˵�
//	
//	display_setDrawFunc(menu_draw);  //�󶨻��ƺ���Ϊmenu_draw

//	buttons_setFuncs(menu_up,menu_select, menu_down);  //�󶨰������ܺ���

//	setMenuInfo(OPTION_COUNT2, MENU_TYPE_STR, PSTR(STR_WIFICMDMENU));   //��ȡ��ǰ�˵���Ϣ��ѡ��������˵����������ֻ���ͼ�꣩
//	setMenuFuncs(MENUFUNC_NEXT, mSelect, MENUFUNC_PREV, modeLoader);  //�󶨲˵��ĺ���,��ǰ������ѡ��ȷ��
//	beginAnimation2(NULL);   
//	
//}






