#ifndef __KERN_FS_CACHE_H_
#define __KERN_FS_CACHE_H_

int cache_init();
int begin_cache();
int end_cache();
void* mapping_file(unsigned int sec ,unsigned int off);
int cache_tick();
#endif
