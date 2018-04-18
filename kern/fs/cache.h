#ifndef __KERN_FS_CACHE_H_
#define __KERN_FS_CACHE_H_

int cache_init();
int begin_op();
int end_op();
void* mapping_file(int sec ,int off);
int cache_tick();
#endif
