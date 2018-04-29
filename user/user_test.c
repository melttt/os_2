#include "syslib.h"

void test()
{

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
        put('c');
        put('\n');
    }

}

void putstr(char *s, int len)
{
    for(int i = 0 ; i < len ; i ++)
    {
        put( *(s+i) );
    }
}
int main()
{

    int c;

    putstr("start", 5);
    while((c = getchar()) != '#')
    {
        put(c);
        if(c == 'g')
        {
            test();
        }
    }

    putstr("over", 4);

    return 0;
}
