#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include<string>
#include "include/console.h"
void clear_screen()
{
    system("clear");
}
void set_cursor(int x, int y)
{
    printf("\033[%d;%dH", y + 1, x + 1);
}
int get_key()
{
    int ch;
    struct termios oldt, newt;
    int oldf;

    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

    ch = getchar();

    //tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    fcntl(STDIN_FILENO, F_SETFL, oldf);

    if (ch != EOF)
    {
        return ch;
    }
    return 0;
}
int do_console(std::string name,int x10,int x11,int x12,int x13,int x14,int x15,int* ret_addr){
    if(name=="clear_screen"){
        clear_screen();
        return 0;
    }
    else if(name=="set_cursor"){
        set_cursor(x10,x11);
        return 0;
    }
    else if(name=="get_key"){
        *ret_addr=get_key();
        return 0;
    }
    else return -1;
}