## Introduction to Local Git Repository Management
First download and install the GitBash

### Setting up the account

The following settings are stored in global GIT congiguration file and apply to all repositories for that user account
```bash
git config --global user.name "ABC"
git config --global user.email "abc@example.com"
```
**Verify the configuration**
```bash
git config --global --list
```

**Create a Project Folder**
```bash
mkdir MyProject
cd MyProject
```
**Create subfolders**
```bash
mkdir Documents
mkdir Scripts
mkdir Backup
```
**Create samplefiles**
```bash
touch Documents/project_notes.txt
touch Scripts/info.sh
```
**Verify the structure**
```bash
ls -R
```
**Initialize the local GITRepository**
```bash
git init
```

**Explore the .git Directory**
```bash
ls -la .git
```

### Create the first commit 
**Add files to the staging area**
```bash
git add .
```
**Check repository status**
```bash
git status
```
**Create first commit**
```bash
git commit -m "Initial Project Struture"
```
**View commit history**
```bash
git log --oneline
```
## Try next step
Create a new subfolder named `Reports` and file named `summary.txt`. Add the file to the repository, commit changes.