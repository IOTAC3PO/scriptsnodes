sudo apt update -y && sudo apt upgrade -y && sudo apt install jq -y
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER
docker run hello-world
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
sudo mkdir -p /opt/shimmerbeta
cd /opt/shimmerbeta
wget -c https://github.com/iotaledger/hornet/releases/download/v2.0.0-beta.3/HORNET-2.0.0-beta.3-docker.tar.gz
tar -xzf HORNET-2.0.0-beta.3-docker.tar.gz
rm HORNET-2.0.0-beta.3-docker.tar.gz
apt install ufw -y
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 14626/udp
ufw allow 15600/tcp
yes | ufw enable
cd /opt/shimmerbeta
docker-compose pull
server_dig=$(dig -x $(hostname -I | awk '{print $1}') | awk 'NR==14 {print $5}' | sed 's/.$//')
echo $server_dig
cd /opt/shimmerbeta
pass=$(docker-compose run --rm hornet tool pwd-hash --json --password $1 | sed -e 's/\r//g')
passwordHash=$(echo $pass | jq -r ".passwordHash")
passwordSalt=$(echo $pass | jq -r ".passwordSalt")
rm .env
touch .env
echo "HORNET_HOST=$server_dig" >> .env
echo "ACME_EMAIL=$2" >> .env
echo "DASHBOARD_USERNAME=$3" >> .env
echo "DASHBOARD_PASSWORD=$passwordHash" >> .env
echo "DASHBOARD_SALT=$passwordSalt" >> .env
./prepare_docker.sh
docker-compose up -d
