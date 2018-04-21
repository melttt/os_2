#ifndef _LIBS_DEFS_H_
#define _LIBS_DEFS_H_


#ifndef NULL
#define NULL ((void *)0)
#endif

typedef int bool;
#define true 1
#define false 0
typedef char int8_t;
typedef unsigned char uchar;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short ushort;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;
#define UINT32_MAX (~(uint32_t)0)
#ifndef uint
#define uint unsigned int
#endif


typedef int32_t intptr_t;
typedef uint32_t uintptr_t;
typedef unsigned int pde_t;
typedef unsigned int pte_t;
typedef pte_t swap_entry_t;
/* size_t is used for memory object sizes */
typedef uintptr_t size_t;

/* used for page numbers */
typedef size_t ppn_t;
/*
#define MIN(x, y) ({        \
        typeof(x) _min1 = (x);      \
        typeof(y) _min2 = (y);      \
        (void) (&_min1 == &_min2);    \
        _min1 < _min2 ? _min1 : _min2; })

#define MAX(x, y) ({        \
        typeof(x) _max1 = (x);      \
        typeof(y) _max2 = (y);      \
        (void) (&_max1 == &_max2);    \
        _max1 > _max2 ? _max1 : _max2; })
*/

#define MAX(a,b) (((a) > (b)) ? (a) : (b))
#define MIN(a,b) (((a) < (b)) ? (a) : (b))


/* *
 * Rounding operations (efficient when n is a power of 2)
 * Round down to the nearest multiple of n
 * */
#define ROUNDDOWN(a, n) ({                                          \
            size_t __a = (size_t)(a);                               \
            (typeof(a))(__a - __a % (n));                           \
        })

#define ROUNDUP(a, n) ({                                            \
            size_t __n = (size_t)(n);                               \
            (typeof(a))(ROUNDDOWN((size_t)(a) + __n - 1, __n));     \
        })

/* Return the offset of 'member' relative to the beginning of a struct type */
#define offsetof(type, member)                                      \
    ((size_t)(&((type *)0)->member))

/* *
 * to_struct - get the struct from a ptr
 * @ptr:    a struct pointer of member
 * @type:   the type of the struct this is embedded in
 * @member: the name of the member within the struct
 * */
#define to_struct(ptr, type, member)                               \
    ((type *)((char *)(ptr) - offsetof(type, member)))

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
#define INITOK "---------->"
#endif
