#!/usr/bin/bash

#
# for openstack vm performance testing script
# Author: Guangjian guangjian@gmail.com
#
# USAGE: vm_perform.sh -z zone_name -n vm_number -e network_uuid -a <start|stop|restart|delete|create>
#

if [ $# != 8 ]
then
    echo "usage  vm_perform.sh -z zone_name -n vm_number -e network_uuid -a <start|stop|restart|delete|create>"
    exit 1
fi

source /root/keystonerc_admin

vm_number=1
zone_name="zone0"

create_vms()
{
    echo "====> start vm's <===="
    date "+%Y-%m-%d %H:%M:%S"
    start_time=$(date +%s)
    nova boot --flavor default --image redhat7-v3 --max-count $vm_number --availability-zone $zone_name --nic net-id=$network_uuid alu-perf
    while [ true ]
    do  
        vms=`nova list|grep -i active|grep alu|wc -l`;
        date "+%Y-%m-%d %H:%M:%S"
        if [ $vms -eq $vm_number ]; then
            echo -e "all [$vms] vms created\n"
            end_time=$(date +%s)
            break
        else
            echo -e "found that [$vms] vms created\n"
        fi
    done
    end_time=$(date +%s)
    echo -e "execute command [nova list]"
    nova list
    echo "Total elapse: $((end_time-start_time)) seconds"
}

stop_vms()
{
    echo "====> stop vm's <===="
    date "+%Y-%m-%d %H:%M:%S"
    start_time=$(date +%s)
    nova stop $vm_str;
    echo

    while [ true ]
    do
        vms=`nova list|grep -i Shutoff|grep alu|wc -l`;        
        date "+%Y-%m-%d %H:%M:%S"
        if [ $vms -eq $vm_number ]; then
            echo -e "all [$vms] vms stopped\n"
            end_time=$(date +%s)
            break
        else
            echo -e "found that [$vms] vms stopped\n"
        fi
    done
    echo -e "execute command [nova list]"
    nova list
    echo "Total elapse: $((end_time-start_time)) seconds"
}

start_vms()
{
    echo "====> start vm's <===="
    date "+%Y-%m-%d %H:%M:%S"
    start_time=$(date +%s)
    nova start $vm_str;
    echo

    while [ true ]
    do  
        vms=`nova list|grep -i active|grep alu|wc -l`;
        date "+%Y-%m-%d %H:%M:%S"
        if [ $vms -eq $vm_number ]; then
            echo -e "all [$vms] vms started\n"
            end_time=$(date +%s)
            break
        else
            echo -e "found that [$vms] vms started\n"
        fi
    done

    echo -e "execute command [nova list]"
    nova list
    echo "Total elapse: $((end_time-start_time)) seconds"
}


restart_vms()
{
    echo "====> restart vm's <===="
    date "+%Y-%m-%d %H:%M:%S"
    start_time=$(date +%s)
    for j in `seq $vm_number`
    do
        echo "reboot vm [alu-perf-${j}]"
        #nova reboot --hard alu-perf-${j}
        nova reboot alu-perf-${j}
    done

    while [ true ]
    do
        vms=`nova list|grep -i active|grep alu|wc -l`;
        date "+%Y-%m-%d %H:%M:%S"
        if [ $vms -eq $vm_number ]; then
            echo -e "all [$vms] vms started\n"
            end_time=$(date +%s)
            break
        else
            echo -e "found that [$vms] vms started\n"
        fi
    done
    echo -e "execute command [nova list]"
    nova list
    echo "Total elapse: $((end_time-start_time)) seconds"
}

delete_vms()
{
    echo "====> delete vm's <===="
    date "+%Y-%m-%d %H:%M:%S"
    start_time=$(date +%s)
    echo "delte vm is:"$vm_str
    nova delete $vm_str

    while [ true ]
    do
        vms=`nova list|grep alu|wc -l`;
        date "+%Y-%m-%d %H:%M:%S"
        if [ $vms -eq 0 ]; then
            echo -e "all [$vm_number] vms deleted\n"
            end_time=$(date +%s)
            break
        else
            echo -e "found that [$vms] vms alive\n"
        fi
    done
    echo -e "execute command [nova list]"
    nova list
    echo "Total elapse: $((end_time-start_time)) seconds"
}


while getopts "z:n:e:a:" arg
do
    case $arg in
    z)
        echo "Zone name is:$OPTARG"
        zone_name=$OPTARG;;
    n)
        echo "VM number is:$OPTARG"
        vm_number=$OPTARG
        for i in `seq $vm_number`
        do  
            vm_str=${vm_str}" alu-perf-"${i}
        done
        echo "vm array is:"$vm_str;;
    e)
        echo "network UUID is: $OPTARG"
        network_uuid=$OPTARG;;
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

