#include "usyscall.h"
void sys_test_p(char a, char b, char c, char d, short e)
{
    sys_test(a, b, c, d, e);
}
int main()
{
    //put('q');
    char a = 'a';
    char b= 'b';
    char c= 'c';
    char d = 'd';
    short e = 777;
    sys_test_p(a, b, c, d, e);
    while(1)
    {
    //    for(b = 0 ; b < 10000; b ++);
     //       show_pid();
    }

    exit();
    return 0;
}
