packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "arch" {
  type    = string
  default = "amd64"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "root_volume_size_gb" {
  type    = number
  default = 32
}

source "amazon-ebs" "debian" {
  ami_name      = "kamailio-infra-slave-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.region
  tags          = {
    Environment = var.environment
  }
  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = "${var.root_volume_size_gb}"
    volume_type           = "gp2"
    delete_on_termination = true
  }
  source_ami_filter {
    filters = {
      name                = "debian-13-${var.arch}-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["136693071363"] # amazon
  }
  ssh_username = "admin"
}

build {
  name    = "kamailio-debian13-ami"
  sources = ["source.amazon-ebs.debian"]

  provisioner "ansible" {
    user                = "admin"
    playbook_file       = "ansible/main.yml"
    galaxy_file         = "ansible/roles/requirements.yml"
    roles_path          = "ansible/roles"
    collections_path    = "ansible/collections"
    inventory_directory = "ansible/inventory_${var.environment}"
    groups              = ["jenkins_slaves"]
    ansible_env_vars    = ["ANSIBLE_CONFIG=ansible/ansible.cfg"]
    extra_arguments     = ["--extra-vars", "\"environment=${var.environment}\""]
    # debugging
    # extra_arguments     = ["-v"]
  }
}
