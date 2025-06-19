# 📱 CLI Commands Quick Reference Card

## For Junior Developers - Keep This Handy!

---

## 🗺️ **Navigation Commands**

| Command | What It Does | Example |
|---------|--------------|---------|
| `pwd` | Show current directory | `pwd` |
| `ls` | List files and folders | `ls -la` |
| `ls -la` | List all with details | Shows hidden files, permissions, sizes |
| `cd` | Change directory | `cd documents` |

---

## 🔍 **Finding Things**

| Command | What It Does | Example |
|---------|--------------|---------|
| `find . -name "*.md"` | Find files by name pattern | Find all markdown files |
| `find . -type d` | Find directories only | List all folders |
| `find . -type f` | Find files only | List all files |
| `find . -mtime -7` | Find recent files | Files modified in last 7 days |

---

## 📁 **File Operations**

| Command | What It Does | Example | ⚠️ Safety |
|---------|--------------|---------|-----------|
| `mv old new` | Rename/move file | `mv file.txt newname.txt` | Overwrites! |
| `mv file dir/` | Move to directory | `mv file.txt documents/` | |
| `rm file` | Delete file | `rm unwanted.txt` | **PERMANENT!** |
| `rm -i file` | Delete with confirmation | `rm -i file.txt` | ✅ Safer |
| `rm -rf dir/` | Delete directory | `rm -rf temp/` | **VERY DANGEROUS!** |

---

## 👀 **File Content**

| Command | What It Does | Example |
|---------|--------------|---------|
| `head file` | First 10 lines | `head app.log` |
| `head -n 5 file` | First 5 lines | `head -n 5 data.txt` |
| `tail file` | Last 10 lines | `tail app.log` |
| `tail -f file` | Follow live file | `tail -f log.txt` |

---

## 📊 **Data Organization**

| Command | What It Does | Example |
|---------|--------------|---------|
| `sort file` | Sort alphabetically | `sort names.txt` |
| `sort -n file` | Sort numerically | `sort -n numbers.txt` |
| `sort -r file` | Sort reverse | `sort -r data.txt` |
| `sort -u file` | Sort + remove duplicates | `sort -u list.txt` |

---

## 🌳 **Project Visualization**

| Command | What It Does | Example |
|---------|--------------|---------|
| `tree` | Show directory structure | `tree` |
| `tree -L 2` | Limit to 2 levels | `tree -L 2` |
| `tree -d` | Directories only | `tree -d` |
| `tree -I "pattern"` | Exclude pattern | `tree -I "node_modules"` |

---

## 🚨 **Emergency Commands**

| Situation | Command | Note |
|-----------|---------|------|
| Stop running command | `Ctrl+C` | Force quit |
| Clear screen | `Ctrl+L` or `clear` | Clean slate |
| Command history | `↑` arrow | Navigate previous commands |
| Search history | `Ctrl+R` | Find old commands |

---

## 💡 **Pro Tips**

### Tab Completion
- Press `Tab` to auto-complete file names
- Double-tap `Tab` to see all options

### Safety First
1. Always `pwd` before dangerous operations
2. Use `ls` to verify what you're working with
3. Start with `rm -i` when learning
4. Test on copies first

### Useful Combinations
```bash
# Safe file exploration
pwd && ls -la

# Find and check recent errors
find . -name "*.log" -exec tail {} \;

# Create backup before cleanup
cp -r project project_backup

# Monitor live logs with filtering
tail -f app.log | grep ERROR
```

---

## 🎯 **Daily Workflow**

### Starting Work
```bash
pwd                    # Where am I?
ls -la                 # What's here?
tree -L 2              # Project overview
```

### During Development
```bash
find . -name "*.dart"  # Find code files
tail -f logs/app.log   # Monitor logs
head README.md         # Quick reference
```

### End of Day
```bash
find . -name "*.tmp"   # Find temp files
rm *.tmp               # Clean up
tree                   # Final structure
```

---

## 📞 **When You Need Help**

| Command | What It Shows |
|---------|---------------|
| `man command` | Full manual for command |
| `command --help` | Quick help for command |
| `which command` | Where command is located |

---

## 🚫 **Never Do This!**

| ❌ Dangerous Command | 💥 What It Does |
|---------------------|-----------------|
| `rm -rf /` | Deletes everything on system |
| `rm -rf *` | Deletes everything in current folder |
| `mv / /backup` | Tries to move root directory |

---

**🎉 Keep practicing daily - these commands will become second nature!**

*Print this card and keep it next to your computer while learning*
