# Alura Devops #

All learning materials.

- Ansible
- Docker
- Vagrant
- Terraform
- ...

# Courses #

## Começando em Linux ##

https://cursos.alura.com.br/formacao-comecando-linux

- [Linux: gerenciando diretórios, arquivos, permissões e processos](https://cursos.alura.com.br/course/linux-gerenciando-diretorios-arquivos-permissoes-processos "")
- [Linux: criando script para processamento de arquivos de logs](https://cursos.alura.com.br/course/linux-criando-script-processamento-arquivos-logs "linux_script_log/")
- [Linux: criando script de monitoramento de sistema](https://cursos.alura.com.br/course/linux-criando-script-monitoramento-sistema "linux_script_monitoramento")

## [Scripting: Automatizando Tarefas em DevOps](https://cursos.alura.com.br/formacao-scripting-automatizando-tarefas-devop://cursos.alura.com.br/formacao-scripting-automatizando-tarefas-devops) ##

- [Scripting: Automatizando Tarefas com Bash e Docker](https://cursos.alura.com.br/course/scripting-automatizando-tarefas-bash-docker)

## [DevOps](https://cursos.alura.com.br/formacao-devops) ##

- [Ansible: implementando sua infraestrutura como c?digo](https://cursos.alura.com.br/course/ansible-implementando-infraestrutura-codigo "ansible-implementando-infraestrutura-codigo")



    #    - shell: 'echo hello world!!'
    # - name: install apache httpd
    #   become: yes
    #   ansible.builtin.apt:
    #     name: apache2
    #     state: latest
    #     update_cache: yes



    - name: inst
      become: yes
      ansible.builtin.apt:
        pkg:
          # - apache2
          - ghostscript
          - libapach2-mod-php
      state: latest
      update_cache: yes
