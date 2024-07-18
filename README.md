#######monitor_script.sh#######

#####Purpose######
The monitor_script.sh Bash script captures system monitoring data and logs it to rotating files in /tmp/. It captures the following information every 10 seconds:

1) grep -r "" /sys/block/nvme*n1/inflight
2) ps aux -L
3) cat /proc/meminfo
4) nstat -a

File Rotation:
The script rotates log files (capture_logs1.txt, capture_logs2.txt, capture_logs3.txt) when they reach a maximum size of 10MB to manage disk space efficiently.

####Usage####
Ensure the script has executable permissions:

1) chmod +x monitor_script.sh

Run the script in the background:

2) nohup ./monitor_script.sh &

This command runs the script in the background using nohup to prevent termination upon logout or terminal closure.

####Output####
Primary log file:

/tmp/capture_logs1.txt
Secondary and tertiary log files used for rotation:

/tmp/capture_logs2.txt
/tmp/capture_logs3.txt

Temporary file used during file rotation:

/tmp/capture_logs_tmp.txt

Configuration:
Adjust max_file_size in the script (max_file_size=10485760) to change the maximum log file size.
