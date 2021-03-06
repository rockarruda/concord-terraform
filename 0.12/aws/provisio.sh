#!/usr/bin/env bash

# Note: currently this is AWS specific. A way to pull tag metadata from other providers
# would be required to achieve the same support as with AWS

# TODO:
# - add support for installing packages from tag metadata
# - add support for installing pip|pip3 packages from tag metadata
# - align the method for build VMs as building docker containers
# - investigate if snaps can be used for all package installation across distros
# - standard way to generate a parameterized configuration

# ------------------------------------------------------------------------------
# A general way to provision a compute using this as the user_data for cloud-init
# ------------------------------------------------------------------------------
#
# Provisio Installer:
#
# To enable the Provisio tool installer the two following tags must be present:
#
# "tags": {
#   "provisio.bucketPath": "s3://starburstdata-artifacts/releases",
#   "provisio.installerProfile": "starburst-concord-agent",
# }
#
# To enable the Provisio application installer the two following tags must be present:
#
# "tags": {
#   "provisio.bucketPath": "s3://starburstdata-artifacts/releases",
#   "provisio.applicationCoordinate": "ca.vanzyl:starburst-concord-agent:tar.gz:1.0.0"
# }
#
# You can also all the Provisio features together, you just need ensure the
# correct tags are present on the compute.
# ------------------------------------------------------------------------------
# Provisio instance tag ids
# ------------------------------------------------------------------------------
provisioBucketPathTag="provisio.bucketPath"
provisioInstallerProfileTag="provisio.installerProfile"
provisioApplicationCoordinateTag="provisio.applicationCoordinate"
provisioSnapsTag="provisio.snaps"
provisioDebsTag="provisio.debs"
provisioRpmsTag="provisio.rpms"
# ------------------------------------------------------------------------------
# Notes:
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
# ------------------------------------------------------------------------------

# This function is taken from https://github.com/jvanzyl/maven-bash
function mavenCoordinateToArtifactPath() {
  # Standard format for a Maven coordinate:
  # <groupId>:<artifactId>[:<extension>[:classifier]]:<version>
  # $1 = coordinate
  IFS=':' read -ra coordinateParts <<< "$1"
  groupId=$(echo ${coordinateParts[0]} | sed 's/\./\//')
  artifactId=${coordinateParts[1]}
  if [ ${#coordinateParts[@]} -eq 3 ]; then
    # <groupId>:<artifactId>:<version>
    version=${coordinateParts[2]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}.jar"
  elif [ ${#coordinateParts[@]} -eq 4 ]; then
    # <groupId>:<artifactId>:<extension>:<version>
    version=${coordinateParts[3]}
    extension=${coordinateParts[2]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}.${extension}"
  elif [ ${#coordinateParts[@]} -eq 5 ]; then
    # <groupId>:<artifactId>:<extension>:<classifier>:<version>
    version=${coordinateParts[4]}
    extension=${coordinateParts[2]}
    classifier=${coordinateParts[3]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}-${classifier}.${extension}"
  fi
  echo $artifactPath
}

function awsTagValue() {
  region=$1
  instanceId=$2
  tag=$3

  aws ec2 describe-tags --region ${region} \
    --filters "Name=resource-id,Values=${instanceId}" "Name=key,Values=${tag}" \
    --query 'Tags[0].Value' --output=text
}

# Do everything to setup the machine as root
cd /root

# ------------------------------------------------------------------------------
# Ultimately we'll install as little as possible with distro specific package
# managers and use snap. If we can get Provisio installed binaries into the
# PATH while installing then we can further the need for package managers
# ------------------------------------------------------------------------------
linuxDistro=$(lsb_release -i | cut -f 2-)
linuxVersion=$(lsb_release -r | cut -f 2-)

if [ "${linuxDistro}" = "Ubuntu" ]; then
  add-apt-repository universe
  apt update
  apt install -y snapd unzip jq

  # Bootstrap: v2 of the AWS CLI for secrets managment
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
fi

# ------------------------------------------------------------------------------
# AWS instance metadata
# ------------------------------------------------------------------------------

# Determine the instanceId of our instance
instanceId=$(wget -qO- http://instance-data/latest/meta-data/instance-id)
echo "instanceId = ${instanceId}"

# Determine the region our instance resides in
region=$(wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed 's/.$//')
echo "region = ${region}"

provisioBucketPath=$(awsTagValue ${region} ${instanceId} ${provisioBucketPathTag})
echo "provisioBucketPath = ${provisioBucketPath}"

provisioInstallerProfile=$(awsTagValue ${region} ${instanceId} ${provisioInstallerProfileTag})
echo "provisioInstallerProfile = ${provisioInstallerProfile}"

provisioApplicationCoordinate=$(awsTagValue ${region} ${instanceId} ${provisioApplicationCoordinateTag})
echo "provisioApplicationCoordinate = ${provisioApplicationCoordinate}"

# ------------------------------------------------------------------------------
# Provisio Installer
# ------------------------------------------------------------------------------

if [ ! -z "${provisioInstallerProfile}" ]; then
  provisioInstallerVersion="1.0.0"
  provisioInstaller="provisio-installer-${provisioInstallerVersion}.tar.gz"
  provisioInstallerUrl="${provisioBucketPath}/ca/vanzyl/provisio/provisio-installer/${provisioInstallerVersion}/${provisioInstaller}"
  provisioHome="/usr/local/provisio"

  echo "Running Provisio tool installer with the following:"
  echo "provisioInstallerVersion = ${provisioInstallerVersion}"
  echo "provisioInstaller = ${provisioInstaller}"
  echo "provisioInstallerUrl = ${provisioInstallerUrl}"
  echo "provisioHome = ${provisioHome}"

  aws s3 cp ${provisioInstallerUrl} .
  tar xf ${provisioInstaller}
  ( cd provisio-installer; ./install ${provisioInstallerProfile} ${provisioHome} )
fi

# ------------------------------------------------------------------------------
# Provisio Application
# ------------------------------------------------------------------------------

if [ ! -z "${provisioApplicationCoordinate}" ]; then
  provisioTarGz="provisio.tar.gz"
  provisioDirectory=".provisio"
  provisioManifest="${PWD}/${provisioDirectory}/provisio.bash"
  provisioScript="${PWD}/${provisioDirectory}/provisio.sh"

  # Create the artifact path from the provisio coordinate
  artifactPath=$(mavenCoordinateToArtifactPath "${provisioApplicationCoordinate}")
  provisioApplicationUrl="${provisioBucketPath}/${artifactPath}"

  echo "Running Provisio application installer with the following:"
  echo "provisioApplicationUrl = ${provisioApplicationUrl}"

  # Fetch the specified provisio artifact
  aws s3 cp "${provisioApplicationUrl}" "${provisioTarGz}"

  # Extract the standard metadata from the provisio.tar.gz
  tar xf "${provisioTarGz}" "${provisioDirectory}"

  # Source the variables present in the provisio.bash file. The variables this manifest
  # can set are:
  #
  # - ${user}
  # - ${packages}
  source ${provisioManifest}

  echo "user = ${user}"
  echo "package = ${packages}"

  # Add specified user as per provisio manifest. This should work on the various
  # standard linux distributions
  useradd -m ${user} -s /bin/bash
  userHome=$( getent passwd "${user}" | cut -d: -f6 )

  # Install repositories that are specified as a variable in the provisio.bash file
  if [[ -v repositories ]]; then
    IFS=' ' read -r -a repos <<< ${repositories} 
    for repo in "${repos[@]}"
    do
      add-apt-repository -y ${repo}
    done
    apt-get update
  fi   

  # Install packages that are specified as a variable the provisio.bash file
  apt install -y ${packages}

  # Unpack the provisio archive in ${userHome}. Provisio server archives have
  # a top-level directory so you don't need to make a directory prior to unpacking.
  tar xzf ${provisioTarGz} -C ${userHome}

  # Set the ownership of everything in ${userHome} to ${user}
  chown -R ${user} ${userHome}

  # Execute the standard provisioning script
  [ -f "${provisioScript}" ] && bash ${provisioScript} ${user} ${userHome}
fi
