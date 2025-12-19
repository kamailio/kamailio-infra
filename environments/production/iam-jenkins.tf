resource "aws_iam_user" "jenkins" {
  name = "jenkins-${var.environment}"
  path = "/system/"

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_access_key" "jenkins" {
  user = aws_iam_user.jenkins.name
}

resource "aws_iam_role" "jenkins" {
  name                  = "jenkins-${var.environment}"
  assume_role_policy    = data.aws_iam_policy_document.ec2_assume_role.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "jenkins" {
  name   = "jenkins-${var.environment}"
  role   = aws_iam_role.jenkins.name
  policy = data.aws_iam_policy_document.jenkins_ec2.json
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-${var.environment}"
  role = aws_iam_role.jenkins.name
}
