# Linux Mini Scripts

This repo currently documents the following:

**`backup.sh`**, a small Bash utility to back up a directory safely.
**`log_parser.sh`**, a small Bash utility to search log files for a regex pattern, with options for case sensitivity, context lines, and output redirection.

---

## 🧰 Script: backup.sh

Copies the contents of a source directory into a timestamped folder
"$src"_backup_YYYY-MM-DD_HHMMSS/, preserving permissions, timestamps,
symlinks, and dotfiles.

### Key behavior

- Creates the destination folder with `mkdir -p`.
- Uses `cp -a -- "$src"/. "$dest"/` (copies contents, not the wrapper directory).
- Guards against non-existent / non-directory sources and exits with a clear error.

---

## 🚀 Usage: backup.sh

Make the script executable (one time):

chmod +x backup.sh

Back up a folder into a timestamped directory (default parent: current dir):

./backup.sh <source_dir> [target_parent_dir]

### Examples

# Backup the ./tests directory into ./tests_backup_YYYY-MM-DD_HHMMSS/
./backup.sh tests

# Backup ~/myproject into ~/Backups/myproject_backup_YYYY-MM-DD_HHMMSS/
./backup.sh ~/myproject ~/Backups

### Quick test

# Set up a tiny test tree
mkdir -p tests && printf "hello\n" > tests/backup_tests.txt

# Run the backup
./backup.sh tests

# Verify contents match
diff -qr tests tests_backup_*    # expect no differences

---

## 🔒 Safety Notes: backup.sh

- `backup.sh` only copies; it never deletes or modifies the source.
- Paths are quoted and separated from options with `--` to avoid issues with spaces or dash-prefixed names.
- If the source is invalid, the script exits with a clear error message.

---

## ⚙️ Requirements

- Bash 4+
- coreutils (cp, mkdir, grep, wc) — installed by default on Ubuntu/WSL.

On minimal systems/containers, you can install core tools with:

sudo apt update
sudo apt install -y coreutils

---

## 🧰 Script: log_parser.sh

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

## 🚀 Usage: log_parser.sh

Make the script executable (one time):

chmod +x log_parser.sh

Run with defaults (searches for `error` case-insensitive):

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
cat found.log
./log_parser.sh -p "timeout" /tmp/app.log && echo "Found timeouts"

### Sample output

matches=2  written_lines=4  pattern=error  out=errors_found.log  file=/tmp/app.log

- matches → number of matching lines (ignores context)
- written_lines → total lines written (includes context if `-c` is used)
- pattern → regex searched
- out → output file path
- file → input file scanned

---
