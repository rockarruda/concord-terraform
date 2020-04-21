load terraform
load variables

@test "Validate outputs of Terraform 's3' module" {
  assertTerraformOutputEquals "arn:aws:s3:::${NAME}" ".arn.value"
  assertTerraformOutputEquals "${NAME}.s3.amazonaws.com" ".bucket_domain_name.value"
  assertTerraformOutputEquals "${NAME}.s3.us-east-2.amazonaws.com" ".bucket_regional_domain_name.value"
}
