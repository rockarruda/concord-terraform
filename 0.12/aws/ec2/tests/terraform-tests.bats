@test "Validate SSH connectivity to provisioned EC2 compute" {
  run bash ./terraform-connect.sh
  # This returns 0 even when there is no connectivity to the host, so we made a
  # wrapper script that checks the error code and outputs OK or ERROR
  [ "${lines[0]}" = "OK" ]
}
