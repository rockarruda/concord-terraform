load terraform

@test "Validate outputs of Terraform 's3' module" {
  assertTerraformOutputEquals "arn:aws:s3:::starburstdata-test-bucket" ".arn.value"
  assertTerraformOutputEquals "starburstdata-test-bucket.s3.amazonaws.com" ".bucket_domain_name.value"
  assertTerraformOutputEquals "starburstdata-test-bucket.s3.us-east-2.amazonaws.com" ".bucket_regional_domain_name.value"
}
