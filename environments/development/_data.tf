data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_policy_document" "jenkins_ec2" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeSpotInstanceRequests",
      "ec2:CancelSpotInstanceRequests",
      "ec2:GetConsoleOutput",
      "ec2:RequestSpotInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "iam:ListInstanceProfilesForRole",
      "iam:PassRole",
      "ec2:GetPasswordData"
    ]
    resources = ["*"]
  }
}

data "sops_file" "secrets" {
  source_file = "../../ami/ansible/inventory_dev/group_vars/all.sops.yml"
  input_type  = "yaml"
}
