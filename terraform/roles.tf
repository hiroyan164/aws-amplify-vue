resource "aws_iam_role" "authenticated_user" {
  name               = "${var.app_name}_${var.app_env}_authed_user_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "cognito-identity.amazonaws.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "cognito-identity.amazonaws.com:amr": "authenticated"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role" "unauthenticated_user" {
  name = "${var.app_name}_${var.app_env}_unauthed_user_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "cognito-identity.amazonaws.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "cognito-identity.amazonaws.com:amr": "unauthenticated"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "storage_upload" {
  name   = "${var.app_name}_${var.app_env}_storage_upload_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}/uploads/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_storage_upload" {
  name = "attach_storage_upload"
  roles = ["${aws_iam_role.authenticated_user.name}"]
  policy_arn = "${aws_iam_policy.storage_upload.arn}"
}

resource "aws_iam_policy" "storage_read" {
  name = "${var.app_name}_${var.app_env}_storage_read_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}/protected/*"
            ],
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "public/",
                        "public/*",
                        "protected/",
                        "protected/*",
                        "private/$${cognito-identity.amazonaws.com:sub}/",
                        "private/$${cognito-identity.amazonaws.com:sub}/*"
                    ]
                }
            },
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_storage_read" {
  name       = "attach_storage_read"
  roles      = ["${aws_iam_role.authenticated_user.name}"]
  policy_arn = "${aws_iam_policy.storage_read.arn}"
}

resource "aws_iam_policy" "storage_write_public" {
  name   = "${var.app_name}_${var.app_env}_storage_write_public_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}/public/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_storage_write_public" {
  name = "attach_storage_write_public"
  roles = ["${aws_iam_role.authenticated_user.name}"]
  policy_arn = "${aws_iam_policy.storage_write_public.arn}"
}

resource "aws_iam_policy" "storage_write_protected" {
  name = "${var.app_name}_${var.app_env}_storage_write_protected_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}/protected/$${cognito-identity.amazonaws.com:sub}/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_storage_write_protected" {
  name       = "attach_storage_write_protected"
  roles      = ["${aws_iam_role.authenticated_user.name}"]
  policy_arn = "${aws_iam_policy.storage_write_protected.arn}"
}

resource "aws_iam_policy" "storage_write_private" {
  name   = "${var.app_name}_${var.app_env}_storage_write_private_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.storage_bucket.arn}/private/$${cognito-identity.amazonaws.com:sub}/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_storage_write_private" {
  name = "attach_storage_write_private"
  roles = ["${aws_iam_role.authenticated_user.name}"]
  policy_arn = "${aws_iam_policy.storage_write_private.arn}"
}
