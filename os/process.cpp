#include"include/process.h"
#include<string>
#include<string.h>
void exit_proc(struct process* proc){
    free(proc->code);
    free(proc->buf);
    proc->process_state=Finish;
    return;
}
int parse_global_var_line(char *line, int *start_addr,int cur_offset) {
    int cnt = 0;
    char *tok = strtok(line, " ,\t\n");
    if((Process_mem-cur_offset)<=0) return -1;
    int *values=(int*)((char*)start_addr+cur_offset);
    while (tok) {
        if(cnt>=(Process_mem-cur_offset)/sizeof(int)) return -1;
        if (strcmp(tok, ".word") != 0) {  // 跳过 .word
            values[cnt++] = atoi(tok);
        }
        tok = strtok(NULL, " ,\t\n");
    }
    return cnt; // 返回解析到的数字个数
}
int init_proc(struct process* proc){
    char** lines=proc->code;
    int pc_line_cnt=0;
    std::unordered_map<std::string, int> symbol_table;
    std::unordered_map<std::string, int> global_var_dict;
    uint32_t next_global_offset=global_variable_offset;
    while(strstr(lines[pc_line_cnt],"text")==NULL){
        char* colon_pos = strchr(lines[pc_line_cnt], ':');
        if (colon_pos != NULL) {
            int name_len = colon_pos - lines[pc_line_cnt];
            char* var_name=(char*)malloc(name_len+1);
            strncpy(var_name, lines[pc_line_cnt], name_len);
            var_name[name_len] = '\0'; 
            pc_line_cnt++;
            if(next_global_offset>=Process_mem){
                free(var_name);
                printf("Segmentation fault,expand memory config.h\n");
                return -1;
            }
            if(strstr(lines[pc_line_cnt], ".word") != NULL){
                global_var_dict.insert({std::string(var_name),next_global_offset});
                free(var_name);
                char* line_cpy=(char*)malloc(strlen(lines[pc_line_cnt]) + 1);
                strcpy(line_cpy,lines[pc_line_cnt]);
                int cnt=parse_global_var_line(line_cpy,(int*)proc->start_mem,next_global_offset);
                free(line_cpy);
                if(cnt<0){
                    printf("Segmentation fault,expand memory config.h\n");
                    return -1;
                }
                else next_global_offset+=cnt*4;
            }
            else {
                printf("wrong in global value");
                return -1;
            }
        }
        pc_line_cnt++;
    }
    for(int i=pc_line_cnt;i<proc->code_line_num;i++){
        char* colon_pos = strchr(lines[i], ':');
        if(colon_pos!=NULL){
            int name_len = colon_pos - lines[i];
            std::string str(lines[i]);
            symbol_table.insert({str.substr(0,name_len),i});
        }
    }
    proc->symbol_table=symbol_table;
    proc->global_var_dict=global_var_dict;
    proc->process_state=Running;
    proc->context.next_pc=pc_line_cnt;
    memset(proc->context.reg,0,sizeof(proc->context.reg));
    proc->context.reg[2]=STACK_SIZE; // set sp to stack size
    return 0;
}