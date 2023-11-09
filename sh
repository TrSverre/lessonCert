#!/bin/bash
prod_ip=$(terraform output -raw ip1)

ssh-keyscan $(terraform output -raw ip1) >> ~/.ssh/known_hosts
echo "[serverprod]" >> /etc/ansible/hosts
echo "server1 ansible_host=$(terraform output -raw ip1)" >> /etc/ansible/hosts
echo "[all:vars]" >> /etc/ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> /etc/ansible/hosts