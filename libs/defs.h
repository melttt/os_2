#ifndef _LIBS_DEFS_H_
#define _LIBS_DEFS_H_

#ifndef NULL
#define NULL ((void *)0)
#endif

typedef int bool;

typedef char int8_t;
typedef unsigned char uchar;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short ushort;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;



typedef int32_t intptr_t;
typedef uint32_t uintptr_t;

/* size_t is used for memory object sizes */
typedef uintptr_t size_t;

/* used for page numbers */
typedef size_t ppn_t;


#endif
