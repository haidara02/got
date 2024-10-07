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
echo -n "$0 (pushy-show|log) "

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
echo "$ pushy-show" >> "$expected" 2>&1
2041 pushy-show >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-log" >> "$expected" 2>&1
2041 pushy-log >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first commit
echo "$ echo 1 > a" >> "$expected" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$expected" 2>&1
2041 pushy-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c0" >> "$expected" 2>&1
2041 pushy-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# show - usage
echo "$ pushy-show" >> "$expected" 2>&1
2041 pushy-show >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# show - invalid filename
echo "$ pushy-show 0:" >> "$expected" 2>&1
2041 pushy-show 0: >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# show - unknown commit
echo "$ pushy-show 1:a" >> "$expected" 2>&1
2041 pushy-show 1:a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# show - file doesn't exist in folder
echo "$ pushy-show 0:d" >> "$expected" 2>&1
2041 pushy-show 0:d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# show - successful
echo "$ pushy-show :a" >> "$expected" 2>&1
2041 pushy-show :a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-show 0:a" >> "$expected" 2>&1
2041 pushy-show 0:a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# log - usage
{ echo "$ pushy-log a"; 2041 pushy-log a; } >> "$expected" 2>&1
# first commit
echo "$ echo 2 > b" >> "$expected" 2>&1
echo 2 > b || exit 1
echo "$ pushy-add b" >> "$expected" 2>&1
2041 pushy-add b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c1" >> "$expected" 2>&1
2041 pushy-commit -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# log - success
echo "$ pushy-log" >> "$expected" 2>&1
2041 pushy-log >> "$expected" 2>&1
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-show" >> "$output" 2>&1
pushy-show >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-log" >> "$output" 2>&1
pushy-log >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# first commit
echo "$ echo 1 > a" >> "$output" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$output" 2>&1
pushy-add a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c0" >> "$output" 2>&1
pushy-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# show - usage
echo "$ pushy-show" >> "$output" 2>&1
pushy-show >> "$output" 2>&1
echo "$?" >> "$out_code"
# show - invalid filename
echo "$ pushy-show 0:" >> "$output" 2>&1
pushy-show 0: >> "$output" 2>&1
echo "$?" >> "$out_code"
# show - unknown commit
echo "$ pushy-show 1:a" >> "$output" 2>&1
pushy-show 1:a >> "$output" 2>&1
echo "$?" >> "$out_code"
# show - file doesn't exist in folder
echo "$ pushy-show 0:d" >> "$output" 2>&1
pushy-show 0:d >> "$output" 2>&1
echo "$?" >> "$out_code"
# show - successful
echo "$ pushy-show :a" >> "$output" 2>&1
pushy-show :a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-show 0:a" >> "$output" 2>&1
pushy-show 0:a >> "$output" 2>&1
echo "$?" >> "$out_code"
# log - usage
{ echo "$ pushy-log a"; pushy-log a; } >> "$output" 2>&1
# first commit
echo "$ echo 2 > b" >> "$output" 2>&1
echo 2 > b || exit 1
echo "$ pushy-add b" >> "$output" 2>&1
pushy-add b >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c1" >> "$output" 2>&1
pushy-commit -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# log - success
echo "$ pushy-log" >> "$output" 2>&1
pushy-log >> "$output" 2>&1
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