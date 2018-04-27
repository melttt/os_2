#include "syslib.h"



int main()
{
    //put('q');
    char a = 'a';
    char b= 'b';
    char c= 'c';
    char d = 'd';
    short e = 777;
    user_test(a, b, c, d, e);
    int x;

    x = fork();
    if(x != 0)
    {
        put('p');
        put('\n');
        while(wait() != -1)
        {
            put('x');
            put('\n');
        }
    }else{
        while(1)
        {
            put('c');
            put('\n');
        }
    }

    return 0;
}
