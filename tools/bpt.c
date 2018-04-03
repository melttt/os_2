#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#define TEST 1

typedef int _off_t;
#define KEYLEN 6
#define VALLEN 8
typedef struct node{
    char type;
    char empty1;
    short empty2;
    _off_t parent;
    _off_t keys[KEYLEN];
    _off_t vals[VALLEN];
}node ;
    
node * make_node(void)
{
        


}






    
//get file size
size_t get_file_size(const char *path)
{
    size_t filesize = -1;
    struct stat statbuf;
    if(stat(path, &statbuf) < 0)
    {
        return filesize;
    }

    filesize = statbuf.st_size;
    return filesize;
}
    
int main()
{
    if(sizeof(node) > 64)
    {
        printf("error size of node\n exit ...");
        return 1;
    }


    printf("size of node :%d \n", sizeof(node));
    printf("fs.img 's size = %d \n", get_file_size("fs.img")/1024/1024);

    return 0;
}







