function flunk() {
  exit_subshell=$TRUE
}

function invoke_subtasks() {
  exit_subshell=$FALSE
  local tasks=($1)
  local index=0
  while [ $index -lt ${#tasks[*]} ] ; do
    invoke "tests/${tasks[$index]}"
    if [ $exit_subshell -eq $TRUE ] ; then
      break
    fi
    let index=index+1
  done

  if [ $exit_subshell -eq $TRUE ] ; then
    return $FALSE
  else
    return $TRUE
  fi
}
