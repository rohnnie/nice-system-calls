#include "types.h"
#include "user.h"
#include "param.h"

int main() {
    printf(1, "Test 3: Changing the value of a process that does not exist.\n");
    nice(70,3);
    exit();
}