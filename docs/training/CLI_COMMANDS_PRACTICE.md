# 🎯 CLI Commands Practice Worksheet

## Junior Developer Training Exercises

This worksheet provides hands-on exercises to practice the CLI commands you've learned. Complete each section to build your command-line confidence!

---

## 📋 **Before You Start**

### Setup Practice Environment
```bash
# Create a safe practice directory
mkdir ~/cli_practice
cd ~/cli_practice

# Create practice files and folders
mkdir docs images logs temp
touch README.md index.html app.js
touch logs/app.log logs/error.log logs/debug.log
touch temp/file1.tmp temp/file2.tmp
echo -e "Apple\nBanana\nCherry\nDate\nElderbery" > fruits.txt
echo -e "10\n2\n30\n4\n100" > numbers.txt
```

---

## 🏋️ **Exercise 1: Navigation Basics (`pwd`, `ls`)**

### Tasks:
1. **Find your location**: Use the command to show your current directory
2. **List everything**: Show all files including hidden ones with details
3. **Explore**: List contents of the `docs` folder
4. **Check sizes**: List files with human-readable sizes

### Your Commands:
```bash
# 1. Where am I?
_____

# 2. Show all files with details
_____

# 3. List docs folder contents
_____

# 4. Show file sizes
_____
```

### Solutions (Don't peek until you try!):
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Where am I?
pwd

# 2. Show all files with details
ls -la

# 3. List docs folder contents
ls docs

# 4. Show file sizes
ls -lh
```
</details>

---

## 🔍 **Exercise 2: Finding Files (`find`)**

### Tasks:
1. **Find all files**: List everything in current directory and subdirectories
2. **Find by type**: Find only directories
3. **Find by name**: Find all `.log` files
4. **Find by pattern**: Find all files starting with "app"
5. **Find recent**: Find files modified in the last 1 day

### Your Commands:
```bash
# 1. Find all files
_____

# 2. Find only directories
_____

# 3. Find .log files
_____

# 4. Find files starting with "app"
_____

# 5. Find recent files
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Find all files
find .

# 2. Find only directories
find . -type d

# 3. Find .log files
find . -name "*.log"

# 4. Find files starting with "app"
find . -name "app*"

# 5. Find recent files
find . -mtime -1
```
</details>

---

## 📁 **Exercise 3: Moving and Organizing (`mv`)**

### Tasks:
1. **Rename file**: Rename `index.html` to `home.html`
2. **Move to folder**: Move `home.html` to the `docs` folder
3. **Rename folder**: Rename `images` folder to `assets`
4. **Move multiple**: Move all `.tmp` files from `temp` to a new `archive` folder

### Your Commands:
```bash
# 1. Rename index.html to home.html
_____

# 2. Move home.html to docs folder
_____

# 3. Rename images folder to assets
_____

# 4. First create archive folder, then move .tmp files
_____
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Rename index.html to home.html
mv index.html home.html

# 2. Move home.html to docs folder
mv home.html docs/

# 3. Rename images folder to assets
mv images assets

# 4. Create archive and move .tmp files
mkdir archive
mv temp/*.tmp archive/
```
</details>

---

## 📊 **Exercise 4: Sorting Data (`sort`)**

### Tasks:
1. **Sort alphabetically**: Sort the fruits list
2. **Sort numerically**: Sort the numbers correctly
3. **Reverse sort**: Sort fruits in reverse order
4. **Remove duplicates**: Add duplicate fruits and sort with unique only

### Your Commands:
```bash
# 1. Sort fruits alphabetically
_____

# 2. Sort numbers numerically
_____

# 3. Sort fruits in reverse
_____

# 4. Add duplicates then sort unique
echo -e "Apple\nBanana" >> fruits.txt
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Sort fruits alphabetically
sort fruits.txt

# 2. Sort numbers numerically
sort -n numbers.txt

# 3. Sort fruits in reverse
sort -r fruits.txt

# 4. Sort with unique only
sort -u fruits.txt
```
</details>

---

## 👀 **Exercise 5: File Preview (`head`, `tail`)**

### Tasks:
1. **First peek**: Show first 3 lines of fruits
2. **Last peek**: Show last 2 lines of fruits
3. **Create log**: Add some log entries and view the end
4. **Monitor mode**: Practice following a file (create a test scenario)

### Your Commands:
```bash
# 1. First 3 lines of fruits
_____

# 2. Last 2 lines of fruits
_____

# 3. Add log entries and view last 5 lines
echo "INFO: App started" >> logs/app.log
echo "DEBUG: Loading config" >> logs/app.log
echo "ERROR: Connection failed" >> logs/app.log
echo "INFO: Retrying..." >> logs/app.log
_____

# 4. Follow the log file (use Ctrl+C to stop)
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. First 3 lines of fruits
head -n 3 fruits.txt

# 2. Last 2 lines of fruits
tail -n 2 fruits.txt

# 3. View last 5 lines of log
tail -n 5 logs/app.log

# 4. Follow the log file
tail -f logs/app.log
```
</details>

---

## 🌳 **Exercise 6: Project Visualization (`tree`)**

### Tasks:
1. **Full view**: Show the complete directory structure
2. **Limited depth**: Show only 2 levels deep
3. **Directories only**: Show just the folder structure
4. **Exclude patterns**: Show structure but exclude `.log` files

### Your Commands:
```bash
# 1. Show complete structure
_____

# 2. Show only 2 levels
_____

# 3. Show only directories
_____

# 4. Exclude .log files
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Show complete structure
tree

# 2. Show only 2 levels
tree -L 2

# 3. Show only directories
tree -d

# 4. Exclude .log files
tree -I "*.log"
```
</details>

---

## 🗑️ **Exercise 7: Clean Up (`rm`) - BE CAREFUL!**

### ⚠️ **Safety First**: Practice with `-i` flag initially!

### Tasks:
1. **Safe removal**: Remove one `.tmp` file with confirmation
2. **Pattern removal**: Remove all remaining `.tmp` files
3. **Directory removal**: Remove the empty `temp` directory
4. **Clean logs**: Remove old log files

### Your Commands:
```bash
# 1. Remove one file safely (with confirmation)
_____

# 2. Remove remaining .tmp files
_____

# 3. Remove empty temp directory
_____

# 4. Remove log files (create some first if needed)
_____
```

### Solutions:
<details>
<summary>Click to reveal answers</summary>

```bash
# 1. Remove one file safely
rm -i archive/file1.tmp

# 2. Remove remaining .tmp files
rm archive/*.tmp

# 3. Remove empty temp directory
rm -r temp

# 4. Remove log files
rm logs/*.log
```
</details>

---

## 🔗 **Challenge: Command Combinations**

### Real-World Scenarios

#### Challenge 1: Project Health Check
**Goal**: Create a summary of your project structure and recent activity

```bash
# Show where you are and what's there
echo "=== CURRENT LOCATION ==="
_____

echo "=== PROJECT STRUCTURE ==="
_____

echo "=== RECENT FILES ==="
_____
```

#### Challenge 2: Log Analysis
**Goal**: Find and analyze the most recent errors

```bash
# Create some test logs first
echo -e "INFO: System started\nERROR: Database connection failed\nWARN: Retrying connection\nINFO: Connected successfully" > logs/system.log

# Find all log files
echo "=== LOG FILES ==="
_____

# Show recent errors (last 10 lines, grep for ERROR)
echo "=== RECENT ERRORS ==="
_____
```

#### Challenge 3: Project Cleanup
**Goal**: Organize files and clean up unnecessary items

```bash
# Find all temporary files
echo "=== TEMPORARY FILES ==="
_____

# Create backup before cleanup
echo "=== CREATING BACKUP ==="
mkdir backup
_____

# Clean up (move to backup instead of delete for safety)
echo "=== MOVING TO BACKUP ==="
_____
```

---

## 🎯 **Self-Assessment Checklist**

Mark each item when you can do it confidently without looking at the guide:

### Basic Navigation
- [ ] I can find my current location (`pwd`)
- [ ] I can list files and folders (`ls`)
- [ ] I can see hidden files and detailed information
- [ ] I can navigate and explore directory contents

### File Finding
- [ ] I can find files by name pattern
- [ ] I can find directories vs files
- [ ] I can find files by modification time
- [ ] I can use basic find options

### File Operations
- [ ] I can rename files safely
- [ ] I can move files between directories
- [ ] I can move multiple files at once
- [ ] I understand the risks of overwriting

### File Content
- [ ] I can preview the beginning of files
- [ ] I can preview the end of files
- [ ] I can follow live log files
- [ ] I can sort file contents

### Project Management
- [ ] I can visualize project structure
- [ ] I can clean up temporary files safely
- [ ] I can organize files into directories
- [ ] I can combine commands for complex tasks

---

## 🚀 **Next Steps**

### Immediate Practice (This Week)
1. Use these commands daily in your development work
2. Create your own practice scenarios
3. Try combining commands with pipes (`|`)
4. Start using command history (`↑` arrow key)

### Skill Building (Next Week)
1. Learn `grep` for text searching
2. Master file permissions (`chmod`)
3. Explore process management (`ps`, `kill`)
4. Study shell scripting basics

### Advanced Goals (This Month)
1. Create automation scripts using these commands
2. Set up aliases for common command combinations
3. Learn about environment variables and PATH
4. Master text processing with `sed` and `awk`

---

## 💡 **Pro Tips for Daily Use**

### Command History
- Use `↑` and `↓` arrows to navigate command history
- Use `Ctrl+R` to search command history
- Use `history` command to see all previous commands

### Tab Completion
- Press `Tab` to auto-complete file and directory names
- Double-tap `Tab` to see all possible completions
- Works with command names too!

### Keyboard Shortcuts
- `Ctrl+C`: Stop current command
- `Ctrl+L`: Clear screen (same as `clear`)
- `Ctrl+A`: Go to beginning of line
- `Ctrl+E`: Go to end of line

### Safety Tips
- Always use `pwd` to confirm your location before dangerous operations
- Use `ls` to verify what you're about to operate on
- Start with `-i` (interactive) flag when learning `rm`
- Test commands on copies or test files first

---

**🎉 Congratulations on completing the CLI Commands Practice Worksheet!**

*Remember: Mastery comes through daily practice. Use these commands in real projects to build muscle memory and confidence.*
