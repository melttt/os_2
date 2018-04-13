#ifndef __KERN_FS_CACHE_H_
#define __KERN_FS_CACHE_H_

int cache_init();
int cache_write(int sec, void *buf);
int cache_read(int sec, void *buf);
int cache_fsyn();
#endif
