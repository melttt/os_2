#include "syslib.h"
#include "string.h"

void putstr(char *s)
{
    for(int i = 0 ; i < strlen(s) ; i ++)
    {
        put( *(s+i) );
    }
}
void test()
{
    int x;

    x = fork();
    if(x != 0)
    {
        putstr("I 'm parent... wait to my child\n");
        while(wait() != -1)
        {
            putstr("close my child\n exit parent\n");
        }
    }else{
        putstr("I 'm child...\nexit child\n");
    }
}


int main()
{

    putstr("start fork demo\n");
    test();

    putstr("over fork demo, byebye\n");
    return 0;
}
