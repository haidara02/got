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
echo -n "$0 (got-rm) "

test_failed() {
    echo "- failed"
    echo "${GREEN}expected"
    cat "$expected"
    echo "${RED}output"
    cat "$output"
    exit 1
}

cd "$exp_dir" || exit 1
# no .got
echo "$ got-rm" >> "$expected" 2>&1
2041 got-rm >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .got
echo "$ got-init" >> "$expected" 2>&1
2041 got-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding files
echo "$ touch a b c d" >> "$expected" 2>&1
touch a b c d || exit 1
echo "$ got-add a b c d" >> "$expected" 2>&1
2041 got-add a b c d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - usage
echo "$ got-rm" >> "$expected" 2>&1
2041 got-rm >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no history of commits and staged changes in index
echo "$ got-rm a" >> "$expected" 2>&1
2041 got-rm a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first commit
echo "$ got-commit -m c0" >> "$expected" 2>&1
2041 got-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - sucess
echo "$ got-rm a" >> "$expected" 2>&1
2041 got-rm a >> "$expected" 2>&1
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
echo "$ got-add c d" >> "$expected" 2>&1
2041 got-add c d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ echo 5 > c" >> "$expected" 2>&1
echo 5 > c || exit 1
echo "$ got-rm b" >> "$expected" 2>&1
2041 got-rm b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ got-rm c" >> "$expected" 2>&1
2041 got-rm c >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ got-rm d" >> "$expected" 2>&1
2041 got-rm d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# file not in .got repository
echo "$ got-rm a" >> "$expected" 2>&1
2041 got-rm a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# second commit
echo "$ got-commit -a -m c1" >> "$expected" 2>&1
2041 got-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - force
echo "$ got-rm --force b" >> "$expected" 2>&1
2041 got-rm --force b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - cached
echo "$ got-rm --cached c" >> "$expected" 2>&1
2041 got-rm --cached c >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# rm - force and cached
echo "$ got-rm --force --cached d" >> "$expected" 2>&1
2041 got-rm --force --cached d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .got
echo "$ got-rm" >> "$output" 2>&1
got-rm >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .got
echo "$ got-init" >> "$output" 2>&1
got-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding files
echo "$ touch a b c d" >> "$output" 2>&1
touch a b c d || exit 1
echo "$ got-add a b c d" >> "$output" 2>&1
got-add a b c d >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - usage
echo "$ got-rm" >> "$output" 2>&1
got-rm >> "$output" 2>&1
echo "$?" >> "$out_code"
# no history of commits and staged changes in index
echo "$ got-rm a" >> "$output" 2>&1
got-rm a >> "$output" 2>&1
echo "$?" >> "$out_code"
# first commit
echo "$ got-commit -m c0" >> "$output" 2>&1
got-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - sucess
echo "$ got-rm a" >> "$output" 2>&1
got-rm a >> "$output" 2>&1
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
echo "$ got-add c d" >> "$output" 2>&1
got-add c d >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ echo 5 > c" >> "$output" 2>&1
echo 5 > c || exit 1
echo "$ got-rm b" >> "$output" 2>&1
got-rm b >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ got-rm c" >> "$output" 2>&1
got-rm c >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ got-rm d" >> "$output" 2>&1
got-rm d >> "$output" 2>&1
echo "$?" >> "$out_code"
# file not in .got repository
echo "$ got-rm a" >> "$output" 2>&1
got-rm a >> "$output" 2>&1
echo "$?" >> "$out_code"
# second commit
echo "$ got-commit -a -m c1" >> "$output" 2>&1
got-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - force
echo "$ got-rm --force b" >> "$output" 2>&1
got-rm --force b >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - cached
echo "$ got-rm --cached c" >> "$output" 2>&1
got-rm --cached c >> "$output" 2>&1
echo "$?" >> "$out_code"
# rm - force and cached
echo "$ got-rm --force --cached d" >> "$output" 2>&1
got-rm --force --cached d >> "$output" 2>&1
echo "$?" >> "$out_code"
cd .. || exit 1

sed -ir "s?$cmd_dir/??g" "$output"
if [ ! -d "$out_dir/.got" ]
then
    echo "- ${RED}.got doesn't exist!${NC}"
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
