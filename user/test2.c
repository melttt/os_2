#include "syslib.h"
#include "string.h"
#include "ustdio.h"


int arr[20];
int arrlen = 5;

void print_arr()
{
    int i = 0;
    for(i = 0 ; i < arrlen ; i ++)
        uprintf("proc%d , time:%d |",i , arr[i]);
    uprintf("\n");
}

void test(int dep)
{
    if(dep == 0) return;
    int x;
    x = fork();
    if(x != 0)
    {
        test(dep - 1);
        while(wait() != -1)
        {

        }
    }else{
        int i = 100;
        while(i--)
        {
            arr[dep] ++;
            
            uprintf("proc%d , time:%d \n",dep , arr[dep]);
        }
    }
}


int main()
{
    memset(arr, 0 , sizeof(arr));
    test(arrlen);
    return 0;
}
