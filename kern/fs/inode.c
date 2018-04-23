#include "fs_ds.h"
#include "ext.h"
#include "inode.h"

#include "bplustree.h"
#define I_TEST 1

#if I_TEST
#include "defs.h"
#include "kdebug.h"
#include "fs_interface.h"
#include "string.h"
#include "stdio.h"
#endif


static node* malloc_node(node **a)
{
    mn *tmp = mn_alloc();
    assert(tmp != NULL);
    *a = &tmp->data;

    return *a;
}

static void free_node(node * d){
   mn_free(node2mn(d));
}

static node* get_node_ptr(_off_t n)
{
    if(n == NIA) return NULL;
    mn *ret = get_mn(n);
    assert(ret);
    return &ret->data;
}


//data
static void insert_fdata(inode *a, _off_t off, _off_t data_rwhere)
{
    assert(a != NULL);
    node *root = get_node_ptr(a->data.root_rwhere); 
    root = bpt_insert(root , off , data_rwhere);
    a->data.root_rwhere = root->where;
}

static _off_t find_fdata(inode *a, _off_t off)
{
    assert(a != NULL);
    node *root = get_node_ptr(a->data.root_rwhere); 
    return bpt_find(root ,off);
}

static void delete_fdata(inode *a, _off_t off)
{
    assert(a != NULL);
    node *root = get_node_ptr(a->data.root_rwhere); 
    root = bpt_delete(root , off);
    a->data.root_rwhere = root->where;
}



int inode_write(inode* a, void* buf, uint len , _off_t off)
{
    
    _off_t off_st = NIA;
    _off_t off_st_mod = NIA;
    _off_t add_val, remind_val ;
    //calc st
    if(a->data.size > off)         
    {
        off_st = (off / FDATA_SIZE) * FDATA_SIZE ; 
        off_st_mod = off % FDATA_SIZE;
     
    }else{
        assert(a->data.size % FDATA_SIZE == 0);
        off_st = a->data.size; //tmpd->file_off ;//= a->data.size;
        off_st_mod = 0;
    }

    fdata *tmpd = NULL;
    _off_t rwhere = NIA;
    char *cur_buf = (char*)buf;
    for(add_val = 0, remind_val = len; remind_val != 0 ; )
    {
        add_val = MIN(remind_val , FDATA_SIZE - off_st_mod);
        
        if((rwhere = find_fdata(a, off_st)) == NIA)
        {
            tmpd = fdata_alloc();
            assert(tmpd != NULL);
            memset(tmpd->off_t , 0, FDATA_SIZE);
            tmpd->file_off = off_st;
            tmpd->valid_len = FDATA_SIZE;
            a->data.size += FDATA_SIZE;
            insert_fdata(a, off_st, tmpd->real_where);
        }else{
            tmpd = get_fdata(rwhere); 
        }
        assert(tmpd != NULL && FDATA_VALID(tmpd));
        memcpy(tmpd->off_t + off_st_mod , cur_buf , add_val);
        
        cur_buf += add_val;
        remind_val -= add_val;
        off_st += FDATA_SIZE;
        off_st_mod = 0;
    }

    return len;
}

int inode_read(inode* a, void* buf, uint len ,_off_t off)
{
    _off_t off_st = NIA ,off_st_mod = NIA;
    _off_t add_val, remind_val ;
    if(off  >= a->data.size)
        return -1;
    if(off + len >= a->data.size) 
    {
        len = a->data.size - off; 
    }

    off_st = (off / FDATA_SIZE) * FDATA_SIZE ; 
    off_st_mod = ((off) % FDATA_SIZE );

    
    fdata *tmpd = NULL;
    _off_t rwhere = NIA;
    char *cur_buf = (char*)buf;

    for(remind_val = len ; remind_val != 0 ;)
    {
        add_val = MIN(remind_val , FDATA_SIZE - off_st_mod);
        rwhere = find_fdata(a, off_st);
        assert(rwhere != NIA);

        tmpd = get_fdata(rwhere); 
        assert(tmpd != NULL);

        memcpy(cur_buf , tmpd->off_t + off_st_mod , add_val);

        cur_buf += add_val;
        remind_val -= add_val;
        off_st += FDATA_SIZE;
        off_st_mod = 0;
    }

    return len;    
}









//static char test[513] = "Oh God ! you do it\n";
static char test2[513];
void init_inode()
{
    int i;
    ext_init();
    inode *xx = get_inode(0x2e00);
//    i = inode_write(xx,test ,sizeof(test) ,2 );
    i = inode_read(xx, test2, sizeof(test2) , 0); 
    cprintf("%d result : %s\n : %x",i,  test2, xx->real_where);
    SYNC_DISK();
    while(1);
}






























