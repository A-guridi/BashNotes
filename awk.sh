# AWK
## Powerful text processing and pattern scanning language
## Operates on fields and records (lines by default)

# BASIC SYNTAX
awk 'pattern { action }' file.txt
awk -F delimiter 'pattern { action }' file.txt
awk -v var=value 'pattern { action }' file.txt
awk -f script.awk file.txt

# Command-line flags
-F delimiter      : set field separator (default: space/tab)
-v var=value      : set variable before processing
-f file           : read AWK script from file
-W version        : show AWK version


# FIELDS AND RECORDS
## $0 = entire line, $1 = first field, $2 = second field, etc.
## NF = number of fields/columns in current record
## NR = number of records (lines) processed so far
## FNR = file record number (resets per file)

# Examples
awk '{print $1}' file.txt                   # print first field of each line
awk '{print $NF}' file.txt                  # print last field
awk '{print $(NF-1)}' file.txt              # print second-to-last field
awk -F: '{print $1}' /etc/passwd            # print username (colon-separated)
awk '{print NR, $0}' file.txt               # print line number and entire line
awk 'NR > 10 && NR < 20 {print}' file.txt  # print lines 11-19
awk '{print NF, $0}' file.txt               # print field count and line


# PATTERNS
## No action defaults to printing the line

# Regex patterns
/regex/ { action }                          # match lines containing regex
/^pattern/ { action }                       # match lines starting with pattern
/pattern$/ { action }                       # match lines ending with pattern
!/pattern/ { action }                       # match lines NOT containing pattern

# Comparison patterns
$1 > 100 { action }                         # if first field > 100
$2 == "admin" { action }                    # if second field equals "admin"
$NF ~ /\.txt$/ { action }                   # if last field ends with .txt
$1 !~ /error/ { action }                    # if first field doesn't contain "error"

# Logical operators
$1 > 10 && $2 < 100 { action }             # AND condition
$1 == "yes" || $2 == "yes" { action }      # OR condition

# Special patterns
BEGIN { action }                            # run before processing any input
END { action }                              # run after processing all input
NR == 1 { action }                          # match first line only

# Examples
grep -like usage
awk '/ERROR/' file.txt                      # print lines containing ERROR
awk '$1 > 50' data.txt                      # print lines where first field > 50
awk '$2 ~ /^[A-Z]/' file.txt                # print lines where field 2 starts with uppercase
awk 'NR % 2 == 0' file.txt                  # print even-numbered lines
awk '/start/,/end/' file.txt                # print from "start" to "end" (range)


# STRING FUNCTIONS
length(string)              : string length
substr(string, start, len)  : extract substring
index(string, substring)    : find position of substring (1-based)
split(string, array, delim) : split string into array
sprintf(format, ...)        : format string
tolower(string)             : convert to lowercase
toupper(string)             : convert to uppercase
match(string, regex)        : test if regex matches (returns position)
sub(regex, replacement, target)      : replace first match
gsub(regex, replacement, target)     : replace all matches

# Examples
awk '{print length($1)}' file.txt           # print length of each first field
awk '{print substr($1, 1, 3)}' file.txt    # print first 3 chars of field 1
awk '{print index($0, "ERROR")}' file.txt  # find position of "ERROR"
awk '{print toupper($1)}' file.txt         # print first field in uppercase
awk '{print tolower($0)}' file.txt         # print entire line in lowercase
awk '{gsub(/old/, "new"); print}' file.txt # replace all "old" with "new"
awk '{n=split($0, a, ":"); print n}' file.txt  # split line by colon, count fields
awk '{if(match($0, /[0-9]+/)) print substr($0, RSTART, RLENGTH)}' file.txt  # extract first number


# NUMERIC FUNCTIONS
int(x)                  : truncate to integer
sqrt(x)                 : square root
sin(x), cos(x)          : trigonometry
exp(x), log(x)          : exponential, natural log
rand()                  : random number 0-1
srand(seed)             : seed random number generator

# Examples
awk '{print int($1 * 1.5)}' file.txt        # multiply by 1.5 and truncate
awk '{sum+=$1} END {print sum/NR}' file.txt # calculate average
awk '{print $1 % 2}' file.txt               # modulo operation (even/odd)
awk '{print sqrt($1)}' file.txt             # square root of first field


# ARRAYS
## Associative arrays (hash maps)

# Declaration and usage
array[key] = value
for (key in array) { action }

# Examples
awk '{count[$1]++} END {for(word in count) print word, count[word]}' file.txt
# Count occurrences of each first field

awk -F: '{users[$1]=1} END {for(u in users) print u}' /etc/passwd
# Extract unique usernames from /etc/passwd

awk '{for(i=1; i<=NF; i++) words[$i]++} END {for(w in words) print w, words[w]}' file.txt
# Count word frequency

# Multi-dimensional arrays (simulated with SUBSEP)
awk '{a[$1,$2]++} END {for(key in a) print key, a[key]}' file.txt


# VARIABLES (Internal)
NR              : current record number (line number)
NF              : number of fields in current record (n of columns)
FNR             : file record number (resets per file)
FS              : field separator (default: space/tab)
RS              : input record separator (default: newline)
OFS             : output field separator (default: space)
ORS             : output record separator (default: newline)
FILENAME        : current filename being processed
ARGC            : argument count
ARGV            : argument array
ENVIRON         : environment variables array
RSTART          : position of match() result
RLENGTH         : length of match() result

# Examples
awk 'BEGIN {FS=":"} {print $1}' /etc/passwd  # set field separator to colon
awk 'BEGIN {OFS="-"} {print $1,$2,$3}' data.txt  # join fields with dash
awk '{print FILENAME, NR, $0}' *.txt         # print filename, line number, content
awk '{print NF}' file.txt                    # print field count per line
awk 'BEGIN {print ENVIRON["HOME"]}'          # print HOME environment variable


# BEGIN AND END BLOCKS
## BEGIN runs before any input, END runs after all input

# Examples
awk 'BEGIN {print "Starting..."; sum=0} {sum+=$1} END {print "Total:", sum}' data.txt

awk 'BEGIN {FS=","} {total+=$2} END {print "Average:", total/NR}' sales.csv

awk 'BEGIN {OFS="\t"} {print $1, $2, $3}' file.txt > output.txt
# Convert space-separated to tab-separated

awk 'BEGIN {count=0} /pattern/ {count++} END {print "Found", count, "matches"}' file.txt


# OUTPUT FORMATTING WITH PRINTF
## Like C's printf, with format strings

printf "format", args

# Common format specifiers
%s      : string
%d      : integer
%f      : floating point (6 decimals by default)
%.2f    : floating point with 2 decimals
%e      : scientific notation
%x      : hexadecimal
%-10s   : left-aligned string in 10-char field
%10.2f  : right-aligned float in 10-char field with 2 decimals
\n      : newline
\t      : tab

# Examples
awk '{printf "%s: %d\n", $1, $2}' file.txt  # name and number
awk '{printf "%.2f\n", $1}' file.txt        # format to 2 decimal places
awk '{printf "%10s %5d %8.2f\n", $1, $2, $3}' file.txt  # aligned columns
awk 'BEGIN {printf "%30s\n", "Centered Title"}' # header formatting
awk '{printf "[%-10s] = %d\n", $1, $2}' data.txt  # aligned output


# CONTROL FLOW
if (condition) action
if (condition) action1; else action2
for (i=1; i<=n; i++) action
while (condition) action
do action; while (condition)
break, continue, next, exit

# Examples
awk '{if ($1 > 50) print "High:", $0; else print "Low:", $0}' file.txt

awk '{for(i=1; i<=NF; i++) print "Field " i ": " $i}' file.txt          # Prints all columns with "Field #number" before

awk '/ERROR/ {print; next} {count++} END {print "Non-error lines:", count}' file.txt        # counts non-error lines by matching lines with error and then skipping them
awk '!/ERROR/ BEGIN {count=0} {count++} END {print "Non-error lines:", count}' file.txt     # same as above, but without printing and using anti-pattern matching

awk '$1 > 1000 {sum+=$1; count++} END {if(count>0) print "Average:", sum/count}' data.txt


# FUNCTIONS
## User-defined functions

function name(arg1, arg2) {
    # function body
    return value
}

# Examples
awk '
function double(x) { return x * 2 }
{ print $1, double($1) }
' file.txt

awk '
function factorial(n) {
    if (n <= 1) return 1
    return n * factorial(n-1)
}
BEGIN { print factorial(5) }
'


# PRACTICAL EXAMPLES AND ONE-LINERS

# 1) Print specific columns with custom formatting
awk '{printf "%-20s %10d\n", $1, $2}' data.txt

# 2) Sum column and calculate average
awk '{sum+=$1; count++} END {print "Sum:", sum, "Average:", sum/count}' numbers.txt

# 3) Filter by condition and print custom output
awk '$3 > 100 {printf "%s earned $%d\n", $1, $3}' sales.txt

# 4) Change field separator and extract username/UID
awk -F: '{print $1, $3}' /etc/passwd | head -5

# 5) Count occurrences (word frequency)
awk '{for(i=1;i<=NF;i++) freq[$i]++} END {for(w in freq) print w, freq[w]}' file.txt

# 6) Print lines within line range
awk 'NR >= 10 && NR <= 20' file.txt

# 7) Replace text conditionally
awk '{gsub(/old/, "new"); print}' file.txt

# 8) Join lines from multiple files with matching keys
awk 'FNR==NR {a[$1]=$0; next} {print a[$1], $0}' file1.txt file2.txt

# 9) Extract and format CSV data
awk -F, '{printf "%-15s | %15s\n", $1, $3}' data.csv

# 10) Print lines with specific pattern and line numbers
awk '/ERROR/ {print NR": "$0}' logfile.txt

# 11) Calculate statistics (min, max, average)
awk '{if(NR==1||$1<min) min=$1; if(NR==1||$1>max) max=$1; sum+=$1} END {print "Min:", min, "Max:", max, "Avg:", sum/NR}' numbers.txt

# 12) Process multiple files and track filename
awk '{print FILENAME": Line " NR ": " $0}' *.txt

# 13) Extract records between two patterns
awk '/START/,/END/ {print}' file.txt

# 14) Compare two files and show differences in fields
awk 'NR==FNR {a[$1]=$0; next} {if(a[$1]!=$0) print FILENAME": Different"; else print FILENAME": Same"}' file1.txt file2.txt

# 15) Transform data format
awk 'BEGIN {OFS="-"} {print $1,$2,$3}' space_separated.txt

# 16) Remove duplicate lines (keep first occurrence)
awk '!seen[$0]++' file.txt

# 17) Print only even/odd numbered lines
awk 'NR % 2 == 0' file.txt     # even
awk 'NR % 2 == 1' file.txt     # odd

# 18) Extract columns and save to new file
awk '{print $1, $3, $5}' input.txt > output.txt

# 19) Complex processing with multiple conditions
awk '$1 ~ /^[A-Z]/ && $2 > 100 {total+=$2; count++} END {if(count>0) print "Matching records:", count, "Total:", total}' data.txt

# 20) Convert record (line) separator to null and field separator to newline, then print second and third line
aws 'RS=""; FS="\n" {print $2, $3 ;}' 


# COMBINING WITH OTHER COMMANDS

# Print longest line
awk '{if(length>max) {max=length; line=$0}} END {print line}' file.txt

# Count lines/words/characters (like wc)
awk 'END {print NR, NF*NR, length($0)}' file.txt

# Find lines with duplicate content in field 1
awk '{print $1}' file.txt | sort | uniq -d

# Process output from another command
ps aux | awk '$3 > 50 {print $2, $11}' # PIDs using > 50% CPU

# Extract IP addresses from log file
grep "192.168" logfile.txt | awk '{print $NF}' | sort | uniq -c

# CSV to TSV (comma to tab separated)
awk 'BEGIN {FS=","; OFS="\t"} {print $1, $2, $3}' data.csv


# TIPS AND GOTCHAS

# - Use -F option for different delimiters, or set FS in BEGIN block
# - Remember fields are 1-indexed, not 0-indexed
# - Use double quotes in string comparisons: $1 == "text"
# - Regex needs slashes: /pattern/, not "pattern"
# - Use ~ for regex match, == for exact string match
# - Arrays in AWK are always associative (no true ordered arrays)
# - Variables are uninitialized to 0 or empty string by default
# - Use printf for better control over output formatting
# - next skips to the next record without executing remaining actions
# - exit terminates the program and runs END block
