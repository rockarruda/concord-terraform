elements=".account_id.value, .caller_arn.value, .caller_user.value"

@test "Validate outputs of Terraform 'id' module" {
  run bash -c "cat terraform-outputs.json | jq -r '${elements}'"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" != "" ]
  [ "${lines[1]}" != "" ]
  [ "${lines[2]}" != "" ]
}
