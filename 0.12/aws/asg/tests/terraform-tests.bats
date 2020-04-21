load terraform
load variables

@test "Validate outputs of Terraform 'asg' module" {
  assertTerraformOutputNotEmpty ".asg.value.arn"
  assertTerraformOutputEquals $NAME ".asg.value.id"
}

@test "Validate SSH connectivity to provisioned ASG compute" {
  run bash ./terraform-connect.sh #debug bats
  # This returns 0 even when there is no connectivity to the host, so we made a
  # wrapper script that checks the error code and outputs OK or ERROR
  [ "${lines[0]}" = "OK" ]
}
