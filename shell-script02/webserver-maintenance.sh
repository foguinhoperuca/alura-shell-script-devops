#!/bin/bash

SCRIPT_PATH="$(pwd)"
LOG_SRC="$(pwd)/apache.log"
TEMPLATE_EMAIL_APACHE=email_apache.tpl
TEMPLATE_EMAIL_MEMORY=email_memory.tpl
NOW=$(date +"%Y-%m-%dT%H-%M-%S")

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
        while [ -z $choosed ]
        do
            echo "*INVALID* parameter $1"
            read -p "Inform your HTTP verb: " choosed
            verb=$(echo $choosed | awk '{ print toupper($1) }')
        done
        # exit 1
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
            ;;
        *)
            echo "Invalid verb."
    esac
}

monitor_apache() {
    site=$1
    if [ -z $site ];
    then
        site="https://sorocaba.sp.gov.br"
        echo "Using default site: $site"
    fi

    email_to=$2
    if [ -z $email_to ];
    then
        email_to="TODO put some e-mail here"
        echo "Using default e-mail to: $email_to"
    fi


    echo "Monitoring apache's status for $site (original: $1)"
    status=$(curl --silent --write-out %{http_code} --output /dev/null $site)
    echo "Returned status for $1 is $status"

    if [ $status -ne 200 ];
    then
        echo "No good: status ($status) found in server. Warn everyone!!"
        sed -i.bkp "s/^Apache returned code was:.*/Apache returned code was: $status [$NOW]/" $TEMPLATE_EMAIL_APACHE

        ssmtp -v $email_to < $TEMPLATE_EMAIL_APACHE
    fi
}

monitor_memory() {
    echo "Monitoring memory"

    total=$(free | grep -i mem | awk '{ print $2 }')
    consumption=$(free | grep -i mem | awk '{ print $3 }')
    used=$(bc <<< "scale=2;$consumption/$total*100" | awk -F. '{ print $1 }')
    echo "Total used memory is: $used% ($consumption / $total * 100)"

    email_to=$(cat $TEMPLATE_EMAIL_MEMORY | grep To: | awk -F: '{ print $2 }')
    echo "Will send e-mail to: $email_to"

    if [ $used -gt 30 ];
    then
        echo "Used too much memory!! Used is: $used% ($consumption / $total * 100)"
        sed -i.bkp "s/^Memory consumption is:.*/Memory consumption is: $used% [$NOW]/" $TEMPLATE_EMAIL_MEMORY
        ssmtp -v $email_to < $TEMPLATE_EMAIL_MEMORY
    fi
}

case $1 in
    "ip")
        apache_ip $2
        ;;
    "http_verb")
        apache_http_verb $2
        ;;
    "monitor_apache")
        monitor_apache $2 $3
        ;;
    "memory")
        monitor_memory
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
