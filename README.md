
# Priority-Based Scheduling  

This project focuses on scheduling mechanisms in the xv6 operating system, introducing the concept of priority-based scheduling, and implementing advanced concepts like priority inversion and priority inheritance.  

---

## Overview  
In this, we will enhance xv6's scheduling mechanism, which currently uses a simple round-robin scheduler, by:  
1. Implementing **priority-based scheduling** with 5 levels of priority.  
2. Adding a `nice` system call to adjust process priority.  
3. Demonstrating priority inversion and resolving it using **priority inheritance** (Extra Credit).  

---

## Tasks  

### **Task 1 - Nice**  
#### Objective:  
Implement a `nice` system call in xv6 to adjust the priority of a process.  

#### Requirements:  
1. Modify the `struct proc` in `proc.h` to store the nice value for each process.  
2. Create the `nice` system call.  
   - Accepts `pid` and `value` as parameters.  
   - Returns the `pid` and the old nice value of the process.  
3. Implement a CLI program for `nice` to:  
   - Change the nice value of a specific process:  
     ```bash
     nice <pid> <value>
     ```  
   - Change the nice value of the current process:  
     ```bash
     nice <value>
     ```

---

### **Task 2 - Priority Scheduler**  
#### Objective:  
Implement a **priority-based scheduler** that gives higher priority to processes with lower nice values.  

#### Requirements:  
1. Processes start with a **default medium priority**.  
2. Scheduler gives CPU time to higher-priority processes first.  
3. Maintain both schedulers (Round Robin and Priority-Based) as compile-time options.  
