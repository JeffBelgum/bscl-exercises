##############################################################################
# Dockerfile for "Bite-Sized Command Line Labs" exercises.
# Credit to Julia Evans (@b0rk) and the "Bite-Sized Command Line" zine:
#   https://wizardzines.com/zines/bite-size-command-line/
# This is unofficial supplemental material, for those who have purchased the zine.
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
      lsof \
      python3 \
      gzip \
      bzip2 \
      xz-utils \
      coreutils

# Create a startup script that launches background jobs.
RUN mkdir -p /usr/local/bin

RUN <<OUTER_HEREDOC
cat <<EOF > /usr/local/bin/start_demo_workloads.sh
#!/bin/bash

###############################################################################
# 1) Low-priority, indefinite CPU load
#    Runs 'yes' but at nice level 15 to minimize impact
###############################################################################
( nice -n 15 yes > /dev/null ) &

###############################################################################
# 2) Low-priority, indefinite I/O load
#    Appends ~10 KB every 3 seconds to /tmp/demofile
###############################################################################
( ionice -c3 sh -c "
  while true; do
    dd if=/dev/zero of=/tmp/demofile bs=1K count=10 oflag=append conv=notrunc \
      >/dev/null 2>&1
    sleep 3
  done
" ) &

###############################################################################
# 3) Low-priority, indefinite memory usage (~10MB)
#    Allocates ~10MB in Python and sleeps in a loop
###############################################################################
( nice -n 15 python3 -c "
import time
x = ' ' * 10000000  # ~10MB
while True:
    time.sleep(60)
" ) &

# End of start_demo_workloads.sh
EOF

# Make the script executable
chmod +x /usr/local/bin/start_demo_workloads.sh
OUTER_HEREDOC

##############################################################################
# 1) Customize the shell prompt + welcome
##############################################################################
# Case insensitive tab completion
RUN echo 'bind "set completion-ignore-case on"' >> /root/.bashrc

# Add a custom prompt
RUN echo 'export PS1="[\u~bite-sized-cmdline-labs \W]\\$ "' >> /root/.bashrc

# Create a top-level /exercises folder
WORKDIR /exercises

# We'll store a short welcome text and automatically display it on login
RUN echo "Welcome to the **Unofficial** Bite-Sized Command Line Labs!\n"              >  /exercises/README.txt \
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
 && echo "Enjoy practicing, and remember to support the official zine if you haven't already purchased it!\n"  >> /exercises/README.txt

RUN echo "cat /exercises/README.txt" >> /root/.bashrc

##############################################################################
# 2) 01_grep
##############################################################################
RUN mkdir -p /exercises/01_grep/data

RUN echo "Cats are wonderful pets.\nDogs are also great!\nI love cATS and DOGS!\ncatfish is not a cat.\n" \
     > /exercises/01_grep/data/cats_and_dogs.txt

RUN echo "Chocolate Cake Recipe\nIngredients:\n  - Flour\n  - Sugar\n  - cocoa\nDirections:\n  Mix flour and sugar.\n  Add cocoa.\n  Bake.\nSugar is sweet.\n" \
     > /exercises/01_grep/data/recipes.txt

# EXERCISES.txt
RUN echo "GREP EXERCISES (01_grep)\n"                                                                    >  /exercises/01_grep/EXERCISES.txt \
 && echo "1) How many lines in cats_and_dogs.txt mention the word \"cats\" (regardless of case)?"        >> /exercises/01_grep/EXERCISES.txt \
 && echo "   Hint: Try grep -i 'cats' data/cats_and_dogs.txt\n"                                          >> /exercises/01_grep/EXERCISES.txt \
 && echo "2) Which file(s) in the data folder mention the word \"Sugar\"?"                               >> /exercises/01_grep/EXERCISES.txt \
 && echo "3) How many lines do NOT contain the string \"cat\" in cats_and_dogs.txt?"                     >> /exercises/01_grep/EXERCISES.txt \
 && echo "4) How many times does the exact substring \"cat\" appear in cats_and_dogs.txt?"               >> /exercises/01_grep/EXERCISES.txt \
 && echo "5) In recipes.txt, on which lines does the word \"Sugar\" appear, and what are the two lines"  >> /exercises/01_grep/EXERCISES.txt \
 && echo "   immediately before and after each match?"                                                   >> /exercises/01_grep/EXERCISES.txt \
 && echo "6) If you combined flags like -i -o -r to look for \"cat\" in all files (ignoring case,"       >> /exercises/01_grep/EXERCISES.txt \
 && echo "   only printing the matched text), what do you see?\n"                                        >> /exercises/01_grep/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 01_grep\n"                                         >  /exercises/01_grep/HINTS.txt \
 && echo "2) Try grep -r 'Sugar' .\n"                                  >> /exercises/01_grep/HINTS.txt \
 && echo "3) Try grep -v 'cat' data/cats_and_dogs.txt\n"               >> /exercises/01_grep/HINTS.txt \
 && echo "4) Try grep -o 'cat' data/cats_and_dogs.txt\n"               >> /exercises/01_grep/HINTS.txt \
 && echo "5) Try grep -C 2 'Sugar' data/recipes.txt\n"                 >> /exercises/01_grep/HINTS.txt \
 && echo "6) Try grep -i -o -r 'cat' .\n"                              >> /exercises/01_grep/HINTS.txt


##############################################################################
# 3) 02_find
##############################################################################
RUN mkdir -p /exercises/02_find/data/subdir
RUN mkdir -p /exercises/02_find/data/emptydir

RUN echo "Hello from alpha" > /exercises/02_find/data/alpha.txt
RUN echo "Hello from beta"  > /exercises/02_find/data/beta.log
RUN touch /exercises/02_find/data/emptyfile.txt
RUN echo "Hello from gamma" > /exercises/02_find/data/subdir/gamma.txt

# EXERCISES.txt
RUN echo "FIND EXERCISES (02_find)\n"                                            >  /exercises/02_find/EXERCISES.txt \
 && echo "1) Which subdirectory holds the file named alpha.txt?"                 >> /exercises/02_find/EXERCISES.txt \
 && echo "   Hint: find . -name alpha.txt\n"                                     >> /exercises/02_find/EXERCISES.txt \
 && echo "2) How many files (not directories) live in the data subdirectory?"    >> /exercises/02_find/EXERCISES.txt \
 && echo "3) Is there an empty file in the data folder? If so, what’s its name?" >> /exercises/02_find/EXERCISES.txt \
 && echo "4) How many items (files and directories) are found under . if you"    >> /exercises/02_find/EXERCISES.txt \
 && echo "   limit the search to -maxdepth 1 versus -maxdepth 2?"                >> /exercises/02_find/EXERCISES.txt \
 && echo "5) Which .txt file(s) contain the word \"Hello\"?"                     >> /exercises/02_find/EXERCISES.txt \
 && echo "6) If you create a file named \"junk\" somewhere under ., can you"     >> /exercises/02_find/EXERCISES.txt \
 && echo "   remove it using a single find command?\n"                           >> /exercises/02_find/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 02_find\n"                           >  /exercises/02_find/HINTS.txt \
 && echo "2) Try find ./data -type f | wc -l\n"          >> /exercises/02_find/HINTS.txt \
 && echo "3) Try find . -size 0\n"                       >> /exercises/02_find/HINTS.txt \
 && echo "4) Compare find . -maxdepth 1 with find . -maxdepth 2\n" \
                                                         >> /exercises/02_find/HINTS.txt \
 && echo "5) Try find . -name '*.txt' -exec grep Hello {} \\;\n" \
                                                         >> /exercises/02_find/HINTS.txt \
 && echo "6) Try find . -name 'junk' -delete\n"          >> /exercises/02_find/HINTS.txt


##############################################################################
# 4) 03_xargs
##############################################################################
RUN mkdir -p /exercises/03_xargs/data

RUN echo "apple\nbanana\ncarrot\n" > /exercises/03_xargs/data/fruits.txt
RUN echo "foo bar\nbaz qux\n"      > /exercises/03_xargs/data/spaces.txt
RUN echo "Hello."                  > /exercises/03_xargs/data/file1.txt
RUN echo "World!"                  > /exercises/03_xargs/data/file2.txt

# EXERCISES.txt
RUN echo "XARGS EXERCISES (03_xargs)\n"                                                                     >  /exercises/03_xargs/EXERCISES.txt \
 && echo "1) How can you print all the fruits from fruits.txt on a single line?"                            >> /exercises/03_xargs/EXERCISES.txt \
 && echo "   Hint: cat data/fruits.txt | xargs echo\n"                                                      >> /exercises/03_xargs/EXERCISES.txt \
 && echo "2) What happens if you run xargs echo on spaces.txt? Can you fix it using the '-0' flag?"         >> /exercises/03_xargs/EXERCISES.txt \
 && echo "3) How do you create a .txt file for each fruit listed in fruits.txt?"                            >> /exercises/03_xargs/EXERCISES.txt \
 && echo "4) Which .txt file(s) contain 'Hello'? Try using xargs in parallel (-P) with grep."               >> /exercises/03_xargs/EXERCISES.txt \
 && echo "5) How can you replace the word 'Hello' with 'Hi' inside each file found in data/?"               >> /exercises/03_xargs/EXERCISES.txt \
 && echo "6) Can you remove empty files by combining 'find' with xargs and '-0'? (Be careful!)\n"           >> /exercises/03_xargs/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 03_xargs\n"                                                                  >  /exercises/03_xargs/HINTS.txt \
 && echo "2) Try: cat data/spaces.txt | xargs echo, then find . -print0 | xargs -0 <command>\n"  >> /exercises/03_xargs/HINTS.txt \
 && echo "3) cat data/fruits.txt | xargs -I {} touch {}.txt\n"                                   >> /exercises/03_xargs/HINTS.txt \
 && echo "4) find . -name '*.txt' | xargs -P 2 -n 1 grep Hello\n"                                >> /exercises/03_xargs/HINTS.txt \
 && echo "5) find data/ -name '*.txt' | xargs sed -i 's/Hello/Hi/g'\n"                           >> /exercises/03_xargs/HINTS.txt \
 && echo "6) find . -type f -empty -print0 | xargs -0 rm\n"                                      >> /exercises/03_xargs/HINTS.txt


##############################################################################
# 5) 04_awk
##############################################################################
RUN mkdir -p /exercises/04_awk/data

RUN echo "id,name,age,salary\n1,Alice,30,60000\n2,Bob,25,50000\n3,Charlie,35,70000\n" \
     > /exercises/04_awk/data/people.csv

RUN echo "apple  10  fruit\nbanana 20  fruit\ncarrot 5   vegetable\n" \
     > /exercises/04_awk/data/products.txt

# EXERCISES.txt
RUN echo "AWK EXERCISES (04_awk)\n"                                                           >  /exercises/04_awk/EXERCISES.txt \
 && echo "1) Which column in people.csv is the 'age' column, and how do you print it?"        >> /exercises/04_awk/EXERCISES.txt \
 && echo "   Hint: awk -F, '{print \$3}' data/people.csv\n"                                   >> /exercises/04_awk/EXERCISES.txt \
 && echo "2) Which employees earn more than 55000? (filter by salary) "                       >> /exercises/04_awk/EXERCISES.txt \
 && echo "3) Can you sum the 'salary' column and print the total?"                            >> /exercises/04_awk/EXERCISES.txt \
 && echo "4) How do you print just the first and second columns from products.txt?"           >> /exercises/04_awk/EXERCISES.txt \
 && echo "5) Which lines in products.txt are longer than 20 characters in total length?"      >> /exercises/04_awk/EXERCISES.txt \
 && echo "6) Can you print only the entries that are 'fruit' with quantity > 10?"             >> /exercises/04_awk/EXERCISES.txt \
 && echo "7) How do you display a custom header line before printing and a summary after?"    >> /exercises/04_awk/EXERCISES.txt

# HINTS.txt
RUN <<CATCOMMAND
cat << 'EOF' > /exercises/04_awk/HINTS.txt
HINTS for 04_awk

2) awk -F, '$4 > 55000 {print $0}' data/people.csv
3) awk -F, '{sum += $4} END {print sum}' data/people.csv
4) awk '{print $1, $2}' data/products.txt
5) awk 'length($0) > 20' data/products.txt
6) awk '($2 > 10 && $3 == "fruit") {print $0}' data/products.txt
7) awk 'BEGIN {print "--- PRODUCT REPORT ---"} { ... } END {print "--- END ---"}'
EOF
CATCOMMAND

##############################################################################
# 6) 05_sed
##############################################################################
RUN mkdir -p /exercises/05_sed/data

RUN echo "cat\ncat\ndog\nlion\ncat\n" > /exercises/05_sed/data/zoo.txt
RUN echo "1 alpha\n2 bravo\n3 charlie\n4 delta\n5 echo\n6 foxtrot\n7 golf\n" > /exercises/05_sed/data/lines.txt

# EXERCISES.txt
RUN echo "SED EXERCISES (05_sed)\n"                                                                       >  /exercises/05_sed/EXERCISES.txt \
 && echo "1) How can you replace just the FIRST occurrence of 'cat' with 'dog' on each line in zoo.txt?"  >> /exercises/05_sed/EXERCISES.txt \
 && echo "   Hint: sed 's/cat/dog/' data/zoo.txt\n"                                                       >> /exercises/05_sed/EXERCISES.txt \
 && echo "2) How can you replace EVERY occurrence of 'cat' with 'dog'?"                                   >> /exercises/05_sed/EXERCISES.txt \
 && echo "3) How do you modify a file IN PLACE, such that 'dog' becomes 'cat' permanently?"               >> /exercises/05_sed/EXERCISES.txt \
 && echo "4) How can you DELETE specific lines by number or by pattern, e.g., remove line 3 or lines matching 'lion'?" \
                                                                                                          >> /exercises/05_sed/EXERCISES.txt \
 && echo "5) Can you print only lines 2 through 5 from lines.txt?"                                        >> /exercises/05_sed/EXERCISES.txt \
 && echo "6) How do you APPEND the word 'panda' after any line that contains 'cat'?"                      >> /exercises/05_sed/EXERCISES.txt \
 && echo "7) What if you want to use different delimiters (like +) instead of / when substituting?"       >> /exercises/05_sed/EXERCISES.txt

RUN <<'CATCOMMAND'
cat <<'EOF' > /exercises/05_sed/HINTS.txt
HINTS for 05_sed

2) Use the 'g' flag: sed 's/cat/dog/g' data/zoo.txt
3) Use '-i': sed -i 's/dog/cat/' data/zoo.txt
4) Use 'sed "3d"' or 'sed "/lion/d"' data/zoo.txt
5) sed -n '2,5p' data/lines.txt
6) sed '/cat/a panda' data/zoo.txt
7) sed 's+cat+dog+g' data/zoo.txt (easier than escaping slashes)
EOF
CATCOMMAND


##############################################################################
# 7) 06_diskusage (du, df, etc.)
##############################################################################
RUN mkdir -p /exercises/06_diskusage

# EXERCISES.txt
RUN echo "DISK USAGE EXERCISES (06_diskusage)\n"                                                    >  /exercises/06_diskusage/EXERCISES.txt \
 && echo "1) How much total disk space does /exercises use, in human-readable form?"                >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "   Hint: du -sh /exercises\n"                                                             >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "2) How can you see overall disk usage (size, used, avail) for each mounted filesystem?"   >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "3) How can you check how many inodes are used/free? (Hint: it's similar to df -h)"        >> /exercises/06_diskusage/EXERCISES.txt \
 && echo "4) Can you try 'ncdu' or 'iostat' (if installed) to see interactive disk usage or I/O stats?\n" \
                                                                                                    >> /exercises/06_diskusage/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 06_diskusage\n"                                               >  /exercises/06_diskusage/HINTS.txt \
 && echo "2) df -h\n"                                                             >> /exercises/06_diskusage/HINTS.txt \
 && echo "3) df -i\n"                                                             >> /exercises/06_diskusage/HINTS.txt \
 && echo "4) ncdu or iostat (if installed) can be run with ncdu / or iostat 5\n"  >> /exercises/06_diskusage/HINTS.txt


##############################################################################
# 8) 07_tar
##############################################################################
RUN mkdir -p /exercises/07_tar/data

RUN echo "Hello from file1" > /exercises/07_tar/data/file1.txt
RUN echo "Hello from file2" > /exercises/07_tar/data/file2.txt

# EXERCISES.txt
RUN echo "TAR EXERCISES (07_tar)\n"                                                           >  /exercises/07_tar/EXERCISES.txt \
 && echo "1) How do you CREATE a .tar archive from file1.txt and file2.txt?"                  >> /exercises/07_tar/EXERCISES.txt \
 && echo "   Hint: tar -cf example.tar data/file1.txt data/file2.txt\n"                       >> /exercises/07_tar/EXERCISES.txt \
 && echo "2) How do you COMPRESS this archive with gzip?"                                     >> /exercises/07_tar/EXERCISES.txt \
 && echo "3) How do you EXTRACT a .tar.gz archive to a specific directory (e.g. /tmp/test)?"  >> /exercises/07_tar/EXERCISES.txt \
 && echo "4) How do you LIST the contents of a .tar.gz file without extracting?"              >> /exercises/07_tar/EXERCISES.txt \
 && echo "5) What other compression flags (like -j or -J) can you try?\n"                     >> /exercises/07_tar/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 07_tar\n"                                                          >  /exercises/07_tar/HINTS.txt \
 && echo "2) tar -czf example.tar.gz data/file1.txt data/file2.txt\n"                  >> /exercises/07_tar/HINTS.txt \
 && echo "3) tar -xzf example.tar.gz -C /tmp/test\n"                                   >> /exercises/07_tar/HINTS.txt \
 && echo "4) tar -tf example.tar.gz\n"                                                 >> /exercises/07_tar/HINTS.txt \
 && echo "5) Try tar -cjf for bzip2 (.tar.bz2) or tar -cJf for xz (.tar.xz)\n"         >> /exercises/07_tar/HINTS.txt


##############################################################################
# 9) 08_ps
##############################################################################
RUN mkdir -p /exercises/08_ps

# EXERCISES.txt
RUN echo "PS EXERCISES (08_ps)\n"                                                              >  /exercises/08_ps/EXERCISES.txt \
 && echo "1) How can you see all running processes (with username, CPU/mem usage, etc.)?"      >> /exercises/08_ps/EXERCISES.txt \
 && echo "   Hint: ps aux\n"                                                                   >> /exercises/08_ps/EXERCISES.txt \
 && echo "2) What option(s) let you see the process tree as ASCII art? (hint: 'forest' mode)"  >> /exercises/08_ps/EXERCISES.txt \
 && echo "3) How can you show environment variables for each process?"                         >> /exercises/08_ps/EXERCISES.txt \
 && echo "4) Which ps option(s) let you choose exactly which columns to list (e.g. wchan)?"    >> /exercises/08_ps/EXERCISES.txt \
 && echo "5) How do you interpret the STATE column letters like R, S, Z, T, etc.?"             >> /exercises/08_ps/EXERCISES.txt \
 && echo "6) Can you see which processes are in a 'zombie' state right now?\n"                 >> /exercises/08_ps/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 08_ps\n"                                                                   >  /exercises/08_ps/HINTS.txt \
 && echo "2) ps axf or ps auxf (forest) or try pstree\n"                                       >> /exercises/08_ps/HINTS.txt \
 && echo "3) ps auxe will show environment variables\n"                                        >> /exercises/08_ps/HINTS.txt \
 && echo "4) ps -eo user,pid,wchan,cmd or other columns\n"                                     >> /exercises/08_ps/HINTS.txt \
 && echo "5) R=running, S=sleeping, Z=zombie, T=stopped, etc.\n"                               >> /exercises/08_ps/HINTS.txt \
 && echo "6) Try ps aux | grep ' Z '\n"                                                        >> /exercises/08_ps/HINTS.txt


##############################################################################
# 10) 09_top
##############################################################################
RUN mkdir -p /exercises/09_top

# EXERCISES.txt
RUN echo "TOP EXERCISES (09_top)\n"                                                            >  /exercises/09_top/EXERCISES.txt \
 && echo "1) How do you run 'top' and exit when you're done?"                                  >> /exercises/09_top/EXERCISES.txt \
 && echo "   Hint: Just type 'top' to start, then press 'q' to exit.\n"                        >> /exercises/09_top/EXERCISES.txt \
 && echo "2) What do the 1-, 5-, and 15-minute load average numbers mean?"                     >> /exercises/09_top/EXERCISES.txt \
 && echo "3) How can you sort the process list by CPU usage interactively?"                    >> /exercises/09_top/EXERCISES.txt \
 && echo "4) Why might 'free + used' memory not add up to the 'total' displayed?"              >> /exercises/09_top/EXERCISES.txt \
 && echo "5) If 'htop' is installed, how does it differ from 'top'?\n"                         >> /exercises/09_top/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 09_top\n"                                                                   >  /exercises/09_top/HINTS.txt \
 && echo "2) They show CPU demand over time. If > # of CPU cores, the system is overloaded.\n"  >> /exercises/09_top/HINTS.txt \
 && echo "3) In many 'top' versions, press 'o' or 'F' (capital) to change sort column.\n"       >> /exercises/09_top/HINTS.txt \
 && echo "4) Because of cached/buffered memory, the 'used' memory isn't always all 'used'.\n"   >> /exercises/09_top/HINTS.txt \
 && echo "5) 'htop' is more colorful/interactive. You can scroll, kill processes, etc.\n"       >> /exercises/09_top/HINTS.txt


##############################################################################
# 11) 10_sort_uniq
##############################################################################
RUN mkdir -p /exercises/10_sort_uniq/data

RUN echo "banana\napple\nbanana\ncherry\napple\napple\n42\n100\n7\n42\n" \
     > /exercises/10_sort_uniq/data/mixed.txt

# EXERCISES.txt
RUN echo "SORT & UNIQ EXERCISES (10_sort_uniq)\n"                                                                >  /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "1) How do you sort the file 'mixed.txt' alphabetically?"                                               >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "   Hint: sort data/mixed.txt\n"                                                                        >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "2) How do you sort it numerically so that numbers come before words in the right order?"               >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "3) How can you remove duplicates, leaving only one of each item?"                                      >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "4) How do you show how many times each item appears?"                                                  >> /exercises/10_sort_uniq/EXERCISES.txt \
 && echo "5) What if you want to do a 'human-readable' sort on things like 1K, 2M, 500K, etc.?"                  >> /exercises/10_sort_uniq/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 10_sort_uniq\n"                                                                        >  /exercises/10_sort_uniq/HINTS.txt \
 && echo "2) Use sort -n data/mixed.txt.\n"                                                                >> /exercises/10_sort_uniq/HINTS.txt \
 && echo "3) Combine sort + uniq, or just do sort -u data/mixed.txt.\n"                                    >> /exercises/10_sort_uniq/HINTS.txt \
 && echo "4) Pipe through uniq -c, e.g.: sort data/mixed.txt | uniq -c.\n"                                 >> /exercises/10_sort_uniq/HINTS.txt \
 && echo "5) Use sort -h for 'human-readable' sorts (like 2K < 10K < 1M).\n"                               >> /exercises/10_sort_uniq/HINTS.txt


##############################################################################
# 11) 11_head_tail
##############################################################################
RUN mkdir -p /exercises/11_head_tail

# Let's provide a small file for demonstration.
RUN echo "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11" \
    > /exercises/11_head_tail/sample.txt

# EXERCISES.txt
RUN echo "HEAD & TAIL EXERCISES (11_head_tail)\n"                                    >  /exercises/11_head_tail/EXERCISES.txt \
 && echo "1) How do you show just the first 5 lines of sample.txt?"                  >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "   Hint: head -n 5 sample.txt\n"                                           >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "2) How do you show just the last 3 lines of sample.txt?"                   >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "3) How do you show all lines EXCEPT the last 5?"                           >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "4) How do you show only the first 1KB of a file (try -c)?"                 >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "5) How do you 'follow' a file as it grows, stopping with Ctrl+C?"          >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "6) Can you do the same 'follow' but stop automatically when another"       >> /exercises/11_head_tail/EXERCISES.txt \
 && echo "   process ends? (Hint: tail --pid PID -f file.log)\n"                     >> /exercises/11_head_tail/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 11_head_tail\n"                                                          >  /exercises/11_head_tail/HINTS.txt \
 && echo "2) tail -n 3 sample.txt\n"                                                         >> /exercises/11_head_tail/HINTS.txt \
 && echo "3) head -n -5 sample.txt => negative means 'exclude the last 5 lines'\n"           >> /exercises/11_head_tail/HINTS.txt \
 && echo "4) head -c 1K sample.txt\n"                                                        >> /exercises/11_head_tail/HINTS.txt \
 && echo "5) tail -f sample.txt => press Ctrl+C to stop\n"                                   >> /exercises/11_head_tail/HINTS.txt \
 && echo "6) tail --pid <PID> -f file.log => stops following when <PID> finishes\n"          >> /exercises/11_head_tail/HINTS.txt


##############################################################################
# 12) 12_less
##############################################################################
RUN mkdir -p /exercises/12_less

# Let's create a small text file for demonstration.
RUN echo "This is a small demonstration of how less works.\n"          >  /exercises/12_less/demo.txt \
 && echo "You can move with arrow keys, PageUp, PageDown, etc.\n"      >> /exercises/12_less/demo.txt \
 && echo "Try using /pattern to search for words!\n"                   >> /exercises/12_less/demo.txt \
 && echo "Press q to quit.\n"                                          >> /exercises/12_less/demo.txt \
 && echo "Use -r to show colors if needed (ls --color | less -r).\n"   >> /exercises/12_less/demo.txt

# EXERCISES.txt
RUN echo "LESS EXERCISES (12_less)\n"                                                       >  /exercises/12_less/EXERCISES.txt \
 && echo "1) How do you open demo.txt in less and navigate?"                                >> /exercises/12_less/EXERCISES.txt \
 && echo "   Hint: less demo.txt (then arrow keys, PgUp/PgDn, q to quit)\n"                 >> /exercises/12_less/EXERCISES.txt \
 && echo "2) How do you search for the word 'pattern' in demo.txt once it's open?"          >> /exercises/12_less/EXERCISES.txt \
 && echo "3) How do you jump to the END of the file, then back to the BEGINNING?"           >> /exercises/12_less/EXERCISES.txt \
 && echo "4) Which flag shows colored output properly if you do: ls --color | less ?"       >> /exercises/12_less/EXERCISES.txt \
 && echo "5) How do you 'follow' the file in real-time (like tail -f) once you're in less?" >> /exercises/12_less/EXERCISES.txt \
 && echo "6) How can you start less at the END of the file or search for 'pattern' upon opening?" >> /exercises/12_less/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 12_less\n"                                                                             >  /exercises/12_less/HINTS.txt \
 && echo "2) Type /pattern then press Enter, use n/N to jump next/prev.\n"                                 >> /exercises/12_less/HINTS.txt \
 && echo "3) Press G to jump to the bottom, g to jump back to the top.\n"                                  >> /exercises/12_less/HINTS.txt \
 && echo "4) less -r  (displays escape codes properly)\n"                                                  >> /exercises/12_less/HINTS.txt \
 && echo "5) Press F in less to follow updates, Ctrl+C to stop.\n"                                         >> /exercises/12_less/HINTS.txt \
 && echo "6) less +G file.txt starts at end; less +/pattern file.txt starts searching for 'pattern'.\n"    >> /exercises/12_less/HINTS.txt


##############################################################################
# 14) 13_kill - Provide dedicated "killable" processes
##############################################################################
RUN mkdir -p /exercises/13_kill

# 1) We'll create a script that spawns multiple unique processes
#    which can be safely killed by learners.
RUN <<CREATE_KILLABLE
cat <<'EOF' > /exercises/13_kill/start_killable_processes.sh
#!/bin/bash

# "kill_test_1": A Python script that just sleeps in a loop, easy to identify/kill
( python3 -c "
import time
while True:
    time.sleep(5)
" ) &

# "kill_test_2": A simple yes loop with a custom string
( yes 'kill_test_2 says hi' ) &

# "kill_test_3": Another sleeping process with a custom name
( bash -c '
while true; do
  echo "kill_test_3 running..."
  sleep 10
done
' ) &

EOF
CREATE_KILLABLE

# Make it executable
RUN chmod +x /exercises/13_kill/start_killable_processes.sh

# EXERCISES.txt
RUN echo "KILL EXERCISES (13_kill)\n"                                                          >  /exercises/13_kill/EXERCISES.txt \
 && echo "1) How do you send SIGTERM (the default) to a known PID? (Hint: kill <PID>)"         >> /exercises/13_kill/EXERCISES.txt \
 && echo "   Hint: kill -15 <PID> or just kill <PID>\n"                                        >> /exercises/13_kill/EXERCISES.txt \
 && echo "2) Start the killable processes (bash start_killable_processes.sh). Then confirm"    >> /exercises/13_kill/EXERCISES.txt \
 && echo "   they're running (ps, pgrep). Kill the 'yes kill_test_2' process with SIGKILL."    >> /exercises/13_kill/EXERCISES.txt \
 && echo "3) Use kill -l to see all signals. Which number is SIGSTOP? SIGCONT?"                >> /exercises/13_kill/EXERCISES.txt \
 && echo "4) How do you 'killall' by process name? Example: killall yes"                       >> /exercises/13_kill/EXERCISES.txt \
 && echo "5) Practice using 'pgrep' or 'pkill' with patterns like '-f kill_test_3'."           >> /exercises/13_kill/EXERCISES.txt \
 && echo "6) Start a 'yes' job in the background and bring it to foreground, then Ctrl+Z,"     >> /exercises/13_kill/EXERCISES.txt \
 && echo "   kill -CONT it, then kill -9 it. Notice the difference?\n"                         >> /exercises/13_kill/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 13_kill\n"                                                             >  /exercises/13_kill/HINTS.txt \
 && echo "2) kill -9 <PID> forcibly kills it. ps aux or pgrep -f kill_test_2"              >> /exercises/13_kill/HINTS.txt \
 && echo "3) kill -l => lists signals. SIGSTOP=19, SIGCONT=18 on many systems.\n"          >> /exercises/13_kill/HINTS.txt \
 && echo "4) killall <process_name>, e.g. killall yes\n"                                   >> /exercises/13_kill/HINTS.txt \
 && echo "5) pgrep -f kill_test_3 or pkill -f kill_test_3 => matches full command.\n"      >> /exercises/13_kill/HINTS.txt \
 && echo "6) fg or bg to bring jobs to foreground/background, kill -STOP or -CONT.\n"      >> /exercises/13_kill/HINTS.txt


##############################################################################
# 15) 14_cat - "cat & friends"
##############################################################################
RUN mkdir -p /exercises/14_cat/data

# Provide a sample file for demonstration
RUN echo "Hello from cat!\nLine 2\nLine 3\n" > /exercises/14_cat/data/sample.txt

# EXERCISES.txt
RUN echo "CAT (& FRIENDS) EXERCISES (14_cat)\n"                                                     >  /exercises/14_cat/EXERCISES.txt \
 && echo "1) How can you display the contents of sample.txt on screen?"                             >> /exercises/14_cat/EXERCISES.txt \
 && echo "   Hint: cat data/sample.txt\n"                                                           >> /exercises/14_cat/EXERCISES.txt \
 && echo "2) How do you show line numbers while printing sample.txt?"                               >> /exercises/14_cat/EXERCISES.txt \
 && echo "3) Try creating a new file interactively using 'cat > newfile.txt'. Type lines,"          >> /exercises/14_cat/EXERCISES.txt \
 && echo "   press Ctrl+D, then confirm what's in newfile.txt.\n"                                   >> /exercises/14_cat/EXERCISES.txt \
 && echo "4) If you had a gzipped file logs.gz, how do you display it without manually unzipping?"  >> /exercises/14_cat/EXERCISES.txt \
 && echo "5) How do you 'tee' your echo output to both the screen and a file at once?"              >> /exercises/14_cat/EXERCISES.txt \
 && echo "6) Combine cat with grep or sed in a pipeline. For instance, cat largefile | grep"        >> /exercises/14_cat/EXERCISES.txt \
 && echo "   'pattern'. Usually it's simpler to grep directly, but practice!\n"                     >> /exercises/14_cat/EXERCISES.txt

# HINTS.txt
RUN echo "HINTS for 14_cat\n"                                                                               >  /exercises/14_cat/HINTS.txt \
 && echo "2) cat -n data/sample.txt => prints line numbers.\n"                                              >> /exercises/14_cat/HINTS.txt \
 && echo "3) cat > newfile.txt (Ctrl+D to finish), then cat newfile.txt.\n"                                 >> /exercises/14_cat/HINTS.txt \
 && echo "4) zcat logs.gz => same as gzip -cd logs.gz | cat.\n"                                             >> /exercises/14_cat/HINTS.txt \
 && echo "5) echo 'hi' | tee out.txt => displays 'hi' and writes it to out.txt.\n"                          >> /exercises/14_cat/HINTS.txt \
 && echo "6) cat bigfile | grep 'pattern'. Usually just grep bigfile - still good to practice.\n"           >> /exercises/14_cat/HINTS.txt


##############################################################################
# 16) 15_lsof
##############################################################################
RUN mkdir -p /exercises/15_lsof

# (1) Create a Python script that:
#     a) Opens /tmp/lsof-test-file.txt and writes data periodically (never closes it).
#     b) Listens on TCP port 9090, accepting connections and sending a greeting.
RUN <<'CREATE_LSOF'
cat <<'EOF' > /exercises/15_lsof/lsof_processes.py
#!/usr/bin/env python3

import time
import threading
import socket

def file_writer():
    """Open a file and write periodically, never closing it."""
    with open("/tmp/lsof-test-file.txt", "w") as f:
        counter = 0
        while True:
            counter += 1
            f.write(f"Line {counter} from file_writer\n")
            f.flush()
            time.sleep(5)

def tcp_server():
    """Simple TCP server on 0.0.0.0:9090, sends a greeting to each connection."""
    srv_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv_sock.bind(("0.0.0.0", 9090))
    srv_sock.listen(5)
    print("TCP server listening on port 9090...")
    while True:
        client_sock, addr = srv_sock.accept()
        client_sock.sendall(b"Hello from lsof test server!\n")
        client_sock.close()

if __name__ == "__main__":
    # Start file_writer in one thread
    fw_thread = threading.Thread(target=file_writer, daemon=True)
    fw_thread.start()

    # Start tcp_server in the main thread
    tcp_server()
EOF
CREATE_LSOF

# (2) Create a shell script that launches the Python script in the background.
RUN <<'STARTER'
cat <<'EOF' > /exercises/15_lsof/start_lsof_processes.sh
#!/bin/bash

# Create /tmp/lsof-test-file.txt if not exists, so we have something to look at
touch /tmp/lsof-test-file.txt

# Start the Python script in background or foreground (your choice).
# We'll do foreground here so we can see logs if we want,
# but you could do " &" if you prefer it fully in background.
python3 /exercises/15_lsof/lsof_processes.py
EOF
STARTER

# Make the starter script executable
RUN chmod +x /exercises/15_lsof/start_lsof_processes.sh \
    && chmod +x /exercises/15_lsof/lsof_processes.py

# (3) Create EXERCISES.txt
RUN echo "LSOF EXERCISES (15_lsof)\n"                                                    >  /exercises/15_lsof/EXERCISES.txt \
 && echo "1) How do you see what files the Python script (once running) has open?"       >> /exercises/15_lsof/EXERCISES.txt \
 && echo "   Hint: Start the script (bash start_lsof_processes.sh) in one terminal,"     >> /exercises/15_lsof/EXERCISES.txt \
 && echo "   then open another shell and do: lsof -p <PID> or lsof /tmp/lsof-test-file.txt\n" \
                                                                                         >> /exercises/15_lsof/EXERCISES.txt \
 && echo "2) How can you see which process is listening on TCP port 9090?"               >> /exercises/15_lsof/EXERCISES.txt \
 && echo "3) How can you filter by network sockets only? (hint: lsof -i, lsof -iTCP, etc.)"  >> /exercises/15_lsof/EXERCISES.txt \
 && echo "4) If you connect to the server (e.g. 'nc localhost 9090'), can you see your"  >> /exercises/15_lsof/EXERCISES.txt \
 && echo "   connection in lsof? Possibly with lsof -i?\n"                               >> /exercises/15_lsof/EXERCISES.txt \
 && echo "5) How do you list all open files under /tmp, or show only a certain user?"    >> /exercises/15_lsof/EXERCISES.txt \
 && echo "6) How might you find deleted files that are still open? (hint: 'deleted')"    >> /exercises/15_lsof/EXERCISES.txt

# (4) Create HINTS.txt
RUN echo "HINTS for 15_lsof\n"                                                                   >  /exercises/15_lsof/HINTS.txt \
 && echo "2) Try lsof -i :9090 or lsof -nP -iTCP:9090.\n"                                        >> /exercises/15_lsof/HINTS.txt \
 && echo "3) lsof -i or lsof -iTCP, possibly use -sTCP:LISTEN to show listening sockets.\n"      >> /exercises/15_lsof/HINTS.txt \
 && echo "4) Use 'nc localhost 9090' in one terminal and lsof -i in another.\n"                  >> /exercises/15_lsof/HINTS.txt \
 && echo "5) lsof /tmp => see open files in /tmp. Or lsof -u <username>.\n"                      >> /exercises/15_lsof/HINTS.txt \
 && echo "6) lsof | grep deleted => sometimes you can find 'deleted' files still in use.\n"      >> /exercises/15_lsof/HINTS.txt


##############################################################################
# Final Dockerfile Steps
##############################################################################
# Default to /exercises so user lands there, show the welcome message, etc.
WORKDIR /exercises

CMD ["/bin/bash", "-c", "/usr/local/bin/start_demo_workloads.sh & exec bash"]
