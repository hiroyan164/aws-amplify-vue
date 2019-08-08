variable "aws_s3_bucket_storage_name" {
  type    = "string"
  default = "storage-bucket"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = "${replace(var.app_name, "_", "-")}-${var.app_env}-${var.aws_s3_bucket_storage_name}"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers = [
      "x-amz-server-side-encryption",
      "x-amz-request-id",
      "x-amz-id-2",
      "ETag"
    ]
    max_age_seconds = 3000
  }
}
