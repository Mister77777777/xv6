#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

#define READ 0
#define WRITE 1

void primes(int num[],int size)
{
    int my_pipe[2];
    pipe(my_pipe);
    if(fork() > 0)   /*write to right pipe*/
    {
        close(my_pipe[READ]); 

        for(int i=0;i<size;i++)
        write(my_pipe[WRITE],&num[i],sizeof(num[i]));

        close(my_pipe[WRITE]);
        wait(0);
    }
    else  /*read left pipe*/
    {
        close(my_pipe[WRITE]);
        int chr_num[34],index=0;
        int tmp,min;
        while(1)
        {
            if(read(my_pipe[READ],&tmp,sizeof(tmp)))
            {
                if(index ==0)
                {
                    min =tmp;
                    printf("prime %d\n",min);
                    index++;
                }
                if(tmp%min != 0) /* not primes*/
                {
                    chr_num[index-1]=tmp;
                    index++;
                }
            }
            else
            break;
        }
        close(my_pipe[READ]);
        primes(chr_num,index-1);
        exit(0);

    }
}

int main(int argc,char *argv[])
{
    int num[34];
    for (int i=2,index =0;i<=35;i++)
    {
        num[index]=i;
        index++;
    }
    primes(num,34);
    exit(0);
}