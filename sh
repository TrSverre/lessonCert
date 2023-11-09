#!/bin/bash
ssh-keyscan $(terraform output -raw ipbild) >> ~/.ssh/known_hosts
echo "[bild]" >> /etc/ansible/hosts
echo "server1 ansible_host=$(terraform output -raw ipbild)" >> /etc/ansible/hosts
ssh-keyscan $(terraform output -raw ipprod) >> ~/.ssh/known_hosts
echo "[prod]" >> /etc/ansible/hosts
echo "server1 ansible_host=$(terraform output -raw ipprod)" >> /etc/ansible/hosts
echo "[all:vars]" >> /etc/ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> /etc/ansible/hosts