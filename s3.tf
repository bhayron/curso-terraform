
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#private-bucket-w-tags
resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "${random_pet.bucket.id}-bhayron"
  tags   = local.common_tags
}

resource "aws_s3_bucket_object" "this" {
  bucket = aws_s3_bucket.my-test-bucket.bucket
  key    = "config/${local.ip_filepath}"
  source = local.ip_filepath
  etag   = filemd5(local.ip_filepath)
}

# Configurar as regras de propriedade do bucket S3
resource "aws_s3_bucket_ownership_controls" "s3-ownership-control" {
  bucket = aws_s3_bucket.my-test-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configurar a ACL do bucket S3 como privada
resource "aws_s3_bucket_acl" "s3-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-ownership-control]

  bucket = aws_s3_bucket.my-test-bucket.id
  acl    = "private"
}
