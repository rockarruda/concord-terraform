dynamodb_table_id="$(cat terraform-outputs.json | jq -r .dynamodb_table.value.id)"
dynamodb_table_arn="$(cat terraform-outputs.json | jq -r .dynamodb_table.value.arn)"
dynamodb_table_hash_key="$(cat terraform-outputs.json | jq -r .dynamodb_table.value.hash_key)"
dynamodb_table_read_capacity="$(cat terraform-outputs.json | jq -r .dynamodb_table.value.read_capacity)"
dynamodb_table_write_capacity="$(cat terraform-outputs.json | jq -r .dynamodb_table.value.write_capacity)"

@test "Validate outputs of Terraform 'dynamodb' module" {
  [ "$dynamodb_table_id" = "concord-testing" ]
  [ "$dynamodb_table_arn" != "" ]
  [ "$dynamodb_table_hash_key" = "LockID" ]
  [ "$dynamodb_table_read_capacity" = "20" ]
  [ "$dynamodb_table_write_capacity" = "20" ]
}
