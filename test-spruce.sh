#!/bin/sh
# Test suite!
set -ex
ORIGDIR=$(pwd)

# Trivial test framework
terminate_fail()
{
    echo "FAILURE: SOME TESTS BEHAVED UNEXPECTEDLY"
    exit 1
}
terminate_success()
{
    echo "SUCCESS: ALL TESTS BEHAVED AS EXPECTED"
    exit 0
}
pass() {
    # expected success
    echo "PASS: $*"
}
fail() {
    # unexpected failure
    echo "FAIL: $*"
    terminate_fail
}
xpass() {
    echo "XPASS: unexpected success: $*"
    terminate_fail
}
xfail() {
    echo "XFAIL: expected failure: $*"
}
# End trivial test framework

cleanup() {
  cd "${ORIGDIR}"
  rm -rf tmp bletch.tmp
}
trap cleanup 0

# Regression test, passes with clang-format 3.8
./spruce -o tmp spruce_test_pre.cpp
if diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
then
  pass "test1: Success!"
else
  fail "test1: Woopsie Daisy! Something done got regressed"
fi

# Test no change on second run
./spruce tmp/spruce_test_pre.cpp
if diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
then
  pass "test2: Success!"
else
  fail "test2: Woopsie Daisy! Second run not equal to first"
fi

# use as filter
rm -rf tmp
./spruce - < spruce_test_pre.cpp > tmp
if diff -u spruce_test_post.cpp tmp
then
  pass "test3: Success!"
else
  fail "test3: Woopsie Daisy! Something done got regressed"
fi

## Test freebase
(
# 1. Create a git repo wif summat in't
rm -rf bletch.tmp
mkdir bletch.tmp
cd bletch.tmp
git init
cp ../spruce_test_pre.cpp spruce_test.cpp
git add spruce_test.cpp
git commit -m 'first commit!'
# 2. branch it
git checkout -b branch2
# 3. mutate branch 2 one way
sed -i.bak -e 's/TheBathroomDoorReadsOccupied/TheBathroomDoorReadsOccupado/' spruce_test.cpp
git commit -a -m "branch 2 went spanish"
# 3. spruce master
git checkout master
before=$(git log -n 1 --format=%H)
../spruce spruce_test.cpp
git commit -a -m "master reformatted"
after=$(git log -n 1 --format=%H)
# 4. now explode
git checkout branch2
sh -x ../spruce freebase "$before" "$after" master
# 5. ideally we'd check something here, but I'm just happy it didn't crash :-)
)

terminate_success
