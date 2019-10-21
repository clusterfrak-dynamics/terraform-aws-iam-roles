include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/clusterfrak-dynamics/terraform-aws-iam-roles?ref=v1.0.0"
}

locals {
  aws_region   = basename(dirname(get_terragrunt_dir()))
  env         = "production"
  custom_tags = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_tags.yaml")}"))
}

inputs = {

  env = local.env

  aws = {
    "region" = local.aws_region
  }

  iam_roles = [
    {
      name = "role-${local.env}"
      policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::bucket-${local.env}",
              "arn:aws:s3:::bucket-${local.env}/*"
            ]
        }
    ]
}
POLICY
      assume_role_policy = <<ASSUME_ROLE_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${AWS_ACCOUNT}:role/tf-eks-kiam-server-role"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
ASSUME_ROLE_POLICY
    }
  ]
}
