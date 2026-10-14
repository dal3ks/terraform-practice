resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket = "workspace-demo-${random_id.bucket_suffix.hex}"
}