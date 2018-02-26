#include "syslib.h"
int main(void);

void umain()
{
    int ret;
    ret = main();
    exit(ret);
}
