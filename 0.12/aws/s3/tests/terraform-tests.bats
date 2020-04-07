elements=".arn.value, .bucket_domain_name.value, .bucket_regional_domain_name.value"

@test "Validate outputs of Terraform 's3' module" {
  run bash -c "cat terraform-outputs.json | jq -r '${elements}'"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "arn:aws:s3:::starburstdata-test-bucket" ]
  [ "${lines[1]}" = "starburstdata-test-bucket.s3.amazonaws.com" ]
  [ "${lines[2]}" = "starburstdata-test-bucket.s3.us-east-2.amazonaws.com" ]
}
