# Configure VS Code as a Git Editor

Git uses a text editorfor operations such as writing commit messages and editing merge conflicts. Configure visual studio as the default Git Editor
```bash
git config --global core.editor "code --wait"
```
Verify the settings
```bash
git config --global core.editor
```
Enable rebase mode for Git Pull
```bash
git config --global pull.rebase true
```
This command tells Git to use rebase instead of merge when you run `git pull`. Without using rebase the history becomes cluttered with many merge commits. While with rebase Git temporarily removes your local commits, updates your branch with the remote changes and then reapplies your commits on top.
You can verify the settings by using the command
```bash
git config --global pull.rebase
```
This command will result in `true`

Configure Git Credential Manager to securly store authentication credentials. This setting allows Git to securely store credentials so you do not need to re-enter your username and password for every operation.
```bash
git config --global credential.helper manager
```
Verify the setting
```bash
git config --global credential.helper
```
This will result in `manager`

Create a repo on GitHub and copy the url
```bash
https://github.com/manpreet/MyProject.git
```
Add the remote repository 
```bash
git remote add origin https://github.com/manpreet/MyProject.git
```
Verify the remote repository
```bash
git remote -v
```
For the first push use 
```bash
git push -u origin master
```
For future pushes uses `git push` and future updates `git pull`

