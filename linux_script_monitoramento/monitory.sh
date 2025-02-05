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

case $1 in
    "watch")
        clear
        date
        monitory
        echo "Show content of $SCRIPT_PATH"
        tree $SCRIPT_PATH
        # echo "Final report ($REPORT_FILE):"
        # cat $REPORT_FILE
        ;;
    "init")
        init_logs
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [filter | redact]. $1 *NOT* found!!"
        echo "filter"
        echo "redact <LOG_PATH_TO_REDACT>"
esac
