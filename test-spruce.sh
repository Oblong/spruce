#!/bin/sh
# Test suite!

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
    echo "PASS: $@"
}
fail() {
    # unexpected failure
    echo "FAIL: $@"
    terminate_fail
}
xpass() {
    echo "XPASS: unexpected success: $@"
    terminate_fail
}
xfail() {
    echo "XFAIL: expected failure: $@"
}
# End trivial test framework

cleanup() {
  rm -rf tmp
}
trap cleanup 0

# Regression test, passes with clang-format 3.8
./spruce -o tmp spruce_test_pre.cpp
if diff -u spruce_test_postfornow.cpp tmp/spruce_test_pre.cpp
then
  pass "regression test"
else
  fail "regression test"
fi

# Aspirational test, won't pass until clang-format is fixed
if diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
then
  xpass "aspirational test; was clang-format magically fixed?"
else
  xfail "aspirational test, won't pass until clang-format is fixed"
fi

terminate_success
