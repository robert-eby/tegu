#!/usr/bin/env ksh
#
#	Mnemonic:	start_tegu_ha
#	Abstract:	Simple wrapper script to start the tegu_ha daemon and to ensure that 
#				multiple daemons aren't running.
#	Date:		30 Jan 2015
#	Author:		E. Scott Daniels
#
#	Mod:		
# --------------------------------------------------------------------------------------------------

export TEGU_ROOT=${TEGU_ROOT:-/var}
logd=${TEGU_LOGD:-$TEGU_ROOT/log/tegu}
libd=${TEGU_LIBD:-$TEGU_ROOT/lib/tegu}
etcd=${TEGU_ETCD:-/etc/tegu}
tegu_user=${TEGU_USER:-tegu}

if [[ -s $libd/ha_pid ]]						# check to see if it's still running
then
	head -1 $libd/ha_pid | read pid
	ps -elf|grep tegu_ha | while read f1 f2 f3 f4 jrest
	do
		if [[ $f4 == $pid ]]
		then
			echo "tegu_ha appears to be running; not restarted  [OK]" >&2
			exit 0
		fi
	done

	echo "tegu_ha with process id $pid wasn't found in system.... starting	[OK]" >&2
fi


nohup tegu_ha >$logd/tegu_ha.log 2>&1 &
pid=$!
echo "$pid" >$libd/ha_pid
echo "tegu_ha was started, pid=$pid"

exit 0