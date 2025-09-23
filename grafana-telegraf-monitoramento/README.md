# [Grafana e Telegraf: Monitoramento em Tempo Real](https://cursos.alura.com.br/course/grafana-telegraf-monitoramento) #

Exemplo de Ferramentas:
* Prometheus
* Graylog
* Appdynamics
* dynatrace
* CA
* Zabbix
* Netdata
* Telegraf
* Grafana

# Env #

- grafana -> 3000
- influx-db -> 8181
- telegraf ->

# Tools #

- stress-ng: can stress various subsystems of a computer.  It can stress load CPU, cache, disk, memory, socket and pipe I/O, scheduling and much more.


# Goals #

Poderia quebrar o monitoramento em 2 partes:
- Infraestrutura associada ao sistema (observar nas máquinas que o sistema roda a saúde de cpu + meomória/swap + disco)
- Log da aplicação em um banco de dados temporal para acompanhar informações mais específicas da aplicação como atividades de login, etc.
- Ainda, o log da aplicação acima pode ser visto como em 2 partes: log de informações sistêmicas (login, segurança, execução de determinada atividade) e métricas de sucesso das regras de negócio (sucesso de vendas, sucesso de contas lançadas, etc)
