include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/network"
}

inputs = {
  environment = "prod"
  name        = "kamailio"
  cidr        = "172.21.1.0/24"
}
