# Requirements

## awscli

```bash
apt install awscli
```

## [opentofu](https://opentofu.org/docs/intro/install/deb/)

/etc/apt/sources.list.d/opentofu.list
```txt
deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
```

```bash
apt install tofu
```

## [terragrunt](https://github.com/gruntwork-io/terragrunt/releases)


## [packer](https://github.com/hashicorp/packer/releases)

# Build AMIs

```bash
cd ami
packer init .
packer build slave.pkr.hcl
```

## debug
```bash
PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer.log packer build slave.pkr.hcl
```

TODO
=====
use terraform-aws-modules:

* https://github.com/terraform-aws-modules/terraform-aws-vpc
* https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
* https://github.com/terraform-aws-modules/terraform-aws-s3-bucket


examples:
========
https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/ipv6-dualstack
