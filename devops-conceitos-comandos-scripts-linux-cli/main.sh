#/bin/bash

eval_params() {
    param01=$1
    all_params=("${@}")
    echo "Testing with params -> $param01"
    echo "show total of params in fn eval_params: $#"
    for param in ${@};
    do
        echo "param in fn: $param"
    done

    echo "all params: ${all_params[1]}"
}

more_params() {
    all_params=("${@}")
    param1=$1
    param2=$2
    param3=$3
    param4=$4
    echo "all_params: $all_params"
    echo "${@}"
    echo "param #0 ${all_params[0]}"
    echo "param #1 ${all_params[1]}"
    echo "param #2 ${all_params[2]}"
    echo "param #3 ${all_params[3]}"
    echo "param #4 ${all_params[4]}"
    echo "+++"
    for param in ${all_params};
    do
        echo "param in fn: $param"
    done

    echo "..."
    echo "$param1"
    echo "$param2"
    echo "$param3"
    echo "$param4"
}

online() {
    program=$1

    echo "Validating if ${program} is online..."
    if pgrep $program &> /dev/null
    then
        echo "$program is online now $(date +"%Y-%m=-%dT%H:%M:%S")"
    else
        echo "No $program online..."
    fi
}

clear
date
echo "**************"

exit_code=0
case $1 in
    "params")
        echo "Total params in program: $#"
        echo "program name: $0 - ${@:2:3}"
        echo "Program params: ${@}"
        echo "Slice in params: ${@:3}"
        echo "---"
        eval_params ${@:1}
        date
        ;;
    "more_params")
        echo "MORE PARAMS case"
        echo "$1"
        echo "$2"
        echo "$3"
        echo "${@}"
        echo "*** INSIDE FN ***"
        more_params $1 $2 $3
        ;;
    "online")
        online $2;;
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
        fi

        ;;
    *)
        # TODO better usage message
        complement=""
        if [ "$1" != "help" ]; then
            exit_code=1
            complement="$1 *NOT* found!!"
        fi
        echo "USAGE: [params | more_params | convert | help]. ${complement}"
        echo "params <ANY_PARAMS>"
        echo "convert <FROM> <TO> <SIZE>"

esac

echo "**************"
echo "Exiting with code ${exit_code}"
date
exit $exit_code
