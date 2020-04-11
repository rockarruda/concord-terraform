ec2_arn="$(cat terraform-outputs.json | jq -r .ec2_instance.value.arn)"
ec2_public_ip="$(cat terraform-outputs.json | jq -r .ec2_instance.value.public_ip)"
ec2_volume_size="$(cat terraform-outputs.json | jq -r .ec2_instance.value.root_block_device[0].volume_size)"

@test "Validate outputs of Terraform 'ec2' module" {
  [ "$ec2_arn" != "" ]
  [ "$ec2_public_ip" != "" ]
  [ "$ec2_volume_size" = "15" ]
}

@test "Validate SSH connectivity to provisioned EC2 compute" {
  run bash ./terraform-connect.sh
  # This returns 0 even when there is no connectivity to the host, so we made a
  # wrapper script that checks the error code and outputs OK or ERROR
  [ "${lines[0]}" = "OK" ]
}
