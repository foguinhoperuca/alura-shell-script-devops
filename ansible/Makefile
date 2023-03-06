.PHONY: deploy-ansilble

deploy-ansible-stage:
	clear
	scp * ladm@172.16.1.12:/home/ladm/universal/projects/pms/alura/devops/ansible/

deploy-ansible-lab:
	clear
	scp * admlocal@172.16.1.36:/home/admlocal/universal/projects/pms/alura/devops/ansible/

ansible-run:
	clear
	ansible -vvv lab -u admlocal --private-key ~/.ssh/id_rsa -i hosts -m shell -a 'echo Hello, World!!'

ansible-test:
	clear
	ansible-playbook provisioning.yml -i hosts -u admlocal --private-key ~/.ssh/id_rsa

# run-pep8: check-source
# 	clear
# 	python best_practices_pep8/main.py
