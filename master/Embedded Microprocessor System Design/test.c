// DE1SoC_SevenSeg.c

#include "DE1SoC_SevenSeg.h"

// Base addresses of the seven segment display peripherals.
volatile unsigned char *sevenseg_base_lo_ptr = (unsigned char *)0xFF200020;
volatile unsigned char *sevenseg_base_hi_ptr = (unsigned char *)0xFF200030;

#define SEVENSEG_N_DISPLAYS_LO 4
#define SEVENSEG_N_DISPLAYS_HI 2

void DE1SoC_SevenSeg_Write(unsigned int display, unsigned char value) {
    if (display < SEVENSEG_N_DISPLAYS_LO) {
        sevenseg_base_lo_ptr[display] = value;
    } else {
        display = display - SEVENSEG_N_DISPLAYS_LO;
        sevenseg_base_hi_ptr[display] = value;
    }
}

void DE1SoC_SevenSeg_SetSingle(unsigned int display, unsigned int value) {
    if (value <= 0xF) {
        // Map values to their corresponding bit-mapping for seven-segment display.
        static const unsigned char segment_mapping[] = {
            0b00111111, // 0
            0b00000110, // 1
            0b01011011, // 2
            0b01001111, // 3
            0b01100110, // 4
            0b01101101, // 5
            0b01111101, // 6
            0b00000111, // 7
            0b01111111, // 8
            0b01101111, // 9
            0b01110111, // A
            0b01111100, // B
            0b00111001, // C
            0b01011110, // D
            0b01111001, // E
            0b01110001  // F
        };

        DE1SoC_SevenSeg_Write(display, segment_mapping[value]);
    } else {
        // Out of range, display a dash on the segment 6.
        DE1SoC_SevenSeg_Write(display, 0b10000000);
    }
}

void DE1SoC_SevenSeg_SetDoubleHex(unsigned int display, unsigned int value) {
    // Display the lower and higher nibbles on the specified displays.
    DE1SoC_SevenSeg_SetSingle(display, value & 0xF);
    DE1SoC_SevenSeg_SetSingle(display + 1, (value >> 4) & 0xF);
}

void DE1SoC_SevenSeg_SetDoubleDec(unsigned int display, unsigned int value) {
    // Display the tens and units on the specified displays.
    DE1SoC_SevenSeg_SetSingle(display, value / 10);
    DE1SoC_SevenSeg_SetSingle(display + 1, value % 10);
}
