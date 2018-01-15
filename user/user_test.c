#include "usyscall.h"
int a = 1;
int b;
int main()
{
    b = a;
    put('q');
    while(1);
    return 0;
}
