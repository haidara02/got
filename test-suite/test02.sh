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
echo -n "$0 (got-commit|show) "

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
echo "$ got-commit" >> "$expected" 2>&1
2041 got-commit >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .got
echo "$ got-init" >> "$expected" 2>&1
2041 got-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no -m | no message | usage
echo "$ got-commit" >> "$expected" 2>&1
2041 got-commit >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no message | usage
echo "$ got-commit -m" >> "$expected" 2>&1
2041 got-commit -m >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# nothing in index
echo "$ got-commit -m c0" >> "$expected" 2>&1
2041 got-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first commit
echo "$ touch a" >> "$expected" 2>&1
touch "a" || exit 1
echo "$ got-add a" >> "$expected" 2>&1
2041 got-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ got-commit -m c0" >> "$expected" 2>&1
2041 got-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# index not diff from latest commit
echo "$ got-commit -m c1" >> "$expected" 2>&1
2041 got-commit -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# -a option with file already in index
echo "$ echo 1 > a" >> "$expected" 2>&1
echo 1 > a || exit 1
echo "$ got-commit -a -m c1" >> "$expected" 2>&1
2041 got-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ got-show 1:a" >> "$expected" 2>&1
2041 got-show 1:a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1


###########################################

cd "$out_dir" || exit 1
# no .got
echo "$ got-commit" >> "$output" 2>&1
got-commit >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .got
echo "$ got-init" >> "$output" 2>&1
got-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# no -m | no message | usage
echo "$ got-commit" >> "$output" 2>&1
got-commit >> "$output" 2>&1
echo "$?" >> "$out_code"
# no message | usage
echo "$ got-commit -m" >> "$output" 2>&1
got-commit -m >> "$output" 2>&1
echo "$?" >> "$out_code"
# nothing in index
echo "$ got-commit -m c0" >> "$output" 2>&1
got-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# first commit
echo "$ touch a" >> "$output" 2>&1
touch "a" || exit 1
echo "$ got-add a" >> "$output" 2>&1
got-add a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ got-commit -m c0" >> "$output" 2>&1
got-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# index not diff from latest commit
echo "$ got-commit -m c1" >> "$output" 2>&1
got-commit -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# -a option with file already in index
echo "$ echo 1 > a" >> "$output" 2>&1
echo 1 > a || exit 1
echo "$ got-commit -a -m c1" >> "$output" 2>&1
got-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ got-show 1:a" >> "$output" 2>&1
got-show 1:a >> "$output" 2>&1
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
