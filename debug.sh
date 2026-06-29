# Debug a bash script
# set -x will enable debug mode inside a script (set +x) to exit it
set -x
echo a b c | tr -d " " ""
# otherwise 
bash -x script.sh   # This will run the script in debug mode too
# Combine with this to get linenumber
export PS4='Line ${LINENO}: '
bash -x script.sh

# Check for syntax erros without runnign the script
bash -n script.sh
shellcheck script.sh        # If available, good for following best practices

set -v          # Reads commans as they are read (instead of executed) to get syntax errors
set -u          # Sets undefined variables as errors
set -e          # Exit on command failure 