#/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

load_vars() {
    export ENV_FILE=.env
    export ENV_HOST=$(cat $ENV_FILE | grep HOST | cut -d = -f2)
    export ENV_PORT=$(cat $ENV_FILE | grep PORT | cut -d = -f2)
    export ENV_USER=$(cat $ENV_FILE | grep USER | cut -d = -f2)
    export ENV_PASS=$(cat $ENV_FILE | grep PASS | cut -d = -f2)
}

ssl() {
    echo "Understending ssl"
    openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
}

root() {
    host=$1
    port=$2
    echo "open $host $port"
    sleep 2
    echo "GET / HTTP/1.1"
    echo "Host: $host"
    echo 
    echo
    sleep 2
}

do_login() {
    host=localhost
    port=8000
    user=$1
    pass=$2
    echo "open $host $port"
    sleep 2
    echo "POST /public/login"
    echo "Content-Type: application/json"
    echo "Content-length: 63"
    echo
    echo "{\"email\": \"$user\", \"senha\": \"$pass\"}"
    echo
    echo
    sleep 2
}

case $1 in
    "load_vars")
        load_vars
        ;;
    "get_root")
        host=$2
        if [ -z $host ];
        then
            host=$ENV_HOST
        fi
        port=$3
        if [ -z $port ];
        then
            port=$ENV_PORT
        fi
        root $host $port
        ;;
    "login")
        user=$2
        if [ -z $user ];
        then
            user=$ENV_USER
        fi
        pass=$3
        if [ -z $pass ];
        then
            pass=$ENV_PASS
        fi
        do_login $user $pass
        ;;
    *)
        echo -e "Option $1 ${RED}**NOT**${NC} found."
        echo -e "${RED}USAGE:${NC} ${BLUE}./commands.sh${NC} ${YELLOW}[load_vars].${NC}"
        echo -e "${RED}USAGE:${NC} ${BLUE}./commands.sh${NC} ${YELLOW}[get_root | login] | telnet > result.html${NC}"
esac
