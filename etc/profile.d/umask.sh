#! /bin/bash
# Change umask for non-admin users from the default 0022 to 0002
# /etc/profile.d/umask.sh

if [ "$UID" -ge 1000 ]; then
    umask 0002
fi
