# Linux Mini Scripts

This repo currently documents **`backup.sh`**, a small Bash utility to back up a directory safely.

---

## 🧰 Script: `backup.sh`

Copies the **contents** of a source directory into a timestamped folder
`"$src"_backup_YYYY-MM-DD_HHMMSS/`, preserving permissions, timestamps, symlinks, and dotfiles.

### Key behavior

* Creates the destination folder with `mkdir -p`.
* Uses `cp -a -- "$src"/. "$dest"/` (copies **contents**, not the wrapper directory).
* Guards against non-existent / non-directory sources and exits with a clear error.

---

## 🚀 Usage

Make the script executable (one time):

```bash
chmod +x backup.sh
```

Back up a folder into a timestamped directory (default parent: current dir):

```bash
./backup.sh <source_dir> [target_parent_dir]
```

### Examples

```bash
# Backup the ./tests directory into ./tests_backup_YYYY-MM-DD_HHMMSS/
./backup.sh tests

# Backup ~/myproject into ~/Backups/myproject_backup_YYYY-MM-DD_HHMMSS/
./backup.sh ~/myproject ~/Backups
```

### Quick test

```bash
# Set up a tiny test tree
mkdir -p tests && printf "hello\n" > tests/backup_tests.txt

# Run the backup
./backup.sh tests

# Verify contents match
diff -qr tests tests_backup_*    # expect no differences
```

---

## 🔒 Safety Notes

* `backup.sh` **only copies**; it never deletes or modifies the source.
* Paths are **quoted** and separated from options with `--` to avoid issues
  with spaces or dash-prefixed names.
* If the source is invalid, the script exits with a clear error message.

---

## ⚙️ Requirements

* **Bash 4+**
* **coreutils** (`cp`, `mkdir`) — installed by default on Ubuntu/WSL.

*On minimal systems/containers, you can install core tools with:*

```bash
sudo apt update
sudo apt install -y coreutils
```
