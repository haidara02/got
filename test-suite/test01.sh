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
echo -n "$0 (pushy-add) "

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
echo "$ pushy-add" >> "$expected" 2>&1
2041 pushy-add >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# no files | usage
echo "$ pushy-add" >> "$expected" 2>&1
2041 pushy-add >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# non-existing file
echo "$ pushy-add nothing" >> "$expected" 2>&1
2041 pushy-add nothing >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# non-regular file
echo "$ mkdir folderA" >> "$expected" 2>&1
mkdir "folderA" || exit 1
echo "$ pushy-add folderA" >> "$expected" 2>&1
2041 pushy-add folderA >> "$expected" 2>&1
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
echo "$ pushy-add a b c d e" >> "$expected" 2>&1
2041 pushy-add a b c d e >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# file deleted from working directory
echo "$ rm -f a" >> "$expected" 2>&1
rm -f a
echo "$ pushy-add a" >> "$expected" 2>&1
2041 pushy-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-add" >> "$output" 2>&1
pushy-add >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# no files | usage
echo "$ pushy-add" >> "$output" 2>&1
pushy-add >> "$output" 2>&1
echo "$?" >> "$out_code"
# non-existing file
echo "$ pushy-add nothing" >> "$output" 2>&1
pushy-add nothing >> "$output" 2>&1
echo "$?" >> "$out_code"
# non-regular file
echo "$ mkdir folderA" >> "$output" 2>&1
mkdir "folderA" || exit 1
echo "$ pushy-add folderA" >> "$output" 2>&1
pushy-add folderA >> "$output" 2>&1
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
echo "$ pushy-add a b c d e" >> "$output" 2>&1
pushy-add a b c d e >> "$output" 2>&1
echo "$?" >> "$out_code"
# file deleted from working directory
echo "$ rm -f a" >> "$output" 2>&1
rm -f a
echo "$ pushy-add a" >> "$output" 2>&1
pushy-add a >> "$output" 2>&1
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
