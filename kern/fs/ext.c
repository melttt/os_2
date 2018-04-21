#include "ext.h"
#include "fs_ds.h"

#define E_TEST 1

#if E_TEST
#include "defs.h"
#include "kdebug.h"
#include "fs_interface.h"
#include "string.h"
#include "stdio.h"
#endif


fs_low_class* fs_f;
#define CLEAR_CACHE() fs_f->begin_fs_op()
#define SYNC_DISK() fs_f->end_fs_op()
#define MAP_D(sec ,off) fs_f->map_disk(sec ,off )
#define INSERT_E(where ) fs_f->insert_ext(where, where)
#define FIND_E(key ) fs_f->find_ext(key)
#define FIND_NEAR_E(near) fs_f->find_ext_near(near )
#define DELETE_E(key ) fs_f->delete_ext(key )
#define SP_N fs_f->supernode_p


/***********************************extent********************************************/
#define EXT_IS_VALID(d) (d->magic_num == EXTENT_MAGIC_NUM) 
#define LAST_EXT (SP_N->e_st_ext + SP_N->e_all_nums)
#define EXT_ADDRESS_IS_VALID(d) (d != NIA && d >= 0 && d < LAST_EXT)
#if 0
int write_extent( _off_t where, extent *ext)
{
    void *dst; 
    dst = MAP_D( where, 0);
    memcpy(dst  , ext , sizeof(extent));
    return 1;
}
#endif
extent* e_alloc()
{
    _off_t address;
    _off_t near = 0;
    extent *ret = NULL;
    address = FIND_NEAR_E( near);

    assert(EXT_ADDRESS_IS_VALID(address));

    ret = MAP_D(address ,0);
    if(ret != NULL && ret->magic_num != EXTENT_MAGIC_NUM )
    {
        if(ret->magic_num == EXTENT_MAGIC_NUM)
        {
            DELETE_E(address);
        }else{
            ret = NULL;     
        }
    }
    return ret;
}

void e_free(extent* ext)
{
    assert(ext != NULL && EXT_IS_VALID(ext));
    ext->e_type = E_TYPE_INVALID;  
    INSERT_E(ext->e_where);
}

extent* make_mn(extent *ext)
{
    int i;
    ext->e_type = E_TYPE_MN;
    ext->e_size = sizeof(meta_node);
    assert(sizeof(extent) < ST_EXTENT_MAX_SIZE);
    ext->e_data_off = ST_EXTENT_MAX_SIZE;
    ext->e_len = MIN((EXT_SIZE - ST_EXTENT_MAX_SIZE) / sizeof(meta_node) , EXTENT_DATA_MAX_LEN);
    ext->e_next_e = NIA;
    ext->e_nums = ext->e_len;
    for(i = 0 ; i < ext->e_len ; i ++) ext->e_valid[i] = 0;
    return ext;
}
/***********************************meta_node******************************************/
#define MN_OFF(ext, i) (((meta_node*)((char*)ext +ext->e_data_off)) + i) 


static meta_node* init_mn(meta_node* m,_off_t high_where , _off_t low_where)
{
    m->magic_num = MN_MAGIC_NUM;
    assert(high_where < (1 << 24));
    m->data.where = m->real_where = CALC_REAL_WHERE(high_where, low_where);
    m->data.next = NIA;

    return m;
}

meta_node* mn_alloc()
{
    extent *ne;
    meta_node *mn;
    _off_t tmp;
    int i;
    if(SP_N->mn_free_nums == 0 )
    {
        ne = make_mn(e_alloc()); 
        tmp = SP_N->mn_free_next_ext;
        ne->e_next_e = tmp;
        SP_N->mn_free_next_ext = ne->e_where;
        SP_N->mn_free_nums ++;
    }

    assert(SP_N->mn_free_next_ext != NIA);

    ne = MAP_D(SP_N->mn_free_next_ext, 0);  
    for(i = 0 ; i < ne->e_len ; i ++)
    {
        if(ne->e_valid[i] == 0) break;
    }
    assert(i != ne->e_len);
    ne->e_valid[i] = 1;

    if(-- ne->e_nums == 0)
    {
        SP_N->mn_free_nums --;
        SP_N->mn_free_next_ext = ne->e_next_e;
        ne->e_next_e = NIA;
    }
   
    mn =  MN_OFF(ne ,i); 
    mn = init_mn(mn, ne->e_where ,i);

    return mn;
}




void mn_free(meta_node* mn)
{
    extent *ne;
    _off_t tmp;
    _off_t low_num;

    ne = MAP_D(GET_REAL_WEHRE_HIGHT(mn->real_where), 0);
    assert(ne->magic_num == EXTENT_MAGIC_NUM );
    low_num = GET_REAL_WHERE_LOW(mn->real_where);
    assert(ne->e_valid[low_num] == 0);
    ne->e_valid[low_num] = 0; 
    ne->e_nums ++;
    assert(ne->e_nums <= ne->e_len);

    if(ne->e_nums == 1)
    {
        tmp = SP_N->mn_free_next_ext;
        ne->e_next_e = tmp;
        SP_N->mn_free_next_ext = ne->e_where;
        SP_N->mn_free_nums ++;
    }

    if(ne->e_nums == ne->e_len)
    {
        SP_N->mn_free_next_ext = ne->e_where; 
        SP_N->mn_free_nums --;
        e_free(ne);
    }
}


meta_node* get_mn(_off_t where)
{
    extent *ne;
    meta_node *mn;
    int high_n = GET_REAL_WEHRE_HIGHT(where);
    int low_n = GET_REAL_WHERE_LOW(where);
    ne = MAP_D(high_n, 0);
    if(ne->e_valid[low_n ])
        mn = MN_OFF(ne, GET_REAL_WHERE_LOW(where));
    else
        mn = NULL;
    return mn;
}

int ext_init(fs_low_class * _fs_f)
{
    fs_f = init_low_fs();
    CLEAR_CACHE();
    cprintf("ok\n");
mn_free( get_mn(0x2e00));
mn_free( get_mn(0x2e01));
        cprintf("p->real_where:%x\n", get_mn(0x2e00)->real_where);
        cprintf("p->real_where:%x\n", get_mn(0x2e01)->real_where);
//        cprintf("p->real_where:%x", get_mn(0x2e02) == NULL ? 1 : 0);

    SYNC_DISK();

    return 1;
}


/*
static void *get_node_ptr(_off_t n)
{
    if(n == NIA)
    {
        return NULL;
    }else{
        return fs_f->map_disk(1 + n / MEXTS , n % MEXTS * NODE_SIZE);
    }
}



static void test(int bg, int ed)
{
//    _extent *ex;
//    int i = 0;
    cprintf("find test bg : %d, ed : %d\n", bg, ed);
    int ret;
    void *root;
    cprintf("123456781234");
    while(bg < ed)
    {

            fs_f->begin_fs_op();

            root = get_node_ptr(fs_f->supernode_p->me_root);

//            root = bpt_delete(root, bg);
 //           root = bpt_insert(root ,bg ,bg);
            if((ret = fs_f->find_ext(root, bg)) != NIA)
            {
                cprintf("\b\b\b\b\b\b\b\b\b\b\b\bfid:%08d", bg);
            }else{
                panic("test error : %d\n",bg);
            }
            if(root)
                fs_f->supernode_p->me_root = ((node*)root)->where;
            else
                fs_f->supernode_p->me_root = NIA;

            fs_f->end_fs_op();
            bg ++;
    }
    cprintf("test ok\n");
}
*/
