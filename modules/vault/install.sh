#!/bin/bash
set -e

# Update and install dependencies
sudo apt update -y
sudo apt install -y unzip jq

# Install Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vault

# Create Vault configuration file
cat <<EOT | sudo tee /etc/vault.hcl
storage "s3" {
  bucket = "custom-vault-data-bucket"
  region = "us-west-2"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui = true
EOT

# Set Vault environment variables
echo 'export VAULT_ADDR="http://127.0.0.1:8200"' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:/usr/local/bin' | sudo tee -a /etc/profile
source /etc/profile

# Create systemd service for Vault
sudo tee /etc/systemd/system/vault.service <<EOT
[Unit]
Description=Vault Server
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/bin/vault server -config=/etc/vault.hcl
ExecReload=/bin/kill --signal HUP \$MAINPID
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and start Vault
sudo systemctl daemon-reload
sudo systemctl enable vault
sudo systemctl start vault
