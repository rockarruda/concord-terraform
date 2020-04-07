source "$HOME/.concord/profile"
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

debug "Getting instanceId of ASG compute..."

while instanceId=$(aws autoscaling \
  describe-auto-scaling-groups \
  --auto-scaling-group-names concord-testing \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} | \
  jq -r .AutoScalingGroups[0].Instances[0].InstanceId); test "$instanceId" = "null"
  do
    debug "Waiting for ASG instance to become ready ..."
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
    debug "Waiting for ASG ${instanceId} to enter 'running' state, currently '${STATE}' ..."
    sleep 3
  done

debug "Instance is in ${STATE}"

publicIp=$(aws ec2 describe-instances \
  --instance-ids ${instanceId} \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} | \
  jq -r .Reservations[0].Instances[0].PublicIpAddress)

debug "publicIp = ${publicIp}"

for i in {1..30}
do
  debug "Attempt ${i} to connect to ASG compute ..."
  ssh -o "StrictHostKeyChecking no" \
      -o ConnectTimeout=1 -i ${pem} \
      -q ubuntu@${publicIp} exit && echo "OK" && break
      sleep 10
done
