/* Interrupts.h
 *
 * Created on: 28 March 2022
 *
 * Author: Benjamin Evans
 *
 * Description: Interrupts header file containing interrupt configuration and ISR declarations along with the state machine for the stopwatch
 * Reference: Interrupt Code from ELEC5620M - Unit 2.A Lab Task 1 - 2-A-Interrupts/main.c
 */

#ifndef INTERRUPTS_INTERRUPTS_H_
#define INTERRUPTS_INTERRUPTS_H_

#include "HPS_IRQ/HPS_IRQ.h"
#include "HPS_Watchdog/HPS_Watchdog.h"
#include "FPGA_PIO/FPGA_PIO.h"
#include "DE1SoC_Addresses/DE1SoC_Addresses.h"
#include "DE1SoC_IRQ/DE1SoC_IRQ.h"
#include "HPS_GPIO/HPS_GPIO.h"
#include "FPGA_PIO/FPGA_PIO.h"
#include "HPS_Watchdog/HPS_Watchdog.h"


typedef struct {
    // Driver contexts:
	PHPSGPIOCtx_t hpsIo;

    PFPGAPIOCtx_t hex0to3;
    PFPGAPIOCtx_t keys;

    // Peripherals without drivers:
    volatile unsigned int * hpsTimer;
    // Value returned from interrupt:
    volatile unsigned int keyPressed;
} AppDrivers_t;
static AppDrivers_t drivers = {0};
// Interrupts Declaration ------------------------------------------------------------
/**
 * ConfigureKeyInterrupt
 *
 * Configure Push Buttons to interrupt on press for all four keys
 * Reference: ELEC5620M - Unit 2.A Lab Task 1 - 2-A-Interrupts/main.c
 *
 */
// void ConfigureKeyInterrupt(void);
__irq void timerISR(HPSIRQSource interruptID, void* param, bool* handled);
/**
 * pushbuttonISR
 *
 * Key Released Interrupt Displays Last Button Released and control stop watch functions
 *
 * Inputs:
 * 		interruptID:		ID of interrupt deffined in HPS_IRQ_IDs.h
 * 		isInit: 			Set to false when interrupt handler is called by IQR
 *      initParams:         pointer will be 0 when called by IQR
 */
__irq void pushbuttonISR(HPSIRQSource interruptID, void* param, bool* handled);
AppDrivers_t ISR_initialize();
unsigned int whetherpressedISR(AppDrivers_t drivers);
#endif
