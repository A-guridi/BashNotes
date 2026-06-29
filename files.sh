# FILE OPERATIONS

# TOUCH
## Create empty files or update modification/access times
touch filename                  # create empty file or update timestamp
touch file1 file2 file3        # create multiple files
touch -a filename              # update only access time
touch -m filename              # update only modification time
touch -t [[CC]YY]MMDDhhmm[.ss] # set specific timestamp
touch -r reference_file target # match timestamp of reference file

# Examples
touch test.txt                          # create empty file
touch -t 202301011200 oldfile.txt       # set to Jan 1, 2023 at noon
touch -r original.txt copy.txt          # match timestamps


# MKDIR
## Create directories
mkdir dirname                   # DO NOT USE: create single directory
mkdir -p path/to/nested/dirs   # ALWAYS USE THIS: create all parent directories
mkdir -m 755 dirname           # create with specific permissions
mkdir dir1 dir2 dir3           # create multiple directories

# Examples
mkdir -p ~/projects/bash/scripts        # create full path
mkdir -m 700 private_dir                # create with 700 permissions
mkdir test_{1..5}              # create test_1 through test_5


# RM / RMDIR
## Remove files and directories
rm filename                     # remove file
rm -f filename                  # force remove (no confirmation)
rm -i filename                  # interactive confirmation
rm -r dirname                   # recursive remove (directory + contents)
rm -rf dirname                  # force recursive remove
rmdir dirname                   # remove empty directory only

# Examples
rm -f *.tmp                             # remove all temp files
rm -r old_project/                      # remove directory and contents
rm -i sensitive_*.txt                   # confirm before removing each file


# CP / COPY
## Copy files and directories
cp source destination           # copy file
cp -r source_dir dest_dir      # recursive copy (directories)
cp -p source dest              # preserve permissions/timestamps
cp -a source dest              # archive mode (copy with all attributes)
cp -v source dest              # verbose output
cp -u source dest              # copy only if source is newer
cp source dest1 dest2 dest3/  # copy multiple to directory

# Examples
cp -r ~/templates/* ./new_project/               # copy all templates
cp -p important.txt backup/important.txt         # preserve attributes
cp -v *.py backup/ 2>&1 | tee copy.log          # verbose with logging
cp -u config.old config                         # update only if needed


# MV / MOVE
## Move or rename files
mv source destination           # move/rename file or directory
mv -i source dest              # interactive confirmation
mv -f source dest              # force overwrite
mv -v source dest              # verbose output
mv source1 source2 source3 destdir/  # move multiple

# Examples
mv oldname.txt newname.txt                      # rename file
mv file.txt archive/                            # move to directory
mv -i *.log logs/                               # move with confirmation
mv project/ ~/projects/                         # move entire directory


# MKTEMP
## Create temporary files/directories safely
mktemp                         # create temp file in /tmp
mktemp -d                      # create temp directory
mktemp -p /custom/path         # create in specific directory
mktemp --suffix=.log           # add custom suffix
mktemp -t prefix.XXXXX         # use custom prefix

# Examples
tmpfile=$(mktemp)                               # create temp file in variable
tmpdir=$(mktemp -d)                             # create temp directory
trap "rm -rf $tmpdir" EXIT                      # CLEANUP cleanup on script exit
log=$(mktemp -t deploy.XXXXX)                   # temp file with prefix


# FIND
## Search for files by various criteria
find path -name pattern         # search by filename
find path -not -name patter     # the not negates all the conditions after it, creating an anti pattern to exlude files
find path -type type            # f (file), d (directory), l (link)
find path -maxdepth N           # recursive search only until N dirs deep
find path -size size            # +Nc, -Nc, Nc (N bytes)
find path -mtime days           # modified N days ago
find path -atime days           # accessed N days ago
find path -perm permissions     # specific permissions
find path -user username        # owned by user
find path -group groupname      # owned by group
find path -exec command {} \;   # execute command on results
find path -print0 | xargs -0    # safe handling of filenames with spaces

# Examples
find . -name "*.txt" -type f                    # find text files
find . -maxdepth 1 -not -name ".*"              # equivalent to "ls", displays all non-hidden files and folders in the current dir only
find . -name "*.o" -o -name "*.out"             # find object files OR output files
find . -type f -size +10M                       # files larger than 10MB
find . -type f -mtime -7                        # modified in last 7 days
find . -type f -name "*.py" -exec chmod 755 {} \;  # make all Python scripts executable
find . -type f -name "*.tmp" -delete            # delete all temp files
find . -type f -print0 | xargs -0 grep "TODO"  # safe grep on found files -> xargs used to pipe output to input as argument safely
find / -name passwd 2>/dev/null                 # suppress permission errors


# LS / LSD
## List files and directories
ls                              # basic listing
ls -l                           # long format (permissions, size, date)
ls -la                          # include hidden files
ls -lh                          # human-readable sizes
ls -lS                          # sort by size (largest first)
ls -lt                          # sort by modification time (newest first)
ls -ltr                         # sort by time, reverse (oldest first)
ls -1                           # one file per line
ls -R                           # recursive listing
ls --group-directories-first    # directories before files

# Examples
ls -lh *.txt | awk '{print $5, $9}'             # show size and name
ls -lt | head -10                               # show 10 newest files
ls -la | grep "^d"                              # show directories only
ls -1 | wc -l                                   # count files
ls -lR | grep "^d" | wc -l                      # count directories recursively


# STAT / FILE
## File information and type detection
stat filename                   # detailed file information
stat -c '%a' filename           # show permissions in octal
stat -c '%y' filename           # show modification time
file filename                   # determine file type
file -b filename                # show file type only (no filename)
file -i filename                # show MIME type

# Examples
stat -c '%s %a %y %n' *.txt                     # size, perms, time, name
file data                                       # show if text/binary/archive
file -b test.sh | grep -q script && echo "Script"  # check if executable


# CHMOD
## Change file permissions
chmod mode filename             # change permissions
chmod u+x filename              # add execute for user
chmod g-w filename              # remove write for group
chmod o=r filename              # set read-only for others
chmod -R mode dirname           # recursive change
chmod 755 filename              # rwxr-xr-x (common for directories)
chmod 644 filename              # rw-r--r-- (common for files)
chmod 600 filename              # rw------- (private file)

# Examples
chmod +x script.sh                              # make executable
chmod -x file.txt                               # remove executable bit
chmod 644 *.txt                                 # readable/writable files
chmod 755 -R project/                           # readable/executable directories
chmod u+s /usr/bin/command                      # set setuid bit


# CHOWN / CHGRP
## Change file owner and group
chown user filename             # change owner
chown user:group filename       # change owner and group
chown -R user dirname           # recursive change
chgrp group filename            # change group only

# Examples (requires sudo)
sudo chown root:root /etc/config              # change ownership
sudo chown -R user:user ~/project/             # transfer directory ownership
sudo chgrp staff shared_file                   # change group


# CAT / LESS / MORE
## Display and paginate file contents
cat filename                    # display entire file
cat file1 file2 file3           # display multiple files
cat file1 file2 > combined.txt # concatenate into new file
less filename                   # paginate with navigation
more filename                   # paginate simple (forward only)
head -n N filename              # show first N lines
tail -n N filename              # show last N lines
tail -f filename                # follow file (watch for updates)

# Examples
cat *.log | tee output.txt                      # display and save
cat -n file.txt                                 # show line numbers
tail -f /var/log/syslog                         # watch log in real-time
head -20 file.txt | tail -10                    # lines 11-20


# WC
## Word Count lines, words, characters
wc filename                     # lines, words, characters
wc -l filename                  # count lines only
wc -w filename                  # count words only
wc -c filename                  # count bytes only
wc -L filename                  # longest line length
wc -l *.txt                     # count lines in multiple files

# Examples
wc -l *.py                                      # count Python lines
cat *.txt | wc -w                               # total words
find . -name "*.sh" -exec wc -l {} \; | awk '{sum+=$1} END {print sum}'  # total shell script lines


# DU / DF
## Disk usage information
du filename                     # file size
du -h filename                  # human-readable size
du -sh dirname                  # directory total size
du -sh *                        # size of each item in current dir
du -shc *.txt                   # sizes and total
du --max-depth=1 -h             # one level deep
df -h                           # disk space per mount
df -h /path                     # space on specific mount

# Examples
du -sh ~/Downloads                              # total download size
du -sh * | sort -h | tail -10                   # 10 largest items
du -sh --max-depth=1 / | sort -h                # largest directories
df -h | grep -E "^/dev"                         # real disk partitions


# CPIO
## Copy files to/from archives (safer than tar for permissions)
cpio -o < filelist > archive.cpio   # create archive from list
cpio -i < archive.cpio              # extract archive
cpio -id < archive.cpio             # extract with directories
cpio -p dest_dir < filelist         # copy files preserving structure

# Examples
find . -name "*.py" | cpio -o > python_files.cpio
cpio -id < backup.cpio 2>/dev/null


# TAR
## Archive files (tape archive)
tar -cvf archive.tar files          # create verbose archive
tar -xvf archive.tar                # extract verbose
tar -czf archive.tar.gz files       # create gzip compressed
tar -xzf archive.tar.gz             # extract gzip
tar -tf archive.tar                 # list contents
tar -rf archive.tar newfile         # append to archive
tar -uvf archive.tar --exclude="*.o" .  # update only changed files

# Examples
tar -czf backup.tar.gz project/                 # compress entire directory
tar -xzf backup.tar.gz -C /target/             # extract to destination
tar -czf - . | ssh user@host "tar -xz -C /remote"  # remote backup
tar -xzf archive.tar.gz --wildcards '*.py'     # extract only .py files


# GZIP / BZIP2 / XZ
## Compression utilities
gzip filename                   # compress file (removes original)
gzip -k filename                # keep original
gzip -d filename.gz             # decompress
gzip -9 filename                # maximum compression (1-9, default 6)
bzip2 filename                  # better compression than gzip
xz filename                     # best compression (but slower)

# Examples
gzip -9 large_file.txt                          # max compression
gunzip file.gz                                  # decompress
zcat file.gz | grep pattern                     # search compressed file
bzcat file.bz2 | head                           # display bzip2 file


# DD 
## Use only for low-level stuff if you are very sure, CAUTION
## Low-level file copy/conversion
dd if=source of=destination     # basic copy
dd if=/dev/zero of=file bs=1M count=100  # create 100MB file
dd if=/dev/urandom of=file bs=1M count=10    # random data file
dd if=/dev/sda of=backup.img bs=4M # backup disk partition
dd status=progress if=source of=dest  # show progress

# Examples
dd if=/dev/zero of=empty.bin bs=1M count=1    # 1MB empty file
dd if=/dev/urandom of=random.dat bs=1k count=100
dd if=/dev/sda1 of=partition.backup bs=4M status=progress


# SPLIT / UNSPLIT
## Split large files
split -n N filename             # split into N parts
split -b size filename          # split by size (10M, 1G, etc)
split -l lines filename         # split by number of lines
cat part_* > original            # rejoin split files

# Examples
split -b 100M large.iso part_    # split 100MB chunks
split -l 1000 bigfile.txt chunk_ # split every 1000 lines
cat xaa xab xac > original.tar.gz # rejoin


# RENAME / MASS RENAME
## Bulk rename files
rename 's/old/new/' files       # Perl rename utility
rename 's/\.txt$/.log/' *.txt   # change extension
for f in old_*; do mv "$f" "${f/old_/new_}"; done  # bash loop rename
mv oldname newname              # single file

# Examples
rename 's/_backup//' *_backup   # remove suffix from files
rename 's/\.JPG$/\.jpg/' *.JPG   # lowercase extensions
for f in *.txt; do mv "$f" "${f%.txt}.md"; done # .txt to .md


# USEFUL COMBINATIONS AND ONE-LINERS

# Remove old files (older than 30 days)
find . -type f -mtime +30 -delete

# Remove empty directories recursively
find . -type d -empty -delete

# Find files changed in last hour
find . -type f -cmin -60

# Make backup with date stamp
cp important.txt important.txt.$(date +%Y%m%d_%H%M%S)

# Copy file to multiple destinations
cp sourcefile dest1/ dest2/ dest3/

# Find and list largest files
find . -type f -exec ls -lh {} \; | sort -k5 -h | tail -20

# Count total size of files matching pattern
find . -name "*.log" -type f -exec du -c {} \; | tail -1

# Secure file deletion (overwrite before deleting)
shred -vfz -n 3 sensitive_file

# Remove files with special characters in name
ls | grep -E "^[^A-Za-z0-9]" | xargs -I {} rm "{}"

# Create sparse file (efficient large file for testing)
fallocate -l 1G sparse_file

# Sync files with preservation and progress
rsync -avh --progress source/ destination/

# Archive with exclusions
tar --exclude='*.o' --exclude='.git' -czf archive.tar.gz project/

# Find duplicate files by content
find . -type f -exec md5sum {} \; | sort | uniq -d

# Change all file extensions in directory
for f in *.old; do mv "$f" "${f%.old}.new"; done

# Set file timestamp to current date
touch -t $(date +%Y%m%d%H%M.%S) filename

# Copy directory structure without files
find . -type d -exec mkdir -p /destination/{} \;


# TIPS AND GOTCHAS

# - Always quote variables in scripts: "$file" not $file
# - Use -r with rm for directories (not just files)
# - Be very careful with rm -rf, especially with variables
# - mktemp is safer than manually creating temp files
# - Use find with -print0 and xargs -0 for filenames with spaces
# - Preserve file attributes with cp -a or rsync
# - Check permissions before accessing sensitive files
# - Use file command to verify file types before processing
# - Always backup before using sed -i or similar in-place edits
# - Use du -h --max-depth for quick size summaries without recursing too deep
