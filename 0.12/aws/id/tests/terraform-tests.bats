load terraform

@test "Validate outputs of Terraform 'id' module" {
  assertTerraformOutputNotEmpty ".account_id.value"
  assertTerraformOutputNotEmpty ".caller_arn.value"
  assertTerraformOutputNotEmpty ".caller_user.value"
}
