#!/usr/bin/env bash

. lib/functions.sh
. lib/silence_warnings.sh
. lib/silence_praise.sh

function missing_script_that_doesnt_silence_warnings_has_output() {
  local output=`invoke '04_not_silent'`
  if [ -z "$output" ] ; then
    return $FALSE
  else
    return $TRUE
  fi
}

function missing_script_silences_warnings_has_no_output() {
  local output=`invoke '04_silent'`
  if [ -z "$output" ] ; then
    return $TRUE
  else
    return $FALSE
  fi
}

cd ci/mocks

callbacks=( \
  missing_script_that_doesnt_silence_warnings_has_output
  missing_script_silences_warnings_has_no_output
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
fi

function return_fail_count() {
  return ${#failure_memo[@]}
}
return_fail_count
