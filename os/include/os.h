#include "process.h"
#include<stddef.h>
#define MaxProcess 8
struct cpu_state{
    int reg[32];
    int pc;
};
struct os{
    struct process process[MaxProcess];
    void* memory_pool;
    int process_mem_size;
    int process_count;
    struct cpu_state cpu;
};

void init_os(struct os* nos);
void exit_os(struct os* nos);
int step(struct process* proc, struct os* nos);
