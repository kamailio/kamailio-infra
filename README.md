# kamailio-infra

IoC for kamailio deb building infra

## Requirements

### awscli

```bash
apt install awscli
```

### [opentofu](https://opentofu.org/docs/intro/install/deb/)

/etc/apt/sources.list.d/opentofu.list

```text
deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
```

```bash
apt install tofu
```

### [packer](https://github.com/hashicorp/packer/releases)

### ansible

I use virtualenvwrapper:

```bash
apt install virtualenvwrapper
```

Just generate a virtual environment for ansible

```bash
mkvirtualenv ansible
```

And use workon before to activate the virtualenv and install requirements

```bash
workon ansible
cd ami/ansible
ansible-galaxy collection install -f --upgrade -r collections/requirements.yml
ansible-galaxy role install -f -r roles/requirements.yml
```

## Build AMIs

```bash
cd ami
packer init .
packer build -var "environment=dev" slave.pkr.hcl
```

### debug

```bash
PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer.log packer build -var "environment=dev" slave.pkr.hcl
```

### Ansible

**group_vars** and **host_vars** files are encrypted using [SOPS](https://github.com/getsops/sops)

[Protecting Ansible secrets with SOPS](https://docs.ansible.com/ansible/latest/collections/community/sops/docsite/guide.html)

## [pre-commit](https://pre-commit.com/)

```bash
apt install pre-commit
pre-commit install
```

## Initial config of letsencrypt

This has to be executed just once when jenkins-master instance gets created

Remove jenkins host from nginx and remove fake letsencrypt certs:

```bash
ssh admin@jenkins.dev.kamailio.org
sudo -i
cd /etc/nginx/sites-enabled
rm jenkins.dev.kamailio.org.conf
cd /etc/letsencrypt
rm -rf live
```

Execute ansible with deb_certbot_create as true:

```bash
cd ami/ansible
workon ansible
ansible-playbook  --inventory=inventory_dev/inventory main.yml --extra-vars='{"deb_certbot_create":true}'
```
