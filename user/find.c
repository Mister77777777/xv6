#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path , char *filename)
{
    char buf[512], *tmp;
    int file;
    struct dirent de;
    struct stat st;

    if((file = open(path, 0)) < 0)
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(file, &st) < 0)
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(file);
        return;
    }
    if(st.type == T_FILE)
    {
        if(strcmp( path + strlen(path) - strlen(filename) , filename ) ==0)
            {
                 printf("%s\n", path);
            }
    }
    if(st.type == T_DIR)
    {
         if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
            {
                printf("find: path too long\n");
            }
            strcpy(buf, path);
            tmp = buf+strlen(buf);
            *tmp++ = '/';

            while(read(file, &de, sizeof(de)) == sizeof(de))
            {
                if(de.inum == 0)
                    continue;
                memmove(tmp, de.name, DIRSIZ);
                tmp[DIRSIZ] = 0;
                if(stat(buf, &st) < 0)
                {
                    printf("find: cannot stat %s\n", buf);
                    continue;
                }

                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
                find(buf, filename);
                
            }
    }
    close(file);

}


int main(int argc, char *argv[])
{
    if(argc != 3)
    {
        printf("input arguments : find <path> <file name>\n");
        exit(1);
    }
   
    find(argv[1], argv[2]);
    exit(0);
}
