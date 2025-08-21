#include <cstdint>
#include<set>
#include<string>
#include<unordered_map>
#include "../../config.h"
enum Process_state{
    Start,
    Running,
    Finish
};
struct context{
    int reg[32]={0};
    int next_pc=0;
};
struct process{
    void* start_mem;
    int mem_size;
    int pid;
    enum Process_state process_state;
    char** code;
    char* buf;
    std::unordered_map<std::string, int> symbol_table;
    std::unordered_map<std::string, int> global_var_dict;
    uint32_t code_line_num;
    struct context context;
};
void exit_proc(struct process* proc);
int init_proc(struct process* proc);