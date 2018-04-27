#include "fs_ds.h"
#include "ext.h"


#ifndef OUT_K
#include "defs.h"
#include "kdebug.h"
#include "fs_interface.h"
#include "string.h"
#include "stdio.h"
#else
#include <string.h>
#include "stddef.h"
#include "assert.h"
#endif

#ifndef MIN
#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#endif





fs_low_class* fs_f;
/***********************************extent********************************************/
#define EXT_IS_VALID(d) (d->magic_num == EXTENT_MAGIC_NUM) 
#define LAST_EXT (SP_N->e_st_ext + SP_N->e_all_nums)
#define EXT_ADDRESS_IS_VALID(d) (d != NIA && d >= 0 && d < LAST_EXT)

extent* e_alloc()
{
    _off_t address;
    _off_t near = 0;
    extent *ret = NULL;
    address = FIND_NEAR_E( near);

    assert(EXT_ADDRESS_IS_VALID(address));

    ret = MAP_D(address ,0);
    if(ret != NULL)
    {
        if(ret->magic_num == EXTENT_MAGIC_NUM)
        {
            DELETE_E(address);
        }else{
            ret = NULL;     
#ifndef OUT_K
            panic("e_alloc : wrong magic_num\n");
#else
        assert(NULL == "e_alloc : wrong magic_num\n");
#endif
        }
    }
    return ret;
}

void e_free(extent* ext)
{
    assert(ext != NULL && EXT_IS_VALID(ext));
    ext->e_type = E_TYPE_invalid;  
    INSERT_E(ext->e_where);
}


/***********************************mn******************************************/
#define mn_OFF(ext, i) (((mn*)((char*)ext +ext->e_data_off)) + i) 
#define HIGH_MAX (1 << 24)

static mn* init_mn(mn* m,_off_t high_where , _off_t low_where)
{
    m->magic_num = MN_MAGIC_NUM;
    assert(high_where < HIGH_MAX);
    m->data.where = m->real_where = CALC_REAL_WHERE(high_where, low_where);
    m->data.next = NIA;

    return m;
}
/**********************************inode***************************************/
#define inode_OFF(ext, i) (((inode*)((char*)ext +ext->e_data_off)) + i) 
static inode* init_inode(inode* m,_off_t high_where, _off_t low_where)
{
    m->magic_num = INODE_MAGIC_NUM;
    assert(high_where < HIGH_MAX);
    m->real_where = CALC_REAL_WHERE(high_where, low_where);

    m->data.type = INODE_TYPE_INVALID;
    m->data.nlink = 0;
    m->data.size = 0;
    m->data.root_rwhere = NIA;
    return m;
}

/**********************************fdata**************************************/
#define fdata_OFF(ext, i) (((fdata*)((char*)ext +ext->e_data_off)) + i) 
static fdata* init_fdata(fdata* m,_off_t high_where, _off_t low_where)
{
    m->magic_num = FDATA_MAGIC_NUM;
    assert(high_where < HIGH_MAX);
    m->real_where = CALC_REAL_WHERE(high_where, low_where);
    m->file_off = 0;
    m->valid_len = 0;

    return m;
}

/*********************************alloc&free*********************************/
#define make_meta_data(type) \
extent* make_##type(extent *ext)    \
{           \
    int i;  \
    ext->e_type = E_TYPE_##type;    \
    ext->e_size = sizeof(type);   \
    assert(sizeof(extent) < ST_EXTENT_MAX_SIZE);    \
    ext->e_data_off = ST_EXTENT_MAX_SIZE;   \
    ext->e_len = MIN((EXT_SIZE - ST_EXTENT_MAX_SIZE) / sizeof(type) , EXTENT_DATA_MAX_LEN);   \
    ext->e_next_e = NIA;    \
    ext->e_nums = ext->e_len;   \
    for(i = 0 ; i < ext->e_len ; i ++) ext->e_valid[i] = 0; \
    return ext;\
}

make_meta_data(mn)
make_meta_data(inode)
make_meta_data(fdata)
#undef make_meta_data


#define meta_data_alloc(type) \
type * type##_alloc()          \
{   \
    extent *ne;                \
    type *ret;         \
    int i;\
    if(SP_N->type##_free_list_nums == 0) \
    {   \
        ne = make_##type(e_alloc());    \
        ne->e_next_e = SP_N->type##_free_next_ext;    \
        SP_N->type##_free_next_ext = ne->e_where; \
        SP_N->type##_free_list_nums ++;\
    }\
    assert(SP_N->type##_free_next_ext != NIA);   \
    ne = MAP_D(SP_N->type##_free_next_ext ,0);\
    for(i = 0 ; i < ne->e_len ; i ++) \
    {           \
       if(ne->e_valid[i] == 0) break; \
    }\
    assert(i != ne->e_len); \
    ne->e_valid[i] = 1 ;\
    if(-- ne->e_nums == 0) \
    {       \
        SP_N->type##_free_list_nums --;\
        SP_N->type##_free_next_ext = ne->e_next_e; \
        ne->e_next_e = NIA;\
    }\
    ret = type##_OFF(ne, i);\
    ret = init_##type(ret , ne->e_where , i);\
    return ret;\
}

meta_data_alloc(mn)
meta_data_alloc(inode)
meta_data_alloc(fdata)
#undef meta_data_alloc


#define meta_free(type) \
void type##_free(type *var)  \
{   \
    extent *ne;              \
    _off_t low_num;             \
    assert(var != NULL);        \
    ne = MAP_D(GET_REAL_WEHRE_HIGHT(var->real_where), 0);    \
    assert(ne->magic_num == EXTENT_MAGIC_NUM );     \
    low_num = GET_REAL_WHERE_LOW(var->real_where);   \
    assert(ne->e_valid[low_num] == 1);  \
    ne->e_valid[low_num] = 0;   \
    ne->e_nums ++;  \
    assert(ne->e_nums <= ne->e_len);\
    if(ne->e_nums == 1)         \
    {                           \
        ne->e_next_e = SP_N->type##_free_next_ext;  \
        SP_N->type##_free_next_ext = ne->e_where; \
        SP_N->type##_free_list_nums ++;   \
    }               \
    if(ne->e_nums == ne->e_len)         \
    {       \
        SP_N->type##_free_next_ext = ne->e_where;   \
        SP_N->type##_free_list_nums --;     \
        e_free(ne);         \
    }                       \
}

meta_free(mn)
meta_free(inode)
meta_free(fdata)
#undef meta_free


#define get_type(type) \
type * get_##type(_off_t where)    \
{   \
    extent *ne; \
    type *ret; \
    int high_n = GET_REAL_WEHRE_HIGHT(where); \
    int low_n = GET_REAL_WHERE_LOW(where);\
    ne = MAP_D(high_n, 0);  \
    if(ne->e_valid[low_n ]) \
        ret = type##_OFF(ne, GET_REAL_WHERE_LOW(where));    \
    else    \
        ret = NULL; \
    return ret; \
}


get_type(mn)
get_type(inode)
get_type(fdata)

#undef get_type

int ext_init(fs_low_class * _fs_f)
{
    //int i;
#ifndef OUT_K
    fs_f = init_low_fs();
#else
    fs_f = _fs_f;
#endif

//    mn *mn;
#if 0
    CLEAR_CACHE();
    for(i = 0 ; i < 99 ; i += 3)
    {
        arr[i] = mn_alloc();
        cprintf("mn:%d,%d,where:%x\n", SP_N->e_free_nums, SP_N->mn_free_list_nums, ((mn*)arr[i])->real_where);
        arr[i + 1] = inode_alloc();
        cprintf("inode:%d,%d,where:%x\n", SP_N->e_free_nums, SP_N->inode_free_list_nums, ((inode*)arr[i+1])->real_where);
        arr[i + 2] = fdata_alloc();
        cprintf("fdata:%d,%d,where:%x\n", SP_N->e_free_nums, SP_N->fdata_free_list_nums, ((fdata*)arr[i + 2])->real_where);
    }
    for(i = 0 ; i < 99 ; i += 3)
    {
        mn_free(arr[i]);
        inode_free(arr[i+1]);
        fdata_free(arr[i+2]);

        cprintf("%d,%d,%d,%d\n", SP_N->e_free_nums, SP_N->mn_free_list_nums, SP_N->inode_free_list_nums, SP_N->fdata_free_list_nums);
    }

    cprintf("ok\n");

    cprintf("p->real_where:%x\n", get_mn(0x2e00)->real_where);
    cprintf("p->real_where:%x\n", get_mn(0x2e01)->real_where);

//    SYNC_DISK();
#endif
    return 1;
}

