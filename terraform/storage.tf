resource "aws_s3_bucket" "bkt01" {
    bucket = "jecampos-bkt01"
    acl = "private"
    tags = {
        Name = "jecampos-bkt01"
    }
}
