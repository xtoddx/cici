# This file contains all the configurations that can be changed.
# To change a configuration, make a config.sh file in your ci directory.

# this is the order the scripts will be called in
tasks=( test )

# if these tasks don't exist in the ci directory, just skip them
# can_skip_tasks=( prepare doc cleanup )
can_skip_tasks=( )

# if there is a failure anywhere, still run these tasks
final_tasks=( )

# if these tasks return non-zero, you can keep going
can_fail_tasks=( )
