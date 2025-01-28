#include "types.h"
#include "user.h"
#include "param.h"

int main() {
    printf(1, "Test 2: Passing value as 8 in nice which is out of bounds.\n");
    int pid=2;
    int value=8;
    nice(pid,value);
    exit();
}