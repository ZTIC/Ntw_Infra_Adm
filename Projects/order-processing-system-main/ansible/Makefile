.PHONY: help setup deploy status clean logs restart

help:
	@echo "OMS Ansible - Local Development"
	@echo "================================"
	@echo "make setup     - Setup local environment"
	@echo "make deploy    - Deploy with Docker Compose"
	@echo "make status    - Check service status"
	@echo "make logs      - View logs"
	@echo "make restart   - Restart services"
	@echo "make clean     - Stop and remove containers"
	@echo "make clean-all - Remove everything (containers, volumes, images)"

setup:
	cd ansible && ansible-playbook playbooks/setup-local.yml

deploy:
	cd ansible && ansible-playbook playbooks/deploy-docker.yml

status:
	cd ansible && ansible-playbook playbooks/status.yml

logs:
	docker-compose -f /opt/oms/docker-compose.yml logs -f

restart:
	docker-compose -f /opt/oms/docker-compose.yml restart

clean:
	cd ansible && ansible-playbook playbooks/clean.yml

clean-all:
	cd ansible && ansible-playbook playbooks/clean.yml -e "clean_all=true"

ping:
	cd ansible && ansible all -m ping