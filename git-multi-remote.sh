#!/bin/bash

# Add Multiple Repository Server Script
# usage: git-multi-remote.sh -u username -r repository

# Get the script directory to find the config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Connection to the url address
declare -A URL
URL=(
  [CON]=""
  [AND]=""
)

# Comment out the repository servers you do not have with the '#' character
declare -A REMOTES     # Explicitly declare key value array
REMOTES=(
  [hub]=github.com
)

# Use the remote.conf file to setup configuration
declare -A CONFIG
CONFIG=(
  [SSL]=false
  [USER]=""
  [REPO]=""
)

# Set the main origin remote
ORIGIN="${REMOTES[hub]}"


USAGE="[-u <user>] [-r <repo>] [--ssl]"
LONG_USAGE="Add multiple remotes(server) for the same repository <repo>.
Config: Use 'remote.conf' to configure variables.
        Keep in mind using argument options 
        will override the configuration variables.

Note: The argument order does not matter.
Options:
    -u <user> Username of the repository
   --user <user>
    -r <repo> Name of the git repository
   --repo <repo>
   --git     Use git connection
   --ssl     Use https connection (default is git)

"

directory_as_repository() {
  IFS='/'
   # Read pwd into an array as tokens separated by IFS
  read -ra FULLPATH <<< "$PWD"
  # Reset to default value after usage
  IFS=' '

  # Get the last index to get the current directory
  last=$(("${#FULLPATH[@]}"-1))
  repo="${FULLPATH[$last]}"

  echo "multi-remote: using '$repo' as default repository"
  set_repository $repo
}

# Check if current directory is a git repository
check_git() {
  if [ -d .git ]; then
    echo "multi-remote: adding multiple remotes for '${CONFIG[REPO]}'
"
  else
    git rev-parse --git-dir 2> /dev/null
    echo "fatal: not a git repository"
    exit 0
  fi
}

# Functions need to be set before getting called
check_ssl() {
  if [ "${CONFIG[SSL]}" = true ]; then
    URL[CON]="https://"
    URL[AND]="/"
  else
    URL[CON]="git@"
    URL[AND]=":"
  fi
}

check_variables() {
  if [ -z "${CONFIG[USER]}" ]; then
    echo "fatal: username is empty"
    exit 0
  fi

  if [ -z "${CONFIG[REPO]}" ]; then
    directory_as_repository
  fi
}

init_config() {
  # while IFS= read -r line;
  while read line
  do
    if echo $line | grep -F = &>/dev/null; then
      # Skip comments lines using regular experssion with wildcards in double brackets
      if [[ $line =~ ^# ]]; then continue; fi

      # Get the main configuration variable
      conf=$(echo "$line" | cut -d '=' -f 1)
      # Identify the identifier and key
      var=$(echo "$conf" | cut -d '.' -f 1)
      key=$(echo "$conf" | cut -d '.' -f 2-)
      # Fetch the value
      val=$(echo "$line" | cut -d '=' -f 2-)

      # echo "$var [ ${key^^} ] = $val"

      # Skip unassigned variables
      if [ -z $val ]; then continue; fi

      # Assign the configurations
      case "$var" in
        REMOTES)
          REMOTES[$key]=$val
          ;;

        CONFIG)
          if [ $key = "ssl" ]; then
            CONFIG[${key^^}]=$val
          else
            CONFIG[${key^^}]=$(echo "$val")
          fi
          ;;
      esac
    fi
  done < "$DIR/remote.conf"
}

main() {
  # Loop to fetch all the commands
  while case "$#" in 0) break ;; esac
  do
    # echo "Looping: $1"
    # echo "value: $2"
    case "$1" in
      -h|--h|--help)
        show_help
        ;;

      -r|--r|--re|--rep|--repo)
        shift
        set_repository "$1"
        ;;

      -u|--u|--user)
        shift
        set_username "$1"
        ;;

      -g|-git|--git)
        CONFIG[SSL]=false
        ;;

      -s|-ssl|--ssl)
        CONFIG[SSL]=true
        ;;

      -*)
        break
        ;;

      *)
        break
        ;;
    esac
    # get the next variable
    shift
  done
}

remote_origin() {
  main="git remote add origin ${URL[CON]}$ORIGIN${URL[AND]}${CONFIG[USER]}/${CONFIG[REPO]}.git"
  echo "$main"
  $main
}

remote_add() {
  for i in "${!REMOTES[@]}"
  do
    key=$i
    url=${REMOTES[$i]}
    add_repo="git remote add $key ${URL[CON]}$url${URL[AND]}${CONFIG[USER]}/${CONFIG[REPO]}.git"
    echo "$add_repo"
    $add_repo
  done
}

remote_seturl() {
  for i in "${!REMOTES[@]}"
  do
    set_url="git remote set-url --add --push origin ${URL[CON]}${REMOTES[$i]}${URL[AND]}${CONFIG[USER]}/${CONFIG[REPO]}.git"
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
  CONFIG[REPO]="$1"
}

set_username() {
  CONFIG[USER]="$1"
}

show_origin() {
  show="git remote show origin"
  echo "$show"
  $show
}

#################################
#     MAIN CODE STARTS HERE     #
#################################

# Load the configuration
init_config

# Options passed in the arguments will override the configuration
main "$@"

# Make sure to check the connection first
check_variables

check_ssl

check_git

# After checking all the requirements start the git remote process
remote_origin

remote_add

remote_seturl

show_origin

exit 0