#include "kdebug.h"
#include "defs.h"
#include "stabs.h"
#include "stdio.h"
#include "string.h"
extern const struct stab __STAB_BEGIN__[];  // beginning of stabs table
extern const struct stab __STAB_END__[];    // end of stabs table
extern const char __STABSTR_BEGIN__[];      // beginning of string table
extern const char __STABSTR_END__[];        // end of string table

/* *
 * stab_binsearch - according to the input, the initial value of
 * range [*@region_left, *@region_right], find a single stab entry
 * that includes the address @addr and matches the type @type,
 * and then save its boundary to the locations that pointed
 * by @region_left and @region_right.
 *
 * Some stab types are arranged in increasing order by instruction address.
 * For example, N_FUN stabs (stab entries with n_type == N_FUN), which
 * mark functions, and N_SO stabs, which mark source files.
 *
 * Given an instruction address, this function finds the single stab entry
 * of type @type that contains that address.
 *
 * The search takes place within the range [*@region_left, *@region_right].
 * Thus, to search an entire set of N stabs, you might do:
 *
 *      left = 0;
 *      right = N - 1;    (rightmost stab)
 *      stab_binsearch(stabs, &left, &right, type, addr);
 *
 * The search modifies *region_left and *region_right to bracket the @addr.
 * *@region_left points to the matching stab that contains @addr,
 * and *@region_right points just before the next stab.
 * If *@region_left > *region_right, then @addr is not contained in any
 * matching stab.
 *
 * For example, given these N_SO stabs:
 *      Index  Type   Address
 *      0      SO     f0100000
 *      13     SO     f0100040
 *      117    SO     f0100176
 *      118    SO     f0100178
 *      555    SO     f0100652
 *      556    SO     f0100654
 *      657    SO     f0100849
 * this code:
 *      left = 0, right = 657;
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
    static void 
stab_binsearch(struct stab *stabs, int *region_left, int *region_right,
        int type, uint addr)
{
    int l = *region_left , r = *region_right;
    int m, true_m;
    int have_matches = 0;
    //    int true_addr = addr;
    while(l <= r)
    {
        true_m = (l + r) / 2;
        m = true_m;
        while(m >= l && stabs[m].n_type != type)
            m --;
        if(m < l)
        {
            l = true_m + 1;
            continue;
        }

        //find a stab
        have_matches = 1;
        if(stabs[m].n_value < addr)
        {
            *region_left = m;
            l = true_m + 1;
        }else if(stabs[m].n_value > addr)
        {
            *region_right = m;
            r = m - 1;
        }else{
            *region_left = m;
            addr ++;
            l = m;
        }
    }
    if(!have_matches)
    {
        *region_right = *region_left - 1;
    }
}
#define MAX_FN_NAME 30
struct eipdebuginfo {
    const char *eip_file;                   // source code filename for eip
    char eip_fn_name[MAX_FN_NAME];                // name of function containing eip
};
static int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
    struct stab *stab_begin =(struct stab*)__STAB_BEGIN__ , *stab_end = (struct stab*)__STAB_END__;
    char * strst_begin = (char*)__STABSTR_BEGIN__;
    char* tmp;
    int tmplen;
    int left, right;
    //ignore the first one
    stab_begin ++; 
    left = 0;
    right = (stab_end - stab_begin) - 1;

    //find the name of file
    stab_binsearch(stab_begin, &left, &right, N_SO, addr);
    if(left > right) return -1;

    info->eip_file = stab_begin[left].n_strx + strst_begin;

    // find the name of function
    stab_binsearch(stab_begin, &left, &right, N_FUN, addr);
    if(left > right) return -1;

    //copy to info
    tmp = stab_begin[left].n_strx + strst_begin;
    tmplen = strfind(tmp,':') - tmp;
    strncpy(info->eip_fn_name, tmp, tmplen);
    info->eip_fn_name[tmplen] = '\0';

    return 1;
}

void
print_stack_trace()
{
    uint32_t *ebp,*eip;
    struct eipdebuginfo info;
    asm volatile("movl %%ebp,%0" : "=r" (ebp));
    while(ebp)
    {
        eip = ebp + 1;
        if(*eip == 0) break;
        debuginfo_eip(*eip, &info);                
        cprintf("eip : %x , file : %s, function : %s \n",*eip,  info.eip_file, info.eip_fn_name);
        ebp = (uint32_t*)(*ebp);
    }
}
void
print_cur_status()
{
    static int round = 0;
    uint16_t reg1,reg2,reg3,reg4;

    asm volatile( "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));

    cprintf("%d: @ring %d\n", round, reg1&0x3);
    cprintf("%d: cs = %x\n", round, reg1);
    cprintf("%d: ds = %x\n", round, reg2);
    cprintf("%d: es = %x\n", round, reg3);
    cprintf("%d: ss = %x\n", round, reg4);
    ++ round; 

}

static bool is_panic = 0;
void  
__panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
    {
        goto panic_dead;
    }
    is_panic = 1;
    va_list ap;
    va_start(ap, fmt);
    cprintf("*****************PANIC!!!*******************\n");
    cprintf("kernel panic at %s:%d:\n", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");
    print_stack_trace();
    va_end(ap);
panic_dead:
    while(1)
    {
        ;
    }
}

