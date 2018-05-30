#include "syslib.h"
#include "string.h"
#include "ustdio.h"


void test()
{
    int x;
    x = fork();
    if(x != 0)
    {
        uprintf("I 'm parent... \n");
        while(wait() != -1)
        {
        }
    }else{
        uprintf("I 'm child... \n");
    }
}


int main()
{
    test();
    return 0;
}
