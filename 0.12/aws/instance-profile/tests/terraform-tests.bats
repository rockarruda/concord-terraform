load terraform

@test "Validate outputs of Terraform 'Instance Profile' module" {
  assertTerraformOutputNotEmpty ".instance_profile.value.arn"
  assertTerraformOutputEquals "concord-testing-instance-profile" ".instance_profile.value.id"
}
