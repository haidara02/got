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
echo -n "$0 (got-add) "

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
echo "$ got-add" >> "$expected" 2>&1
2041 got-add >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .got
echo "$ got-init" >> "$expected" 2>&1
2041 got-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no files | usage
echo "$ got-add" >> "$expected" 2>&1
2041 got-add >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# non-existing file
echo "$ got-add nothing" >> "$expected" 2>&1
2041 got-add nothing >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# non-regular file
echo "$ mkdir folderA" >> "$expected" 2>&1
mkdir "folderA" || exit 1
echo "$ got-add folderA" >> "$expected" 2>&1
2041 got-add folderA >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# successful adds
echo "$ touch a" >> "$expected" 2>&1
touch "a" || exit 1
echo "$ touch b" >> "$expected" 2>&1
touch "b" || exit 1
echo "$ touch c" >> "$expected" 2>&1
touch "c" || exit 1
echo "$ touch d" >> "$expected" 2>&1
touch "d" || exit 1
echo "$ touch e" >> "$expected" 2>&1
touch "e" || exit 1
echo "$ got-add a b c d e" >> "$expected" 2>&1
2041 got-add a b c d e >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# file deleted from working directory
echo "$ rm -f a" >> "$expected" 2>&1
rm -f a
echo "$ got-add a" >> "$expected" 2>&1
2041 got-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .got
echo "$ got-add" >> "$output" 2>&1
got-add >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .got
echo "$ got-init" >> "$output" 2>&1
got-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# no files | usage
echo "$ got-add" >> "$output" 2>&1
got-add >> "$output" 2>&1
echo "$?" >> "$out_code"
# non-existing file
echo "$ got-add nothing" >> "$output" 2>&1
got-add nothing >> "$output" 2>&1
echo "$?" >> "$out_code"
# non-regular file
echo "$ mkdir folderA" >> "$output" 2>&1
mkdir "folderA" || exit 1
echo "$ got-add folderA" >> "$output" 2>&1
got-add folderA >> "$output" 2>&1
echo "$?" >> "$out_code"
# successful adds
echo "$ touch a" >> "$output" 2>&1
touch "a" || exit 1
echo "$ touch b" >> "$output" 2>&1
touch "b" || exit 1
echo "$ touch c" >> "$output" 2>&1
touch "c" || exit 1
echo "$ touch d" >> "$output" 2>&1
touch "d" || exit 1
echo "$ touch e" >> "$output" 2>&1
touch "e" || exit 1
echo "$ got-add a b c d e" >> "$output" 2>&1
got-add a b c d e >> "$output" 2>&1
echo "$?" >> "$out_code"
# file deleted from working directory
echo "$ rm -f a" >> "$output" 2>&1
rm -f a
echo "$ got-add a" >> "$output" 2>&1
got-add a >> "$output" 2>&1
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
