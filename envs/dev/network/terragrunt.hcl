include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/network"
}

inputs = {
  environment = "dev"
  name        = "kamailio"
  cidr        = "172.20.1.0/24"
}
