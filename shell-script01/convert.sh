#!/bin/bash

SCRIPT_PATH="$(pwd)"
IMG_SRC="$(dirname $0)/book-images"
IMG_SUB_SRC="$(dirname $0)/subdir"
DESTINY_SRC="$(pwd)/result"

function clean_results() {
    if [ ! -d $DESTINY_SRC/ ];
    then
        echo "CREATING FOLDER to store results: $DESTINY_SRC"
        mkdir -p $DESTINY_SRC
    else
        if [ -z "$(ls -A $DESTINY_SRC/)" ];
        then
            echo "NO CONTENT to be removed!!"
        else
            rm -rf $DESTINY_SRC/*
            touch .gitignore
            echo "REMOVED CONTENT from $DESTINY_SRC"
        fi
    fi

    # ls -lah $DESTINY_SRC/
    echo "---"
    echo ""
}

function multi() {
    echo "multi fn using: $@"
    for image in $@
    do
        if [[ "$image" != "multi" ]];
        then
            convert $IMG_SRC/$image.jpg $DESTINY_SRC/$image.png
        fi
    done
}

function all_images() {
    for image in `ls book-images/*.jpg`;
    do
        local dest=`echo $image | awk -F. '{ print $1 }' | awk -F/ '{ print $2 }'`
        echo "Convert from: $image --> to destiny: $DESTINY_SRC/$dest.png"
        convert $image $DESTINY_SRC/$dest.png
    done
    echo "dest inside all_images: $dest"
    echo "zero status: $0"
    echo "exit status: $?"
}

function search_subdir() {
    cd $1
    echo "---- START $1 ::: $(pwd) "

    for file in *
    do
        local res=$(find . -name $file)
        # echo "cmd=find . -name $file ::: file=$file ::: res=$res"
        if [ -d $file ]
        then
            # echo "IS DIRECTORY $file"
            search_subdir ./$file
        else
            local dest=`echo $file | awk -F. '{ print $1 }'`
            local dir_path=$(pwd | sed -e "s/^${SCRIPT_PATH//\//\\/}//g")
            mkdir -p $DESTINY_SRC/$dir_path
            # echo "NO NO NO DIR $file - should convert it ::: $dest ::: $SCRIPT_PATH"
            # echo "dir_path=$dir_path"
            convert $file $DESTINY_SRC/$dir_path/$dest.png
        fi
    done
    cd ..
    echo "---- END $1"
}

pc_process_report() {
    echo "PC PROCESS REPORT"

    PROCESSES=$(ps -e -o pid --sort -size | head -n 11 | grep -v PID)
    echo "List of processes:"
    echo "$PROCESSES"
    echo "---"
    echo "Details:"

    for process in $PROCESSES
    do
        name=$(ps -p $process -o comm=)
        memory=$(ps -p $process -o size | grep -v SIZE)
        val=$(bc <<< "scale=2;$memory/1024")
        echo "Process $process details: datetime $(date +'%Y-%m-%d_%H-%M-%S') name is $name size is $val MB ($memory KB)" >> logs/$name.log
    done
}

case $1 in
    "single")
        image=$2
        convert $IMG_SRC/$image.jpg $DESTINY_SRC/$image.png
        ;;
    "multi")
        clean_results
        multi $@ 2>multi_errors.log
        echo "MULTI Images converted!!"
        echo "images: $@"
        ;;
    "all_images")
        rm -rf $DESTINY_SRC
        echo "Cleaning results..."
        clean_results 2>all_images_errors.log
        all_images
        echo "ALL images converted!!"
        echo "----"
        echo "dest is: $dest"
        ;;
    "subdir")
        clean_results 2>>subdir.log
        echo "subdir converting: $IMG_SUB_SRC"
        ls -lah $IMG_SUB_SRC
        echo ""
        # search_subdir $IMG_SUB_SRC 2>>subdir.log
        search_subdir $IMG_SUB_SRC
        echo "SUBDIR images converted!!"
        echo "----"
        ;;
    "pcprocess")
        clear
        pc_process_report
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [single | multi | all_images | subdir]. $1 *NOT* found!!"
        # echo "single"
        # echo "multi"
        # echo "all_images"
        # echo "subdir"
        # echo "pcprocess"
esac

echo "Exit status is: $?"
if [ $? -eq 0 ]
then
    echo "Success!!"
else
    echo "Got some error!!"
fi
