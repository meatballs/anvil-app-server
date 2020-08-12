#!/bin/bash
export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
export USER_ID=${USER_ID:=1000}
export GROUP_ID=${GROUP_ID:-$USER_ID}
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}

chown -R $USER_ID:$GROUP_ID /anvil-data
exec gosu $USER_ID:$GROUP_ID $@
