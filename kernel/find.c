#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"


char* fmtname(char *path)
{
  char *p;

  for(p = path + strlen(path); p >= path && *p != '/'; p--);
  p ++;

  return p;
}

void find(char *path, char *p) 
{
  // fprintf(1, "%s %s\n", path, p);
  char buf[512], *ptr;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0) { // open file
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0) { // set up file stat
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type) {
  case T_FILE:  
    if(strcmp(fmtname(path), p) == 0) {
      printf("%s\n", path);
    }
    break;
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ > sizeof buf) {
      printf("find: path too long\n");
      break;
    }
    strcpy(buf, path);
    ptr = buf + strlen(buf);
    *ptr++ = '/';  // ./
    while(read(fd, &de, sizeof(de)) == sizeof(de)) { // dfs every file in directory
      //printf("%s %d\n", path, de.inum);
      if(de.inum == 0 || !strcmp(de.name, ".\0") || !strcmp(de.name, "..\0")) continue;
      memmove(ptr, de.name, strlen(de.name) + 1);
      find(buf, p);
    }
  }

  close(fd);
}

int main(int argc, char *argv[])
{  
    find(argv[1], argv[2]);
    exit(0);
}
