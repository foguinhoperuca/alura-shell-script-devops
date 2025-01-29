#!/bin/bash

SCRIPT_PATH="$(pwd)"
LOG_SRC="$(pwd)/apache.log"
TEMPLATE_EMAIL_APACHE=email_apache.tpl
TEMPLATE_EMAIL_MEMORY=email_memory.tpl
NOW=$(date +"%Y-%m-%dT%H-%M-%S")
BKP_PATH=$(pwd)/backup
REMOTE_BKP_PATH=$HOME/universal/data/backup/multitude
export PGPASSFILE=.pgpass
export DB_HOST=$(cat $PGPASSFILE | cut -d : -f1 | sed -n '1,1p')
export DB_PORT=$(cat $PGPASSFILE | cut -d : -f2 | sed -n '1,1p')
export DB_DATABASE=$(cat $PGPASSFILE | cut -d : -f3 | sed -n '1,1p')
export DB_USER=$(cat $PGPASSFILE | cut -d : -f4 | sed -n '1,1p')
export TARGET_SERVER_FILE=.target-server
export TARGET_SERVER_ADDR=$(cat $TARGET_SERVER_FILE | grep TARGET_SERVER_ADDR | cut -d = -f2)
export TARGET_SERVER_USER=$(cat $TARGET_SERVER_FILE | grep TARGET_SERVER_USER | cut -d = -f2)

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

backup_db() {
    if [ ! -d $BKP_PATH ];
    then
        echo "Missing $BKP_PATH at $NOW -- creating it..."
        mkdir -p $BKP_PATH
    fi

    echo "Credentials to access DB: $DB_HOST $DB_PORT $DB_DATABASE $DB_USER"

    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -f multitude.sql

    # TODO do backup with custom format or not
    # pg_dump -c -Fp -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -f $BKP_PATH/"$NOW"_backup.sql  
    pg_dump -c -Fc -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -f $BKP_PATH/"$NOW"_backup.dump 
    
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT * FROM shell_script_02.produtos LIMIT 5;'
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT * FROM shell_script_02.usuarios LIMIT 5;'

    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'DELETE FROM shell_script_02.produtos;'
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'DELETE FROM shell_script_02.usuarios;'

    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT COUNT(*) AS "TOTAL PRODUTOS" FROM shell_script_02.produtos LIMIT 5;'
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT COUNT(*) AS "TOTAL USUARIOS" FROM shell_script_02.usuarios LIMIT 5;'

    scp backup/* $TARGET_SERVER_USER@$TARGET_SERVER_ADDR:$REMOTE_BKP_PATH

}


restore_db() {
    restore_target=$1
    if [ -z $restore_target ];
    then
        echo "*NOT ALLOWED* without restore target"
        exit 1
    fi
    echo ""
    echo "RESTORE DB! $restore_target"
    echo "..."
    
    echo "..."
    echo ""
    echo "Credentials to access DB: $DB_HOST $DB_PORT $DB_DATABASE $DB_USER"

    RESTORE_CMD="psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -f $REMOTE_BKP_PATH/"$restore_target"_backup.sql"
    bkp_file=$(ls $REMOTE_BKP_PATH/ | sed -E "s/_backup.sql//" | grep -w $restore_target)
    if [ $? -ne 0 ];
    then
        RESTORE_CMD="pg_restore --clean --if-exists -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER $REMOTE_BKP_PATH/"$restore_target"_backup.dump"
        echo "Using pg_restore command!! $target_file :: $bkp_file"
    fi

    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT * FROM shell_script_02.produtos LIMIT 5;'
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT * FROM shell_script_02.usuarios LIMIT 5;'

    echo "[$PGPASSFILE] Restoring DB with cmd: $RESTORE_CMD"
    result=$($RESTORE_CMD)

    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT COUNT(*) AS "TOTAL PRODUTOS" FROM shell_script_02.produtos LIMIT 5;'
    psql -h $DB_HOST -p $DB_PORT -d $DB_DATABASE -U $DB_USER -c 'SELECT COUNT(*) AS "TOTAL USUARIOS" FROM shell_script_02.usuarios LIMIT 5;'
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
    "db")
        target=$2
        if [ -z $target ];
        then
            while [ -z $target ]
            do
                echo "*INVALID* option! Which one database should be restored?"
                backups_available=$(ls $REMOTE_BKP_PATH | tr -d "_backup.(sql|dump)")
                echo "$backups_available"
                read -p "Inform your target with full datetime: " target
            done
            echo ""
            echo "New target is $target"
            target_found=$(ls $REMOTE_BKP_PATH | tr -d "_backup.(sql|dump)" | grep -w $target)
            if [ -z $target_found ];
            then
                echo "I quit!! $target *NOT FOUND* in:"
                echo "$backups_available"
                exit 1
            fi
        fi

        # backup_db

        # ls -lah $BKP_PATH
        # cat $BKP_PATH/* | wc -l
        # ls -lah $REMOTE_BKP_PATH
        # cat $REMOTE_BKP_PATH/* | wc -l

        restore_db $target
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
