/* LCD.c
 *
 * Created on: 12 May 2024
 *
 */

#include "LCD.h"

// LT24 context structure
PLT24Ctx_t lt24;

// Frame buffers for display data
static unsigned short frameBuffer[76800];
int test = 0;
// Previous frame coordinates for objects
int prevX1 = 0;
int prevY1 = 0;
int prevX2 = 0;
int prevY2 = 0;
int prevX3 = 0;
int prevY3 = 0;

#define SCREEN_HEIGHT 320

// Exit the program if the status is not equal to the success status
void exitOnFail(signed int status, signed int successStatus){
    if (status != successStatus) {
        exit((int)status); // Add breakpoint here to catch failure
    }
}

// Map an object to the frame buffer and update the display
void FrameBuffer_mapcar(const unsigned short* obj, unsigned int startX, unsigned int startY, unsigned int width, unsigned height, int id){
    unsigned int endX, endY, x, y, fbIndex, objIndex;

    // Calculate the end coordinates of the object
    endX = startX + width - 1;
    endY = startY + height - 1;

    // Ensure the object fits within the screen boundaries
    if(endX > 239) endX = 239;
    if(endY > 319) endY = 319;

    // Restore previous frame if the position has changed
    if ((id == 0) && ((prevX1 != startX) || (prevY1 != startY))) {
        reback(60, 60, prevX1, prevY1, game2ground);
        prevX1 = startX;
        prevY1 = startY;
    } else if ((id == 1) && ((prevX3 != startX) || (prevY3 != startY))) {
        reback(60, 60, prevX3, prevY3, game2ground);
        prevX3 = startX;
        prevY3 = startY;
    }

    // Copy the object pixels into the frame buffer
    for(y = startY; y <= endY; y++) {
        for(x = startX; x <= endX; x++) {
            fbIndex = x + (y * 240);
            objIndex = (x - startX) + (y - startY) * width;
            if(obj[objIndex] != 0xFFFF) {
                frameBuffer[fbIndex] = obj[objIndex];
                exitOnFail(LT24_drawPixel(lt24, frameBuffer[fbIndex], x, y), ERR_SUCCESS);
            }
        }
    }
}

// Map the player's car to the frame buffer and update the display
void FrameBuffer_mapmycar(const unsigned short* obj, unsigned int startX, unsigned int startY, unsigned int width, unsigned height){
    unsigned int endX, endY, x, y, fbIndex, objIndex;

    // Calculate the end coordinates of the object
    endX = startX + width - 1;
    endY = startY + height - 1;

    // Ensure the object fits within the screen boundaries
    if(endX > 239) endX = 239;
    if(endY > 319) endY = 319;

    // Restore previous frame if the position has changed
    if ((prevX2 != startX) || (prevY2 != startY)) {
        reback(60, 60, prevX2, prevY2, game2ground);
        prevX2 = startX;
        prevY2 = startY;
    }

    // Copy the object pixels into the frame buffer
    for(y = startY; y <= endY; y++) {
        for(x = startX; x <= endX; x++) {
            fbIndex = x + (y * 240);
            objIndex = (x - startX) + (y - startY) * width;
            if(obj[objIndex] != 0xFFFF) {
                frameBuffer[fbIndex] = obj[objIndex];
                exitOnFail(LT24_drawPixel(lt24, frameBuffer[fbIndex], x, y), ERR_SUCCESS);
            }
        }
    }
}

// Map an object to the frame buffer and update the display
void FrameBuffer_map(const unsigned short* obj, unsigned int startX, unsigned int startY, unsigned int width, unsigned height){
    unsigned int endX, endY, x, y, fbIndex, objIndex;

    // Calculate the end coordinates of the object
    endX = startX + width - 1;
    endY = startY + height - 1;

    // Ensure the object fits within the screen boundaries
    if(endX > 239) endX = 239;
    if(endY > 319) endY = 319;

    // Copy the object pixels into the frame buffer
    for(y = startY; y <= endY; y++) {
        for(x = startX; x <= endX; x++) {
            fbIndex = x + (y * 240);
            objIndex = (x - startX) + (y - startY) * width;
            if(obj[objIndex] != 0xFFFF) {
                frameBuffer[fbIndex] = obj[objIndex];
                exitOnFail(LT24_drawPixel(lt24, frameBuffer[fbIndex], x, y), ERR_SUCCESS);
            }
        }
    }
}

// Restore a section of the background to the frame buffer
void heartback(int height, int startY){
    unsigned int fbIndex;

    int width = 30;
    int endX = 1 + width - 1;
    int endY = startY + height - 1;

    // Ensure the coordinates fit within the screen boundaries
    if(endX > 239) endX = 239;
    if(endY > 319) endY = 319;

    // Copy the background pixels into the frame buffer
    for(int y = startY; y <= endY; y++) {
        for(int x = 0; x <= endX; x++) {
            fbIndex = x + (y * 240);
            frameBuffer[fbIndex] = game2ground[fbIndex];
            exitOnFail(LT24_drawPixel(lt24, game2ground[fbIndex], x, y), ERR_SUCCESS);
        }
    }
}

// Restore a section of the background to the frame buffer
void reback(int width, int height, int startX, int startY, const unsigned short* obj){
    unsigned int endX, endY, fbIndex;

    endX = startX + width - 1;
    endY = startY + height - 1;

    // Ensure the coordinates fit within the screen boundaries
    if(endX > 239) endX = 239;
    if(endY > 319) endY = 319;

    // Copy the background pixels into the frame buffer
    for(int y = startY; y <= endY; y++) {
        for(int x = startX; x <= endX; x++) {
            fbIndex = x + (y * 240);
            frameBuffer[fbIndex] = obj[fbIndex];
            exitOnFail(LT24_drawPixel(lt24, frameBuffer[fbIndex], x, y), ERR_SUCCESS);
        }
    }
}

// Draw the background to the frame buffer
void Drawbackground(const unsigned short* bg) {
    unsigned int idx;

    // Copy the background pixels into the frame buffer
    for (idx = 0; idx < 76800; idx++) {
        frameBuffer[idx] = bg[idx];
    }
}

// Copy the frame buffer to the display
void Drawscreen() {
    exitOnFail(LT24_copyFrameBuffer(lt24, frameBuffer, 0, 0, 240, 320), ERR_SUCCESS);
}

// Initialize the LCD display
void LCDinitial() {
    unsigned int colorIdx = 0;
    unsigned short colors[6] = {LT24_RED, LT24_YELLOW, LT24_GREEN, LT24_CYAN, LT24_BLUE, LT24_MAGENTA};

    // Initialize the LCD Display
    exitOnFail(LT24_initialise(LSC_BASE_GPIO_JP1, NULL, &lt24), ERR_SUCCESS);
    printf("11\n");
    HPS_ResetWatchdog();

    // Display Internal Test Pattern
    // exitOnFail(LT24_testPattern(lt24), ERR_SUCCESS);
    HPS_ResetWatchdog();

    // Clear the LCD
    LCDclear(LT24_BLACK);
    printf("12\n");

    // Draw the background
    Drawbackground(bg);
    printf("test= %i\n", test);
}

// Clear the LCD display with a specified color
void LCDclear(unsigned short color) {
    LT24_clearDisplay(lt24, color);
    unsigned int color32 = (color << 16) | color;
    memset(frameBuffer, color32, 240 * 320 * sizeof(unsigned short));
}

// Draw a string on the LCD display
void DrawString(int x, int y, char *string, unsigned short color){
    int charIdx;
    int row, col;

    // Loop through each character in the string
    for(charIdx = 0; charIdx < strlen(string); charIdx++) {
        int charOffset = x + ((charIdx) * 12);

        // Print each character pixel by pixel
        for(row = 0; row < 5; row++) {
            for(col = 0; col < 7; col++) {
                if((BF_fontMap[string[charIdx] - ' '][row] >> (col)) & 1) {
                    int px = charOffset + (row * 2);
                    int py = y + (col * 2);

                    // Write to frame buffer instead of drawing directly
                    frameBuffer[px + py * 240] = color;
                    frameBuffer[(px + 1) + py * 240] = color;
                    frameBuffer[px + (py + 1) * 240] = color;
                    frameBuffer[(px + 1) + (py + 1) * 240] = color;
                    exitOnFail(LT24_drawPixel(lt24, color, charOffset + (row * 2), y + (col * 2)), ERR_SUCCESS);
                    exitOnFail(LT24_drawPixel(lt24, color, charOffset + (row * 2), y + (col * 2) + 1), ERR_SUCCESS);
                    exitOnFail(LT24_drawPixel(lt24, color, charOffset + (row * 2) + 1, y + (col * 2)), ERR_SUCCESS);
                    exitOnFail(LT24_drawPixel(lt24, color, charOffset + (row * 2) + 1, y + (col * 2) + 1), ERR_SUCCESS);
                }
            }
        }
    }
}

// Test the screen by drawing various shapes and strings
void Testscreen(void){
    char *alphabet[88] = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
                           "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1",
                           "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f",
                           "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                           "u", "v", "w", "x", "y", "z", "!", "#", "$", "%", "&", "(", ")", "*",
                           "+", ",", "-", "_", ".", "/", "?", "@", ">", "<", "=", ";", ":", "{",
                           "}", "[", "]", "~"};

    int i;

    // Test DrawLine
    LCDclear(LT24_MAGENTA);
    DrawLine(10, 100, 200, 200, 1, LT24_RED);
    DrawLine(10, 200, 200, 300, 1, LT24_BLUE);

    usleep(2000000);
    HPS_ResetWatchdog();

    // Test DrawRectangle
    DrawRectangle(10, 50, 100, 200, FILL_BLACK, LT24_BLUE);

    usleep(2000000);

    // Test DrawCircle
    LCDclear(LT24_YELLOW);
    DrawCircle(100, 50, 50, FILL_BLACK, LT24_RED);

    usleep(2000000);

    // Test string drawing
    LCDclear(LT24_GREEN);
    for (i = 0; i < 88; i++) {
        LCDclear(LT24_WHITE);
        DrawString(150, 200, alphabet[i], LT24_RED);
        usleep(200000);
    }
}

// Draw a line on the LCD display
void DrawLine(int y0, int x0, int y1, int x1, unsigned int const type, unsigned short color){
    int const yRange = y1 - y0;
    int const xRange = x1 - x0;
    unsigned int x, y;
    unsigned int const step = (type == 2) ? 2 : 1;

    if (abs(xRange) > abs(yRange)) {
        unsigned int const start = xRange > 0 ? x0 : x1;
        unsigned int const stop = xRange > 0 ? x1 : x0;
        for (x = start; x <= stop; x += step) {
            int dx = x - x0;
            unsigned int const y = y0 + yRange * dx / xRange;
            int fbIndex = x + y * 240;
            frameBuffer[fbIndex] = color;
            test = LT24_drawPixel(lt24, color, x, y);
        }
    } else {
        unsigned int const start = yRange > 0 ? y0 : y1;
        unsigned int const stop = yRange > 0 ? y1 : y0;
        for (y = start; y <= stop; y += step) {
            int const dy = y - y0;
            unsigned int const x = x0 + xRange * dy / yRange;
            int fbIndex = x + y * 240;
            frameBuffer[fbIndex] = color;
            test = LT24_drawPixel(lt24, color, x, y);
        }
    }
}

// Draw a rectangle on the LCD display
void DrawRectangle(int y0, int x0, int height, int width, FillType const fill, unsigned short color){
    if (fill == FILL_TRANSPARENT) {
        DrawLine(x0, y0, x0 + (width - 1), y0, 1, color);
        DrawLine(x0, y0 + (height - 1), x0 + (width - 1), y0 + (height - 1), 1, color);
        DrawLine(x0, y0, x0, y0 + (height - 1), 1, color);
        DrawLine(x0 + (width - 1), y0, x0 + (width - 1), y0 + (height - 1), 1, color);
    } else {
        int type = (fill == FILL_BLACK) ? 1 : 0;
        for (int y = y0; y < y0 + height; y++) {
            DrawLine(x0, y, x0 + (width - 1), y, type, color);
        }
    }
}

// Draw a circle on the LCD display
void DrawCircle(int y0, int x0, int radius, FillType const fill, unsigned short color){
    int x = radius;
    int y = 0;
    int radiusError = 1 - x;

    while(x >= y) {
        if (fill == FILL_TRANSPARENT) {
            frameBuffer[(x + x0) + (y + y0) * 240] = color;
            frameBuffer[(-x + x0) + (y + y0) * 240] = color;
            frameBuffer[(y + x0) + (x + y0) * 240] = color;
            frameBuffer[(-y + x0) + (x + y0) * 240] = color;
            frameBuffer[(-y + x0) + (-x + y0) * 240] = color;
            frameBuffer[(y + x0) + (-x + y0) * 240] = color;
            frameBuffer[(x + x0) + (-y + y0) * 240] = color;
            frameBuffer[(-x + x0) + (-y + y0) * 240] = color;
            exitOnFail(LT24_drawPixel(lt24, color, x + x0, y + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, -x + x0, y + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, y + x0, x + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, -y + x0, x + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, -y + x0, -x + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, y + x0, -x + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, x + x0, -y + y0), ERR_SUCCESS);
            exitOnFail(LT24_drawPixel(lt24, color, -x + x0, -y + y0), ERR_SUCCESS);
        } else {
            int type = (fill == FILL_BLACK) ? 1 : 0;
            DrawLine(x + x0, y + y0, -x + x0, y + y0, type, color);
            DrawLine(y + x0, x + y0, -y + x0, x + y0, type, color);
            DrawLine(y + x0, -x + y0, -y + x0, -x + y0, type, color);
            DrawLine(x + x0, -y + y0, -x + x0, -y + y0, type, color);
        }

        y++;
        if (radiusError < 0) {
            radiusError += 2 * y + 1;
        } else {
            x--;
            radiusError += 2 * (y - x) + 1;
        }
    }
}