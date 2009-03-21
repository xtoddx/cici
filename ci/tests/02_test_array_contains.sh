#!/usr/bin/env bash

. lib/functions.sh
. lib/silence_warnings.sh
. lib/silence_praise.sh

TRUE=0
FALSE=1

function test_when_contains() {
  ary=(a b c d)
  bash_array_contains "`echo ${can_fail_tasks[@]}`" "a"
  return $?
}

function test_when_doesnt_contain() {
  ary=(a b c d)
  bash_array_contains "`echo ${can_fail_tasks[@]}`" "not_in_list"
  if [ $? -eq $FALSE ] ; then
    return $TRUE
  else
    return $FALSE
  fi
}

callbacks=( \
  test_when_doesnt_contain
  test_when_contains \
)

index=0
while [ $index -lt ${#callbacks[@]} ] ; do
  test_flunked=$FALSE
  ${callbacks[$index]}
  if [ $test_flunked -eq $TRUE ] ; then
    failure_memo[${#failure_memo[*]}]="${callbacks[$index]}"
  fi
  let index=index+1
done

if [ ${#failure_memo[@]} -gt 0 ] ; then
  echo "FAILED SUBTESTS: ${failure_memo[@]}"
  false
else
  true
fi
