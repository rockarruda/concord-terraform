source "$HOME/.concord/profile"
source "${PWD}/variables.bash"
source "${PWD}/terraform.bash"
pem="$HOME/.concord/${AWS_PEM}"
sshRetries=10

function debug() {
  message=$1
  if [ "${debug}" = "true" ]; then
    if [ ! -z "${bats}" ]; then
      echo "# ${message}" >&3
    else
      echo "${message}"
    fi
  fi
}

[ "$1" = "debug" ] && debug=true
[ "$2" = "bats" ] && bats=true

debug "Getting instanceId of EC2 fleet compute..."

fleetId=$(terraformOutputValue .ec2_fleet.value.id)

while instanceId=$(aws ec2 \
  describe-fleet-instances \
  --fleet-id ${fleetId} \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} | \
  jq -r .ActiveInstances[0].InstanceId | \
  tr -d "\r\n\t"); test "$instanceId" = "null"
  do
    debug "Waiting for EC2 fleet instance to become ready ..."
    sleep 3
  done

debug "instanceId = ${instanceId}"

while STATE=$(aws ec2 \
  describe-instances \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --instance-ids ${instanceId} \
  --output text --query 'Reservations[*].Instances[*].State.Name'); test "$STATE" != "running"
  do
    debug "Waiting for EC2 fleet ${instanceId} to enter 'running' state, currently '${STATE}' ..."
    sleep 3
  done

debug "Instance is in the ${STATE} state"

publicIp=$(aws ec2 describe-instances \
  --instance-ids ${instanceId} \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} | \
  jq -r .Reservations[0].Instances[0].PublicIpAddress | \
  tr -d "\n\r\t")

sshCommand="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 -i ${pem} -q ubuntu@${publicIp} exit"

debug "Instance PublicIp = ${publicIp}"
debug "Instance Pem = ${pem}"
debug "Instance SSH = ${sshCommand}"

for i in {1..30}
do
  debug "Attempt ${i} to connect to EC2 fleet compute ..."
  ${sshCommand} && echo "OK" && break
  sleep 10
done
