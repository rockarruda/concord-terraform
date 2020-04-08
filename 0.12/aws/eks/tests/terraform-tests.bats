vpc_id="$(cat terraform-outputs.json | jq -r .vpc_id.value)"
vpc_name="$(cat terraform-outputs.json | jq -r .vpc.value.tags.Name)"
nat_eips="$(cat terraform-outputs.json | jq -r '.["nat-eips"].value["us-east-2a"].id')"
nat_gw="$(cat terraform-outputs.json | jq -r '.["nat-gw"].value["us-east-2a"].id')"
public_subnet="$(cat terraform-outputs.json | jq -r '.["public_subnets"].value["us-east-2a"].id')"
private_subnet="$(cat terraform-outputs.json | jq -r '.["privat_subnets"].value["us-east-2a"].id')"

eks_service_role_arn="$(cat terraform-outputs.json | jq -r '.["eks-service-role"].value.arn')"
eks_service_role_id="$(cat terraform-outputs.json | jq -r '.["eks-service-role"].value.id')"
eks_worker_node_instance_profile_arn="$(cat terraform-outputs.json | jq -r '.["eks-worker-node-instance-profile"].value.arn')"
eks_worker_node_instance_profile_id="$(cat terraform-outputs.json | jq -r '.["eks-worker-node-instance-profile"].value.id')"
eks_worker_node_role_arn="$(cat terraform-outputs.json | jq -r '.["eks-worker-node-role"].value.arn')"
eks_worker_node_role_id="$(cat terraform-outputs.json | jq -r '.["eks-worker-node-role"].value.id')"
iam_role_arn="$(cat terraform-outputs.json | jq -r '.["iam-role"].value.arn')"
iam_role_id="$(cat terraform-outputs.json | jq -r '.["iam-role"].value.id')"
instance_profile_arn="$(cat terraform-outputs.json | jq -r '.["instance-profile"].value.arn')"
instance_profile_id="$(cat terraform-outputs.json | jq -r '.["instance-profile"].value.id')"

@test "Validate outputs of Terraform 'eks-roles-policies' module" {
  [ "$vpc_id" != "" ]
  [ "$vpc_name" = "concord-testing" ]
  [ "$nat_eips" != "" ]
  [ "$nat_gw" != "" ]
  [ "$public_subnet" != "" ]
  [ "$private_subnet" != "" ]
  [ "$eks_service_role_arn" != "" ]
  [ "$eks_service_role_id" = "concord-testing-eks-service-node-role" ]
  [ "$eks_worker_node_instance_profile_arn" != "" ]
  [ "$eks_worker_node_instance_profile_id" = "concord-testing-eks-worker-node-profile" ]
  [ "$eks_worker_node_role_arn" != "" ]
  [ "$eks_worker_node_role_id" = "concord-testing-eks-worker-node-role" ]
  [ "$iam_role_arn" != "" ]
  [ "$iam_role_id" = "concord-testing" ]
  [ "$instance_profile_arn" != "" ]
  [ "$instance_profile_id" = "concord-testing" ]
}
