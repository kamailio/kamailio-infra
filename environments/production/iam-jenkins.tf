resource "aws_iam_user" "jenkins" {
  name = "jenkins"
  path = "/system/"

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_access_key" "jenkins" {
  user = aws_iam_user.jenkins.name
}

data "aws_iam_policy_document" "jenkins" {
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

resource "aws_iam_user_policy" "jenkins" {
  name   = "jenkins"
  user   = aws_iam_user.jenkins.name
  policy = data.aws_iam_policy_document.jenkins.json
}
