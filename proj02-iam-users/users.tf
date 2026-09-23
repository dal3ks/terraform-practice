# Read users and their assigned roles from user-roles.yaml and convert into a map
/*
{
username: string
roles: string[]}

Objects are easier to access as: {username => roles}
*/

locals {

# convert the YAML user list into a map for easy role lookups by username
  users_from_yaml = yamldecode(file("${path.module}/user-roles.yaml")).users
  users_map = {
    for user_config in local.users_from_yaml : user_config.username => user_config.roles
  }
}

# Create an IAM user for each user define in user-roles.yaml
resource "aws_iam_user" "users" {
  for_each = toset(local.users_from_yaml[*].username)
  name     = each.value
}

# Create a console login profile for each IAM user
resource "aws_iam_user_login_profile" "users" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 8

# Prevent Terraform from treating password-related changes
# as configuration drift after the login profile is created
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}

# Output the generated initial passwords by username
# Marked sensitive to prevent terraform displaying them normally

output "passwords" {
  value = {
  for user, user_login in aws_iam_user_login_profile.users : user => user_login.password }
  sensitive = true
}

