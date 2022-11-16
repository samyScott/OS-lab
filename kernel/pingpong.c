#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
  int fd1[2], fd2[2];
  pipe(fd1), pipe(fd2); // fd1 p->c fd2 c->p
  char buf1[2], buf2[2];

  char *str = "a";
  int pid;
  if((pid = fork()) == 0) //child
  {
    close(fd1[1]);
    read(fd1[0], buf1, sizeof buf1); 
    close(fd1[0]);   
    printf("%d: received ping\n", getpid());
    close(fd2[0]);
    write(fd2[1], str, strlen(str));
    close(fd2[1]);
  }
  else if(pid > 0)
  {
    close(fd1[0]);
    write(fd1[1], str, strlen(str));
    close(fd1[1]);
    close(fd2[1]);
    read(fd2[0], buf2, sizeof buf2);
    printf("%d: received pong\n", getpid());
    close(fd2[0]);
  }
  else
  {
    fprintf(2, "fork pid failed");
    exit(1);
  }

  exit(0);
}
