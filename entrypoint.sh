#!/bin/bash

export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}

exec gosu $USER_ID:$GROUP_ID $@
