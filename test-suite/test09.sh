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
echo -n "$0 (pushy-merge) "

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
echo "$ pushy-merge" >> "$expected" 2>&1
2041 pushy-merge >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no commits yet
echo "$ pushy-merge" >> "$expected" 2>&1
2041 pushy-merge >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding files and first commit
echo "$ echo 1 > a" >> "$expected" 2>&1
echo 1 > a || exit 1
echo "$ echo 1 > b" >> "$expected" 2>&1
echo 1 > b || exit 1
echo "$ pushy-add a b" >> "$expected" 2>&1
2041 pushy-add a b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c0" >> "$expected" 2>&1
2041 pushy-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# usage error
echo "$ pushy-merge master -m" >> "$expected" 2>&1
2041 pushy-merge master -m >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# same branch
echo "$ pushy-merge master -m m0" >> "$expected" 2>&1
2041 pushy-merge master -m m0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# unknown branch
echo "$ pushy-merge b1 -m m0" >> "$expected" 2>&1
2041 pushy-merge b1 -m m0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# empty commit message
echo "$ pushy-merge master" >> "$expected" 2>&1
2041 pushy-merge master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first branch
echo "$ pushy-branch b1" >> "$expected" 2>&1
2041 pushy-branch b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to b1
echo "$ pushy-checkout b1" >> "$expected" 2>&1
2041 pushy-checkout b1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# modifying, adding and committing files on b1
echo "$ echo 2 >> a" >> "$expected" 2>&1
echo 2 >> a || exit 1
echo "$ echo 1 > c" >> "$expected" 2>&1
echo 1 > c || exit 1
echo "$ pushy-add c" >> "$expected" 2>&1
2041 pushy-add c >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -a -m c1" >> "$expected" 2>&1
2041 pushy-commit -a -m c1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to master
echo "$ pushy-checkout master" >> "$expected" 2>&1
2041 pushy-checkout master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# modifying, adding and committing files on master
echo "$ sed -i 1d b" >> "$expected" 2>&1
sed -i 1d b || exit 1
echo "$ echo 1 > d" >> "$expected" 2>&1
echo 1 > d || exit 1
echo "$ pushy-add d" >> "$expected" 2>&1
2041 pushy-add d >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -a -m c2" >> "$expected" 2>&1
2041 pushy-commit -a -m c2 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# first merge
echo "$ pushy-merge b1 -m m0" >> "$expected" 2>&1
2041 pushy-merge b1 -m m0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# second branch
echo "$ pushy-branch b2" >> "$expected" 2>&1
2041 pushy-branch b2 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to b2
echo "$ pushy-checkout b2" >> "$expected" 2>&1
2041 pushy-checkout b2 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding and committing file on b2
echo "$ echo 1 > e" >> "$expected" 2>&1
echo 1 > e || exit 1
echo "$ pushy-add e" >> "$expected" 2>&1
2041 pushy-add e >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c3" >> "$expected" 2>&1
2041 pushy-commit -m c3 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# checkout to master
echo "$ pushy-checkout master" >> "$expected" 2>&1
2041 pushy-checkout master >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# second merge - fast forward: nothing to commit
echo "$ pushy-merge b2 -m m1" >> "$expected" 2>&1
2041 pushy-merge b2 -m m1 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# modifying and committing file on master
echo "$ sed -Ei s/1/42/ e" >> "$expected" 2>&1
sed -Ei s/1/42/ e || exit 1
echo "$ pushy-commit -a -m c3" >> "$expected" 2>&1
2041 pushy-commit -a -m c3 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# third merge - merge conflict
echo "$ pushy-merge b2 -m m2" >> "$expected" 2>&1
2041 pushy-merge b2 -m m2 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# log
echo "$ pushy-log" >> "$expected" 2>&1
2041 pushy-log >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-merge" >> "$output" 2>&1
pushy-merge >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# no commits yet
echo "$ pushy-merge" >> "$output" 2>&1
pushy-merge >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding files and first commit
echo "$ echo 1 > a" >> "$output" 2>&1
echo 1 > a || exit 1
echo "$ echo 1 > b" >> "$output" 2>&1
echo 1 > b || exit 1
echo "$ pushy-add a b" >> "$output" 2>&1
pushy-add a b >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c0" >> "$output" 2>&1
pushy-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# usage error
echo "$ pushy-merge master -m" >> "$output" 2>&1
pushy-merge master -m >> "$output" 2>&1
echo "$?" >> "$out_code"
# same branch
echo "$ pushy-merge master -m m0" >> "$output" 2>&1
pushy-merge master -m m0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# unknown branch
echo "$ pushy-merge b1 -m m0" >> "$output" 2>&1
pushy-merge b1 -m m0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# empty commit message
echo "$ pushy-merge master" >> "$output" 2>&1
pushy-merge master >> "$output" 2>&1
echo "$?" >> "$out_code"
# first branch
echo "$ pushy-branch b1" >> "$output" 2>&1
pushy-branch b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to b1
echo "$ pushy-checkout b1" >> "$output" 2>&1
pushy-checkout b1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# modifying, adding and committing files on b1
echo "$ echo 2 >> a" >> "$output" 2>&1
echo 2 >> a || exit 1
echo "$ echo 1 > c" >> "$output" 2>&1
echo 1 > c || exit 1
echo "$ pushy-add c" >> "$output" 2>&1
pushy-add c >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -a -m c1" >> "$output" 2>&1
pushy-commit -a -m c1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to master
echo "$ pushy-checkout master" >> "$output" 2>&1
pushy-checkout master >> "$output" 2>&1
echo "$?" >> "$out_code"
# modifying, adding and committing files on master
echo "$ sed -i 1d b" >> "$output" 2>&1
sed -i 1d b || exit 1
echo "$ echo 1 > d" >> "$output" 2>&1
echo 1 > d || exit 1
echo "$ pushy-add d" >> "$output" 2>&1
pushy-add d >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -a -m c2" >> "$output" 2>&1
pushy-commit -a -m c2 >> "$output" 2>&1
echo "$?" >> "$out_code"
# first merge
echo "$ pushy-merge b1 -m m0" >> "$output" 2>&1
pushy-merge b1 -m m0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# second branch
echo "$ pushy-branch b2" >> "$output" 2>&1
pushy-branch b2 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to b2
echo "$ pushy-checkout b2" >> "$output" 2>&1
pushy-checkout b2 >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding and committing file on b2
echo "$ echo 1 > e" >> "$output" 2>&1
echo 1 > e || exit 1
echo "$ pushy-add e" >> "$output" 2>&1
pushy-add e >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c3" >> "$output" 2>&1
pushy-commit -m c3 >> "$output" 2>&1
echo "$?" >> "$out_code"
# checkout to master
echo "$ pushy-checkout master" >> "$output" 2>&1
pushy-checkout master >> "$output" 2>&1
echo "$?" >> "$out_code"
# second merge - fast forward: nothing to commit
echo "$ pushy-merge b2 -m m1" >> "$output" 2>&1
pushy-merge b2 -m m1 >> "$output" 2>&1
echo "$?" >> "$out_code"
# modifying and committing file on master
echo "$ sed -Ei s/1/42/ e" >> "$output" 2>&1
sed -Ei s/1/42/ e || exit 1
echo "$ pushy-commit -a -m c3" >> "$output" 2>&1
pushy-commit -a -m c3 >> "$output" 2>&1
echo "$?" >> "$out_code"
# third merge - merge conflict
echo "$ pushy-merge b2 -m m2" >> "$output" 2>&1
pushy-merge b2 -m m2 >> "$output" 2>&1
echo "$?" >> "$out_code"
# log
echo "$ pushy-log" >> "$output" 2>&1
pushy-log >> "$output" 2>&1
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
