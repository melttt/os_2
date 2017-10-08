#include "memlayout.h"
#include "list.h"
#include "kdebug.h"
free_area_t free_area;


#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}


static void
default_init_memmap(struct Page *base, size_t n)
{
    assert(n > 0);
    struct Page *p = base;
    for( ; p != base + n ; p ++ )
    {
        assert(PageReserved(p));
        p->flags = 0;
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
    nr_free += n;
}

static struct Page *
default_alloc_pages(size_t n)
{
    assert(n > 0);
    if(n > nr_free)
    {
        return NULL;
    }

    list_entry_t *le, *len;
    le = &free_list;
    while((le=list_next(le)) != &free_list)
    {
       struct Page *p = le2page(le, page_link);
       if(p->property >= n)
       {
           int i;
           for(i = 0 ;i < n; i ++){
               len = list_next(le);
               struct Page *pp = le2page(le, page_link);
               SetPageReserved(pp);
               ClearPageProperty(pp);
               list_del(le);
               le = len;
           }
           if(p->property>n){
               (le2page(le,page_link))->property = p->property - n;
           }
           ClearPageProperty(p);
           SetPageReserved(p);
           nr_free -= n;
           return p;
       }
    }
    return NULL;
}


static void
default_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;

    while((le=list_next(le)) != &free_list) {
      p = le2page(le, page_link);
      if(p>base){
        break;
      }
    }
    
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
    set_page_ref(base, 0);
    ClearPageProperty(base);
    SetPageProperty(base);
    base->property = n;

    p = le2page(le,page_link) ;
    if( base+n == p ){
      base->property += p->property;
      p->property = 0;
    }

    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);

    if(le!=&free_list && p==base-1)
    {
        while(le!=&free_list){
            if(p->property){
                p->property += base->property;
                base->property = 0;
                break;
            }
            le = list_prev(le);
            p = le2page(le,page_link);
        }
    }
    nr_free += n;
}


static size_t
default_nr_free_pages(void) {
    return nr_free;
}


