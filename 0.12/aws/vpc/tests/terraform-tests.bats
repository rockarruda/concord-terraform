vpc_id="$(cat terraform-outputs.json | jq -r .vpc_id.value)"
vpc_name="$(cat terraform-outputs.json | jq -r .vpc.value.tags.Name)"
nat_eips="$(cat terraform-outputs.json | jq -r '.["nat-eips"].value["us-east-2a"].id')"
nat_gw="$(cat terraform-outputs.json | jq -r '.["nat-gw"].value["us-east-2a"].id')"
public_subnet="$(cat terraform-outputs.json | jq -r '.["public_subnets"].value["us-east-2a"].id')"
private_subnet="$(cat terraform-outputs.json | jq -r '.["privat_subnets"].value["us-east-2a"].id')"

@test "Validate outputs of Terraform 'vpc' module" {
  [ "$vpc_id" != "" ]
  [ "$vpc_name" = "concord-testing-vpc" ]
  [ "$nat_eips" != "" ]
  [ "$nat_gw" != "" ]
  [ "$public_subnet" != "" ]
  [ "$private_subnet" != "" ]
}
