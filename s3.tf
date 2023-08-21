
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#private-bucket-w-tags
resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "${random_pet.bucket.id}-bhayron"

  tags = {
    Name        = "My first Terraform bucket"
    Environment = "Dev"
    ManagedBy   = "Terraform"
    Owner       = "Cleber Gasparoto"
    CreatedAt   = "2023-08-02"
  }
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
