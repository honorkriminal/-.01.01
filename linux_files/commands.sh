#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
umask 022

for program in man ed vi more python3; do
    command -v "$program" >/dev/null || { printf 'Required program: %s\n' "$program" >&2; exit 1; }
done

lab_dir=$(mktemp -d "${TMPDIR:-/tmp}/linux-files.XXXXXX")
cd "$lab_dir"
run() {
    printf '\n$ %s\n' "$1"
    eval "$1"
}

run 'set -o | head -n 6'
run 'man ls > manual_ls.txt'
run 'head -n 18 manual_ls.txt'
run 'touch -- -example.txt'
run 'ls -- -example.txt'
run 'rm -- -example.txt'

run 'pwd'
run 'mkdir pic'
run 'cd pic'
run 'pwd'
run 'cd ..'
run 'cd /etc'
run 'pwd'
run 'cd "$lab_dir"'

run 'mkdir dir'
run 'mkdir -m 750 private'
run 'mkdir dir1 dir2 dir3'
run 'mkdir -p nested/level2/level3'
run 'mkdir "$lab_dir/absolute_dir"'
run 'touch file1.txt file2.txt'
run 'touch *.txt'
run 'ls -ld private nested/level2/level3'

run 'ls'
run 'printf "#!/bin/sh\nprintf hello\\n\n" > program.sh'
run 'chmod +x program.sh'
run 'ln -s file1.txt link_to_file'
run 'mkfifo pipe_demo'
run 'ls -F'
run 'ls -l'
run 'ls -F "$lab_dir/pic"'

run 'rmdir dir'
run 'mkdir -p removable/child/leaf'
run 'rmdir -p removable/child/leaf'
run 'mkdir -p temp/subdir'
run 'touch temp/subdir/data.txt'
run 'rm -rv temp'
run 'mkdir interactive_dir'
run 'printf "y\n" | rm -irv interactive_dir'

run 'cat > notes.txt <<EOF
Linux file commands
Hello, world!
EOF'
run 'cat notes.txt'
run 'ed notes.txt <<EOF
2c
Hello from ed!
.
w
q
EOF'
run 'cat notes.txt'

run 'cat notes.txt file1.txt'
run 'more notes.txt'

run 'touch delete1 delete2 delete3'
run 'rm delete1 delete2 delete3'
run 'touch fileA fileB'
run 'printf "y\nn\n" | rm -i file?'
run 'ls fileB'
run 'rm -v fileB'

run 'cp notes.txt notes_copy.txt'
run 'mkdir copies'
run 'cp notes.txt notes_copy.txt copies'
run 'if printf "n\n" | cp -i notes.txt copies; then :; else printf "Overwrite declined.\n"; fi'
run 'mkdir backup'
run 'cp -r copies backup'
run 'ls -R backup'

run 'mv notes_copy.txt renamed.txt'
run 'mv renamed.txt copies'
run 'mv copies katalog'
run 'mkdir destination'
run 'mv katalog destination'
run 'ls -R destination'

run 'cat > tabl1 <<EOF
1 Ivan   578   moscow
2 Peter  435   newyork
3 Sasha  734   orel
EOF'
run 'cat tabl1'
run 'cut -c 1,3,4,5,15-21 tabl1'

run 'cat > docs.txt <<EOF
linux
Red Hat Linux
red hat linux
get data
put data
print result
write file
applez
abz
a
A
banana
EOF'
run 'grep linux docs.txt'
run 'grep -c linux docs.txt'
run 'grep -v linux docs.txt'
run 'grep -i linux docs.txt'
run 'grep -ci "Red Hat Linux" docs.txt'
run 'grep -E "get|put|print|write" docs.txt'
run 'egrep "get|put|print|write" docs.txt'
run 'grep "^a.*z$" docs.txt'
run 'grep "^[aA]$" docs.txt'
run 'grep "^a.z$" docs.txt'
run 'grep "^ab*z$" docs.txt'
run 'cat > price <<EOF
Tea: \$1.00
Coffee: \$2.50
EOF'
run 'grep '\''\$1\.00'\'' price'

run 'mkdir -p search/subdir'
run 'touch search/main.c search/subdir/util.c search/new.txt search/old.txt'
run 'truncate -s 300000 search/big.bin'
run 'touch -a -m -d "40 days ago" search/old.txt'
run 'find search -name "*.c"'
run 'find search -type f'
run 'find search -type d'
run 'find search -type f -size +500'
run 'find search -type f -mtime -3'
run 'find search -type f -atime +3'
run 'find search -type f -user "$(id -un)"'
run 'find search -type f -group "$(id -gn)"'
run 'find search -maxdepth 1 -type f'
run 'find search -type f -atime +30 -exec rm -v {} \;'
run 'find search -type f'

printf '%s\n' "$lab_dir"
