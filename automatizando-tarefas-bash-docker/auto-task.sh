#!/bin/bash

NOW=$(date +"%FT%H-%M-%S")
LOG="logs/report.log"
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

conflict() {
    echo "--- Conflict analyzys for file: $1"
    local filename=$1

    if [ ! -f $filename ]; then
        echo "${filename} *NOT FOUND*"
        exit 1
    fi
 
    if grep -q -E "<<<<<|=====|>>>>>" $filename; then
        echo ""
        echo "-----------------------------------"
        echo "The ${filename} *GOT* some conflict!!"
        echo "-----------------------------------"
    else
        echo ""
        echo "-----------------------------------"
        echo "*NO* conflict dound in ${filename}"
        echo "-----------------------------------"
    fi
    echo ""
}

#TODO implement return values
search_conflicts() {
    local folder=$1
    if [ -z $folder ];
    then
        echo "Missing folder: ${fodler}. Exiting..."
        exit 1
    fi

    local total_files=0
    local total_folders=0
    echo "********************************************"
    echo "Folder is ${folder}"
    echo "********************************************"
    echo ""

    echo "Searching conflicts in ${folder}"
    for filename in "$folder"/*;
    do
        if [ -f $filename ];
        then
            let "total_files++"
            conflict "${filename}"
        elif [ -d "$filename" ];
        then
            let "total_folders++"
            echo "*** new folder found: ${filename}"
            search_conflicts $filename
        fi
    done

    echo ""
    echo "..................................................."
    echo "Only in current folder: $folder"
    echo "total files: ${total_files}"
    echo "total folders: ${total_folders}"
    echo "..................................................."
    echo ""
}

stats_for_conflicts() {
    local folder=$1
    local filename
    local files=$("$folder"/*)
    local i=0
    local total_files=0
    local total_folders=0

    while [ $i -lt ${#files[@]} ];
    do
        echo "..."
        filename="${files[$i]}"
        if [ -f "$filename" ];
        then
            echo "verify $filename"
            ((total_files++))
        elif [ -d $filename ];
        then
            echo "verify $folder"
            ((total_folders++))
        fi
        ((i++))
    done

    echo ""
    echo "..................................................."
    echo "Stats collected only in current folder: $folder"
    echo "total files: ${total_files}"
    echo "total folders: ${total_folders}"
    echo "..................................................."
    echo ""

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
            echo -e "Missing parameter disk. Using default: ${BLUE}${DEFAULT_DISK}${NC}"
            target=$DEFAULT_DISK
        fi
        disk $target
        ;;
    "conflict")
        # Setup initial verification of function outside it
        clear
        date
        if [ $# -ne 2 ]; then
            echo "Missing parameter for conflict analyze for conflict analyze. ${YELLOW}EExiting..."
            exit 1
        fi
        if [ ! -d $2  ];
        then
            echo -e "*NO DIRECTORY* with parameter: ${RED} $2${NC}. ${YELLOW}Exiting..."
            exit 1
        fi
        search_conflicts $2
        stats_for_conflicts
        ;;
    *)
        echo "USAGE: auto-tash.sh [monitory | disk | conflict]. $1 **NOT** found."
esac
