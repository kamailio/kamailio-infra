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

### [terragrunt](https://github.com/gruntwork-io/terragrunt/releases)

Used to keep dev and production environments and don't replicate code if possible.

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
ansible-galaxy collection install --upgrade -r collections/requirements.yml
ansible-galaxy role install -f -r content/roles/requirements.yml
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

## TODO

### use [terraform-aws-modules](https://github.com/terraform-aws-modules)

* [terraform-aws-vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc)
* [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance)
* [terraform-aws-s3-bucket](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket)

examples:

* [ipv6-dualstack](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/ipv6-dualstack)
