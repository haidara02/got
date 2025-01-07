# got

## Description
got is a lightweight version control system inspired by Git. It provides basic functionalities for creating repositories, tracking file changes, committing updates, and managing branches. Designed to work in POSIX-compatible Shell, GOT offers a simple interface for managing file versions and changes.

## Command List
1. **got-init**
   Initializes an empty repository by creating a `.got` directory to store repository data.  
   Example usage:
   ```bash
   got-init
   Initialized empty GOT repository in .got
   ```
2. **got-add [filenames...]**
   Adds specified files to the index for tracking. Only files in the current directory are allowed.
3. **got-commit -m [message]**
   Commits the current state of the index to the repository with a descriptive message.
   Example usage:
   ```bash
   got-commit -m "Initial commit"
   Committed as commit 0
   ```
4. **got-log**
   Displays a list of all commits with their numbers and messages.
5. **got-show [commit]:[filename]**
   Displays the content of a file as of a specific commit. If no commit is specified, the file's state in the index is shown.
6. **got-commit [-a] -m [message]**
   Commits changes with an optional -a flag to add all modified files to the index before committing.
7. **got-rm [--force] [--cached] [filenames...]**
   Removes files from the index or the working directory.
   - --cached: Removes only from the index.
   - --force: Removes files even if it results in data loss.
8. **got-status**
   Displays the status of files in the working directory, index, and repository, including staged, modified, and untracked files.
9. **got-branch [-d] [branch-name]**
   Manages branches:
    - Create a branch when branch-name is provided.
   - Delete a branch with the -d flag.
   - List all branches if no branch name is provided.
11. **got-checkout [branch-name]**
   Switches to the specified branch.
12. **got-merge (branch-name|commit-number) -m [message]**
   Merges changes from a branch or commit into the current branch and creates a commit.

## Examples
### Basic Workflow
```bash
got-init
echo "lorem" > a
echo "ipsum" > b
got-add a b
got-commit -m "first commit"
```
### Adding Changes
```bash
echo "lorem ipsum" >> a
got-add a
got-commit -m "commit"
```
### Viewing Logs and File Versions
```bash
got-log
1 second commit
0 first commit

got-show 0:a
lorem ipsum
```
### Branch Management
```bash
got-branch feature-branch
got-checkout feature-branch
echo "new feature" >> c
got-add c
got-commit -m "feature added"
got-checkout master
got-merge feature-branch -m "merged feature-branch"
```

## Requirements
- POSIX-compatible Shell environment.

## Notes
- got is designed to store all repository data inside the .got directory. No external files or directories are used.
- got does not require a specific internal structure for .got, allowing flexibility in implementation.
- got commands mimic Git but are simplified for educational purposes.
