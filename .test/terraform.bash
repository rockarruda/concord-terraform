# These functions operate on the terraform-outputs.json that is generated
# by the test harness. We use 'jq' queries to retrieve values from the
# terraform-outputs.json

function terraformOutputValue() {
  cat terraform-outputs.json | jq -r "${1}"
}

function assertTerraformOutputEquals() {
  # $1: expected value
  # $2: jq query to extract value from terraform-outputs.json
  value=$(cat terraform-outputs.json | jq -r "${2}")
  [ "${value}" = "${1}" ]
}

function assertTerraformOutputNotEmpty() {
  # $1: jq query to extract value from terraform-outputs.json
  value=$(cat terraform-outputs.json | jq -r "${1}")
  [ ! -z "${value}" ]
}
