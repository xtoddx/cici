. $CI_ROOT/lib/defined_values.sh

function invoke() {
  local script=$1
  if [ ! -f "ci/$script" ] ; then
    missing_script $script
    return
  fi
  ("ci/$script")
  rv=$?
  if [ $rv -ne $TRUE ] ; then
    failed_script $script
  else
    passed_script $script
  fi
}

function missing_script() {
  local script=$1
  bash_array_contains "`echo ${can_skip_tasks[@]}`" $script
  if [ $? -ne $TRUE ] ; then
    flunk "Missing task: $script"
  else
    warn "Missing task: ${script}.  If you don't need it, maybe remove it from the tasks definition in config.sh"
  fi
}

function failed_script() {
  local script=$1
  bash_array_contains "`echo ${can_fail_tasks[@]}`" $script
  if [ $? -ne $TRUE ] ; then
    flunk "Failed task: $script"
    invoke_final_tasks
  else
    warn "Failed task: ${script} -- Ignoring Failure."
  fi
}

function passed_script() {
  local script=$1
  praise "Passed: $script"
}

function bash_array_contains() {
  local ary=($1)
  local val=$2
  local idx=0
  while [ $idx -lt ${#ary[@]} ] ; do
    if [ ${ary[$idx]} == $val ] ; then
      return $TRUE 
    fi
    let idx=idx+1
  done
  return $FALSE
}

function invoke_final_tasks {
  # FIXME: MAKE SURE THEY ARE IN THE OKAY-TO-FAIL LIST SO WE DONT INF. LOOP
  local index=0
  while [ $index -lt ${#final_tasks[@]} ]  ; do
    invoke ${final_tasks[$index]}
    let index=index+1
  done
}

function report_success {
  echo "**************************************"
  echo "*** ALL TESTS EXECUTED SUCESSFULLY ***"
  echo "**************************************"
}

function flunk {
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
  echo "!!! FAILURE FAILURE FAILURE !!!" >&2
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
  echo $1 >&2
  exit
}

function warn {
  echo $1
}

function praise {
  echo $1
}
