#|/bin/bash

export NOW=$(date "+%FT%H-%M-%S")
export SCRIPT_PATH=$(dirname $0)
export LOG_DIR="${SCRIPT_PATH}/logs"
export REPORT_FILE="${LOG_DIR}/report.dat"
export TMP_DIR="${SCRIPT_PATH}/tmp"
export LOG_COMBINED="${TMP_DIR}/log_combined.log"
export LOG_COMPRESSED="${SCRIPT_PATH}/log_combined.tar.gz"

init_logs() {
    echo "Init data in syslog with logger"
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=error msg=\"error: Falha ao iniciar o serviço Apache\""
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=warning msg=\"failed: Servi?o Nginx n?o conseguiu se reiniciar\""
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=info msg=\"access denied: Tentativa de acesso ao banco de dados falhou\""
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=error msg=\"unauthorized: Tentativa de login SSH falhou\""
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=info msg=\"Sistema funcionando corretamente\""
    logger -p local0.info "time=\"$(date +'%Y-%m-%dT%H:%M:%S')\" level=warning msg=\"fail: Erro no driver de rede\""
}

monitory() {
    grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}' > $REPORT_FILE
    grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog 
}

network() {
    ip=$1

    if [ -z $ip ]; then
        echo "No ip informed!"
    fi

    res=$(ping -c 1 $ip > /dev/null)
    # echo "[NEUTRAL Return status would be: $? ip: ${ip} res: ${res}"
    if [ $? -ne 0 ]
    then
        echo "[ERROR] Return status would be: $? ip: ${ip}"
        echo "[$NOW] got some error!! No conection to ${ip}" >> $REPORT_FILE
    else
        echo "[OK] Return status would be: $? ip: ${ip}"
        echo "[$NOW] OK connection to ${ip}" >> $REPORT_FILE
    fi

    website="https://www.alura.com.br/"
    http=$(curl -s --head $website | grep "HTTP/2 200" )
    # echo "[NEUTRAL Return status would be: $? ip: ${ip} http: ${http}"
    if [ $? -ne 0 ]
    then
        echo "[ERROR] Return status would be: $? website: ${website}"
        echo "[$NOW] got some error!! No conection to with website ${website}" >> $REPORT_FILE
    else
        echo "[OK] Return status would be: $? website: ${website}"
        echo "[$NOW] OK connection to ${website}" >> $REPORT_FILE
    fi

    echo "----------------------------------------" >> $REPORT_FILE
}

disk() {
    echo "Monitoring disk"

    echo $NOW > $REPORT_FILE
    df -h | grep -v "Filesystem" | awk '$5 > 70 {print $1 " esta com " $5 " de uso."}' >> $REPORT_FILE
    du -sh $HOME >> $REPORT_FILE
    echo "----------------------------------------" >> $REPORT_FILE
}

hardware() {
    echo "Monitoring hardware"
    echo $NOW > $REPORT_FILE
    memory=$(free -h | grep Mem | awk '{print "Total: " $2 ", Usada: " $3 ", Livre: " $4}')
    echo $memory
    echo $memory >> $REPORT_FILE
    echo "***"
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{ print "CPU usage: " 100 - $1 "%" }')
    echo $cpu
    echo $cpu >> $REPORT_FILE
    echo "+++"
    filedisk=$(iostat | grep -E "Device|^sda|^sdb|^sdc" | awk '{ print $1, $2, $3, $4 }')
    echo $filedisk
    echo $filedisk >> $REPORT_FILE
    echo "---"
}

case $1 in
    "init")
        init_logs
        ;;
    "watch")
        clear
        date
        monitory
        echo "Show content of $SCRIPT_PATH"
        tree $SCRIPT_PATH
        # echo "Final report ($REPORT_FILE):"
        # cat $REPORT_FILE
        ;;
    "network")
        clear
        date
        echo "" > $REPORT_FILE
        network $2
        ;;
    "disk")
        clear
        date
        echo "" > $REPORT_FILE
        disk
        ;;
    "hardware")
        clear
        date
        echo "" > $REPORT_FILE
        hardware
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [filter | redact]. $1 *NOT* found!!"
        echo "filter"
        echo "redact <LOG_PATH_TO_REDACT>"
esac
