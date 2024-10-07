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
echo -n "$0 (pushy-status) "

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
echo "$ pushy-status" >> "$expected" 2>&1
2041 pushy-status >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# init .pushy
echo "$ pushy-init" >> "$expected" 2>&1
2041 pushy-init >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# adding files and first commit
echo "$ touch a b c d e f g h" >> "$expected" 2>&1
touch a b c d e f g h || exit 1
echo "$ pushy-add a b c d e f" >> "$expected" 2>&1
2041 pushy-add a b c d e f >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ pushy-commit -m c0" >> "$expected" 2>&1
2041 pushy-commit -m c0 >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - usage
echo "$ pushy-status nothing" >> "$expected" 2>&1
2041 pushy-status nothing >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - file changed, different changes staged for commit
echo "$ echo 1 > a" >> "$expected" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$expected" 2>&1
2041 pushy-add a >> "$expected" 2>&1
echo "$?" >> "$exp_code"
echo "$ echo 2 > a" >> "$expected" 2>&1
echo 2 > a || exit 1
# status - file changed, changes staged for commit
echo "$ echo 2 > b" >> "$expected" 2>&1
echo 2 > b || exit 1
echo "$ pushy-add b" >> "$expected" 2>&1
2041 pushy-add b >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - file changed, changes not staged for commit
echo "$ echo 3 > c" >> "$expected" 2>&1
echo 3 > c || exit 1
# status - file deleted
echo "$ rm d" >> "$expected" 2>&1
rm d || exit 1
# status - file deleted, deleted from index
echo "$ pushy-rm --force e" >> "$expected" 2>&1
2041 pushy-rm --force e >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - same as repo
# f
# status - added to index
echo "$ pushy-add g" >> "$expected" 2>&1
2041 pushy-add g >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - untracked
# h
echo "$ pushy-status" >> "$expected" 2>&1
2041 pushy-status >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - added to index, file changed
echo "$ echo 10 > g" >> "$expected" 2>&1
echo 10 > g || exit 1
echo "$ pushy-status" >> "$expected" 2>&1
2041 pushy-status >> "$expected" 2>&1
echo "$?" >> "$exp_code"
# status - added to index, file deleted
echo "$ rm -f g" >> "$expected" 2>&1
rm -f g || exit 1
echo "$ pushy-status" >> "$expected" 2>&1
2041 pushy-status >> "$expected" 2>&1
echo "$?" >> "$exp_code"
cd .. || exit 1

###########################################

cd "$out_dir" || exit 1
# no .pushy
echo "$ pushy-status" >> "$output" 2>&1
pushy-status >> "$output" 2>&1
echo "$?" >> "$out_code"
# init .pushy
echo "$ pushy-init" >> "$output" 2>&1
pushy-init >> "$output" 2>&1
echo "$?" >> "$out_code"
# adding files and first commit
echo "$ touch a b c d e f g h" >> "$output" 2>&1
touch a b c d e f g h || exit 1
echo "$ pushy-add a b c d e f" >> "$output" 2>&1
pushy-add a b c d e f >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ pushy-commit -m c0" >> "$output" 2>&1
pushy-commit -m c0 >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - usage
echo "$ pushy-status nothing" >> "$output" 2>&1
pushy-status nothing >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - file changed, different changes staged for commit
echo "$ echo 1 > a" >> "$output" 2>&1
echo 1 > a || exit 1
echo "$ pushy-add a" >> "$output" 2>&1
pushy-add a >> "$output" 2>&1
echo "$?" >> "$out_code"
echo "$ echo 2 > a" >> "$output" 2>&1
echo 2 > a || exit 1
# status - file changed, changes staged for commit
echo "$ echo 2 > b" >> "$output" 2>&1
echo 2 > b || exit 1
echo "$ pushy-add b" >> "$output" 2>&1
pushy-add b >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - file changed, changes not staged for commit
echo "$ echo 3 > c" >> "$output" 2>&1
echo 3 > c || exit 1
# status - file deleted
echo "$ rm d" >> "$output" 2>&1
rm d || exit 1
# status - file deleted, deleted from index
echo "$ pushy-rm --force e" >> "$output" 2>&1
pushy-rm --force e >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - same as repo
# f
# status - added to index
echo "$ pushy-add g" >> "$output" 2>&1
pushy-add g >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - untracked
# h
echo "$ pushy-status" >> "$output" 2>&1
pushy-status >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - added to index, file changed
echo "$ echo 10 > g" >> "$output" 2>&1
echo 10 > g || exit 1
echo "$ pushy-status" >> "$output" 2>&1
pushy-status >> "$output" 2>&1
echo "$?" >> "$out_code"
# status - added to index, file deleted
echo "$ rm -f g" >> "$output" 2>&1
rm -f g || exit 1
echo "$ pushy-status" >> "$output" 2>&1
pushy-status >> "$output" 2>&1
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
