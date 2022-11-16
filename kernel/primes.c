#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void create_child_process()
{
  int p;
  if(read(0, &p, sizeof(int)) <= 0) return;  // end condition
  printf("prime %d\n", p);

  int fd[2];
  pipe(fd);
  int pid;

  if((pid = fork()) == 0) {
    close(fd[1]);
    close(0);
    dup(fd[0]);
    close(fd[0]);
    create_child_process();
  } else if(pid > 0) {
    close(fd[0]);
    int n;
    while(read(0, &n, sizeof(int)) > 0) {
      if(n % p == 0) continue;
      write(fd[1], &n, sizeof(int));
    }
    close(fd[1]);
    wait(0);
  } else {
    fprintf(2, "primes: fork thread failed");
    exit(1);
  }  
  
}
int main(int argc, char *argv[])
{
  int fd[2]; // p->fd1[1] fd1[0]->c
  pipe(fd);  
  int pid;

  if((pid = fork()) == 0) {
    close(fd[1]);
    close(0);
    dup(fd[0]);
    close(fd[0]);
    create_child_process();
  } else if(pid > 0) {
    close(fd[0]);
    for(int i = 2; i < 36; i ++)
    {
      write(fd[1], &i, sizeof i);
    } 
    close(fd[1]);
    wait(0);
  }
  else
  {
    fprintf(2, "fork thread failed");
    exit(1);
  }
  exit(0);
}
