#if 0
#include "basic_p.h"
#include "sleeplock.h"
#include "proc.h"
#include "sche.h"
#include "kdebug.h"
#include "cpu.h"
void
initsleeplock(struct sleeplock *lk, char *name)
{
  init_lock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = CUR_PROC->pid;
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
}

bool
holdingsleep(struct sleeplock *lk)
{
  bool r;
  
  acquire(&lk->lk);
  r = lk->locked;
  release(&lk->lk);
  return r;
}

#endif
