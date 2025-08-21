#include "include/os.h"
#include <sys/mman.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string>
#include <unordered_map>
const char* delim = " ,\t\n";
const int MAX_TOKENS=6;
static std::unordered_map<std::string, int> reg_str2int;
int do_syscall(std::string name,int x10,int x11,int x12,int x13,int x14,int x15,int* ret_addr,process* proc);
int do_console(std::string name,int x10,int x11,int x12,int x13,int x14,int x15,int* ret_addr);
void init_os(struct os* nos)
{    
    nos->process_mem_size=Process_mem;
    nos->memory_pool = mmap(NULL, MaxProcess *  nos->process_mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    /*
    +---------------------+
    |                     |
    |       stack         |
    |                     |
    |                     |
    |---------------------|                      
    |                     | 
    |   global variable   |               
    |                     | 
    |                     |
    +---------------------+  

    */
    for(int i=0;i<32;i++){
        nos->cpu.reg[i]=0;
    }
    for (int i = 0; i <32; i++) {
        reg_str2int["x" + std::to_string(i)] = i;
    }
    reg_str2int["t"+std::to_string(0)]=5;
    reg_str2int["t"+std::to_string(1)]=6;
    reg_str2int["t"+std::to_string(2)]=7;
    reg_str2int["sp"]=2;
    nos->cpu.pc=0;
}
void exit_os(struct os* nos)
{
    for(int i=0;i<nos->process_count;i++){
        if(nos->process[i].process_state!=Finish){
            exit_proc(&nos->process[i]);
        }
    }
    if (nos->memory_pool) {
        munmap(nos->memory_pool, nos->process_mem_size*MaxProcess);
        nos->memory_pool = NULL;
    }
}
int step(struct process* proc, struct os* nos)
{
    if(proc->process_state==Start){
        if(init_proc(proc)<0) return -1;
        else return 0;
    }
    else if(proc->process_state==Running){
        char** lines=proc->code;
        nos->cpu.pc=proc->context.next_pc;
        memmove(nos->cpu.reg, proc->context.reg, sizeof(int) * 32);
        while(1){
            //printf("%d\n",nos->cpu.pc);
            char *line = lines[nos->cpu.pc];
            if (line[0] == '.' || strstr(line, ":")!=NULL) {
                nos->cpu.pc++;
                continue;
            }
            else{  
                int count = 0;
                char *tokens[MAX_TOKENS];
                char* line_cpy=(char*)malloc(strlen(line) + 1);
                strcpy(line_cpy,line);
                char *p = strtok(line_cpy, delim);
                while (p && count < MAX_TOKENS) {
                    tokens[count++] = p;  
                    p = strtok(NULL, delim);
                }
                char* op=tokens[0];

                if(strcmp(op,"li")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=std::stoi(arg2);
                }
                else if(strcmp(op,"la")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=proc->global_var_dict[std::string(arg2)];
                }
                else if(strcmp(op,"mv")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]];
                }
                else if(strcmp(op,"add")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]]+ nos->cpu.reg[reg_str2int[std::string(arg3)]];
                }
                else if(strcmp(op,"addi")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]]+std::stoi(arg3);
                }
                else if(strcmp(op,"sub")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]]- nos->cpu.reg[reg_str2int[std::string(arg3)]];
                }
                else if(strcmp(op,"mul")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]]* nos->cpu.reg[reg_str2int[std::string(arg3)]];
                }
                else if(strcmp(op,"div")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]= nos->cpu.reg[reg_str2int[std::string(arg2)]]/nos->cpu.reg[reg_str2int[std::string(arg3)]];
                }
                else if(strcmp(op,"divu")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=(int)((uint32_t)nos->cpu.reg[reg_str2int[std::string(arg2)]]/nos->cpu.reg[reg_str2int[std::string(arg3)]]);
                }
                else if(strcmp(op,"rem")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=nos->cpu.reg[reg_str2int[std::string(arg2)]]%nos->cpu.reg[reg_str2int[std::string(arg3)]];
                }
                else if(strcmp(op,"urem")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=(int)((uint32_t)nos->cpu.reg[reg_str2int[std::string(arg2)]]%nos->cpu.reg[reg_str2int[std::string(arg3)]]);
                }
                else if(strcmp(op,"slli")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=nos->cpu.reg[reg_str2int[std::string(arg2)]]<<std::stoi(arg3);
                } 
                else if(strcmp(op,"xor")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=nos->cpu.reg[reg_str2int[std::string(arg2)]] ^ nos->cpu.reg[reg_str2int[std::string(arg3)]];
                } 
                else if(strcmp(op,"xori")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=nos->cpu.reg[reg_str2int[std::string(arg2)]] ^ std::stoi(arg3);
                } 
                else if(strcmp(op,"seqz")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    if(nos->cpu.reg[reg_str2int[std::string(arg2)]]==0) nos->cpu.reg[reg_str2int[std::string(arg1)]]=1;
                    else nos->cpu.reg[reg_str2int[std::string(arg1)]]=0;
                }
                else if(strcmp(op,"snez")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    if(nos->cpu.reg[reg_str2int[std::string(arg2)]]!=0) nos->cpu.reg[reg_str2int[std::string(arg1)]]=1;
                    else nos->cpu.reg[reg_str2int[std::string(arg1)]]=0;
                }
                else if(strcmp(op,"slt")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    if(nos->cpu.reg[reg_str2int[std::string(arg2)]]<nos->cpu.reg[reg_str2int[std::string(arg3)]]) nos->cpu.reg[reg_str2int[std::string(arg1)]]=1;
                    else nos->cpu.reg[reg_str2int[std::string(arg1)]]=0;
                } 
                else if(strcmp(op,"sgt")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char* arg3=tokens[3];
                    if(nos->cpu.reg[reg_str2int[std::string(arg2)]]>nos->cpu.reg[reg_str2int[std::string(arg3)]]) nos->cpu.reg[reg_str2int[std::string(arg1)]]=1;
                    else nos->cpu.reg[reg_str2int[std::string(arg1)]]=0;
                } 
                else if(strcmp(op,"j")==0){
                    char* arg1=tokens[1];
                    nos->cpu.pc=proc->symbol_table[std::string(arg1)];
                }
                else if(strcmp(op,"bnez")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    if(nos->cpu.reg[reg_str2int[std::string(arg1)]]!=0) nos->cpu.pc=proc->symbol_table[std::string(arg2)];
                }
                else if(strcmp(op,"jal")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    if(proc->symbol_table.find(std::string(arg2))!=proc->symbol_table.end()){
                        nos->cpu.reg[reg_str2int[std::string(arg1)]]=nos->cpu.pc;
                        nos->cpu.pc=proc->symbol_table[std::string(arg2)];
                    }
                    else{
                        int ret=do_syscall(std::string(arg2),nos->cpu.reg[reg_str2int["x10"]],
                            nos->cpu.reg[reg_str2int["x11"]],nos->cpu.reg[reg_str2int["x12"]]
                        ,nos->cpu.reg[reg_str2int["x13"]],nos->cpu.reg[reg_str2int["x14"]],
                        nos->cpu.reg[reg_str2int["x15"]],&(nos->cpu.reg[reg_str2int["x10"]]),proc);
                        if(ret==-1){
                            ret=do_console(std::string(arg2),nos->cpu.reg[reg_str2int["x10"]],
                            nos->cpu.reg[reg_str2int["x11"]],nos->cpu.reg[reg_str2int["x12"]]
                        ,nos->cpu.reg[reg_str2int["x13"]],nos->cpu.reg[reg_str2int["x14"]],
                        nos->cpu.reg[reg_str2int["x15"]],&(nos->cpu.reg[reg_str2int["x10"]]));
                        }
                        if(ret<0){
                            printf("unrecoginze syscall:%s\n",std::string(arg2).c_str());
                            proc->process_state=Finish;
                            exit_proc(proc);
                        }
                    }
                }
                else if(strcmp(op,"ret")==0){
                    nos->cpu.pc= nos->cpu.reg[reg_str2int[std::string("x1")]];
                }
                else if(strcmp(op,"lw")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char reg_name[16];
                    int offset=0;
                    memset(reg_name,0,sizeof(reg_name));
                    sscanf(arg2, "%d(%15[^)])", &offset, reg_name); 
                    int base = nos->cpu.reg[reg_str2int[std::string(reg_name)]];
                    if(offset+base>Process_mem||(reg_str2int[std::string(reg_name)]==2&&offset>MAX_SP_OFFSET)){
                        printf("segmentation fault,please expand the Stack and MAX_SP_OFFSET in config.h\n");
                        return -1;
                    }
                    nos->cpu.reg[reg_str2int[std::string(arg1)]]=*(int*)((char*)proc->start_mem+offset+base);
                }
                else if(strcmp(op,"sw")==0){
                    char* arg1=tokens[1];
                    char* arg2=tokens[2];
                    char reg_name[16];
                    int offset=0;
                    memset(reg_name,0,sizeof(reg_name));
                    sscanf(arg2, "%d(%15[^)])", &offset, reg_name); 
                    int base = nos->cpu.reg[ reg_str2int[std::string(reg_name)]];
                    if(offset+base>Process_mem||(reg_str2int[std::string(reg_name)]==2&&offset>MAX_SP_OFFSET)){
                        printf("segmentation fault,please expand the Stack and MAX_SP_OFFSET in config.h\n");
                        return -1;
                    }
                    *(int*)((char*)proc->start_mem+offset+base)=nos->cpu.reg[reg_str2int[std::string(arg1)]];
                }
                else{
                    printf("unreconginzed op %s\n",tokens[0]);
                    free(line_cpy);
                    return -1;
                }
                nos->cpu.pc+=1;
                proc->context.next_pc=nos->cpu.pc;
                memmove(proc->context.reg,nos->cpu.reg, sizeof(int) * 32);
                free(line_cpy);
                break;
            }
        }
    }
    return 0;
}