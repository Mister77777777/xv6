#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

#define READ 0
#define WRITE 1

int main(int argc,char *argv[])
{
    if(argc !=1)
    printf("don't input arguments\n");  /*no input*/

    int pipeParToChr[2];
    int pipeChrToPar[2];
    char buf[8];

    pipe(pipeParToChr);
    pipe(pipeChrToPar);

    int pid = fork();
    if(pid ==0)  /*child*/
    {
        close(pipeParToChr[WRITE]);
        read(pipeParToChr[READ],buf,sizeof(buf));
        close(pipeParToChr[READ]);
        /*read*/

        close(pipeChrToPar[READ]);
        write(pipeChrToPar[WRITE],"pong\n",5);
        close(pipeChrToPar[WRITE]);

        printf("%d: received %s\n",getpid(),buf);
        exit(0);
    }
    else  /*parent*/
    {
        close(pipeParToChr[READ]);
        write(pipeParToChr[WRITE],"ping\n",5);
        close(pipeParToChr[WRITE]);

        close(pipeChrToPar[WRITE]);
        read(pipeChrToPar[READ],buf,sizeof(buf));
        close(pipeChrToPar[READ]);
        wait(0);    /*parent should exit after child*/

        printf("%d: received %s\n",getpid(),buf);
        exit(0);

    }



}