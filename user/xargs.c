#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[])
{
  for(int i = 1; i < argc; i ++) argv[i - 1] = argv[i];
  char args[MAXARG];
  int i = 0, pid;

  while(read(0, args + i, sizeof(char)) > 0) {
    i ++;
    if(args[i - 1] == '\n') {
      args[i - 1] = '\0';

      if((pid = fork()) == 0) { //child
	argv[argc - 1] = args;
        exec(argv[0], argv);
      } else if(pid > 0){
        i = 0;
	wait(0);
      } else {
	fprintf(2, "xargs: fork thread failed");
	exit(1);
      }
    }
  }
  exit(0);
}
