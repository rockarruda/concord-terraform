load terraform
load variables

region="$(cat terraform.tfvars.json | jq -r .aws_region | tr -d "\r\n\t")"
availability_zones=( "${region}a" "${region}b" )

@test "Validate outputs of Terraform 'vpc-sps' module" {

  # Verify that VPC was created
  assertTerraformOutputEquals $region '.region.value'
  assertTerraformOutputNotEmpty ".vpc.value.id"
  assertTerraformOutputEquals "${NAME}-vpc" ".vpc.value.tags.Name"

  # Verify that count of created public subnets matches no. of AZ's
  assertTerraformOutputMapSize 0 '.public_subnets.value'
  # Verify that count of created NAT Gateways matches no. of AZ's
  assertTerraformOutputMapSize 0 '.["nat-gw"].value'
  # Verify that count of created Elastic IP' matches no. of AZ's
  assertTerraformOutputMapSize 0 '.["nat-eips"].value'
  # Verify that count of created private subnets matches no. of AZ's
  assertTerraformOutputMapSize $(( ${#availability_zones[@]}*2 )) '.private_subnets.value'

  for az in ${availability_zones[@]}; do

    # Verify that 2 private subnets where created in availability zone
    assertTerraformOutputArraySize 2 "[ .private_subnets.value[] | select(.availability_zone==\"$az\").id ]"

  done

}
