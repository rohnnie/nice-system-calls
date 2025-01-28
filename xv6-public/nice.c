#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "param.h"

int
main(int argc, char *argv[])
{
  int priority, pid=-1;
  // old_priority=-1;
  if(argc < 2 || argc > 3){
    printf(2,"Usage: nice pid priority\n");
    exit();
  }
  if(argc==2){
    //change the priority of the current process to the priority given in prompt
    priority = atoi(argv[1]);
    if (priority < 0 || priority > 5){
      printf(2,"Invalid priority (0-5)!\n");
      exit();
    }
    int current_pid=getpid();
    int res=nice(current_pid,priority);
    printf(1,"%d %d\n",res/MOD,res%MOD);
    exit();
  }
  else{
    //if three arguments are given
    priority = atoi(argv[2]);
    if (priority < 0 || priority > 5){
      printf(2,"Invalid priority (0-5)!\n");
      exit();
    }
    pid = atoi(argv[1]);
    int res=nice(pid,priority);
    printf(1,"%d %d\n",res/MOD,res%MOD);
    exit();
  }
}