#ifndef _KERN_MM_SWAP_H_
#define _KERN_MM_SWAP_H_
#include "defs.h"
extern volatile bool swap_init_ok;
extern size_t max_swap_offset;
/* *
 * swap_offset - takes a swap_entry (saved in pte), and returns
 * the corresponding offset in swap mem_map.
 * */
#define swap_offset(entry) ({                                       \
               size_t __offset = (entry >> 8);                        \
               if (!(__offset > 0 && __offset < max_swap_offset)) {    \
                    panic("invalid swap_entry_t = %08x.\n", entry);    \
               }                                                    \
               __offset;                                            \
          })



#endif
