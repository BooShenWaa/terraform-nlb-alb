resource "random_uuid" "nlb-tg-uuid" {
}

resource "aws_s3_bucket" "populate_NLB_TG_bucket" {
  bucket = "nlb-tg-bucket-${random_uuid.nlb-tg-uuid.result}"
  acl = "private"
  force_destroy = true

  versioning {
    enabled = false
  }
  

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm     = "AES256"
  #     }
  #   }
  # }
}

output "bucket_name" {
  value = aws_s3_bucket.populate_NLB_TG_bucket.bucket
}