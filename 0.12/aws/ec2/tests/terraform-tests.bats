load terraform

@test "Validate outputs of Terraform 'ec2' module" {
  assertTerraformOutputNotEmpty .ec2_instance.value.arn
  assertTerraformOutputNotEmpty .ec2_instance.value.public_ip
  assertTerraformOutputEquals 15 .ec2_instance.value.root_block_device[0].volume_size
}

@test "Validate SSH connectivity to provisioned EC2 compute" {
  run bash ./terraform-connect.sh
  # This returns 0 even when there is no connectivity to the host, so we made a
  # wrapper script that checks the error code and outputs OK or ERROR
  [ "${lines[0]}" = "OK" ]
}
