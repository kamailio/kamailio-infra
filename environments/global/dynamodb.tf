# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "kamailio-build-env-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "global"
    Purpose     = "terraform-state-locking"
  }
}
