.PHONY: run-aws

PRIVATE_KEY_PATH=alura-ansible-terraform-prm

run-aws:
	@clear
	@date
	echo "<h1>Hello World AWS Ansible Terraform</h1><p>Alura's course.</p>" > index.html
	nohup busybox httpd -f -p 8080 &
	@date

run-playbook-django:
	@clear
	@date
	ansible-playbook playbook.yml -u ubuntu --private-key $(PRIVATE_KEY_PATH) -i hosts.yml
