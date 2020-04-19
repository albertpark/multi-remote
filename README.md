# git-multi-remote.sh - Add multiple remote servers

## Introduction

This script will help you setup for multiple remote servers for a repository.

## Usage

Pull the file from the repository:
```bash
<<<<<<< HEAD
$ git clone https://github.com/albertpark/multi-remote.git
=======
$ git clone https://github.com/albertpark/git-multi-remote.git
>>>>>>> d41d541f3bdad72b3285c1d16f9f7aa1eef8117c
```

Here is the help menu:
```bash
$ git-multi-remote.sh --h
Add multiple server for the same repository <repo>.
Note: The argument order matters.
Options:
    -u <user> Username of the repository
   --user <user>
    -r <repo> Name of the git repository
  --repo <repo>
    --ssl     Use https connection (default is git)
```

Now go to your desired directory to set up multiple remote servers and run the script by replacing the `<username>` and `<repo>` to your username and repository name:

```bash
$ git init ./tmp/repo
$ cd ./tmp/repo
$ ../multi-remote/git-multi-remote.sh -u <username> -r <repo> --ssl
```

The `--ssl` flag is optional as will set the remote with `HTTPS` connection. The default connection will be `SSH`.

## License

MIT

