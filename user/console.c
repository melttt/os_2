#include "syslib.h"
#include "ustdio.h"
#include "../kern/fs/fs_ds.h"


char* get_string(char *str)
{
    char ch;
    int len = 0;
    uprintf("$:");
    while((ch = getchar()) != '\n')
    {
        if(ch == '\b')
        {
            if(len > 0)
            {
                len --;
                uprintf("\b \b");
            }
        }else{
            str[len ++] = ch;
            uprintf("%c", ch); 
        }
    }
    uprintf("\n");
    str[len] = 0;
    return str;
}

dirent dsz[10];
int main()
{

    char buff[30];
    int x;



    uprintf("welcome to my os\n");

    while(1)
    {
        get_string(buff);
        if(!strcmp(buff, "version"))
        {
            uprintf("version 0.01\n");
        }else if(!strcmp(buff, "user_test")){

            x = fork();  
            if(x != 0)
            {
                while(wait() != -1)
                {

                }
            }else{
                exec("user_test");
            }

        }else if(!strcmp(buff, "ls")){
            int ret = get_dirents(dsz, sizeof(dsz));
            for(int i = 0 ; i < ret ; i ++)
            {
                uprintf("%s\n", dsz[i].name);
            }
        }else if(!strncmp(buff ,"mkdir", 5)){
            mkdir(buff + 6);
        }else if(!strncmp(buff, "cd", 2)){
            chdir(buff + 3);
        }else if(!strncmp(buff, "file", 4)){


        }else if(!strcmp(buff, "test2")){
            x = fork();  
            if(x != 0)
            {
                while(wait() != -1)
                {

                }
            }else{
                exec("test2");
            }

        }else{
            uprintf("command not found : %s\n", buff);
        }

    }

    return 0;
}
