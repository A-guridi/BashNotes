# STRINGS
## Iterating over a string
for((i=0; i<${#str}; i++)); do char="${str:i:1}"; done

## Inputs
${#array} -> len of array
${array[@]} -> array elements
${array[*]} -> array elements as a single string


## Arrays
array=(one two three)
declare -A associative_array=(
  [key1]=value1
  [key2]=value2
)

# READ
# each invocation reads line by line of the input
read -a array   # reads an array split by spaces

# Read each line from a file into an array
mapfile -t lines < file.txt
echo "${lines[@]}"

# Read each line from stdin into an array
printf 'one\ntwo\nthree\n' | mapfile -t input_array
echo "${input_array[@]}"

# Read a single line into an array of words
read -r -a words < file.txt
echo "${words[@]}"

# Build an array manually from a file using a loop
declare -a arr=()
while IFS= read -r line; do
    arr+=("$line")
done < file.txt
echo "${arr[@]}"

## Change words in array

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora');
declare -a patter=( ${Unix[@]/Red*/Redhat Sucks} )
echo ${patter[@]}

## Read files
while read -r line; do
    # echo "$line"
    for word in $line; do
        if [[ -n "${associative_array["$word"]}" ]]; then
            (( associative_array["$word"]+=1 ))
        else
            (( associative_array["$word"]=1 ))
        fi
    done
done < "$filename"          # subsitute by >filename to write the loop output into a file

## Sort directly from loops
for key in "${!associative_array[@]}"; do
    echo "$key ${associative_array[$key]}"
done | sort -rn -k2


# FILES
## list files in array
find=(*)    # do not use ls
find . -name '*.jpg' -print     # find files ending in jpg in the current dir

## write stdout+stderr logs to file
grep proud file 'not a file' > proud.log 2>&1

### Heredostrings as input strings
grep proud <<<"I am a proud sentence"

### Diff two files by using temp sorted files
diff <(sort file1) <(sort file2)

# Write config to a file directly from terminal
cat <<EOF > config.txt
host=localhost
port=5432
database=mydb
EOF

## xargs
# xargs reads items from standard input and executes a command using those items as arguments.
# It is useful for taking pipe output and turning it into arguments for another command.
# Common flags:
#   -n N    : use at most N arguments per command line
#   -0      : input items are terminated by a null character, safe for spaces/special characters
#   -I repl : replace occurrences of repl in the initial-arguments with each input item
#   -r      : do not run the command if there is no input
#   -p      : prompt before running each command line
#   -P N    : run in parallel N times

echo -e "file1.txt\nfile2.txt" | xargs rm

# Use -n to batch items into multiple invocations.
printf '%s\n' a b c d | xargs -n2 echo

# Placeholder replacement example.
echo "one two" | xargs -n1 -I{} sh -c 'printf "item=%s\n" "$1"' _ {}

# Non-find examples:
# - Remove files listed in a text file.
cat delete-list.txt | xargs rm
# Run curl in parallel (4 Processes) on a list of URLS
cat urls.txt | xargs -P 4 -I {} curl {}
# - Copy files listed on stdin to backup directory.
echo "a.txt b.txt" | xargs -n1 -I{} cp {} backup/
# - Run grep on file names passed from stdin.
echo "README.md basics.sh" | xargs -n1 grep -H "TODO"

# Safe input handling with null terminators. Useful when input names may contain spaces.
find . -name '*.log' -print0 | xargs -0 rm          # Very important to use -print0 with find and the -0 flag in combination to process files correctly
find . -name '*.txt' -print0 | xargs -0 gzip

# Use -n to limit how many arguments go to each command invocation.
printf '%s\n' a b c d | xargs -n2 echo

# Use -I{} for a placeholder replacement pattern.
echo "one two" | xargs -n1 -I{} sh -c 'printf "item=%s\n" "$1"' _ {}

# Combine with find and other utilities.
find . -type f -name '*.sh' -print0 | xargs -n1 basename
find . -maxdepth 1 -type f | xargs -n1 ls -l

## String matches in [[ ... ]] (bash)
# Basic comparisons
[[ "$str" == "foo" ]]      # equal
[[ "$str" != "foo" ]]      # not equal
[[ "$str" < "$other" ]]   # lexicographically smaller
[[ "$str" > "$other" ]]   # lexicographically greater
[[ -z "$str" ]]            # empty string
[[ -n "$str" ]]            # non-empty string

# Pattern matching
[[ "$str" == foo* ]]       # starts with foo
[[ "$str" == *.txt ]]      # ends with .txt
[[ "$str" == [A-Z]* ]]     # starts with uppercase letter
[[ "$str" != foo* ]]       # does not start with foo

# Regex matching
[[ "$str" =~ ^[A-Z]{3}[0-9]+$ ]]   # regex match

# Examples
str="hello"
[[ "$str" == hello ]] && echo "match"
[[ "$str" != world ]] && echo "not world"
[[ "$str" == h* ]] && echo "starts with h"
[[ "$str" =~ ^h ]] && echo "matches regex"

