#include "usyscall.h"
int a = 1;
int b;
int main()
{
    b = a;
    //put('q');

    while(1)
    {
        for(b = 0 ; b < 10000; b ++);
            show_pid();
    }

    exit();
    return 0;
}
