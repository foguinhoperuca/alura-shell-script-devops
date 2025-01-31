#|/bin/bash

LOG_DIR="logs"

SUB_ARR_0=("User password is .*" "User password is REDACTED")
SUB_ARR_1=("User password reset request with token .*" "User password reset request with token REDACTED")
SUB_ARR_2=("API key leaked: .*" "API key leaked: REDACTED")
SUB_ARR_3=("User credit card last four digits: .*" "User credit card last four digits: REDACTED")
SUB_ARR_4=("User session initiated with token: .*" "User session initiated with token: REDACTED")

REDACT_TEXT=(
    SUB_ARR_0[@]
    SUB_ARR_1[@]
    SUB_ARR_2[@]
    SUB_ARR_3[@]
    SUB_ARR_4[@]
)

redact() {
    log_file=$1
    redacted_log_file="${log_file}.redacted"
    echo "Processing log file $log_file > $redacted_log_file"
    cp $log_file $redacted_log_file


    #COUNT=5
    COUNT=${#REDACT_TEXT[@]}
    for ((i=0; i < $COUNT; i++))
    do
        original="${!REDACT_TEXT[i]:0:1}"
        replace="${!REDACT_TEXT[i]:1:1}"
        echo "$original [WILL BE REPLACED BY] $replace"
        sed -i "s/${original}/${replace}/g" $redacted_log_file
    done

    # sed -i 's/User password is .*/User password is REDACTED/g' "$redacted_log_file"

    # original="${!REDACT_TEXT[0]:0:1}"
    # replace="${!REDACT_TEXT[0]:1:1}"
    # echo "$original [WILL BE REPLACED BY] $replace"
    # sed -i "s/${original}/$replace/g" "$redacted_log_file"
}

filter() {
        target=$1
    echo "Filtering $target"
#    if [ -z $target ];
#        then
#            while [ -z $target ]
#            do
#                echo "*INVALID* option! Which one database should be restored?"
#                backups_available=$(ls $REMOTE_BKP_PATH | tr -d "_backup.(sql|dump)")
#                echo "$backups_available"
#                read -p "Inform your target with full datetime: " target
#            done
#            echo ""
#            echo "New target is $target"
#            target_found=$(ls $REMOTE_BKP_PATH | tr -d "_backup.(sql|dump)" | grep -w $target)
#            if [ -z $target_found ];
#            then
#                echo "I quit!! $target *NOT FOUND* in:"
#                echo "$backups_available"
#                exit 1
#            fi
#        fi

    find $LOG_DIR -name "*.log" -print0 | while IFS= read -r -d '' filename; do
        FILTERED="${filename}.filtered"
        grep "ERROR" $filename > $FILTERED
        grep "SENSITIVE_DATA" $filename >> $FILTERED

        FRONT_LINES=$(cat $filename | wc -l);
        FRONT_FILTER_LINES=$(cat ${filename}.filtered | wc -l);

        echo "$filename --> Orig: ${FRONT_LINES} vs Filt: ${FRONT_FILTER_LINES}"
    done

}

case $1 in
    "filter")
        filter $2
        ;;
    "redact")
        redact $2
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [filter]. $1 *NOT* found!!"
        echo "filter <STRING_TO_FILTER>"
esac
