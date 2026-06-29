#!/usr/bin/env bash


# This exercise covers how to implement a basic grep function to search for matching text in a input row of files

line_numbers=0
names_only=0
invert=0
whole_line=0
ignore_case=0
file_names=0

while getopts "nlivx" opt; do
    case $opt in
        n) line_numbers=1 ;;
        l) names_only=1 ;;
        i) ignore_case=1 ;;
        v) invert=1 ;;
        x) whole_line=1 ;;
        *) exit 1 ;;
    esac
done

# shift to discard all the flagged options
shift "$((OPTIND-1))"

pattern=$1
shift       # from here on, all args are just file names

# if more than one input file, display file names
[[ "$#" -ge 2 ]] && file_names=1

# adds ^ and $ to do whole line matching
(( whole_line )) && pattern="^${pattern}$"

# make lowercase matching default
(( ignore_case )) && shopt -s nocasematch

readfile() {
    local file=$1
    local line
    local matched
    local line_no=0

    while IFS= read -r line; do
        ((line_no++))

        matched=0
        [[ $line =~ $pattern ]] && matched=1

        # invert the pattern matching
        (( invert )) && (( matched = !matched ))

        # continue if no matches
        (( matched )) || continue

        if (( names_only )); then
            printf '%s\n' "$file"
            return
        fi

        if (( file_names && line_numbers )); then
            printf '%s:%d:%s\n' "$file" "$line_no" "$line"
        elif (( file_names )); then
            printf '%s:%s\n' "$file" "$line"
        elif (( line_numbers )); then
            printf '%d:%s\n' "$line_no" "$line"
        else
            printf '%s\n' "$line"
        fi

    done < "$file"
}

for file in "$@"; do
    readfile "$file"
done