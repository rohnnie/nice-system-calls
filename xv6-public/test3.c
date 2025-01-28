#include "types.h"
#include "stat.h"
#include "user.h"

// Function to calculate and print prime numbers up to 1000
void calculate_primes(int priority, int t) {
    int pid = getpid();
    // Set the process priority using the nice system call
    nice(pid,priority);
    int i,j;
    int start_time = uptime();
    int prime_count = 0;

    printf(1, "Started Current PID: %d, Priority: %d\n", pid, priority);

    // Loop to find all prime numbers up to 1000
    for (i = 2; i <= 1000000; i++) {
        int is_prime = 1;
        for (j = 2; j * j <= i; j++) {
            if (i % j == 0) {
                is_prime = 0;
                break;
            }
        }
        if (is_prime) {
            prime_count++;
        }
    }

    int end_time = uptime();
    int execution_time = end_time - start_time;
    
    printf(1, "Finished Current PID: %d, Priority: %d, Execution Time: %d ticks, Total Primes Found: %d\n", pid, priority, execution_time, prime_count);

    exit();
}

// Main function to run multiple processes
int main(int argc, char *argv[]) {
    int priorities[] = {2, 2, 4,4};  // Example priorities for each process
    int process_count = sizeof(priorities) / sizeof(priorities[0]);
    int t = 100; // Time threshold in ticks
    int i;
    for (i = 0; i < process_count; i++) {
        if (fork() == 0) {
            // Child process: calculate primes
            calculate_primes(priorities[i], t);
        }
    }

    // Wait for all child processes to finish
    for (i = 0; i < process_count; i++) {
        wait();
    }

    exit();
}