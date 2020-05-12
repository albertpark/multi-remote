# git multi-remote - Add multiple remote servers


## Introduction

This script will help you setup multiple remote servers for the same repository hosted on different domains.


## Installation

Pull the file from the repository:
```bash
→ $ cd ~
→ $ git clone https://github.com/albertpark/multi-remote.git
```

In order to use `git-multi-remote` script as new sub-commands with git, it needs to be available in your `PATH` environment:
```bash
→ $ export PATH=$PATH:~/multi-remote/bin
```


## Usage

Here is the help menu:
```bash
→ $ git multi-remote -h
Add multiple remotes(server) for the same repository <repo>.

Usage: git multi-remote [-u <user>] [-r <repo>] [--ssl]

Note: The argument order does not matter.
Options:
    -c <repo> [<alias>]
              Clone git repository
              must pass in repository name
              optional to pass alias directory
   --clone <repo> [<alias>]
   --git      Use git connection
    -i <repo> [<alias>]
              Initialize with git repository
              must pass in repository name
              optional to pass alias directory
   --init <repo> [<alias>]
    -r <repo> Name of the git repository
   --repo <repo>
   --ssl      Use https connection (default is git)
    -u <user> Username of the repository
   --user <user>

Config: Use 'remote.conf' to configure variables.
        Keep in mind using argument options 
        will override the configuration variables.
```

Now go to your desired directory to set up multiple remote servers and run the script by replacing the `<username>` and `<repo>` to your username and repository name:
```bash
→ $ git multi-remote -c multi-remote -u albertpark --ssl
```

The `--ssl` flag is optional and will set the remote with a `HTTPS` connection. The default connection will be `SSH` (`git`).

## Configuration

Included a configuration file to setup multiple remote servers and username including ssl connection in `remote.conf`:
```
# Mark the origin with '*' otherwise default is github.com
REMOTES.bb=bitbucket.org*
REMOTES.gh=github.com
REMOTES.gl=gitlab.com

# Set ssl connection
CONFIG.ssl=true

# Set uername and repository
CONFIG.user=albertpark
# GIT_DIR will set the directory name as the repository
CONFIG.repo=multi-remote
```
Note: Options passed in the arguments will override the configuration settings.


## Examples

After setting up the configuration file the `git-multi-remote` script can be save you some keystrokes.  
  

### Existing Repository

When you just want to add multiple remotes to an existing repository:
```bash
→ $ cd repository-project
→ $ git multi-remote -u albertpark -r repository-project
```

If your repository name is the same as the directory name you can setup the configuration variable `CONFIG.repo` to `GIT_DIR` and use the script will use the directory name as the repository name:
```
# remote.conf
CONFIG.user=albertpark
CONFIG.repo=GIT_DIR
```

```bash
# After setting up the configuration
→ $ cd repository-project
→ $ git multi-remote
```

### Cloning Repository
The `--clone` option will clone the git repository and setup all the remotes:
```bash
# Before setting up the configuration
→ $ git multi-remote -c multi-remote -u albertpark --ssl
# After setting up the configuration
→ $ git multi-remote -c multi-remote
# With an alias 'temp-repo' directory
→ $ git multi-remote -c multi-remote temp-repo
```

### Initializing Repository

Usage with the `--init` option:
```bash
# Before setting up the configuration
→ $ git multi-remote -i multi-remote -u albertpark --ssl
# After setting up the configuration
→ $ git multi-remote -i multi-remote
```


### Supports

Here are the remote list that `git-multi-remote` supports:
```
• bitbucket.org
• github.com
• gitlab.com
• visualstudio.com (Azure-DevOps)

```

## License

MIT
