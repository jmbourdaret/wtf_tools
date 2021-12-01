#!/bin/bash -x
  
# launch a 'meld' of a terraform plan,to better visualize the changes.
# useful if your TF is too old and does not support the '-json' option. (otherwise, jq is your friend)
# AND your stack is not very TF friendly, like rancher_stack

# use meld, the GUI diff viewer. needs meld istalled.

# usage :  arg is passed to 'terraform plan '
# so : no arg for a global tf plan, or "-target=my_stack.my_resource"
# 

# keeping the interesting part of a tf plan
terraform plan -no-color $1 | sed '1,/^---------/d;/^---------/,$d' > /tmp/plan9
# set aside the before and after parts for the stuff that changed
perl -lne 'if (/([^:]*:[ ]+)(.*)=>(.*)$/) { print($1,$2) } else { print }' /tmp/plan9 > /tmp/tf.before
perl -lne 'if (/([^:]*:[ ]+)(.*)=>(.*)$/) { print($1,$3) } else { print }' /tmp/plan9 > /tmp/tf.after
# pretty print the snippets of the rancher_stack 
printf '%b\n' "$(</tmp/tf.before)" > /tmp/tf.before.prettyprint
printf '%b\n' "$(</tmp/tf.after)" > /tmp/tf.after.prettyprint
# launch the GUI diff viewer
meld /tmp/tf.before.prettyprint /tmp/tf.after.prettyprint
