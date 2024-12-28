##############################################################################
# Dockerfile for "Bite-Sized Command Line Labs" exercises.
##############################################################################
FROM ubuntu:22.04

##############################################################################
# 0) Install necessary packages
##############################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      grep \
      findutils \
      sed \
      gawk \
      vim \
      less \
      procps \
      tar \
      lsof

##############################################################################
# 1) Customize the shell prompt + welcome
##############################################################################
# Add a custom prompt
RUN echo 'export PS1="[\u~bite-sized-cmdline-labs \W]\\$ "' >> /root/.bashrc

# Create a top-level /exercises folder
WORKDIR /exercises

# We'll store a short welcome text and automatically display it on login
RUN echo "Welcome to the Bite-Sized Command Line Labs!\n"                             >  /exercises/README.txt \
 && echo "Explore the exercises in numeric order:"                                    >> /exercises/README.txt \
 && echo "  01_grep"                                                                  >> /exercises/README.txt \
 && echo "  02_find"                                                                  >> /exercises/README.txt \
 && echo "  03_xargs"                                                                 >> /exercises/README.txt \
 && echo "  04_sed"                                                                   >> /exercises/README.txt \
 && echo "  05_awk"                                                                   >> /exercises/README.txt \
 && echo "  08_ps"                                                                    >> /exercises/README.txt \
 && echo "  07_tar"                                                                   >> /exercises/README.txt \
 && echo "  06_diskusage"                                                             >> /exercises/README.txt \
 && echo "  09_top"                                                                   >> /exercises/README.txt \
 && echo "  10_sort_uniq"                                                             >> /exercises/README.txt \
 && echo "  11_head_tail"                                                             >> /exercises/README.txt \
 && echo "  12_less"                                                                  >> /exercises/README.txt \
 && echo "  13_kill"                                                                  >> /exercises/README.txt \
 && echo "  14_cat"                                                                   >> /exercises/README.txt \
 && echo "  15_lsof\n"                                                                >> /exercises/README.txt \
 && echo "Type 'cd /exercises/<number>_<topic>' and 'cat EXERCISES.txt' to begin.\n"  >> /exercises/README.txt \
 && echo "Have fun practicing!\n"                                                     >> /exercises/README.txt

RUN echo "cat /exercises/README.txt" >> /root/.bashrc


##############################################################################
# 2) 01_grep
##############################################################################
RUN mkdir -p /exercises/01_grep/data

RUN echo "Cats are wonderful pets.\nDogs are also great!\nI love cATS and DOGS!\ncatfish is not a cat.\n" \
     > /exercises/01_grep/data/cats_and_dogs.txt

RUN echo "Chocolate Cake Recipe\nIngredients:\n  - Flour\n  - Sugar\n  - cocoa\nDirections:\n  Mix flour and sugar.\n  Add cocoa.\n  Bake.\nSugar is sweet.\n" \
     > /exercises/01_grep/data/recipes.txt

RUN echo "GREP EXERCISES (01_grep)\n"                                                                 >  /exercises/01_grep/EXERCISES.txt \
 && echo "1) Basic search: grep 'Cats' data/cats_and_dogs.txt. Then ignore case (-i) to also find 'cATS'."  >> /exercises/01_grep/EXERCISES.txt \
 && echo "2) Recursive: grep -r 'Sugar' . from /exercises/01_grep/data to find matches in all files."       >> /exercises/01_grep/EXERCISES.txt \
 && echo "3) Invert match (-v): Show lines that do NOT contain 'cat' in cats_and_dogs.txt."                 >> /exercises/01_grep/EXERCISES.txt \
 && echo "4) Only matching text (-o): grep -o 'cat' cats_and_dogs.txt to see how many times 'cat' appears." >> /exercises/01_grep/EXERCISES.txt \
 && echo "5) Context: grep -C 2 'Sugar' data/recipes.txt to see lines before/after the match."              >> /exercises/01_grep/EXERCISES.txt \
 && echo "6) Combine flags: e.g. grep -i -o -r 'cat' . (case-insensitive, only match, recursive)."          >> /exercises/01_grep/EXERCISES.txt


##############################################################################
# 3) 02_find
##############################################################################
RUN mkdir -p /exercises/02_find/data/subdir
RUN mkdir -p /exercises/02_find/data/emptydir

RUN echo "Hello from alpha" > /exercises/02_find/data/alpha.txt
RUN echo "Hello from beta"  > /exercises/02_find/data/beta.log
RUN touch /exercises/02_find/data/emptyfile.txt
RUN echo "Hello from gamma" > /exercises/02_find/data/subdir/gamma.txt

RUN echo "FIND EXERCISES (02_find)\n"                                                           >  /exercises/02_find/EXERCISES.txt \
 && echo "1) Find by name: find . -name alpha.txt. Then try -iname ALPHA.TXT (case-insensitive)." >> /exercises/02_find/EXERCISES.txt \
 && echo "2) Find by type: -type f vs. -type d. List only files or directories."                  >> /exercises/02_find/EXERCISES.txt \
 && echo "3) Empty files: find . -size 0 to spot emptyfile.txt."                                  >> /exercises/02_find/EXERCISES.txt \
 && echo "4) Max depth: find . -maxdepth 1. Compare with -maxdepth 2 to see more."                >> /exercises/02_find/EXERCISES.txt \
 && echo "5) Exec: find . -name '*.txt' -exec grep Hello {} \\;. Or use echo, rm, etc."           >> /exercises/02_find/EXERCISES.txt \
 && echo "6) Delete: If you create a junk file, remove it with find . -name 'junk' -delete."       >> /exercises/02_find/EXERCISES.txt


##############################################################################
# 4) 03_xargs
##############################################################################
RUN mkdir -p /exercises/03_xargs/data

RUN echo "apple\nbanana\ncarrot\n" > /exercises/03_xargs/data/fruits.txt
RUN echo "foo bar\nbaz qux\n"      > /exercises/03_xargs/data/spaces.txt
RUN echo "Hello."                  > /exercises/03_xargs/data/file1.txt
RUN echo "World!"                  > /exercises/03_xargs/data/file2.txt

RUN echo "XARGS EXERCISES (03_xargs)\n"                                                                       >  /exercises/03_xargs/EXERCISES.txt \
 && echo "1) Basic usage: cat data/fruits.txt | xargs echo. Notice how xargs splits lines into arguments."    >> /exercises/03_xargs/EXERCISES.txt \
 && echo "2) Handling spaces: cat data/spaces.txt | xargs echo. Notice how it sees multiple tokens."          >> /exercises/03_xargs/EXERCISES.txt \
 && echo "   Try: find . -print0 | xargs -0 <COMMAND> to handle spaces safely."                               >> /exercises/03_xargs/EXERCISES.txt \
 && echo "3) -I {}: cat data/fruits.txt | xargs -I {} touch {}.txt => create a file per fruit."               >> /exercises/03_xargs/EXERCISES.txt \
 && echo "4) Parallel (-P): find . -name '*.txt' | xargs -P 2 -n 1 grep Hello."                               >> /exercises/03_xargs/EXERCISES.txt \
 && echo "5) Replace text: find . -name '*.txt' | xargs sed -i 's/Hello/Hi/g' (careful!)."                    >> /exercises/03_xargs/EXERCISES.txt \
 && echo "6) Combine with -0: find . -type f -empty -print0 | xargs -0 rm to remove empty files."             >> /exercises/03_xargs/EXERCISES.txt


##############################################################################
# 5) 04_sed
##############################################################################
RUN mkdir -p /exercises/04_sed/data

RUN echo "cat\ncat\ndog\nlion\ncat\n" > /exercises/04_sed/data/zoo.txt
RUN echo "1 alpha\n2 bravo\n3 charlie\n4 delta\n5 echo\n6 foxtrot\n7 golf\n" > /exercises/04_sed/data/lines.txt

RUN echo "SED EXERCISES (04_sed)\n"                                                               >  /exercises/04_sed/EXERCISES.txt \
 && echo "1) Simple substitution: sed 's/cat/dog/' data/zoo.txt => changes first 'cat' in each line."    >> /exercises/04_sed/EXERCISES.txt \
 && echo "2) Global (-g): sed 's/cat/dog/g' to replace all occurrences of 'cat' per line."               >> /exercises/04_sed/EXERCISES.txt \
 && echo "3) In-place (-i): sed -i 's/dog/cat/' data/zoo.txt modifies the file itself. Check the result!" >> /exercises/04_sed/EXERCISES.txt \
 && echo "4) Delete lines: sed '3d' data/zoo.txt (removes 3rd line). Or sed '/lion/d' to remove lines matching 'lion'." \
                                                                                                         >> /exercises/04_sed/EXERCISES.txt \
 && echo "5) Range of lines: sed -n '2,5p' data/lines.txt => prints lines 2 to 5 only."                  >> /exercises/04_sed/EXERCISES.txt \
 && echo "6) Append after match: sed '/cat/a panda' data/zoo.txt => adds 'panda' line after each 'cat' line." \
                                                                                                         >> /exercises/04_sed/EXERCISES.txt \
 && echo "7) Alternative delimiters: sed 's+cat+dog+g' might be easier than escaping slashes."            >> /exercises/04_sed/EXERCISES.txt


##############################################################################
# 6) 05_awk
##############################################################################
RUN mkdir -p /exercises/05_awk/data

RUN echo "id,name,age,salary\n1,Alice,30,60000\n2,Bob,25,50000\n3,Charlie,35,70000\n" \
     > /exercises/05_awk/data/people.csv

RUN echo "apple  10  fruit\nbanana 20  fruit\ncarrot 5   vegetable\n" \
     > /exercises/05_awk/data/products.txt

RUN echo "AWK EXERCISES (05_awk)\n"                                                                                >  /exercises/05_awk/EXERCISES.txt \
 && echo "1) Print a column: awk -F, '{print \$3}' data/people.csv => prints the 'age' column."                    >> /exercises/05_awk/EXERCISES.txt \
 && echo "2) Conditional print: awk -F, '\$4 > 55000 {print}' data/people.csv => find salary > 55000."            >> /exercises/05_awk/EXERCISES.txt \
 && echo "3) Sum a column: awk -F, '{sum += \$4} END {print sum}' data/people.csv => total all salaries."         >> /exercises/05_awk/EXERCISES.txt \
 && echo "4) Field separators: for data/products.txt, try awk '{print \$1, \$2}' to see name + quantity."         >> /exercises/05_awk/EXERCISES.txt \
 && echo "5) Length condition: awk 'length(\$0) > 20' data/products.txt => print lines > 20 chars long."          >> /exercises/05_awk/EXERCISES.txt \
 && echo "6) Multiple conditions: e.g. '(\$2 > 10 && \$3 == \"fruit\") {print}' for products that are fruit & >10." >> /exercises/05_awk/EXERCISES.txt \
 && echo "7) BEGIN/END blocks: print a header in BEGIN, then sum or summary in END."                               >> /exercises/05_awk/EXERCISES.txt


##############################################################################
# 7) 06_diskusage (du, df, etc.)
##############################################################################
RUN mkdir -p /exercises/06_diskusage

RUN echo "DISK USAGE EXERCISES (06_diskusage)\n"                                                        >  /exercises/06_diskusage/EXERCISES.txt \
 && echo "1) du -sh /exercises => see how big the exercises folder is in human-readable form."          >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "2) df -h => see overall disk usage for each mounted filesystem."                               >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "3) df -i => see inode usage. Low free inodes can block file creation."                         >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "4) If you install ncdu or iostat, try them: ncdu for interactive usage, iostat for read/write stats." >> /exercises/06_diskusage/EXERCISES.txt


##############################################################################
# 8) 07_tar
##############################################################################
RUN mkdir -p /exercises/07_tar/data

RUN echo "Hello from file1" > /exercises/07_tar/data/file1.txt
RUN echo "Hello from file2" > /exercises/07_tar/data/file2.txt

RUN echo "TAR EXERCISES (07_tar)\n"                                                                       >  /exercises/07_tar/EXERCISES.txt \
 && echo "1) Create an archive: tar -cf example.tar data/file1.txt data/file2.txt. Then list it: tar -tf example.tar."     >> /exercises/07_tar/EXERCISES.txt \
 && echo "2) Compress: tar -czf example.tar.gz data/file1.txt data/file2.txt => now it's gzipped."                          >> /exercises/07_tar/EXERCISES.txt \
 && echo "3) Extract: tar -xzf example.tar.gz -C /tmp/test => unpacks into /tmp/test (create that dir first!)."            >> /exercises/07_tar/EXERCISES.txt \
 && echo "4) List contents without extracting: tar -tf example.tar.gz => see what's inside."                               >> /exercises/07_tar/EXERCISES.txt \
 && echo "5) Try other flags: -j (bzip2), -J (xz) if installed, to compare file sizes."                                     >> /exercises/07_tar/EXERCISES.txt


##############################################################################
# 7) 08_ps
##############################################################################
RUN mkdir -p /exercises/08_ps

RUN echo "PS EXERCISES (08_ps)\n"                                                                               >  /exercises/08_ps/EXERCISES.txt \
 && echo "1) ps aux: see who owns processes, their PIDs, CPU & memory usage, etc."                             >> /exercises/08_ps/EXERCISES.txt \
 && echo "2) Wide output: ps auxww => show full command lines that might be truncated otherwise."              >> /exercises/08_ps/EXERCISES.txt \
 && echo "3) Environment: ps auxe => might show environment variables (root needed for all details)."          >> /exercises/08_ps/EXERCISES.txt \
 && echo "4) ps -eo user,pid,wchan,cmd => choose exactly which columns to list (like wchan for kernel states)." >> /exercises/08_ps/EXERCISES.txt \
 && echo "5) ps axf or pstree => see a process tree. Notice which processes spawn others."                      >> /exercises/08_ps/EXERCISES.txt \
 && echo "6) Process states: watch for 'R' (running), 'S' (sleeping), 'Z' (zombie). Which do you see?"          >> /exercises/08_ps/EXERCISES.txt


##############################################################################
# 10) 09_top
##############################################################################
RUN mkdir -p /exercises/09_top

RUN echo "TOP EXERCISES (09_top)\n"                                                                     >  /exercises/09_top/EXERCISES.txt \
 && echo "1) Run 'top': notice CPU usage, memory usage, load average. Press 'q' to exit."               >> /exercises/09_top/EXERCISES.txt \
 && echo "2) Check load average: the 1, 5, 15-minute numbers. Compare to your CPU count."               >> /exercises/09_top/EXERCISES.txt \
 && echo "3) Sort by CPU usage if your 'top' supports interactive sorting (often type 'o', then '%CPU')." >> /exercises/09_top/EXERCISES.txt \
 && echo "4) Observe memory columns: total, free, used, cache. Why might 'free + used' ≠ total?"         >> /exercises/09_top/EXERCISES.txt \
 && echo "5) If 'htop' is installed, compare. It's more colorful and interactive."                       >> /exercises/09_top/EXERCISES.txt


##############################################################################
# 11) 10_sort_uniq
##############################################################################
RUN mkdir -p /exercises/10_sort_uniq/data

RUN echo "banana\napple\nbanana\ncherry\napple\napple\n42\n100\n7\n42\n" \
     > /exercises/10_sort_uniq/data/mixed.txt

RUN echo "SORT & UNIQ EXERCISES (10_sort_uniq)\n"                                                                         >  /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "1) Basic sort: sort data/mixed.txt => alphabetical order. Notice '42' vs. '7' if you do normal sort."          >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "2) Numeric sort (-n): sort -n data/mixed.txt => sorts numbers properly (7, 42, 100, etc.)."                     >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "3) Removing duplicates: cat data/mixed.txt | sort | uniq => see each unique line. Or just sort -u."             >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "4) Counting duplicates: cat data/mixed.txt | sort | uniq -c => see how many times each line appears."           >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "5) Human sort (-h): if you have sizes like 1K, 2M, try 'ls -lh | sort -h' to see them in ascending size order."  >> /exercises/10_sort_uniq/EXERCISES.txt


##############################################################################
# 12) 11_head_tail
##############################################################################
RUN mkdir -p /exercises/11_head_tail

RUN echo "HEAD & TAIL EXERCISES (11_head_tail)\n"                                                       >  /exercises/11_head_tail/EXERCISES.txt \
 && echo "1) head file.txt => first 10 lines. Use -n to change lines (e.g. head -n 5)."                 >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "2) tail file.txt => last 10 lines. tail -n 20 => last 20 lines. Compare differences."         >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "3) Negative -n: head -n -5 file.txt => all lines except the last 5."                          >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "4) Bytes (-c): head -c 1K file.txt => first 1024 bytes. tail -c 1K => last 1024 bytes."       >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "5) tail -f logs.txt => follow new lines as they arrive (useful for logs). Press Ctrl+C to stop." >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "6) tail --retry or tail --pid can handle special cases. Explore if you have a log scenario."   >> /exercises/11_head_tail/EXERCISES.txt


##############################################################################
# 13) 12_less
##############################################################################
RUN mkdir -p /exercises/12_less

RUN echo "LESS EXERCISES (12_less)\n"                                                                >  /exercises/12_less/EXERCISES.txt \
 && echo "1) less file.txt => read a file. Move with arrow keys, PgUp/PgDn. Press q to quit."         >> /exercises/12_less/EXERCISES.txt \
 && echo "2) Searching: type /pattern then Enter, use n / N to go to next/prev match."                 >> /exercises/12_less/EXERCISES.txt \
 && echo "3) G / g => jump to end / beginning of file. Like vim commands."                            >> /exercises/12_less/EXERCISES.txt \
 && echo "4) -r => show colored output (e.g. ls --color | less -r) instead of escape codes."           >> /exercises/12_less/EXERCISES.txt \
 && echo "5) F => follow the file as it grows, similar to tail -f. Press Ctrl+C to stop."              >> /exercises/12_less/EXERCISES.txt \
 && echo "6) +cmd => less +G file.txt starts at the end. less +/foo file.txt searches for 'foo' at start." >> /exercises/12_less/EXERCISES.txt


##############################################################################
# 14) 13_kill
##############################################################################
RUN mkdir -p /exercises/13_kill

RUN echo "KILL EXERCISES (13_kill)\n"                                                                         >  /exercises/13_kill/EXERCISES.txt \
 && echo "1) kill -SIGNAL PID => send a signal (default is SIGTERM=15). Use ps or top to find a PID."         >> /exercises/13_kill/EXERCISES.txt \
 && echo "2) kill -9 or kill -KILL => forcibly terminate. Use carefully if normal kill doesn't stop it."      >> /exercises/13_kill/EXERCISES.txt \
 && echo "3) kill -l => lists all signals. Identify SIGSTOP, SIGTERM, SIGKILL, etc."                          >> /exercises/13_kill/EXERCISES.txt \
 && echo "4) killall => kill all processes by name: killall firefox (with -w or -i for caution)."             >> /exercises/13_kill/EXERCISES.txt \
 && echo "5) pgrep / pkill => find or kill processes by pattern. pgrep -f or pkill -f might match full cmd."  >> /exercises/13_kill/EXERCISES.txt \
 && echo "6) Practice: run 'yes > /dev/null &' then find its PID and kill it."                                >> /exercises/13_kill/EXERCISES.txt


##############################################################################
# 15) 14_cat
##############################################################################
RUN mkdir -p /exercises/14_cat/data

RUN echo "Hello from cat!\nLine 2\nLine 3\n" > /exercises/14_cat/data/sample.txt

RUN echo "CAT (& FRIENDS) EXERCISES (14_cat)\n"                                                          >  /exercises/14_cat/EXERCISES.txt \
 && echo "1) cat data/sample.txt => display the file content."                                          >> /exercises/14_cat/EXERCISES.txt \
 && echo "2) cat -n data/sample.txt => number each line."                                               >> /exercises/14_cat/EXERCISES.txt \
 && echo "3) Redirect input: cat > new.txt => type lines, press Ctrl+D to finish, check new.txt."        >> /exercises/14_cat/EXERCISES.txt \
 && echo "4) zcat => prints a gzipped file's contents (if you have a .gz file). 'zcat logs.gz' etc."     >> /exercises/14_cat/EXERCISES.txt \
 && echo "5) tee => duplicates stdin to stdout & a file: echo 'hi' | tee out.txt => see 'hi', also in out.txt." >> /exercises/14_cat/EXERCISES.txt \
 && echo "6) Combine with grep, sed, etc.: cat bigfile | grep 'term'. Usually you can just 'grep' directly though." \
                                                                                                         >> /exercises/14_cat/EXERCISES.txt


##############################################################################
# 16) 15_lsof
##############################################################################
RUN mkdir -p /exercises/15_lsof

RUN echo "LSOF EXERCISES (15_lsof)\n"                                                             >  /exercises/15_lsof/EXERCISES.txt \
 && echo "1) Run 'lsof' (no args) => see a long list of open files by all processes."             >> /exercises/15_lsof/EXERCISES.txt \
 && echo "2) lsof -p <PID> => which files a given PID has open. Use 'ps' or 'top' to find a PID."  >> /exercises/15_lsof/EXERCISES.txt \
 && echo "3) lsof /exercises => see what's open in /exercises. Or lsof . if you 'cd' somewhere."   >> /exercises/15_lsof/EXERCISES.txt \
 && echo "4) lsof | grep deleted => find processes holding deleted files open (common on Linux)."  >> /exercises/15_lsof/EXERCISES.txt \
 && echo "5) Network sockets: lsof -i => list open TCP/UDP. Try -nP to skip DNS/port resolution."   >> /exercises/15_lsof/EXERCISES.txt \
 && echo "6) Combine with kill or pgrep if you need to free a locked file or kill a stuck process." >> /exercises/15_lsof/EXERCISES.txt

##############################################################################
# Final Dockerfile Steps
##############################################################################
# Default to /exercises so user lands there, show the welcome message, etc.
WORKDIR /exercises
CMD ["/bin/bash"]
