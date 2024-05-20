/* LCD.h
 *
 * Created on: 12 05 2024
 * Author: Zhu Zhu
 */

#ifndef LCD_H_
#define LCD_H_

#include "DE1SoC_LT24/DE1SoC_LT24.h"
#include "BasicFont/BasicFont.h"
#include "HPS_usleep/HPS_usleep.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include "Util/macros.h"
#include "DE1SoC_Addresses/DE1SoC_Addresses.h"
#include "HPS_Watchdog/HPS_Watchdog.h"
#include <stdint.h>
#include <stdbool.h>
#include "bitmap.h"

/**
 * Enumeration for different fill types.
 */
typedef enum {
    FILL_TRANSPARENT, ///< Transparent with outline
    FILL_BLACK,       ///< Filled black
    FILL_WHITE,       ///< Filled white (no outline)
} FillType;

/**
 * Draw the background to the frame buffer.
 * @param background Pointer to the background bitmap.
 */
void Drawbackground(const unsigned short* background);

/**
 * Copy the frame buffer to the display.
 */
void Drawscreen();

/**
 * Initialize the LCD display.
 */
void LCDinitial(void);

/**
 * Test the screen by drawing various shapes and strings.
 */
void Testscreen(void);

/**
 * Clear the LCD display with a specified color.
 * @param colour The color to clear the screen with.
 */
void LCDclear(unsigned short colour);

/**
 * Map an object to the frame buffer and update the display.
 * @param object Pointer to the object bitmap.
 * @param xStart X-coordinate where the object starts.
 * @param yStart Y-coordinate where the object starts.
 * @param width Width of the object.
 * @param height Height of the object.
 */
void FrameBuffer_map(const unsigned short* object, unsigned int xStart, unsigned int yStart, unsigned int width, unsigned height);

/**
 * Map a car object to the frame buffer and update the display.
 * @param object Pointer to the car object bitmap.
 * @param xStart X-coordinate where the car starts.
 * @param yStart Y-coordinate where the car starts.
 * @param width Width of the car.
 * @param height Height of the car.
 * @param num Car identifier.
 */
void FrameBuffer_mapcar(const unsigned short* object, unsigned int xStart, unsigned int yStart, unsigned int width, unsigned height, int num);

/**
 * Map the player's car to the frame buffer and update the display.
 * @param object Pointer to the player's car bitmap.
 * @param xStart X-coordinate where the car starts.
 * @param yStart Y-coordinate where the car starts.
 * @param width Width of the car.
 * @param height Height of the car.
 */
void FrameBuffer_mapmycar(const unsigned short* object, unsigned int xStart, unsigned int yStart, unsigned int width, unsigned height);

/**
 * Draw a string on the LCD display.
 * @param x X-coordinate where the string starts.
 * @param y Y-coordinate where the string starts.
 * @param string The string to be drawn.
 * @param colour The color of the string.
 */
void DrawString(int x, int y, char *string, unsigned short colour);

/**
 * Restore a section of the background to the frame buffer.
 * @param width Width of the section.
 * @param height Height of the section.
 * @param startX X-coordinate where the section starts.
 * @param startY Y-coordinate where the section starts.
 * @param object Pointer to the background object bitmap.
 */
void reback(int width, int height, int startX, int startY, const unsigned short* object);

/**
 * Restore a section of the background to the frame buffer.
 * @param height Height of the section.
 * @param startY Y-coordinate where the section starts.
 */
void heartback(int height, int startY);

/**
 * Draw a line on the LCD display.
 * @param y0 Y-coordinate of the starting point.
 * @param x0 X-coordinate of the starting point.
 * @param y1 Y-coordinate of the ending point.
 * @param x1 X-coordinate of the ending point.
 * @param type Type of the line (1 for solid line, 2 for dashed line).
 * @param colour The color of the line.
 */
void DrawLine(int y0, int x0, int y1, int x1, unsigned int const type, unsigned short colour);

/**
 * Draw a rectangle on the LCD display.
 * @param y0 Y-coordinate of the top-left corner.
 * @param x0 X-coordinate of the top-left corner.
 * @param height Height of the rectangle.
 * @param width Width of the rectangle.
 * @param fill Fill type (FILL_TRANSPARENT, FILL_BLACK, FILL_WHITE).
 * @param colour The color of the rectangle.
 */
void DrawRectangle(int y0, int x0, int height, int width, FillType const fill, unsigned short colour);

/**
 * Draw a circle on the LCD display.
 * @param y0 Y-coordinate of the center.
 * @param x0 X-coordinate of the center.
 * @param radius Radius of the circle.
 * @param fill Fill type (FILL_TRANSPARENT, FILL_BLACK, FILL_WHITE).
 * @param colour The color of the circle.
 */
void DrawCircle(int y0, int x0, int radius, FillType const fill, unsigned short colour);

/**
 * Exit the program if the status is not equal to the success status.
 * @param status The current status.
 * @param successStatus The success status to compare against.
 */
void exitOnFail(signed int status, signed int successStatus);

#endif /* LCD_H_ */
