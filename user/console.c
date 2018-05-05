#include "syslib.h"
#include "string.h"
#include "stdio.h"


static int uprintf(const char *fmt, ...)
{
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    cnt = vprintfmt(put,fmt,ap);
    va_end(ap);
    return cnt;
}


char* get_string(char *str)
{
    char ch;
    int len = 0;
    uprintf("$:");
    while((ch = getchar()) != '\n')
    {
        if(len != 0 && ch == '\b')
        {
            len --;
            uprintf("\b");
        }else{
            str[len ++] = ch;
            uprintf("%c", ch); 
        }
    }
    uprintf("\n");
    str[len] = 0;
    return str;
}

int main()
{

    char buff[30];
    int x;
    uprintf("welcome to my os\n");

    while(1)
    {
        get_string(buff);
        if(!strcmp(buff, "fuck"))
        {
            uprintf("fuck you \n");
        }else if(!strcmp(buff, "test")){

            x = fork();  
            if(x != 0)
            {
                while(wait() != -1)
                {
                    uprintf("test over\n");
                }
            }else{
                uprintf("child exec\n");
                exec("user_test");
            }

        }else if(!strcmp(buff, "ls")){
            ls(); 
            uprintf("ls over\n");
        }else{
            uprintf("your input : %s\n", buff);
        }

    }

    return 0;
}
