# Linux Mini Scripts

This repo currently documents the following:

**`backup.sh`**, a small Bash utility to back up a directory safely. 
**`log_parser.sh`**, a small Bash utility to search log files for a regex pattern, with options for case sensitivity, context lines, and output redirection. 
**`sys_report.sh`**, a small Bash utility to generate a system information report, including CPU, memory, disk, and network details. 
**`decompress.sh`**, a small Bash utility to repeatedly decompress a file until it becomes human-readable text.

---

## 🧰 Script: `backup.sh`

Copies the contents of a source directory into a timestamped folder
"$src"_backup_YYYY-MM-DD_HHMMSS/, preserving permissions, timestamps,
symlinks, and dotfiles.

### Key behavior

- Creates the destination folder with `mkdir -p`.
- Uses `cp -a -- "$src"/. "$dest"/` (copies contents, not the wrapper directory).
- Guards against non-existent / non-directory sources and exits with a clear error.

---

## 🚀 Usage: `backup.sh`

Make the script executable (one time):

chmod +x backup.sh

Back up a folder into a timestamped directory (default parent: current dir):

./backup.sh <source_dir> [target_parent_dir]

### Examples

./backup.sh tests 
./backup.sh ~/myproject ~/Backups

### Quick test

mkdir -p tests && printf "hello\n" > tests/backup_tests.txt 
./backup.sh tests 
diff -qr tests tests_backup_*    # expect no differences

---

## 🔒 Safety Notes: `backup.sh`

- `backup.sh` only copies; it never deletes or modifies the source.
- Paths are quoted and separated from options with `--` to avoid issues with spaces or dash-prefixed names.
- If the source is invalid, the script exits with a clear error message.

---

## ⚙️ Requirements

- Bash 4+
- coreutils (cp, mkdir, grep, wc, df, free, ps, ip, file, tar) — installed by default on Ubuntu/WSL.

On minimal systems/containers, you can install core tools with:

sudo apt update 
sudo apt install -y coreutils procps iproute2 bzip2 xz-utils tar

---

## 🧰 Script: `log_parser.sh`

Searches a log file for a given regex pattern and writes the matches to an output file. 
Provides options for case sensitivity, context lines, and summary reporting. 
Exits 0 if matches are found, 1 if not, and 2 for usage errors.

### Key behavior

- Validates that the input file exists before running.
- Supports extended regex patterns with `-E` (default: `error`).
- Case-insensitive by default; `-S` enables case-sensitive matching.
- Optional `-c N` shows N lines of context before/after each match.
- Writes results to an output file (default: `errors_found.log`).
- Prints a summary with match count, lines written, and paths.

---

## 🚀 Usage: `log_parser.sh`

chmod +x log_parser.sh 
./log_parser.sh <logfile>

### Options

-p PATTERN   Regex to search for (default: "error") 
-o OUTFILE   Output file to write matches (default: "errors_found.log") 
-c N         Context lines before/after each match (default: 0) 
-S           Case-sensitive (default is case-insensitive) 
-h           Show help 

### Examples

./log_parser.sh /tmp/app.log 
./log_parser.sh -p "WARN" -o warn.log /tmp/app.log 
./log_parser.sh -S -p "ERROR" -c 1 -o found.log /tmp/app.log 
./log_parser.sh -p "timeout" /tmp/app.log && echo "Found timeouts" 

### Sample output

matches=2  written_lines=4  pattern=error  out=errors_found.log  file=/tmp/app.log

---

## 🧰 Script: `sys_report.sh`

Generates a system information report with details about the OS, CPU, memory, disk usage, top processes, and network configuration.

### Key behavior

- Prints OS and kernel version (`uname -a`).
- Shows uptime and system load averages (`uptime`).
- Displays CPU details (via `lscpu`).
- Reports memory usage (`free -h`).
- Shows disk usage for root filesystem (`df -h /`).
- Lists the top 5 CPU-consuming processes (`ps -eo ...`).
- Prints IPv4 addresses assigned to the system (`ip -4 addr show`).

---

## 🚀 Usage: `sys_report.sh`

chmod +x sys_report.sh 
./sys_report.sh

### Example output (abridged)

===== System Report ===== 
Date: Thu Sep 18 15:21:44 ADT 2025 

>> OS and Kernel: 
Linux mymachine 5.15.133.1-microsoft-standard-WSL2 ... 

>> Uptime and Load: 
15:21:44 up  2:03,  1 user,  load average: 0.11, 0.04, 0.01 

>> CPU Info: 
Architecture:            x86_64 
CPU(s):                  8 
Model name:              Intel(R) Core(TM) i7-10750H CPU @ 2.60GHz 

>> Memory Usage: 
Mem:  15Gi total, 2.0Gi used, 10Gi free, 3.0Gi cached, 12Gi available 

>> Disk Usage (/): 
Filesystem      Size  Used Avail Use% Mounted on 
/dev/sdb        250G   40G  210G  16% / 

>> Top CPU Processes: 
PID COMMAND %CPU 
1223 firefox  8.3 
 879 chrome   5.7 
  62 systemd  1.1 

>> IP Addresses (IPv4): 
192.168.1.101 
172.17.0.1 

===== End of Report ===== 

---

## 🧰 Script: `decompress.sh`

Repeatedly decompresses a file until it becomes human-readable text. Useful for working with nested compressed files (as seen in the Bandit wargame challenges).

### Key behavior

- Detects file type using `file --mime-type`.
- Supports gzip, bzip2, xz, and tar archives.
- Automatically extracts and updates the working file.
- Stops once the file is plain text, JSON, or XML.
- Prints progress at each step.

---

## 🚀 Usage: `decompress.sh`

chmod +x decompress.sh 
./decompress.sh <compressed_file>

### Examples

./decompress.sh mystery.gz 
./decompress.sh secret_archive.tar 

### Sample output

[*] gunzip: mystery.gz 
[*] bunzip2: mystery 
[*] tar extract: mystery 
[+] Reached readable text: mystery_contents/file.txt 
Hello, world! 

---
