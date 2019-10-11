resource "aws_iam_policy" "iam-policy" {
  count  = length(var.iam_roles)
  name   = "tf-iam-policy-${var.iam_roles[count.index]["name"]}"
  policy = var.iam_roles[count.index]["policy"]
}

resource "aws_iam_role" "iam-role" {
  count              = length(var.iam_roles)
  name               = "tf-iam-role-${var.iam_roles[count.index]["name"]}"
  assume_role_policy = var.iam_roles[count.index]["assume_role_policy"]
}

resource "aws_iam_role_policy_attachment" "iam-policy-attachment" {
  count      = length(var.iam_roles)
  role       = aws_iam_role.iam-role[count.index].name
  policy_arn = aws_iam_policy.iam-policy[count.index].arn
}
