# TR
## tr is for text trimming and deleting
echo "My Little Pony" | tr [:upper:] [:lower:] | tr -d ' ' -> mylittlepony # first upper to lower, second deletes spaces
printf '%s' "my ID is 73535" | tr -cd [:digit:] -> 73535 # only digits
tr -d '\t' '\n' < words.txt         # usage with a file
-d -> delete
-c keep only the pattern
-s -> subtitution ->  # Note: (a bit complicated, for advanced stuff use the parameter subtitution or sed)
echo "A bit complex stuff" | tr -s ' ' '\n' -> Changes spaces for newlines 

# UNIQ
## for unique stuff, counting, deleting, removing duplicated
uniq file.txt -> Display unique lines only (-c flag to count them too)
sort kt.txt | uniq -c | awk '{print $2 ", " $1}' -> Display counter and each line, pretty formated with awk
# Uniq has many flags, all related to counting, finding and reading files with uniq stuff. 

# SORT
## Sorts a file or input lines. The input must be separated by \n to sort (use in combo with tr)
echo "a e d c b" | tr -s ' ' '\n' | sort | tr -s '\n' ', ' -> "a, b, c, d, e" (with double tr to change from and back to lines)
-r -> sort in reverse
-n -> sort numbers correctly
-kN,M -> sort by column number starting from N->M (for the same use -k2,2 for example)
-t -> specify delimiter (useful for columns)
# e.g  sorts by the second column (after the -) the actual numbers
printf "987-123\n456-7890\n456-7890\n345-00001" | sort -n -t '-' -k 2 -> 987-123 \n 456-7890 \n 456-7890 \n 345-00001

# GREP
## Pattern matching text
# Basic: grep 'pattern' file.txt/globfile (e.g *.txt)
-i          : ignore case
--include   : use only files matching that glob
--exclude   : exclude files matching the glob
-v          : invert match (show non-matching lines)
-n          : show line numbers
# -H        : show filename (useful with multiple files)
# -r/-R     : recursive search in directories
# -E        : use Extended regular expressions (egrep)
# -F        : fixed-strings (fast, no regex)
# -o        : print only the matching part of the line
-c          : print count of matching lines per file
-l          : list file names with matches
# -L        : list file names without matches
-w          : match whole words only
# -x        : match whole line only
-A N        : print N lines After each match
# -B N      : print N lines Before each match
# -C N      : print N lines of Context around each match (both A and B basically)

# 1) Case-insensitive search for "error" in a log file, show line numbers:
grep -i -n "error" /var/log/syslog

# 2) Search recursively for "TODO" in current directory, only in .py files:
grep -R --include='*.py' -n "TODO" .
# Search for function definitions in C files and show filenames and line numbers:
grep -R --include='*.c' -n "^\s*int [a-zA-Z_][a-zA-Z0-9_]*\s*(" .

# 3) Use extended regex to match either "foo" or "bar"in all txt files:
grep -E 'foo|bar' *.txt

# 4) Remove lines from aall files in current and subdirs by using inverted search
grep -r -w -v "Password:*" /home/user/*

# 4) Extract email-like tokens from a file (only matching parts):
grep -o -E '\b[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}\b' contacts.txt

# 5) Count blank lines in a file:
grep -c '^$' file.txt

# 6) Show lines that do NOT match (e.g., remove comments):
grep -v '^#' config.conf

# 7) Find processes and avoid matching the grep command itself:
ps aux | grep -i ssh | grep -v grep

# 8) Show matches with 2 lines of context after each match:
grep -n -A 2 'ERROR' app.log

# 9) Combine with sort/uniq to count matched tokens (e.g., area codes):
grep -oE '\b[0-9]{3}\b' calls.log | sort | uniq -c | sort -nr


# Notes:
# - Use -F for fixed-string searches when you don't need regex (faster).
# - Remember to quote patterns that contain shell-special characters.
# - Use --exclude or --include with recursive searches to limit files.


# SED
## Stream editor for filtering and transforming text
## Note: by default, if given a file, applies the transform line by line
## Common flags
-n        : suppress automatic printing of pattern space
-e script : add the script to be executed
-f file   : read sed script from file
-i[SUFFIX]: edit files in-place (optionally keep backup with SUFFIX)
-r / -E   : use extended regular expressions

## Basic substitution form
#   s/pattern/replacement/flags
#   flags: g (global), p (print), N number to replace nth match on line (e.g only first match, second match), I case insensitive


## Examples
# 1) Simple replace (all occurrences on each line):
sed -e 's/foo/bar/g' file.txt

# 2) In-place replacement starting from second occurence on (with backup):
sed -i.bak 's/old/new/2g' file.txt

# 3) Wrap the word "error" in brackets (case insensitive)
sed -r 's/\berror\b/{&}/gI' file.txt

# 3) Delete blank lines:
sed '/^$/d' file.txt > newfile

# 4) Use / too by changing the sed construction
sed s|/usr/loca/bin|/bin/g file > newfile
sed s/\/usr\/local\/bin/\/bin file > newfile

# 4) Print only matching lines (case-insenstive) (useful with -n):
sed -n '/ERROR/pI' app.log

# 5) Eliminate duplicate words
sed -r 's/([a-z]+) \1/\1/'

#7 ) Swap numbers around (e.g. credit cards numbers)
sed -r 's/(\d{4}) (\d{4}) (\d{4}) (\d{4})/\4 \3 \2 \1/'

#8 ) Remove blank lines after deleting words (with an A) with sed
sed -r 's/\w*[a]\w*//gI' | grep .

# 5) Print line numbers with matching lines:
sed -n '/pattern/{=;p;}' file.txt

# 6) Use capture groups to reformat (swap two CSV columns):
sed -E 's/^([^,]+),([^,]+)/\2,\1/' data.csv         # uses regex to match the first 2 columns separated by ','

# 7) Add a line after matches:
sed '/^Section:/a\
#New summary line' report.txt

# 8) Append text to lines matching a pattern:
sed '/TODO/s/$/  # needs follow-up/' tasks.txt

# 9) Replace only on a specific line range (lines 10-20):
sed '10,20 s/old/new/g' file.txt

# 10) Replace from line 20 until the end
sed '20,$ s/old/new/g' file.txt

# 10) Use sed as a quick tokenizer with piping (extract first field):
echo "a:b:c" | sed 's/:.*$//'   # => a

#print last 10 lines of file (instead of tail)
# First argument is the filename
lines=$(wc -l "$1" | awk '{print $1}' )
start=$(( lines - 10))
sed "1,$start d" "$1"

## Notes and tips
# - Prefer -E for extended regex to avoid many backslashes.
# - Use -n together with explicit p commands to control output precisely.
# - For complex scripts, put sed commands in a file and use -f script.sed.
# - Be cautious with `-i` (in-place); keep backups when unsure.



# TRAP
## command executed on error, useful for backups and deleting tempfiles
rollback() {
  echo "[ROLLBACK] Deployment failed. Restoring backup..."
  rm -rf "$APP_DIR"
  cp -r "$BACKUP_DIR" "$APP_DIR"
  systemctl restart myapp
  echo "[ROLLBACK] Complete. Service restored."
  exit 1
}

trap rollback ERR