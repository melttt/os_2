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


/*******************************dirent****************************/
uint hash1(char *name, int len)
{
    int i = 0, p = 13, mod = 1000000007;
    uint hashres = name[i];
    for(i = 1 ; i < len ; i ++)
    {
        hashres = (hashres * p + name[i]) % mod;
    }
    return hashres;
}
uint hash2(char *name, int len)
{
    int i = 0, p = 13, mod = 1000000009;
    uint hashres = name[i];
    for(i = 1 ; i < len ; i ++)
    {
        hashres = (hashres * p + name[i]) % mod;
    }
    return hashres;
}

static int dirent_cmp(dirent *a, char* name, int len, uint hash1, uint hash2);
inline static int dirent_cmp(dirent *a, char* name, int len, uint hash1, uint hash2)
{

    if(a->hash1 == hash1 && a->hash2 == hash2 && !strncmp(name, a->name , len))
        return 1;
    return 0;
}


inode *dirent_lookup(inode *parent, char* name)
{
    int len = strlen(name);
    uint hash1_res = hash1(name ,len);
    uint hash2_res = hash2(name, len);
    _off_t off = 0;
    uint buf_i = 0;
    _off_t rwhere = NIA;
    dirent buf[DIRENT_BUF_MAX];

    for(off = 0 ; off < parent->data.size ; off += sizeof(buf) )
    {
        inode_read(parent, (char*)buf, sizeof(buf), off);
        for(buf_i = 0 ; buf_i != DIRENT_BUF_MAX ; buf_i ++) 
        {
            
            if(buf[buf_i].hash1 == 0 && buf[buf_i].hash2 ==0 && buf[buf_i].rwhere == 0)
                return NULL;

            if(dirent_cmp(&buf[buf_i], name, len ,hash1_res, hash2_res) == 1){
                rwhere = buf[buf_i].rwhere;                
                return get_inode(rwhere);
            }
        }
    }

    return NULL;
}

void dirent_make(dirent* a, char* name, int len, _off_t rwhere)
{
    if(len > DIRENT_LEN)
        len = DIRENT_LEN - 1;
    memcpy(a->name ,name ,len);
    a->name[DIRENT_LEN - 1] = 0;

    a->hash1 = hash1(name, len);
    a->hash2 = hash2(name, len);
    a->rwhere = rwhere; 
}

void dirent_link(inode *parent , char* name, inode *newnode )
{
    int len = strlen(name);
    _off_t off = 0;
    uint buf_i = 0;
    dirent tmpd;
    dirent buf[DIRENT_BUF_MAX];

    for(off = 0 ; off < parent->data.size ; off += sizeof(buf) )
    {
        inode_read(parent, (char*)buf, sizeof(buf), off);
        for(buf_i = 0 ; buf_i != DIRENT_BUF_MAX ; buf_i ++) 
        {
            if(buf[buf_i].hash1 == 0 && buf[buf_i].hash2 ==0 && buf[buf_i].rwhere == 0)
            {
                off += buf_i * sizeof(dirent);
                goto found;
            }
        }
    }

    assert(off == parent->data.size);
found:
    dirent_make(&tmpd, name, len, newnode->real_where);
    inode_write(parent ,&tmpd ,sizeof(tmpd),off);

    newnode->data.nlink ++;
}

/*
int dirent_delete(inode *parent ,char *name)
{
    int len = strlen(name);
    inode *thatnode = dirent_lookup(parent ,name);
    if(thatnode == NULL) return -1;                
    
    if(thatnode->data.type == INODE_TYPE_DIR)
    {


    }else if(thatnode->data.type == INODE_TYPE_FILE)
    {
        
    }

    return 0;
}
*/


/****************************FILE**************************/


char* parse_path(char* path, char* ret, int* ret_len)
{
     while(*path  == '/') 
         path ++;
     *ret_len = 0;

     while(*path != '/' && *path != '\0')
     {
         *ret ++ = *path ++;
         (*ret_len) ++;
     }

     *ret = '\0';
     return path;
}


//static char test[513] = "Oh God ! you do it";
static char test2[513] = "Oh shit! my genius";
void init_inode()
{
    int i;
    ext_init();
    //inode *file1 = get_inode(0x2e00);//inode_alloc();
    inode *rot = get_inode(0x2e01);//inode_alloc();
    //i = inode_write(file1,test ,sizeof(test) ,2 );
    inode* dir2 = dirent_lookup(rot, "dir2");
    inode* isfile3 = dirent_lookup(dir2, "file3");

    if( isfile3)
    {
        i = inode_read(isfile3, test2, sizeof(test2) , 0); 
        cprintf("%d,result : %s\n",i, test2);

        char bb[] = "./home/////melt//tt///os_2/os_2";
        char *p = bb;
        char ret[20];
        int ret_len;
        for( ; *p != 0 ;)
        {
            p = parse_path(p ,ret, &ret_len);
            cprintf("%s\n", ret);
        }


    }else{
        panic("no file1\n");
    }

    //i = inode_read(xx, test2, sizeof(test2) , 0); 
    //cprintf("%d result : %s\n : %x",i,  test2, xx->real_where);

    //SYNC_DISK();
    while(1);
}

