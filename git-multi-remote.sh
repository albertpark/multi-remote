#!/bin/bash

# Add Multiple Repository Server Script
# usage: git-multi-remote.sh -u username -r repository

declare -A REPOS     # Explicitly declare key value array

# Comment out the repository servers you do not have with the '#' character
REPOS[buc]=bitbucket.org
REPOS[hub]=github.com
REPOS[lab]=gitlab.com

USER=""
REPO=""
CONN="git@"
POST=":"

USAGE="[-u <user>] [-r <repo>] [--ssl]"
LONG_USAGE="Add multiple server for the same repository <repo>.
Note: The argument order matters.
Options:
    -u <user> Username of the repository
  --user <user>
    -r <repo> Name of the git repository
  --repo <repo>
  --ssl     Use https connection (default is git)

"

case "$1" in
    -h|--help)
      echo "usage: $(basename "$0") $USAGE"
      echo ""
      echo "$LONG_USAGE"
      exit 0
esac

# Check if current directory is a git repository
if [ -d .git ]; then
  #echo .git
  echo "adding multiple repositories";
else
  git rev-parse --git-dir 2> /dev/null;
  echo "fatal: not a git repository"
  exit 0
fi;

# Get the username
while case "$#" in 0) break ;; esac
do
  case "$1" in
    -u|--u|--user)
      shift
      USER="$1"
      break
      ;;
    -*)
      break
      ;;
    *)
      break
      ;;
  esac
  shift
done

# Get the repository name
while case "$#" in 0) break ;; esac
do
  case "$2" in
    -r|--r|--re|--rep|--repo)
      shift
      REPO="$2"
      break
      ;;
    -*)
      break
      ;;
    *)
      break
      ;;
  esac
  shift
done

# Check for ssl connection
while case "$#" in 0) break ;; esac
do
  case "$3" in
    -ssl|--ssl)
      CONN="https://"
      POST="/"
      break
      ;;
    -*)
      break
      ;;
    *)
      break
      ;;
  esac
  shift
done


init_repo="git remote add origin $CONN${REPOS[hub]}$POST$USER/$REPO.git"
echo "$init_repo"
eval "$init_repo"

for i in "${!REPOS[@]}"
do
    key=$i
    url=${REPOS[$i]}
    add_repo="git remote add $key $CONN$url$POST$USER/$REPO.git"
    echo "$add_repo"
    eval "$add_repo"
done

for i in "${!REPOS[@]}"
do
    set_url="git remote set-url --add --push origin $CONN${REPOS[$i]}$POST$USER/$REPO.git"
    echo "$set_url"
    eval "$set_url"
done

show_origin="git remote show origin"
echo "$show_origin"
eval "$show_origin"

