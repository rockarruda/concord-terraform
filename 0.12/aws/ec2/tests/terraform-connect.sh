source "$HOME/.concord/profile"
pem="$HOME/.concord/${AWS_PEM}"
public_ip="$(cat terraform-outputs.json | jq -r .ec2_instance.value.public_ip)"

# Wait up to 5 minutes
for i in {1..30}
do
  ssh -o "StrictHostKeyChecking no" \
      -o ConnectTimeout=10 -i ${pem} \
      -q ubuntu@${public_ip} exit && echo "OK" && break
  sleep 10
done
