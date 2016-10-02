#!/usr/bin/bash

#
# for vm performance action testing
# Author: Guangjian guangjian@gmail.com
#
# USAGE: vm_perform.sh -a action
#

if [ $# != 2 ]
then
	echo "usage  vm_perform.sh -a <start|stop|restart|delete|create>"
	exit 1
fi

source /root/keystonerc_guangjian

create_vms()
{
	nova boot --flavor 2U2G-100G --image redhat7-v3 --max-count 10 --nic net-id=28a4105c-df59-4a63-92e7-19abbf41fda9 alu-perf
}

stop_vms()
{
	echo "====> stop vm's <===="
	date
	nova stop alu-perf-1 alu-perf-2 alu-perf-3 alu-perf-4 alu-perf-5 alu-perf-6 alu-perf-7 alu-perf-8 alu-perf-9 alu-perf-10;
	echo

	for i in `seq 60` 
	do
		echo -e "count vm status [${i}] - `date` ";
		nova list|grep -i Shutoff|grep alu|wc -l;
	done
}

start_vms()
{
	echo "====> start vm's <===="
	date
	nova start alu-perf-1 alu-perf-2 alu-perf-3 alu-perf-4 alu-perf-5 alu-perf-6 alu-perf-7 alu-perf-8 alu-perf-9 alu-perf-10;
	echo

	for i in `seq 10` 
	do
		echo -e "count vm status [${i}] - `date` ";
		nova list|grep -i active|grep alu|wc -l;
	done
}


restart_vms()
{
	echo "====> restart vm's <===="
	date
	for j in `seq 10`
	do
		echo "reboot vm [alu-perf-${j}]"
		#nova reboot --hard alu-perf-${j}
		nova reboot alu-perf-${j}
	done

	echo

	for i in `seq 10` 
	do
		echo -e "count vm status [${i}] - `date` ";
		nova list|grep -i ACTIVE|grep alu|wc -l;
	done
}

delete_vms()
{
	echo "====> delete vm's <===="
	date
	nova delete alu-perf-1 alu-perf-2 alu-perf-3 alu-perf-4 alu-perf-5 alu-perf-6 alu-perf-7 alu-perf-8 alu-perf-9 alu-perf-10;
	echo

	for i in `seq 10` 
	do
		echo -e "count vm status [${i}] - `date` ";
		nova list|grep ACTIVE|grep alu|wc -l;
	done
}


while getopts "a:" arg
do
    case $arg in
        a)
            echo "action's arg:$OPTARG"
            case $OPTARG in
                create)
                    create_vms;;
                stop)
                    stop_vms;;
                start)
                    start_vms;;
                restart)
                    restart_vms;;
                delete)
                    delete_vms;;
                *)
                    echo "unknow action"
                    exit 1;;
            esac;;

        ?)
            echo "unkown argument"
            exit 1;;

    esac
done


