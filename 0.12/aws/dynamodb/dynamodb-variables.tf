variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_billing_mode" {
  type    = string
  default = "PROVISIONED"
}

variable "dynamodb_read_capacity" {
  type    = number
  default = 20
}

variable "dynamodb_write_capacity" {
  type    = number
  default = 20
}
