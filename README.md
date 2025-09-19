# Linux Mini Scripts

This repo is a small collection of Linux utilities I’ve written in Bash. Nothing overcomplicated — just practical scripts that solve real problems and show clean, reliable Bash practices.

Currently included:
- **backup.sh** → backs up a directory into a timestamped folder (keeps permissions, symlinks, and dotfiles intact).
- **log_parser.sh** → searches logs with a regex pattern, with options for case sensitivity, context lines, and output redirection.
- **sys_report.sh** → prints a quick system report (OS, CPU, memory, disk, processes, IPs).
- **decompress.sh** → keeps unpacking a file until it’s plain text (inspired by the Bandit wargame).

---

## 🗂 backup.sh

Copies the contents of a source directory into a timestamped folder like:

```
mydir_backup_2025-09-18_142300/
```

### Usage

```bash
chmod +x backup.sh
./backup.sh <source_dir> [target_parent_dir]
```

Examples:
```bash
./backup.sh tests
./backup.sh ~/myproject ~/Backups
```

This only copies files — it never deletes or modifies the source.

---

## 🔎 log_parser.sh

Searches a log file for a regex pattern. By default it looks for “error” (case-insensitive), but you can change that.

### Usage

```bash
chmod +x log_parser.sh
./log_parser.sh -p "failed login" -o results.log -c 2 server.log
```

Options:
- `-p` → regex pattern (default: “error”)
- `-c` → number of context lines
- `-o` → output file
- `-S` → case-sensitive search

The script writes matches to the output file and prints a short summary with the match count.

---

## 🖥 sys_report.sh

Quick system snapshot. Shows:
- OS and kernel
- Uptime and load
- CPU info
- Memory usage
- Disk usage (root filesystem)
- Top CPU processes
- IPv4 addresses

### Usage

```bash
chmod +x sys_report.sh
./sys_report.sh
```

---

## 📦 decompress.sh

Given a compressed file, it keeps unpacking until you reach plain text. Supports gzip, bzip2, xz, tar, and more.

### Usage

```bash
chmod +x decompress.sh
./decompress.sh mysteryfile.gz
```

I first built this while doing the Bandit wargame, where one challenge had me decompress a file again and again. I did it manually the first time, then wrote this script to automate it.

---

## Requirements

- Bash 4+
- Coreutils (already on most Linux distros)
- gzip, bzip2, xz-utils, tar, etc. for decompress.sh
