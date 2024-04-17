/*
 * Project: N|Watch
 * Author: Zak Kemble, contact@zakkemble.co.uk
 * Copyright: (C) 2013 by Zak Kemble
 * License: GNU GPL v3 (see License.txt)
 * Web: http://blog.zakkemble.co.uk/diy-digital-wristwatch/
 */

#include "common.h"

float BatteryVol;
void drawBattery()
{              //battery_voltage();
	int bat; char ad[5];
	const byte* battIcon;
	if(BatteryVol < 3.2)
		battIcon = battIconEmpty;
	else if(BatteryVol < 3.7)
		battIcon = battIconLow;
	else if(BatteryVol < 4)
		battIcon = battIconHigh;
	else
		battIcon = battIconFull;

	draw_bitmap(0, FRAME_HEIGHT - 8, battIcon, 16, 8, NOINVERT, 0);
	if((4.2-BatteryVol)<1)//经测量断电时电压为3.3V左右，电压区间位3.3v-4.21v
	 bat=(BatteryVol-3.2)*99;
	else
	 bat=99;
	sprintf((char *)ad,"%d", bat);//
	draw_string(ad,NOINVERT,18,FRAME_HEIGHT-8);
}

