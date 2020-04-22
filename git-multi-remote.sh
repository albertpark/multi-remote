#!/bin/bash

# Add Multiple Repository Server Script
# usage: git-multi-remote.sh -u username -r repository

declare -A REMOTES     # Explicitly declare key value array

# Comment out the repository servers you do not have with the '#' character
REMOTES=(
  [buc]=bitbucket.org
  [hub]=github.com
  [lab]=gitlab.com
)

# Set ssl connection
SSL=false

USER=""
REPO=""

CONN=""
POST=""

USAGE="[-u <user>] [-r <repo>] [--ssl]"
LONG_USAGE="Add multiple server for the same repository <repo>.
Note: The argument order does not matter.
Options:
    -u <user> Username of the repository
  --user <user>
    -r <repo> Name of the git repository
  --repo <repo>
  --ssl     Use https connection (default is git)

"
# Functions need to be set before getting called
check_ssl() {
  if [ "$SSL" = true ]; then
    CONN="https://"
    POST="/"
  else
    CONN="git@"
    POST=":"
  fi
}

remote_main() {
  main="git remote add origin $CONN${REMOTES[hub]}$POST$USER/$REPO.git"
  echo "$main"
  $main
}

remote_add() {
  for i in "${!REMOTES[@]}"
  do
      key=$i
      url=${REMOTES[$i]}
      add_repo="git remote add $key $CONN$url$POST$USER/$REPO.git"
      echo "$add_repo"
      $add_repo
  done
}

remote_seturl() {
  for i in "${!REMOTES[@]}"
  do
      set_url="git remote set-url --add --push origin $CONN${REMOTES[$i]}$POST$USER/$REPO.git"
      echo "$set_url"
      $set_url
  done
}

show_help() {
  echo "usage: $(basename "$0") $USAGE"
  echo ""
  echo "$LONG_USAGE"
  exit 0
}

set_repository() {
  REPO="$1"
}

set_username() {
  USER="$1"
}

show_origin() {
  show="git remote show origin"
  echo "$show"
  $show
}

#################################
#     MAIN CODE STARTS HERE     #
#################################

# Check if current directory is a git repository
if [ -d .git ]; then
  #echo .git
  echo "adding multiple repositories";
else
  git rev-parse --git-dir 2> /dev/null;
  echo "fatal: not a git repository"
  exit 0
fi;

# Loop to fetch all the commands
while case "$#" in 0) break ;; esac
do
  # echo "Looping: $1"
  # echo "value: $2"
  case "$1" in
    -h|--help)
      show_help
      ;;

    -r|--r|--re|--rep|--repo)
      # get the next variable
      shift
      set_repository "$1"
      ;;

    -u|--u|--user)
      # get the next variable
      shift
      set_username "$1"
      ;;

    -s|-ssl|--ssl)
      SSL=true
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

# Make sure to check the connection first
check_ssl

remote_main

remote_add

remote_seturl

show_origin
