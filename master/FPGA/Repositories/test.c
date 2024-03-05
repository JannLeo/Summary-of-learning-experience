/*
 * DE1SoC_SevenSeg.c
 *
 *  Created on: 12 Feb 2021
 *      Author: Harry Clegg
 *  Updated on: 24 Feb 2024
 *      Author: David Cowell
 *      		You!
 */

#include "DE1SoC_SevenSeg.h"

// ToDo: Add the base addresses of the seven segment display peripherals.
// 7-segment HEX[3], HEX[2], HEX[1] & HEX[0] Displays.
volatile unsigned char *sevenseg_base_lo_ptr = (unsigned char *)0xFF200020;
// 7-segment HEX[5] & HEX[4] Displays.
volatile unsigned char *sevenseg_base_hi_ptr = (unsigned char *)0xFF200030;

// There are four HEX displays attached to the low (first) address.
#define SEVENSEG_N_DISPLAYS_LO 4

// There are two HEX displays attached to the high (second) address.
#define SEVENSEG_N_DISPLAYS_HI 2

void DE1SoC_SevenSeg_Write(unsigned int display, unsigned char value) {
    // Select between the two addresses so that the higher level functions
    // have a seamless interface.
    if (display < SEVENSEG_N_DISPLAYS_LO) {
        // If we are targeting a low address, use byte addressing to access
        // directly.
        sevenseg_base_lo_ptr[display] = value;
    } else {
        // If we are targeting a high address, shift down so byte addressing
        // works.
        display = display - SEVENSEG_N_DISPLAYS_LO;
        sevenseg_base_hi_ptr[display] = value;
    }
}

void DE1SoC_SevenSeg_SetSingle(unsigned int display, unsigned int value) {
    // ToDo: Write the code for driving a single seven segment display here.
    // Your function should turn a real value 0-F into the correctly encoded
    // bits to enable the correct segments on the seven segment display to
    // illuminate. Use the DE1SoC_SevenSeg_Write function you created earlier
    // to set the bits of the display.

	// Address assignment for different values of value
	if(value <= 15){
		static const unsigned char display_mapping[] = {
			0x3F, // 0
			0x06, // 1
			0x5B, // 2
			0x4F, // 3
			0x66, // 4
			0x6D, // 5
			0x7D, // 6
			0x07, // 7
			0x7F, // 8
			0x6F, // 9
			0x77, // A
			0x7C, // B
			0x39, // C
			0x5E, // D
			0x79, // E
			0x71  // F
		};
		DE1SoC_SevenSeg_Write(display,display_mapping[value]);
	}
	else{
		DE1SoC_SevenSeg_Write(display,0x80);
	}


}

void DE1SoC_SevenSeg_SetDoubleHex(unsigned int display, unsigned int value) {
    // ToDo: Write the code for setting a pair of seven segment displays
    // here. Good coding practice suggests your solution should call
    // DE1SoC_SevenSeg_SetSingle() twice.
    // This function should show the first digit of a HEXADECIMAL number on
    // the specified 'display', and the second digit on the display to
    // the left of the specified display.

    /** Some examples:
     *
     *    input | output | HEX(N+1) | HEX(N)
     *    ----- | ------ | -------- | ------
     *        5 |     05 |        0 |      5
     *       30 |     1E |        1 |      E
     *     0x60 |     60 |        6 |      0
     */
	if(value > 0xff){
		DE1SoC_SevenSeg_SetSingle(display,16);
		DE1SoC_SevenSeg_SetSingle(display+1,16);
	}
	else{
		DE1SoC_SevenSeg_SetSingle(display,value & 0xf);
		DE1SoC_SevenSeg_SetSingle(display+1,(value & 0xf0)>>4);
	}
}

void DE1SoC_SevenSeg_SetDoubleDec(unsigned int display, unsigned int value) {
    // ToDo: Write the code for setting a pair of seven segment displays
    // here. Good coding practice suggests your solution should call
    // DE1SoC_SevenSeg_SetSingle() twice.
    // This function should show the first digit of a DECIMAL number on
    // the specified 'display', and the second digit on the display to
    // the left of the specified display.

    /** Some examples:
     *
     *	  input | output | HEX(N+1) | HEX(N)
     *    ----- | ------ | -------- | ------
     *        5 |     05 |        0 |      5
     *       30 |     30 |        3 |      0
     *     0x60 |     96 |        9 |      6
     */
	if(value > 0x63 ){
		DE1SoC_SevenSeg_SetSingle(display,16);
		DE1SoC_SevenSeg_SetSingle(display+1,16);
	}
	else{
		DE1SoC_SevenSeg_SetSingle(display,value % 10);
		DE1SoC_SevenSeg_SetSingle(display+1,(value / 10) % 10);
	}
}
