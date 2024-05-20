/*
 * main.c
 *
 * This program is a simple piece of code to test interrupts.
 */

#include "DE1SoC_Addresses/DE1SoC_Addresses.h"
#include "DE1SoC_IRQ/DE1SoC_IRQ.h"
#include "HPS_GPIO/HPS_GPIO.h"
#include "FPGA_PIO/FPGA_PIO.h"
#include "HPS_Watchdog/HPS_Watchdog.h"

#include "Interrupts.h"

// 当HPS定时器中断发生时调用的ISR，用于切换LED的状态并清除定时器中断标志。
//HPS Timer Interrupt Toggles LED
__irq void timerISR(HPSIRQSource interruptID, void* param, bool* handled) {
    //Return failure if context is NULL pointer.
    if (param == NULL) return;
    //Cast param to expected type
    AppDrivers_t* pDrivers = (AppDrivers_t*)param;
    //Toggle the LED
    HPS_GPIO_toggleOutput(pDrivers->hpsIo,ARM_GPIO_HPS_LED);
    //Clear the Timer Interrupt Flag
    //By reading timer end of interrupt register
    (pDrivers->hpsTimer[3]);
    //IRQ Handled
    *handled = true;
    //Reset watchdog.
    HPS_ResetWatchdog();
}

//当按键中断发生时调用的ISR，用于读取按键的状态并更新按键的按下情况。
//Key Released Interrupt Displays Last Button Released
__irq void pushbuttonISR(HPSIRQSource interruptID, void* param, bool* handled) {
    //Return failure if context is NULL pointer.
    if (param == NULL) return;
    //Cast param to expected type
    AppDrivers_t* pDrivers = (AppDrivers_t*)param;
    //Read the Push-button interrupt register, and clear the flags
    unsigned int press;
    FPGA_PIO_getInterruptFlags(pDrivers->keys, &press, 0xF, true);
    //Update list of key presses received
    // - this is an example of how you can return values from an interrupt
    //   routine.
    pDrivers->keyPressed |= press;
    //IRQ Handled
    *handled = true;
    //Reset watchdog.
    HPS_ResetWatchdog();
}

// AppDrivers_t ISR_initialize(){
//     AppDrivers_t drivers;
//     drivers.hpsTimer = (unsigned int*)LSC_BASE_HPS_TIMERSP0;

//     // Initialise drivers
//     // HPS_GPIO_initialise(LSC_BASE_ARM_GPIO, ARM_GPIO_DIR, 0, 0, &drivers.hpsIo);
//     FPGA_PIO_initialise(LSC_BASE_KEYS, LSC_CONFIG_KEYS, &drivers.keys);
//     // FPGA_PIO_initialise(LSC_BASE_7SEG_0to3, LSC_CONFIG_7SEG, &drivers.hex0to3);
    
//     //Set HPS LED low
//     // HPS_GPIO_setOutput(drivers.hpsIo, 0, ARM_GPIO_HPS_LED);

//     //Initialise IRQs
//     HPS_IRQ_initialise(false,NULL);
//     HPS_ResetWatchdog();

//     // Register interrupt handler for timer. We provide a pointer to our drivers
//     // structure as a parameter so that we can make use of it in the interrupt handler
//     HPS_IRQ_registerHandler(IRQ_TIMER_L4SP_0, timerISR, &drivers);
//     // Configure HPS Timer to interrupt every second
//     // Timer base address
//     drivers.hpsTimer[2] = 0; // write to control register to stop timer
//     // Set the timer period
//     drivers.hpsTimer[0] = 500000000; // period = 1/(100 MHz) x (100 x 10^6) = 1 sec
//     // Write to control register to start timer, with interrupts
//     drivers.hpsTimer[2] = 0x03; // mode = 1, enable = 1
//     HPS_ResetWatchdog();

//     // Register interrupt handler for keys
//     HPS_IRQ_registerHandler(IRQ_LSC_KEYS, pushbuttonISR, &drivers);
//     // Configure Push Buttons to interrupt on press
//     FPGA_PIO_setInterruptEnable(drivers.keys, 0xF, 0xF); // Enable interrupts for all four KEYs
//     HPS_ResetWatchdog();

//     //Finally we enable the interrupts
//     HPS_IRQ_globalEnable(true);
//     return drivers;

// }

// unsigned int whetherpressedISR(AppDrivers_t drivers){
//     HpsErr_t wasDisabled = HPS_IRQ_globalEnable(false);
//     unsigned int keyPressed = drivers.keyPressed;
//     drivers.keyPressed = 0;
//     HPS_IRQ_globalEnable(wasDisabled != ERR_SKIPPED);
//     HPS_ResetWatchdog();
//     return keyPressed;
// }

// //主要是初始化驱动程序和中断，并在主循环中处理中断事件。在代码中有详细的注释说明每一步的作用。
// int main(void) {
//     // Keep track of all our device drivers in a friendly structure
//     static AppDrivers_t drivers = {0};
//     drivers.hpsTimer = (unsigned int*)LSC_BASE_HPS_TIMERSP0;

//     // Initialise drivers
//     HPS_GPIO_initialise(LSC_BASE_ARM_GPIO, ARM_GPIO_DIR, 0, 0, &drivers.hpsIo);
//     FPGA_PIO_initialise(LSC_BASE_KEYS, LSC_CONFIG_KEYS, &drivers.keys);
//     FPGA_PIO_initialise(LSC_BASE_7SEG_0to3, LSC_CONFIG_7SEG, &drivers.hex0to3);
    
//     //Set HPS LED low
//     HPS_GPIO_setOutput(drivers.hpsIo, 0, ARM_GPIO_HPS_LED);

//     //Initialise IRQs
//     HPS_IRQ_initialise(false,NULL);
//     HPS_ResetWatchdog();

//     // Register interrupt handler for timer. We provide a pointer to our drivers
//     // structure as a parameter so that we can make use of it in the interrupt handler
//     HPS_IRQ_registerHandler(IRQ_TIMER_L4SP_0, timerISR, &drivers);
//     // Configure HPS Timer to interrupt every second
//     // Timer base address
//     drivers.hpsTimer[2] = 0; // write to control register to stop timer
//     // Set the timer period
//     drivers.hpsTimer[0] = 100000000; // period = 1/(100 MHz) x (100 x 10^6) = 1 sec
//     // Write to control register to start timer, with interrupts
//     drivers.hpsTimer[2] = 0x03; // mode = 1, enable = 1
//     HPS_ResetWatchdog();

//     // Register interrupt handler for keys
//     HPS_IRQ_registerHandler(IRQ_LSC_KEYS, pushbuttonISR, &drivers);
//     // Configure Push Buttons to interrupt on press
//     FPGA_PIO_setInterruptEnable(drivers.keys, 0xF, 0xF); // Enable interrupts for all four KEYs
//     HPS_ResetWatchdog();

//     //Finally we enable the interrupts
//     HPS_IRQ_globalEnable(true);

//     //Do nothing in the run loop but reset the watchdog.
//     //Notice how the light blinks anyway.
//     while(1) {
//         //With interrupts enabled, we can also save power by
//         //putting the processor to sleep, until an interrupt
//         //occurs. 
//         //You don't have to do this if you have other things
//         //to do in the main run loop.
//         __asm("WFI");
//         //Reset watchdog.
//         HPS_ResetWatchdog();
//         //Check if any keys were pressed. We temporarily disable
//         //interrupts while we are reading the shared data value
//         HpsErr_t wasDisabled = HPS_IRQ_globalEnable(false);
//         unsigned int keyPressed = drivers.keyPressed; // Read bit map of pressed keys
//         drivers.keyPressed = 0;                       // Clear list for next time.
//         HPS_IRQ_globalEnable(wasDisabled != ERR_SKIPPED);
//         //Now do something to handle the key presses
//         if (keyPressed) {
//             unsigned int hexVal;
//             unsigned char* hexValPtr = (unsigned char*)&hexVal;
//             //Prepare to display 1 or 0 on 7-seg corresponding to whichever keys are pressed.
//             for (unsigned int i = 0; i < 4; i++) {
//                 hexValPtr[i] = (keyPressed & (1 << i)) ? 0x06 : 0x3F;
//             }
//             // Display on 7-seg LEDs
//             FPGA_PIO_setOutput(drivers.hex0to3, hexVal, UINT32_MAX);
//         }
//     }
// }


