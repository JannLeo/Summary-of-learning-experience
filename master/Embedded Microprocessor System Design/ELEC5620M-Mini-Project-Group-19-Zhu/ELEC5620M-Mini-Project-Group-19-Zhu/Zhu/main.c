#include"main.h"

int main(void) {
    //Variables
    PLT24Ctx_t lt24;
    printf("begin\n");


	// drivers = ISR_initialize();
	drivers.hpsTimer = (unsigned int*)LSC_BASE_HPS_TIMERSP0;

    // Initialise drivers
    // HPS_GPIO_initialise(LSC_BASE_ARM_GPIO, ARM_GPIO_DIR, 0, 0, &drivers.hpsIo);
    FPGA_PIO_initialise(LSC_BASE_KEYS, LSC_CONFIG_KEYS, &drivers.keys);
    // FPGA_PIO_initialise(LSC_BASE_7SEG_0to3, LSC_CONFIG_7SEG, &drivers.hex0to3);

    //Set HPS LED low
    // HPS_GPIO_setOutput(drivers.hpsIo, 0, ARM_GPIO_HPS_LED);

    //Initialise IRQs
    HPS_IRQ_initialise(false,NULL);
    HPS_ResetWatchdog();

    // Register interrupt handler for timer. We provide a pointer to our drivers
    // structure as a parameter so that we can make use of it in the interrupt handler
    HPS_IRQ_registerHandler(IRQ_TIMER_L4SP_0, timerISR, &drivers);
    // Configure HPS Timer to interrupt every second
    // Timer base address
    drivers.hpsTimer[2] = 0; // write to control register to stop timer
    // Set the timer period
    drivers.hpsTimer[0] = 500000000; // period = 1/(100 MHz) x (100 x 10^6) = 1 sec
    // Write to control register to start timer, with interrupts
    drivers.hpsTimer[2] = 0x03; // mode = 1, enable = 1
    HPS_ResetWatchdog();

    // Register interrupt handler for keys
    HPS_IRQ_registerHandler(IRQ_LSC_KEYS, pushbuttonISR, &drivers);
    // Configure Push Buttons to interrupt on press
    FPGA_PIO_setInterruptEnable(drivers.keys, 0xF, 0xF); // Enable interrupts for all four KEYs
    HPS_ResetWatchdog();

    //Finally we enable the interrupts
    HPS_IRQ_globalEnable(true);



    //initialize LCD
    LCDinitial();
    printf("othercar=%i,car=%i,heart=%i\n",othercar,car,heart);

    //Wait a moment
    Drawbackground(bg);
    //Main Run Loop
    while (1) {

    	HPS_ResetWatchdog();
    			HpsErr_t wasDisabled = HPS_IRQ_globalEnable(false);
    	    	unsigned int keyPressed = drivers.keyPressed;
    	    	drivers.keyPressed = 0;
    	    	HPS_IRQ_globalEnable(wasDisabled != ERR_SKIPPED);
    	    	HPS_ResetWatchdog();
    	//basical code
    	switch(state){
    		case menu:
    			Drawbackground(bg);
    			FrameBuffer_map(heart, 20, 20, 20, 20);
    			DrawString(70, 10, "Game Box", LT24_RED);
    			DrawString(70, 50, "Menu:", LT24_RED);
    			DrawString(50, 80, "1.Bounce Ball", LT24_RED);
    			DrawString(50, 110, "2.car", LT24_RED);
    			Drawscreen();
    			if (*key_ptr & 0x1)  state = intro;
    			if (*key_ptr & 0x2)  {
    				LCDclear(LT24_GREEN);

    				state = game1;
    			}
    			if (*key_ptr & 0x4)  {

    				game2_init();
    				state = game2;

    			}


    		break;
    		case intro:
    			LCDclear(LT24_WHITE);
    			FrameBuffer_map(heart, 20, 20, 20, 20);

    			if (*key_ptr & 0x2)  {
    				Drawbackground(bg2);
    				state = menu;

    			}
    			if (*key_ptr & 0x3)  state = game1;

    		break;
    		case game1:
    			Drawbackground(bg2);

    			if (*key_ptr & 0x1){
    				Drawbackground(bg);

    				state = menu;
    			}


    		break;
    		case game2:

    			game2_start();


    		break;
    	}





        //Finally reset the watchdog.
        HPS_ResetWatchdog();
    }
}