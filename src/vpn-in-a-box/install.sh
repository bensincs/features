#!/bin/sh
set -e

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

DNS_SERVER_IP=${DNS_SERVER_IP:-"abc"}

# Install some tools
apt-get update
apt-get -y install --no-install-recommends apt-utils apt-transport-https nano zip unzip curl icu-devtools make openvpn dnsutils figlet bsdmainutils jq iputils-ping socat

# Copy over bash scripts
INSTALL_PATH='/usr/local/vpn-in-a-box'
mkdir -p $INSTALL_PATH
# Install some bash scripts that can just be ran
cp -a ./_/. $INSTALL_PATH
chmod -R +x $INSTALL_PATH

# Write environments file
ENV_PATH="$INSTALL_PATH/environments"
mkdir -p $ENV_PATH
cat > $ENV_PATH/local.env \
<< EOF
export DNS_SERVER_IP="${DNS_SERVER_IP}"
EOF
