resource "aws_s3_bucket" "mybucket" {
    bucket = "firstbucket-terrafrom-sandeshsgowda"

    tags = {
        Name = "mybucket"
        Environment = "Dev"
    }

}
resource "aws_s3_bucket_versioning" "myaws_s3version"{
    bucket = aws_s3_bucket.mybucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
