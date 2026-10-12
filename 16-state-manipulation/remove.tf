# how to remove the new object
#  1- via CLI
#  2- via removed block

removed {
  from = aws_s3_bucket.my_new_bucket
  lifecycle {
    destroy = false
  }
}
