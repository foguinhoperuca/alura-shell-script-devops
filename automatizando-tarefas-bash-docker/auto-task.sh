#!/bin/bash

NOW=$(date +"%FT%H-%M-%S")
LOG="logs/report.log"

monitory() {
    echo "monitory script site $1"
    if [ -z $1 ];
    then
        echo "Missing parameter site. Exiting..."
        exit 1
    fi

    status=$(curl --write-out %{http_code} --silent --output /dev/null $1)
    echo "Status would be ${status} for site $1"
    echo "Status would be ${status} for site $1" >> $LOG
}

disk() {
    echo "Show disk info"
    disk=$1
    info=$(df -h | grep "${disk}" | awk '{ print $5 }')
    echo "disk usage for ${disk} is ${info}"
    echo "disk usage for ${disk} is ${info}" >> $LOG
}

echo "Reporting at ${NOW}" > $LOG
case $1 in
    "monitory")
        clear
        date
        monitory $2
        ;;
    "disk")
        DEFAULT_DISK="/dev/sda1"
        clear
        date
        target=$2
        if [ -z $2 ];
        then
            echo "Missing parameter disk. Using default: ${DEFAULT_DISK}"
            target=$DEFAULT_DISK
        fi
        disk $target
        ;;
    *)
        echo "USAGE: auto-tash.sh [monitory | disk]. $1 **NOT** found."
esac
