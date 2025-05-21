#!/usr/bin/env bash
ansible-playbook -i hosts install-docker.yml --ask-become-pass
