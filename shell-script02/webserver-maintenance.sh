#!/bin/bash

SCRIPT_PATH="$(pwd)"
LOG_SRC="$(pwd)/apache.log"

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

apache_log() {
    echo "Starting with parameter $1"
    regex="\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"

    if [[ $1 =~ $regex ]]
    then
        echo "Correct regex!! $1"
        echo "---"
        cat $LOG_SRC | grep -n $1
        if [ $? -ne 0 ]
        then
            echo "IP address $1 *NOT FOUND* in log file"
        fi
        echo "---"
    else
        echo "Invalid input!! $1"
        exit 1
    fi
}

apache_http_verb() {
    if [ -z $1 ];
    then
        echo "*INVALID* parameter $1"
        # TODO use read -p "Inform your HTTP verb: " choosed
        choosed=""
        verb=$(echo $choosed | awk '{ print toupper($1) }')
        exit 1
    else
        verb=$(echo $1 | awk '{ print toupper($1) }')
    fi
    echo "HTTP verb filter: $verb (original was $1)"
    echo ":::*** "

    case $verb in
        "GET" | "POST" | "PUT" | "DELETE")
            OLD_IFS=$IFS
            IFS=$'\n'
            text_filtered=$(cat $LOG_SRC | grep $verb)
            if [ $? -ne 0 ]
            then
                echo "HTTP verb $verb *NOT FOUND* in log file"
            fi
            unset ITER
            ITER=0
            for txt in $text_filtered;
            do
                echo $txt
                ITER=$(expr $ITER + 1)
            done
            echo "--------"
            echo "TOTAL: $ITER"

            if [ $1 == "GET" ]
            then
                echo true
            elif [ $1 == "POST" ]
            then
                echo false
            fi

            ;;
        *)
            echo "Invalid verb."
    esac

}

case $1 in
    "ip")
        apache_ip $2
        ;;
    "http_verb")
        apache_http_verb $2
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [log | multi | all_images | subdir]. $1 *NOT* found!!"
        # echo "single"
        # echo "multi"
        # echo "all_images"
        # echo "subdir"
        # echo "pcprocess"
esac
