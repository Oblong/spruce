#!/bin/sh
# Test suite that will pass once we bend clang-format to our will

./spruce -o tmp spruce_test_pre.cpp
if ! diff -u spruce_test_post.cpp tmp/spruce_test_pre.cpp
then
  echo "FAILED"
  exit 1
fi
rm -rf tmp
echo "SUCCESS"
exit 0
