load terraform
load variables

@test "Validate outputs of Terraform 'Instance Profile' module" {
  assertTerraformOutputNotEmpty ".instance_profile.value.arn"
  assertTerraformOutputEquals $NAME ".instance_profile.value.id"
}
