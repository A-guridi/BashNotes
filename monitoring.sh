# PS
## Useful to get current running processes in linux
ps -e -> Displays all processes
ps -a -> Display all processes with a terminal
ps -x -> Display background proceses (no terminal associated)
ps -u user -> Display processes from user "user"
ps aux -> Detailed report of all running processes
-f -> Full name displayed


# STRACE
## command to trace the syscalls and processes that run after running some other command
## very useful for debugging
strace ls -> registers what happens after calling "ls"

# PERF
## More on 
https://gitgood.dev/cheat-sheets/linux-perf-essentials

## command to get current performance stats 
perf top -> current top proccesses
perf record -> record the performance of an active process
perf record -e 'syscalls:*' -a sleep 5 && perf report -> records syscalls for 5 seconds,  then shows the report
perf stat python numpy-matrix.py -i matrix.in  -> count and aggregate stats from running the python script

# TOP and HTOP
## Display current running processes (htop is more user-friendly)
htop -u user

# CPU STAT
## Display information of CPU usage
mpstat -P ALL 1     # Display on all cores
pidstat             # Display utilization of Processes
pidstat -U CPU -r memory -d disk -t threads

free                # current memory (RAM) utilization
iostat              # Disk utilization
iotop               # Per process IOPS, queues and more disk stuff



