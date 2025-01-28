#include "types.h"
#include "user.h"
#include "param.h"

int main() {
    printf(1, "Test 1: Nice Value\n");
    int i;
    for(i=4;i>1;i=i-2){
      int value = i;
      int res = nice(getpid(),value);
      if (res < 0) {
          printf(1, "Failed: Unable to Change Value\n");
      } else {
          printf(1, "Current PID: %d, Old_Value: %d, New Value: %d\n", res/MOD, res%MOD, value);
      }
    }
    exit();
}