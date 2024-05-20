/*
 * main.h
 *
 *  Created on:13/05/2024
 *      Author: zhu zhu
 */

#ifndef MAIN_H_
#define MAIN_H_






#include "DE1SoC_Addresses/DE1SoC_Addresses.h"
#include "DE1SoC_LT24/DE1SoC_LT24.h"
#include "HPS_Watchdog/HPS_Watchdog.h"
#include "HPS_usleep/HPS_usleep.h"
#include "Util/macros.h"
#include "LCD.h"
#include "bitmap.h"
#include "game2.h"
#include "Interrupts.h"
#include <stdio.h>

#include "DE1SoC_IRQ/DE1SoC_IRQ.h"
#include "HPS_GPIO/HPS_GPIO.h"
#include "FPGA_PIO/FPGA_PIO.h"

//Debugging Function
#include <stdlib.h>

//variety
#define menu 		0
#define intro 		1
#define game1		2
#define game2		3

char world[]="hello world";
int state;


volatile unsigned int *key_ptr = (unsigned int *)0xFF200050;


#endif /* MAIN_H_ */
