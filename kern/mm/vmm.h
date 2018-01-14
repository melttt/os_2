#ifndef _KERN_MM_VM_H_
#define _KERN_MM_VM_H_

#include "defs.h"
#include "list.h"
#include "memlayout.h"

int32_t init_kvm(void);

extern pte_t *kpgdir;
extern volatile unsigned int pgfault_num;


/******************************************************************************/


struct mm_struct;

// the virtual continuous memory area(vma)
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT
    uintptr_t vm_start;      //    start addr of vma
    uintptr_t vm_end;        // end addr of vma
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma
};

#define le2vma(le, member)                  \
    to_struct((le), struct vma_struct, member)

#define VM_READ                 0x00000001
#define VM_WRITE                0x00000002
#define VM_EXEC                 0x00000004
#define VM_STACK                0x00000008

// the control struct for a set of vma using the same PDT
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 // the count of these vma
    void *sm_priv;                   // the private data for swap manager
};

//vmm 
struct vma_struct *find_vma(struct mm_struct *mm, uintptr_t addr);
struct vma_struct *vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags);
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma);
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write);

//mm
struct mm_struct *mm_create(void);
void mm_destroy(struct mm_struct *mm);
bool mm_setup_pgdir(struct mm_struct *mm);

//function when page default
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr);

//page fuction
void vmm_init(void);
void check_vmm(void);
pte_t* read_pte_addr(pde_t *pgdir, uintptr_t va, int32_t alloc);
void page_remove(pde_t *pgdir, uintptr_t la);

#endif
