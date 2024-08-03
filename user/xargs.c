#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include"kernel/param.h"

int main(int argc,char * argv[])
{
    char *new_argv[MAXARG];
    int index =0;
    char block[32],buf[32];
    int buf_index=0;
    char *tmp =buf;

    for(int i=1;i<argc;i++)
    new_argv[index++]=argv[i];
    int k;

    while(1)
    {
        if((k = read(0, block, sizeof(block))) > 0)
        {
            for(int i=0;i<k;i++)
            {
                if(block[i]=='\n')
                {
                    buf[buf_index]=0;
                    new_argv[index]=tmp;
                    index++;
                    new_argv[index]=0;
                    buf_index=0;
                    tmp=buf;
                    index=argc-1;
                    if(fork()==0)
                    exec(argv[1],new_argv);
                    wait(0);
                }
                else if(block[i]==' ')
                {
                    buf[buf_index]=0;
                    buf_index++;
                    new_argv[index]=tmp;
                    index++;
                    tmp=&buf[buf_index];
                }
                else
                {
                    buf[buf_index]=block[i];
                    buf_index++;
                }
            }
        }
        else
        break;
    }
    exit(0);


}