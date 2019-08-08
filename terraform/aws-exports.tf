resource "local_file" "aws_exports_js" {
  filename = "../src/aws-exports.js"
  content  = <<EOF
const awsmobile = {
    "aws_project_region": "${var.aws_default_region}",
    "aws_cognito_identity_pool_id": "${aws_cognito_identity_pool.idpool.id}",
    "aws_cognito_region": "${var.aws_default_region}",
    "aws_user_pools_id": "${aws_cognito_user_pool.userpool.id}",
    "aws_user_pools_web_client_id": "${aws_cognito_user_pool_client.webclient.id}",
    "oauth": {},
    "aws_user_files_s3_bucket": "${aws_s3_bucket.storage_bucket.bucket}",
    "aws_user_files_s3_bucket_region": "${var.aws_default_region}",
};
export default awsmobile;
EOF
}
