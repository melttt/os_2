#ifndef _CONSOLE_H_
#define _CONSOLE_H_
#include "defs.h"
typedef
enum real_color{
    rc_black,
    rc_blue,
    rc_green,
    rc_cyan,
    rc_red,
    rc_magenta,
    rc_brown,
    rc_light_grey,
    rc_dark_grey,
    rc_light_blue,
    rc_light_green,
    rc_light_cyan,
    rc_light_red,
    rc_light_magenta,
    rc_light_brown,
    rc_white,
    rc_xxxx
}real_color_t;

//  清屏
void clear_cons();
//  屏幕输出一个字符 带颜色
void putc_color_cons(char c, real_color_t back, real_color_t fore);
//  屏幕打印一个\0结尾的字符串，默认黑底白字
void putc_cons(char cstr);

void init_cons();

#endif
