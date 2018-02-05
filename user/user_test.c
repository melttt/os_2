#include "usyscall.h"
int a = 1;
int b;
int main()
{
    b = a;
    put('q');
    exit();
    return 0;
}
