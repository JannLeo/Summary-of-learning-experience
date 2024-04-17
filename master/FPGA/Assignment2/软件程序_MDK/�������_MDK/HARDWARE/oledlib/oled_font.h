#ifndef OLED_FONT_H
#define OLED_FONT_H

typedef enum 
{
	TEXT_BK_NULL=0,
	TEXT_BK_NOT_NULL,
}Type_textbk;



extern const  unsigned char  font5x7[];
extern const  unsigned char  F8X16[];

unsigned char GetFontSize(void);
void SetFontSize(unsigned char value);
void SetTextBkMode(Type_textbk value);
Type_textbk GetTextBkMode(void);
#endif

