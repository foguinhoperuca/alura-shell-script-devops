#|/bin/bash

export NOW=$(date "+%FT%H-%M-%S")
export SCRIPT_PATH=$(dirname $0)
export LOG_DIR="${SCRIPT_PATH}/logs"
export REPORT_FILE="${LOG_DIR}/report.dat"
export TMP_DIR="${SCRIPT_PATH}/tmp"
export LOG_COMBINED="${TMP_DIR}/log_combined.log"
export LOG_COMPRESSED="${SCRIPT_PATH}/log_combined.tar.gz"

export SUB_ARR_0=("User password is .*" "User password is REDACTED")
export SUB_ARR_1=("User password reset request with token .*" "User password reset request with token REDACTED")
export SUB_ARR_2=("API key leaked: .*" "API key leaked: REDACTED")
export SUB_ARR_3=("User credit card last four digits: .*" "User credit card last four digits: REDACTED")
export SUB_ARR_4=("User session initiated with token: .*" "User session initiated with token: REDACTED")
export REDACT_TEXT=(
    SUB_ARR_0[@]
    SUB_ARR_1[@]
    SUB_ARR_2[@]
    SUB_ARR_3[@]
    SUB_ARR_4[@]
)

shuffle() {
    target=$1
    echo "SHUFFLING log file $target > ${target}.shuffled"
    cat $target | shuf > "${target}.shuffled"
}

redact() {
    log_file=$1
    redacted_log_file="${log_file}.redacted"
    echo "REDACTING log file $log_file > $redacted_log_file"
    cp $log_file $redacted_log_file

    COUNT=${#REDACT_TEXT[@]}
    for ((i=0; i < $COUNT; i++))
    do
        original="${!REDACT_TEXT[i]:0:1}"
        replace="${!REDACT_TEXT[i]:1:1}"
        # echo "$original [WILL BE REPLACED BY] $replace"
        sed -i "s/${original}/${replace}/g" $redacted_log_file
    done
}

filter() {
    echo "0. Reporting at $NOW" > $REPORT_FILE
    echo "0. Combining at $NOW" > $LOG_COMBINED
    rm -rf $LOG_COMPRESSED
    find $LOG_DIR -name "*.log" -print0 | while IFS= read -r -d '' filename;
    do
        echo "|--------------------------------------"
        echo "| Processing $filename"
        echo "|--------------------------------------"
        echo ""

        shuffle $filename

        redact ${filename}.shuffled

        echo "FILTERING log file ${filename}.shuffled.redacted > ${filename}.shuffled.redacted.filtered"
        grep "ERROR" "${filename}.shuffled.redacted" > "${filename}.shuffled.redacted.filtered"
        grep "SENSITIVE_DATA" "${filename}.shuffled.redacted" >> "${filename}.shuffled.redacted.filtered"

        echo "SORTING   log file ${filename}.shuffled.redacted.filtered > ${filename}.shuffled.redacted.filtered.sorted"
        sort "${filename}.shuffled.redacted.filtered" -o "${filename}.shuffled.redacted.filtered.sorted"

        echo "UNIQUING  log file ${filename}.shuffled.redacted.filtered.sorted > ${filename}.shuffled.redacted.filtered.sorted.uniq"
        uniq "${filename}.shuffled.redacted.filtered.sorted" > "${filename}.shuffled.redacted.filtered.sorted.uniq"

        ORIG_LINES=$(cat $filename | wc -l)
        SHUF_LINES=$(cat ${filename}.shuffled | wc -l)
        REDA_LINES=$(cat ${filename}.shuffled.redacted | wc -l)
        FILT_LINES=$(cat ${filename}.shuffled.redacted.filtered | wc -l)
        SORT_LINES=$(cat ${filename}.shuffled.redacted.filtered.sorted | wc -l)
        UNIQ_LINES=$(cat ${filename}.shuffled.redacted.filtered.sorted.uniq | wc -l)
        TOT_REDACT=$(cat ${filename}.shuffled.redacted | grep "REDACTED" | wc -l)
        TOT_W_UNIQ=$(cat ${filename}.shuffled.redacted.filtered.sorted.uniq | wc -w)
        result="$filename --> Orig: ${ORIG_LINES} vs Shuf: ${SHUF_LINES} vs Reda: ${REDA_LINES} ($TOT_REDACT total redacted) vs Filt: ${FILT_LINES} vs SORT: ${SORT_LINES} vs Uniq: ${UNIQ_LINES} ($TOT_W_UNIQ total words)"
        echo "${result}" >> $REPORT_FILE
        echo ""

        basename_log=$(basename ${filename})
        echo "basename log is: ${basename_log}"
        if [[ "${basename_log}" == *frontend* ]];
        then
            echo "FRONT END!"
            sed 's/^/[FRONTEND] /' "${filename}" >> $LOG_COMBINED
        elif [[ "${basename_log}" == *backend* ]];
        then
            echo "BACK END"
            sed 's/^/[BACKEND] /' "${filename}" >> $LOG_COMBINED
        else
            echo "SEND AS IS"
            sed 's/^/[AS_IS] /' "${filename}" >> $LOG_COMBINED
        fi
    done

    echo ""
    echo "Sorting cobined log"
    sort -k2 $LOG_COMBINED -o $LOG_COMBINED
    echo "..."

    echo "Creating compressed log"
    tar -czf $LOG_COMPRESSED -C "$TMP_DIR" .
    echo "..."
    echo ""
}

case $1 in
    "filter")
        clear
        date
        filter
        echo "Show content of $SCRIPT_PATH"
        tree $SCRIPT_PATH
        echo "Final report ($REPORT_FILE):"
        cat $REPORT_FILE
        ;;
    "redact")
        redact $2
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [filter | redact]. $1 *NOT* found!!"
        echo "filter"
        echo "redact <LOG_PATH_TO_REDACT>"
esac
