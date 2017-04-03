#!/bin/sh
# Test suite!
ORIGDIR="$(pwd)"

# Trivial test framework
start_test()
{
    test_name="$*"
    echo "==== RUN: $test_name ===="
}

terminate_fail()
{
    echo "FAILURE: SOME TESTS BEHAVED UNEXPECTEDLY"
    #cleanup
    exit 1
}
terminate_success()
{
    echo "SUCCESS: ALL TESTS BEHAVED AS EXPECTED"
    cleanup
    exit 0
}
pass() {
    # expected success
    echo "PASS: $test_name $*"
}
fail() {
    # unexpected failure
    echo "FAIL: $test_name $*"
    terminate_fail
}
xpass() {
    echo "XPASS: unexpected success: $test_name $*"
    terminate_fail
}
xfail() {
    echo "XFAIL: expected failure: $test_name $*"
}

# pass() if last command succeeded, else fail()
# Using this means not doing 'set -e'
assert_status_zero() {
    if test $? = 0
    then
        pass "$*"
    else
        fail "$*"
    fi
}

# Given name of test, fail() if last command succeeded, else pass()
# Using this means not doing 'set -e'
assert_status_nonzero() {
    if test $? = 0
    then
        fail "$*"
    else
        pass "$*"
    fi
}
# End trivial test framework

cleanup() {
    # paranoid lint is paranoid
    if cd "${ORIGDIR}"
    then
        rm -rf tmp bletch.tmp
    fi
}

start_test "regression-test-pass1"
rm -rf tmp
./spruce -o tmp spruce_test_pre.cpp
diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
assert_status_zero ""

start_test "regression-test-pass2"
./spruce tmp/spruce_test_pre.cpp
diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
assert_status_zero ""

start_test "regression-test-filter"
rm -rf tmp
./spruce - < spruce_test_pre.cpp > tmp
diff -u spruce_test_post.cpp tmp
assert_status_zero ""

start_test "precommit-should-complain"
# 1. Create a git repo wif summat in't
rm -rf bletch.tmp
mkdir bletch.tmp
# good lord paranoid lint is paranoid
# shellcheck disable=SC2164
cd bletch.tmp
git init
echo 'First commit!' > README.md
git add README.md
git commit -m 'First commit!'
cp ../spruce_test_pre.cpp spruce_test.cpp
git add spruce_test.cpp
# verify that spruce scolds us for proposing to commit unstylish code
../spruce precommit
assert_status_nonzero ""

start_test "precommit-should-not-complain"
git commit -m 'first code commit, sinfully unstylish!'
# 2. branch it
git checkout -b branch2
# 3. mutate branch 2 one way
sed -i.bak -e 's/TheBathroomDoorReadsOccupied/TheBathroomDoorReadsOccupado/' spruce_test.cpp
git commit -a -m "branch 2 went spanish"
# 3. spruce master
git checkout master
before=$(git log -n 1 --format=%H)
../spruce spruce_test.cpp
git add spruce_test.cpp
# verify that spruce recognizes we have mended our ways
../spruce precommit
assert_status_zero ""

start_test "freebase"
git commit -m "master reformatted, so stylish now"
after=$(git log -n 1 --format=%H)
# 4. now explode
git checkout branch2
../spruce freebase "$before" "$after" master
# 5. ideally we'd check something here, but I'm just happy it didn't crash :-)
assert_status_zero ""

start_test "precommit-after-freebase"
# Verify that all's quiet on the western front
../spruce precommit
assert_status_zero ""

terminate_success
