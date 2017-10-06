#include "kdebug.h"
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
void stab_binsearch(struct stab *stabs, int *region_left, int *region_right,
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
    }else{
        ;
    }
}
