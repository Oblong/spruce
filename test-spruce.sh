#!/bin/sh
# Wrapper around clang-format to make enforcing new oblong coding style easy

./spruce -o tmp spruce_test_pre.cpp
dif=$(diff spruce_test_post.cpp tmp/spruce_test_pre.cpp)
if [ "$dif" != "" ] ; then
  echo "FAILED"
  if [ "$1" == "-v" ] ; then
    echo "$dif"
  fi
  exit 1
fi
rm -rf tmp
echo "SUCCESS"
exit 0