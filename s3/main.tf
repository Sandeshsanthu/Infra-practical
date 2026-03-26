resource "aws_s3_bucket" "storage" {
    bucket = "my-tf-test-bucket-sandeshsgowda"
    tags = {
        name = "my-bucket"
        Environment = "Dev"
    }
}
resource "aws_s3_bucket_accelerate_configuration" "acceselater"{
    bucket = aws_s3_bucket.storage.id
    status = "Enabled"

}