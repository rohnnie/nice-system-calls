#include "types.h"
#include "stat.h"
#include "user.h"

void prime() {
  int num = 2;  // Start from 2, since 1 is not a prime number
  while (num < 7) {
    int prime = 1;
    int i;
    for (i = 2; i * i <= num; i++) {  // Corrected condition to i * i <= num
      if (num % i == 0) {
        prime = 0;
        break;
      }
    }
    if (prime) {
      printf(1, "Pid: %d, Prime: %d\n", getpid(), num);
    }
    num++;
  }
}


int main() {
  printf(1,"-------------- Test Case 1 with Custom Scheduler ---------\n");
  printf(1,"Lowering the Parent's Priority Below the Child's Priority\n");
  int pid = fork();
  sleep(200); // to process changing the pid
  if (pid < 0) {
      printf(2, "Fork fail in pid: %d\n", getpid());
      exit();
  }
  if (pid > 0) {
    printf(1, "Change Parents priority to 1 with pid=%d\n", getpid());
    nice(getpid(), 1);
  }
  if (pid == 0) {
    printf(1, "Child process with pid=%d\n", getpid());
    // nice(getpid(),5);
    prime();
    exit();
  } else {
    printf(1, "Parent process with pid=%d\n", getpid());
    prime();
    wait();
    exit();
  }
  exit();
}
