${parameter:-word} # Use Default Value. If 'parameter' is unset or null, 'word' (which may be an expansion) is substituted. Otherwise, the value of 'parameter' is substituted.

${parameter:=word} # Assign Default Value. If 'parameter' is unset or null, 'word' (which may be an expansion) is assigned to 'parameter'. The value of 'parameter' is then substituted.

${parameter:+word} #Use Alternate Value. If 'parameter' is null or unset, nothing is substituted, otherwise 'word' (which may be an expansion) is substituted.

${parameter:offset:length} #Substring Expansion. Expands to up to 'length' characters of 'parameter' starting at the character specified by 'offset' If ':length' is omitted, go all the way to the end. If 'offset' is negative (use parentheses!), count backward from the end of 'parameter' instead of forward from the beginning. If 'parameter' is @ or an indexed array name subscripted by @ or *, the result is 'length' positional parameters or members of the array, respectively, starting from 'offset'.

${#parameter} #The length in characters of the value of 'parameter' is substituted. If 'parameter' is an array name subscripted by @ or *, return the number of elements.

${parameter#pattern} #The 'pattern' is matched against the beginning of 'parameter'. The result is the expanded value of 'parameter' with the shortest match deleted. 
#If 'parameter' is an array name subscripted by @ or *, this will be done on each element. Same for all following items.

${parameter##pattern} #As above, but the longest match is deleted.

${parameter%pattern} #The 'pattern' is matched against the end of 'parameter'. The result is the expanded value of 'parameter' with the shortest match deleted.

${parameter%%pattern} #As above, but the longest match is deleted.

${parameter/pat/string} #Results in the expanded value of 'parameter' with the first (unanchored) match of 'pat' replaced by 'string'. Assume null string when the '/string' part is absent.

${parameter//pat/string} #As above, but every match of 'pat' is replaced.

${parameter/#pat/string} #As above, but matched against the beginning. Useful for adding a common prefix with a null pattern: "${array[@]/#/prefix}".

${parameter/%pat/string} #As above, but matched against the end. Useful for adding a common suffix with a null pattern. 

# Example strings:
# parameter="abcdeabc"

#   ${parameter#abc}    => deabc
#   ${parameter##a*e}   => abc (from the end)
#   ${parameter%abc}    => abcde
#   ${parameter%%b*c}   => a
#   ${parameter/de/XY}  => abcXYabc
#   ${parameter//a/X}   => XbcdeXbc
#   ${parameter/#abc/X} => Xdeabc
#   ${parameter/%abc/Y} => abcdeY
#

#  parameter="/home/user/file.txt":
#   ${parameter#*/}         => home/user/file.txt
#   ${parameter##*/}        => file.txt
#   ${parameter%.*}         => /home/user/file
#   ${parameter%%/*}        => (empty string)
#   ${parameter/.txt/.bak} => /home/user/file.bak
#   ${parameter//o/O}       => /hOme/user/file.txt
#   ${parameter/#/mnt}      => /mnt/home/user/file.txt
#   ${parameter/%txt/.bak} => /home/user/file.bak
#
# Example array values:
# array=("apple" "banana" "cherry")
#   ${array[@]#b*}          => apple banana cherry
#   ${array[@]##*e}         => apple banana cherry
#   ${array[@]%a}           => appl banan cherr
#   ${array[@]%%a}          => appl banan cherr
#   ${array[@]/a/X}         => Xpple bXnXnX cherry
#   ${array[@]//a/X}        => Xpple bXnXnX cherry
#   ${array[@]/#b/B}        => apple Banana cherry
#   ${array[@]/%y/YY}       => apple banana cherrYY
#
# array=("/usr/bin" "/etc/passwd")
#   ${array[@]#*/}          => usr/bin passwd
#   ${array[@]##*/}         => bin passwd
#   ${array[@]%/*}          => /usr /etc
#   ${array[@]%%/*}         => (empty string) (empty string)
#   ${array[@]/.txt/.bak}   => /usr/bin /etc/passwd
#   ${array[@]//*/X}        => X X
#   ${array[@]/#/mnt}       => /mnt/usr/bin /mnt/etc/passwd
#   ${array[@]/%d/.bak}     => /usr/bin /etc/passbak