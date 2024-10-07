#!/bin/dash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PATH="$PATH:$(pwd)"
cmd_dir="$(pwd)"
exp_dir="$(mktemp -d)"
out_dir="$(mktemp -d)"
expected="$(mktemp)"
output="$(mktemp)"
exp_code="$(mktemp)"
out_code="$(mktemp)"

trap 'rm -rf "$exp_dir" "$out_dir" "$expected" "$output" "$exp_code" "$out_code"' INT HUP QUIT TERM EXIT
echo -n "$0 (pushy-rm) "

test_failed() {
    echo "- failed"
    echo "${GREEN}expected"
    cat "$expected"
    echo "${RED}output"
    cat "$output"
    exit 1
}

cd "$exp_dir" || exit 1
# no .pushy
echo "$ pushy-rm" >> "$expected" 2>&1
2041 pushy-rm >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding files
echo "$ touch a b c d" >> "$expected" 2>&1
touch a b c d || exit 1
echo "$ pushy-add a b c d" >> "$expected" 2>&1
2041 pushy-add a b c d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - usage
echo "$ pushy-rm" >> "$expected" 2>&1
2041 pushy-rm >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no history of commits and staged changes in index
echo "$ pushy-rm a" >> "$expected" 2>&1
2041 pushy-rm a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first commit
echo "$ pushy-commit -m c0" >> "$expected" 2>&1
2041 pushy-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - sucess
echo "$ pushy-rm a" >> "$expected" 2>&1
2041 pushy-rm a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - repo diff to working file (b)
# rm - different to both the working file and the repo (c)
# rm - staged changes in index (d)
echo "$ echo 2 > b" >> "$expected" 2>&1
echo 2 > b || exit 1
echo "$ echo 3 > c" >> "$expected" 2>&1
echo 3 > c || exit 1
echo "$ echo 4 > d" >> "$expected" 2>&1
echo 4 > d || exit 1
echo "$ pushy-add c d" >> "$expected" 2>&1
2041 pushy-add c d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ echo 5 > c" >> "$expected" 2>&1
echo 5 > c || exit 1
echo "$ pushy-rm b" >> "$expected" 2>&1
2041 pushy-rm b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-rm c" >> "$expected" 2>&1
2041 pushy-rm c >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-rm d" >> "$expected" 2>&1
2041 pushy-rm d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# file not in .pushy repository
echo "$ pushy-rm a" >> "$expected" 2>&1
2041 pushy-rm a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# second commit
echo "$ pushy-commit -a -m c1" >> "$expected" 2>&1
2041 pushy-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - force
echo "$ pushy-rm --force b" >> "$expected" 2>&1
2041 pushy-rm --force b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - cached
echo "$ pushy-rm --cached c" >> "$expected" 2>&1
2041 pushy-rm --cached c >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - force and cached
echo "$ pushy-rm --force --cached d" >> "$expected" 2>&1
2041 pushy-rm --force --cached d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-rm" >> "$output" 2>&1
pushy-rm >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding files
echo "$ touch a b c d" >> "$output" 2>&1
touch a b c d || exit 1
echo "$ pushy-add a b c d" >> "$output" 2>&1
pushy-add a b c d >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - usage
echo "$ pushy-rm" >> "$output" 2>&1
pushy-rm >> "$output" 2>&1
echo "$?" >> "$out_code"
# no history of commits and staged changes in index
echo "$ pushy-rm a" >> "$output" 2>&1
pushy-rm a >> "$output" 2>&1
echo "$?" >> "$out_code"
# first commit
echo "$ pushy-commit -m c0" >> "$output" 2>&1
pushy-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - sucess
echo "$ pushy-rm a" >> "$output" 2>&1
pushy-rm a >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - repo diff to working file (b)
# rm - different to both the working file and the repo (c)
# rm - staged changes in index (d)
echo "$ echo 2 > b" >> "$output" 2>&1
echo 2 > b || exit 1
echo "$ echo 3 > c" >> "$output" 2>&1
echo 3 > c || exit 1
echo "$ echo 4 > d" >> "$output" 2>&1
echo 4 > d || exit 1
echo "$ pushy-add c d" >> "$output" 2>&1
pushy-add c d >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ echo 5 > c" >> "$output" 2>&1
echo 5 > c || exit 1
echo "$ pushy-rm b" >> "$output" 2>&1
pushy-rm b >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-rm c" >> "$output" 2>&1
pushy-rm c >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-rm d" >> "$output" 2>&1
pushy-rm d >> "$output" 2>&1
echo "$?" >> "$out_code"
# file not in .pushy repository
echo "$ pushy-rm a" >> "$output" 2>&1
pushy-rm a >> "$output" 2>&1
echo "$?" >> "$out_code"
# second commit
echo "$ pushy-commit -a -m c1" >> "$output" 2>&1
pushy-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - force
echo "$ pushy-rm --force b" >> "$output" 2>&1
pushy-rm --force b >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - cached
echo "$ pushy-rm --cached c" >> "$output" 2>&1
pushy-rm --cached c >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - force and cached
echo "$ pushy-rm --force --cached d" >> "$output" 2>&1
pushy-rm --force --cached d >> "$output" 2>&1
echo "$?" >> "$out_code"
cd .. || exit 1

sed -ir "s?$cmd_dir/??g" "$output"
if [ ! -d "$out_dir/.pushy" ]
then
    echo "- ${RED}.pushy doesn't exist!${NC}"
    exit 1
fi

if ! diff -q "$expected" "$output" > /dev/null || ! diff -q "$exp_code" "$out_code" > /dev/null
then
    test_failed
elif ! diff -q "$exp_dir" "$out_dir" > /dev/null
then
    echo "- ${RED}differing files:"
    diff -q "$exp_dir" "$out_dir"
else
    echo "- ${GREEN}passed${NC}"
fi
