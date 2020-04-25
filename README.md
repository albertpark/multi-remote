# git-multi-remote.sh - Add multiple remote servers

## Introduction

This script will help you setup for multiple remote servers for a repository.

## Usage

Pull the file from the repository:
```bash
$ git clone https://github.com/albertpark/multi-remote.git
```

Here is the help menu:
```bash
$ cd multi-remote
$ ./git-multi-remote.sh --h
Add multiple server for the same repository <repo>.
Note: The argument order does not matter.
Options:
    -u <user> Username of the repository
  --user <user>
    -r <repo> Name of the git repository
  --repo <repo>
  --git     Use git connection
  --ssl     Use https connection (default is git)
```

Now go to your desired directory to set up multiple remote servers and run the script by replacing the `<username>` and `<repo>` to your username and repository name:

```bash
$ git init tmp/repo
$ cd tmp/repo
$ ../multi-remote/git-multi-remote.sh -u <username> -r <repo> --ssl
```

The `--ssl` flag is optional and will set the remote with `HTTPS` connection. The default connection will be `SSH`.

## Configuration

Included a configuration file to setup multiple remote servers and username including ssl connection in `remote.conf`:
```
REMOTES.buc=bitbucket.org
REMOTES.hub=github.com
REMOTES.lab=gitlab.com

# Set ssl connection
CONFIG.ssl=true

# Set uername and repository
CONFIG.user=albertpark
CONFIG.repo=multi-remote
```
Note: Options passed in the arguments will override the configuration settings.

## License

MIT

