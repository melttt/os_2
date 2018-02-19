#include "basic_p.h"
#include "timer.h"
volatile uint32_t ktime = 0;

uint32_t get_time()
{
    return ktime;
}
