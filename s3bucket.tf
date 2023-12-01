#################################
##creating bucket for s3 backend
################################

# Note: Create s3 bucket with a unique name.
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "eks-bucket-proj24"
  force_destroy = true
}

# Enable versioning so we can see the full revision history of our state files
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}



# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}