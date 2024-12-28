# Start from a small base image with the needed utilities
FROM ubuntu:22.04

# Install basic command-line tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        grep \
        findutils \
        less \
        vim \
        sed \
        gawk \
    && rm -rf /var/lib/apt/lists/*

# Create a directory to hold all exercises
WORKDIR /exercises
RUN mkdir -p grep find xargs sed awk

##############################################################################
# 1) GREP EXERCISES
##############################################################################
RUN mkdir -p /exercises/01_grep/data

RUN echo "Cats are wonderful pets.\nDogs are also great!\nI love cATS and DOGS!\ncatfish is not a cat.\n" \
     > /exercises/01_grep/data/cats_and_dogs.txt

RUN echo "Chocolate Cake Recipe\nIngredients:\n  - Flour\n  - Sugar\n  - cocoa\nDirections:\n  Mix flour and sugar.\n  Add cocoa.\n  Bake.\nSugar is sweet.\n" \
     > /exercises/01_grep/data/recipes.txt

RUN echo "# GREP Exercises\n" \
         "1. **Basic grep**: Search for the word 'Cats' in cats_and_dogs.txt. Then try ignoring case (`-i`).\n" \
         "2. **Recursive grep**: Search for 'Sugar' in all files under /exercises/01_grep/data.\n" \
         "3. **Invert match** (`-v`): Find lines that **do not** contain 'cat'.\n" \
         "4. **Print only matches** (`-o`): Show just the matched word 'cat'.\n" \
         "5. **Context** (`-A`, `-B`, `-C`): Show surrounding lines around 'Sugar'.\n" \
         "6. **Try combining** multiple flags (`-i -o -r`).\n" \
     > /exercises/01_grep/EXERCISES.md

##############################################################################
# 2) FIND EXERCISES
##############################################################################
RUN mkdir -p /exercises/02_find/data/subdir
RUN mkdir -p /exercises/02_find/data/emptydir

RUN echo "Hello from alpha" > /exercises/02_find/data/alpha.txt
RUN echo "Hello from beta"  > /exercises/02_find/data/beta.log
RUN touch /exercises/02_find/data/emptyfile.txt
RUN echo "Hello from gamma" > /exercises/02_find/data/subdir/gamma.txt

RUN echo "# FIND Exercises\n" \
         "1. **Find by name**: Look for 'alpha.txt' in the /exercises/02_find/data folder.\n" \
         "2. **Find by type**: Locate directories (`-type d`) vs. files (`-type f`).\n" \
         "3. **Case-insensitive name** (`-iname`): Find .txt files ignoring case.\n" \
         "4. **Find empty files** (`-size 0`): Look for accidental empties.\n" \
         "5. **Max depth** (`-maxdepth N`): Limit how far to search.\n" \
         "6. **Find + exec**: Run a command on each matched file.\n" \
         "7. **Delete**: Create a throwaway file and remove it using `-delete`.\n" \
         "8. (Optional) **locate**: Try `locate` if you want faster searches (needs `updatedb`).\n" \
     > /exercises/02_find/EXERCISES.md

##############################################################################
# 3) XARGS EXERCISES
##############################################################################
RUN mkdir -p /exercises/03_xargs/data

RUN echo "apple\nbanana\ncarrot\n" > /exercises/03_xargs/data/fruits.txt
RUN echo "foo bar\nbaz qux\n"      > /exercises/03_xargs/data/spaces.txt
RUN echo "Hello."                  > /exercises/03_xargs/data/file1.txt
RUN echo "World!"                  > /exercises/03_xargs/data/file2.txt

RUN echo "# XARGS Exercises\n" \
         "1. **Basic usage**: `cat data/fruits.txt | xargs echo` to see how xargs splits & passes args.\n" \
         "2. **Handling spaces**: Notice lines with spaces (`spaces.txt`). Try `cat spaces.txt | xargs echo`.\n" \
         "3. **-I**: Create a file for each fruit: `cat data/fruits.txt | xargs -I {} touch {}.txt`.\n" \
         "4. **Parallel** (`-P`): `find . -name '*.txt' | xargs -P 2 -n 1 grep Hello`.\n" \
         "5. **Replace text**: `find . -name '*.txt' | xargs sed -i 's/Hello/Hi/g'`.\n" \
         "6. **Combined**: `find . -type f -empty -print0 | xargs -0 rm`.\n" \
     > /exercises/03_xargs/EXERCISES.md

##############################################################################
# 4) SED EXERCISES
##############################################################################
RUN mkdir -p /exercises/04_sed/data

# Create a text file with multiple lines for SED transformations
RUN echo "cat\ncat\ndog\nlion\ncat\n" > /exercises/04_sed/data/zoo.txt
RUN echo "1 alpha\n2 bravo\n3 charlie\n4 delta\n5 echo\n6 foxtrot\n7 golf\n" > /exercises/04_sed/data/lines.txt

RUN echo "# SED Exercises\n" \
         "1. **Basic substitution**: Replace 'cat' with 'dog' in zoo.txt (print to screen). E.g. `sed 's/cat/dog/' zoo.txt`.\n" \
         "2. **Global substitution**: Replace **all** 'cat' with 'dog' using `s/cat/dog/g`.\n" \
         "3. **In-place**: Use `-i` to modify zoo.txt directly.\n" \
         "4. **Delete lines**: Remove the 3rd line or remove lines matching 'lion'.\n" \
         "   - E.g. `sed '3d' zoo.txt` or `sed '/lion/d' zoo.txt`.\n" \
         "5. **Range of lines**: Print only lines 2–5 of lines.txt using `-n 2,5p`.\n" \
         "6. **Append or insert**: Insert the word 'panda' after lines that contain 'cat'. `sed '/cat/a panda' zoo.txt`.\n" \
         "7. **Regex delimiters**: Try alternative delimiters (`s+cat+dog+g`).\n" \
         "8. **Combine**: After substituting 'cat' → 'dog', use another sed command to delete lines with 'lion'.\n" \
     > /exercises/04_sed/EXERCISES.md

##############################################################################
# 5) AWK EXERCISES
##############################################################################
RUN mkdir -p /exercises/05_awk/data

# Create a CSV-like file for AWK usage
RUN echo "id,name,age,salary\n1,Alice,30,60000\n2,Bob,25,50000\n3,Charlie,35,70000\n" \
     > /exercises/05_awk/data/people.csv

# Another file for column-based manipulations
RUN echo "apple  10  fruit\nbanana 20  fruit\ncarrot 5   vegetable\n" \
     > /exercises/05_awk/data/products.txt

RUN echo "# AWK Exercises"                         >  /exercises/05_awk/EXERCISES.md \
 && echo "1. **Print a column**: ..."              >> /exercises/05_awk/EXERCISES.md \
 && echo "   - e.g. \`awk -F, '{print \$3}'...\`."  >> /exercises/05_awk/EXERCISES.md \
 && echo "2. **Conditional print**: ..."           >> /exercises/05_awk/EXERCISES.md \
 && echo "   - e.g. \`awk -F, '\$4 > 55000 { ...\`." >> /exercises/05_awk/EXERCISES.md \
 && echo "..."                                     >> /exercises/05_awk/EXERCISES.md


##############################################################################
# Provide a quick overall "table of contents" in /exercises
##############################################################################
RUN echo "Welcome to the Bite-Sized Command Line Exercises container!\n\n" \
         "Here's where everything is:\n" \
         "  /exercises/01_grep/EXERCISES.md  => grep exercises\n" \
         "  /exercises/02_find/EXERCISES.md  => find exercises\n" \
         "  /exercises/03_xargs/EXERCISES.md => xargs exercises\n" \
         "  /exercises/04_sed/EXERCISES.md   => sed exercises\n" \
         "  /exercises/05_awk/EXERCISES.md   => awk exercises\n\n" \
         "Feel free to explore each /exercises/<tool>/data/ directory.\n" \
         "Open each EXERCISES.md and try out the commands.\n" \
         > /exercises/README.md

# Set the default working directory to /exercises
WORKDIR /exercises

# Default command just drops us into a shell
CMD ["/bin/bash"]

