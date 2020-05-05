load terraform
load variables

@test "Validate outputs of Terraform 'launch-template' module" {
  assertTerraformOutputNotEmpty ".launch_template.value.arn"
  assertTerraformOutputEquals $NAME ".launch_template.value.name"
  assertTerraformOutputNotEmpty ".launch_template.value.user_data"
}
