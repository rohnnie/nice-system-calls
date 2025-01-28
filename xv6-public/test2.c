#include "types.h"
#include "stat.h"
#include "user.h"

// Function to calculate and print prime numbers
void find_primes(int priority, int t) {
    int pid = getpid();
    // Set the process priority using the nice system call
    nice(pid, priority);

    int start_time = uptime();
    int i = 1;

    printf(1, "Started Current PID: %d, Priority: %d\n", pid, priority);

    while (1) {
        int  j;

        // Check if the number is a prime
        for (j = 2; j * j <= i; j++) {
            if (i % j == 0) {
                break;
            }
        }

        int current_time = uptime();
        if (current_time - start_time >= t) {
            int end_time = uptime();
            int execution_time = end_time - start_time;
            printf(1, "Finished Current PID: %d, Priority: %d, Execution Time: %d\n", pid, priority, execution_time);
            exit();
        }
        i++;
    }
}

int main() {
    int max_time = 1000;

    // Creating 3 children with same priority
    int p1 = fork();
    if (p1 == 0) {
        find_primes(2, max_time); 
        exit();
    }

  
    int p2 = fork();
    if (p2 == 0) {
        find_primes(2, max_time);
        exit();
    }

    int p3 = fork();
    if (p3 == 0) {
        find_primes(2, max_time);
        exit();
    }
    while(wait()!=-1);
    exit();
}
