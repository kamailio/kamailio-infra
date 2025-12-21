#!/bin/bash
cd ami/ansible || exit 1

function check {
  env=${1:-dev}
  sops --decrypt "inventory_${env}/group_vars/all.sops.yml" > "inventory_${env}/group_vars/all.tmp.secret.yml"
  if ! cmp -s "inventory_${env}/group_vars/all.secret.yml" "inventory_${env}/group_vars/all.tmp.secret.yml" ; then
    sops --encrypt "inventory_${env}/group_vars/all.secret.yml" > "inventory_${env}/group_vars/all.sops.yml"
    echo "ami/ansible/inventory_${env}/group_vars/all.sops.yml generated"
  fi
}

check dev
check prod
