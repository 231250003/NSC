#include"include/syscall.h"
#include"include/process.h"
#include<stdio.h>
#include <string>
#include <unistd.h>
#include <sys/syscall.h>
int read(int type){
    if(type==0){
        char s;
        scanf("%c",&s);
        return (int)s;
    }
    else if(type==1){
        int s;
        scanf("%d",&s);
        return s;
    }
    else{
        printf("unsupported type\n");
        return 0;
    }
}
void print(int type,int c){
    if(type==0){
        printf("%c",(char)c);
    }
    else if(type==1){
        printf("%d",c);
    }
}
void usleep_(int time){
    usleep(time);
}
void exit(process *process){
   process->process_state=Finish;
}
int gettimeofday_(){
    struct timeval tv;
    syscall(SYS_gettimeofday, &tv, 0);
    return (int)(tv.tv_usec);        
}
int do_syscall(std::string name,int x10,int x11,int x12,int x13,int x14,int x15,int* ret_addr,process* process){
    if(name=="read"){
        *ret_addr=read(x10);
        return 0;
    }
    else if(name=="usleep_"){
        usleep_(x10);
        return 0;
    }
    else if(name=="gettimeofday_"){
        *ret_addr=gettimeofday_();
        return 0;
    }
    else if(name=="print"){
        print(x10,x11);
        return 0;
    }
    else if(name=="exit"){
        exit(process);
        //exit_proc(process);
        return 0;
    }
    else{
        return -1;
    }
}