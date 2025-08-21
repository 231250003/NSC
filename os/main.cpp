#include "include/os.h"
#include <stdlib.h>
#include <time.h>  
#include <stdio.h>
#include <sys/stat.h> 
#include <string.h>
char* load_file_to_memory(const char* filename) {
    FILE* file = fopen(filename, "rb");
    if (!file) {
        perror("Failed to open file");
        return NULL;
    }

    // 获取文件大小
    struct stat st;
    if (fstat(fileno(file), &st) != 0) {
        perror("Failed to get file size");
        fclose(file);
        return NULL;
    }
    size_t file_size = st.st_size;

    // 分配内存（+1用于可能的null终止符）
    char* buffer = (char*)malloc(file_size + 1);
    if (!buffer) {
        perror("Memory allocation failed");
        fclose(file);
        return NULL;
    }

    // 读取文件内容
    size_t bytes_read = fread(buffer, 1, file_size, file);
    if (bytes_read != file_size) {
        perror("Failed to read file");
        free(buffer);
        fclose(file);
        return NULL;
    }

    // 可选：添加null终止符（如果是文本文件）
    buffer[file_size] = '\0';
    fclose(file);
    return buffer;
}

int split_lines(char* code,char*** out_lines) {
    if(code==NULL) return -1;
    int line_count=0;
    char **lines = NULL;
    for (char* p=strtok(code, "\n"); p; p=strtok(NULL, "\n")) {
        char **tmp = (char**)realloc(lines, (line_count + 1) * sizeof(char *));
        if (!tmp) { perror("realloc"); free(lines); return -1; }
        lines = tmp;
        lines[line_count++] = p;
    }
    *out_lines = lines;
    return line_count;
}


int main(int argc, char *argv[]){
    struct os nos;
    init_os(&nos);
     if (argc <= 1) {
        printf("Usage: %s <path1> <path2> ...\n", argv[0]);
        return 1;
    }
    if(argc-1>MaxProcess){
        printf("cannot run more than %d process concurrently\n",MaxProcess);
        return 1;
    }
    nos.process_count=argc-1;
    for(int i=0;i<nos.process_count;i++){
        char* buf=load_file_to_memory(argv[i+1]);
        int line_num=split_lines(buf,&nos.process[i].code);
        if(line_num<0){
            printf("path not found\n");
            return -1;
        }
        else  nos.process[i].code_line_num=line_num;
        nos.process[i].start_mem=(char*)nos.memory_pool+(i*nos.process_mem_size);
        nos.process[i].process_state=Start;
        nos.process[i].buf=buf;
    }
    uint32_t process_loop_cnt=0;
    while(1){
        bool flag=false;
        for(int i=0;i<nos.process_count;i++){
            if(nos.process[i].process_state!=Finish) flag=true;
        }
        if(flag){
            int cur_processs_id=process_loop_cnt%nos.process_count;
            if(step(&(nos.process[cur_processs_id]),&nos)<0){
                exit_proc(&nos.process[cur_processs_id]);
                exit_os(&nos);
                return -1;
            } 
            process_loop_cnt++;
        }
        else break;
    }
    exit_os(&nos);
    return 0;
}
