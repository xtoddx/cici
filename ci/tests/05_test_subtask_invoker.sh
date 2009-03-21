#!/usr/bin/env bash

. lib/functions.sh
. lib/silence_warnings.sh
. lib/silence_praise.sh
. lib/subtask_invoker.sh

function fail_if_a_single_subtask_fails() {
  invoke_subtasks "05_passing 05_failing 05_passing"
  if [ $? -eq $FALSE ] ; then
    return $TRUE
  else
    return $FALSE
  fi
}

function pass_if_all_subtasks_pass() {
  invoke_subtasks "05_passing 05_passing 05_passing"
  return $?
}

cd ci/mocks

callbacks=( \
  fail_if_a_single_subtask_fails \
  pass_if_all_subtasks_pass \
)

failure_memo=( )

index=0
while [ $index -lt ${#callbacks[@]} ] ; do
  ${callbacks[$index]}
  if [ $? -ne $TRUE ] ; then
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
