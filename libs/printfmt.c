#include "defs.h"
#include "stdarg.h"
#include "string.h"
#define CH_MAX 15
static void print_int(void (*putch)(char),int num, int base, int width, char epch)
{
    char strr[CH_MAX];
    char *str = strr;
    int len;
    itoa(num, str, base);
    len = strlen(str);
    while(width > len)
    {
        putch(epch);
        width --;
    }
    while(*str != '\0')
    {
        putch(*str);
        str ++;
    }
}
int vprintfmt(void (*putch)(char), const char *fmt, va_list ap)
{
    char ch;
    char *str;
    int len = 0;
    int num = 0;
    int width = 0;
    char epch = ' ';
    while((ch = *fmt) != '\0')
    {
       if(ch == '%' || width != 0 || epch != ' ')
       {
           if(width == 0 && epch == ' ')
           {
               ch = *(++fmt);
           }
           if(ch == '\0')
           {
               break;
           }

           switch(ch)
           {
               case '0':
                   if(width == 0)
                   {
                       epch = '0';
                   }else{
                       width = width * 10 +  ch - '0';
                   }
                   break;
               case '1' ... '9':
                   width = width * 10 +  ch - '0';
                   break;
               case 'd' :
                   print_int(putch, va_arg(ap, int),10, width, epch);
                   width = 0;
                   epch = ' ';
                   break;
               case 's' :
                   str = va_arg(ap, char*);
                   len = strlen(str);
                   while(width > len)
                   {
                       putch(epch);
                       width --;
                   }
                   while(*str != '\0') 
                   {
                       putch(*str ++);
                   }
                   width = 0;
                   epch = ' ';
                   break;
               case 'x' :
                   print_int(putch, va_arg(ap,int), 16, width, epch);
                   width = 0;
                   epch = ' ';
                   break;
               case 'c' :
                   while(width-- > 1)
                   {
                       putch(epch);
                   }
                   putch(va_arg(ap,int));
                   width = 0;
                   epch = ' ';
                   break;
               case '%' :
                   putch('%');
                   break;
               default:
                   ;
           }
           num ++;
       }else{
           putch(ch);
       }
       fmt ++;
    }
    return num;
}
