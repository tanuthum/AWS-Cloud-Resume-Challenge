// visitor_count is a name inside Terraform, it use for a reference 
resource "aws_dynamodb_table" "visitor_count" { 
  name           = "ViewCount"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
