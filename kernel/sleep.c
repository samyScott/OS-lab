#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int 
main(int argc, char *argv[])
{
  int time;

  if(argc <= 1)
  {
    fprintf(2, "no sleep time");
    exit(1);
  }

  time = atoi(argv[1]);
  if(time < 0)
  {
    fprintf(2, "time of sleep should postive");
    exit(1);
  }

  sleep(time);
  exit(0);
} 