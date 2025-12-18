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
  name = "jenkins-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
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
