# TOOLS


mkfs : ./mkfs.c  ../kern/fs/ext.c ../kern/fs/ext.h  ../kern/fs/inode.h  ../kern/fs/inode.c ./mkfs_interface.c   ./mkfs_interface.h ../boot/bootblock ../kern/kernel
	gcc  -o mkfs ./mkfs.c  ../kern/fs/ext.c ../kern/fs/ext.h  ../kern/fs/inode.h  ../kern/fs/inode.c ./mkfs_interface.c   ./mkfs_interface.h -D OUT_K
	./mkfs -f ../fs.img -b ../boot/bootblock -k ../kern/kernel -m 	



test : mkfs fs.img



fs.img : 
	@echo making fs.img......
	dd if=/dev/zero of=fs.img bs=1M count=512
	@echo fs.img ok!

clean:
	rm -rf $(TOOLS_OBJS)
	rm -rf mkfs 



