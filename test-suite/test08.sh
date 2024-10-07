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
echo -n "$0 (pushy-checkout) "

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
echo "$ pushy-checkout" >> "$expected" 2>&1
2041 pushy-checkout >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no commits yet
echo "$ pushy-checkout" >> "$expected" 2>&1
2041 pushy-checkout >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding file and first commit
echo "$ echo 1 > a" >> "$expected" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$expected" 2>&1
2041 pushy-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c0" >> "$expected" 2>&1
2041 pushy-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# usage error
echo "$ pushy-checkout" >> "$expected" 2>&1
2041 pushy-checkout >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first branch
echo "$ pushy-branch b1" >> "$expected" 2>&1
2041 pushy-branch b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# modify working and index and checkout to b1
echo "$ echo 2 > a" >> "$expected" 2>&1
echo 2 > a || exit 1
echo "$ pushy-add a" >> "$expected" 2>&1
2041 pushy-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-checkout b1" >> "$expected" 2>&1
2041 pushy-checkout b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to b1 - same branch
echo "$ pushy-checkout b1" >> "$expected" 2>&1
2041 pushy-checkout b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to master and second commit
echo "$ pushy-checkout master" >> "$expected" 2>&1
2041 pushy-checkout master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ echo 2 > a" >> "$expected" 2>&1
echo 2 > a || exit 1
echo "$ pushy-commit -a -m c1" >> "$expected" 2>&1
2041 pushy-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to b1 and modifying working file
echo "$ pushy-checkout b1" >> "$expected" 2>&1
2041 pushy-checkout b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ echo 3 > a" >> "$expected" 2>&1
echo 3 > a || exit 1
# checkout to master - changes would be overwritten
echo "$ pushy-checkout master" >> "$expected" 2>&1
2041 pushy-checkout master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# committing changes
echo "$ pushy-commit -a -m c1" >> "$expected" 2>&1
2041 pushy-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to master - success
echo "$ pushy-checkout master" >> "$expected" 2>&1
2041 pushy-checkout master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-checkout" >> "$output" 2>&1
pushy-checkout >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# no commits yet
echo "$ pushy-checkout" >> "$output" 2>&1
pushy-checkout >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding file and first commit
echo "$ echo 1 > a" >> "$output" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$output" 2>&1
pushy-add a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c0" >> "$output" 2>&1
pushy-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# usage error
echo "$ pushy-checkout" >> "$output" 2>&1
pushy-checkout >> "$output" 2>&1
echo "$?" >> "$out_code"
# first branch
echo "$ pushy-branch b1" >> "$output" 2>&1
pushy-branch b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# modify working and index and checkout to b1
echo "$ echo 2 > a" >> "$output" 2>&1
echo 2 > a || exit 1
echo "$ pushy-add a" >> "$output" 2>&1
pushy-add a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-checkout b1" >> "$output" 2>&1
pushy-checkout b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to b1 - same branch
echo "$ pushy-checkout b1" >> "$output" 2>&1
pushy-checkout b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to master and second commit
echo "$ pushy-checkout master" >> "$output" 2>&1
pushy-checkout master >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ echo 2 > a" >> "$output" 2>&1
echo 2 > a || exit 1
echo "$ pushy-commit -a -m c1" >> "$output" 2>&1
pushy-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to b1 and modifying working file
echo "$ pushy-checkout b1" >> "$output" 2>&1
pushy-checkout b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ echo 3 > a" >> "$output" 2>&1
echo 3 > a || exit 1
# checkout to master - changes would be overwritten
echo "$ pushy-checkout master" >> "$output" 2>&1
pushy-checkout master >> "$output" 2>&1
echo "$?" >> "$out_code"
# committing changes
echo "$ pushy-commit -a -m c1" >> "$output" 2>&1
pushy-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to master - success
echo "$ pushy-checkout master" >> "$output" 2>&1
pushy-checkout master >> "$output" 2>&1
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
