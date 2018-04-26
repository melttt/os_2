#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include "../kern/fs/fs_ds.h"





char *disk_in_mem;
char *filename;
int fd;



void* mapping_disk(uint sec ,uint off)
{
    return (filename + EXTENT_SIZE * sec + off) ;
}
/*********************interface*********************/

static uint get_file_size(const char *path)
{
    uint filesize = -1;
    struct stat statbuf;
    if(stat(path, &statbuf) < 0)
    {
        return filesize;
    }

    filesize = statbuf.st_size;
    return filesize;
}

void setup_disk_in_mem()
{
    uint disk_size = get_file_size(filename);
    uint copy_size = EXTENT_SIZE;
    disk_in_mem = malloc(disk_size);     
    printf("disk_in_mem of size : %d\n",disk_size );


    for(uint i = 0 ; i < disk_size ; i += sizeof(copy_size))
    {
        read(fd, disk_in_mem + i ,sizeof(copy_size));
    }
    printf("read over\n");

    if(((supernode*)disk_in_mem)->magic_num == SUPER_NODE_MAGIC_NUM )
    {
        printf("pass\n");
    }    

}


int main()
{
    filename = "../fs.img";
    fd = open(filename, O_RDWR );    
    setup_disk_in_mem();

    return 0;
}
