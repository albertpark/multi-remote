# git multi-remote - Add multiple remote servers

## Introduction

This script will help you setup for multiple remote servers for a repository.

## Installation

Pull the file from the repository:
```bash
→ $ git clone https://github.com/albertpark/multi-remote.git
```

In order to use git-multi-remote script as new subcommands with git, it needs to be available in your `PATH` environment:
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
    -u <user> Username of the repository
   --user <user>
    -r <repo> Name of the git repository
   --repo <repo>
   --git      Use git connection
   --ssl      Use https connection (default is git)

Config: Use 'remote.conf' to configure variables.
        Keep in mind using argument options
        will override the configuration variables.
```

Now go to your desired directory to set up multiple remote servers and run the script by replacing the `<username>` and `<repo>` to your username and repository name:

```bash
→ $ git init temp-repo
→ $ cd temp-repo
→ $ git multi-remote -u <username> -r <repo> --ssl
```

The `--ssl` flag is optional and will set the remote with a `HTTPS` connection. The default connection will be `SSH` (`git`). When `<repo>` is not configured or defined the script will use the working directory as the default repository name.

## Configuration

Included a configuration file to setup multiple remote servers and username including ssl connection in `remote.conf`:
```
REMOTES.bb=bitbucket.org
REMOTES.gh=github.com
REMOTES.gl=gitlab.com

# Set ssl connection
CONFIG.ssl=true

# Set uername and repository
CONFIG.user=albertpark
# To use directory name as the default repository name use GIT_DIR
CONFIG.repo=multi-remote
```
Note: Options passed in the arguments will override the configuration settings.

## License

MIT
