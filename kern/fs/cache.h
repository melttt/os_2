#ifndef __KERN_FS_CACHE_H_
#define __KERN_FS_CACHE_H_

int cache_init();
int cache_write(int sec ,int off ,void *buf ,int len );
int cache_read(int sec ,int off ,void *buf ,int len);
int cache_fsyn();
#endif
