# data "aws_vpc" "main" {
#   filter {
#     name   = "tag:Build_id"
#     values = ["kama-build"]
#   }
# }

# data "aws_route_table" "public" {
#   filter {
#     name   = "tag:Build_id"
#     values = ["kama-build"]
#   }
# }

data "aws_availability_zones" "available" {
  state = "available"
}
# data "aws_security_group" "web_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["web-security-group"]
#   }

# }
