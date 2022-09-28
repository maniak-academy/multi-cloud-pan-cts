#!/bin/bash
local_ipv4="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"


#Utils
sudo apt-get install unzip
sudo apt-get install unzip
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get jq

sudo apt-get update -y
sudo apt-get install -y docker.io

snap install vault


#Download Consul
CONSUL_VERSION="1.12.2"
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

#Install Consul
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin/
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

sudo mkdir --parents /opt/consul

#Create Consul User
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir --parents /opt/consul
sudo chown --recursive consul:consul /opt/consul

#Create Systemd Config
sudo cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

#Create config dir
sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl


cat << EOF > /etc/consul.d/consul.hcl
data_dir = "/opt/consul"
datacenter = "AzureAcademyDC1"
bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"10.1.2.0/24\" | attr \"address\" }}"
retry_join = ["${consul_server_ip}"]
EOF


cat << EOF > /etc/consul.d/vaul.hcl
service {
  id      = "${owner}-vault"
  name    = "${owner}-vault"
  tags    = ["${owner}-vault"]
  port    = 8200
  check {
    id       = "${owner}-vault"
    name     = "TCP on port vault"
    tcp      = "localhost:8200"
    interval = "30s"
    timeout  = "10s"
  }
}
EOF


#Enable the service
sudo systemctl restart consul
sudo service consul start



curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
EOF

cat <<-EOF > /docker-compose.yml
version: '3'
services:
  vault:
    container_name: vault
    network_mode: host
    restart: always
    image: vault
    environment:
      - VAULT_DEV_ROOT_TOKEN_ID=root
EOF

/usr/local/bin/docker-compose up -d


