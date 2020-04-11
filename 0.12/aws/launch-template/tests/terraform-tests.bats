load terraform

@test "Validate outputs of Terraform 'launch-template' module" {
  assertTerraformOutputNotEmpty ".launch_template.value.arn"
  assertTerraformOutputEquals "concord-testing" ".launch_template.value.name"
  assertTerraformOutputNotEmpty ".launch_template.value.user_data"
}
