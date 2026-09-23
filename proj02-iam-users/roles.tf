locals {
  # Map each IAM role to the AWS-managed policies it should receive
  role_policies = {
    readonly = [
      "ReadOnlyAccess"
    ]
    admin = [
      "AdministratorAccess"
    ]
    auditor = [
      "SecurityAudit"
    ]
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess"
    ]
  }
  # Convert the role -> policies structure into individual role/policy pairs
  # Makes it easier to loop over each statement later
  role_policies_list = flatten([
    for role, policies in local.role_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])
}

output "policies" {
  value = local.role_policies_list
}

# Get the current AWS account ID so we don't hardcode it into user ARNs
data "aws_caller_identity" "current" {}

# Create a trust policy for each role
# Only allow users assigned that role to assume it

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = toset(keys(local.role_policies))
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)
      ]
    }
  }
}

# Create the IAM roles and give each its matching trust policy
resource "aws_iam_role" "roles" {
  for_each = toset(keys(local.role_policies))

  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.value].json
}

#Look up the AWS-managed policies named in role_policies
data "aws_iam_policy" "managed_policies" {
  for_each = toset(local.role_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"

}

# Create one attachment for every role/policy pair
# count.index selects the matching pair from role_policies_list

resource "aws_iam_role_policy_attachment" "role_policy_attachments" {
  count      = length(local.role_policies_list)
  role       = aws_iam_role.roles[local.role_policies_list[count.index].role].name
  policy_arn = data.aws_iam_policy.managed_policies[local.role_policies_list[count.index].policy].arn
}