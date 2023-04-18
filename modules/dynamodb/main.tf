resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.dynamodb_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  dynamic "attribute" {
    for_each = var.attribute
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
  tags = {
    Environment = "dev"
  }
}