  GNU nano 6.2                          ej.sh                                   
if [ "$1" != "" ]
then
	sudo apt update -y && sudo apt upgrade -y && sudo apt install jq -y
	wget -qO - https://ppa.hornet.zone/pubkey.txt | sudo apt-key add -
	sudo sh -c 'echo "deb http://ppa.hornet.zone stable main" >> /etc/apt/sources.list.d/hornet.list'
	sudo apt update -y && sudo apt install hornet
	sudo systemctl enable hornet.service
	sudo sed -i 's/localhost/0.0.0.0/g' /var/lib/hornet/config.json
	sudo sed -i 's/127.0.0.0/0.0.0.0/g' /var/lib/hornet/config.json
	sudo sed -i 's/"Spammer"/"Spammer","Autopeering"/g' /var/lib/hornet/config.json
	sudo apt install ufw -y
	sudo ufw allow 22
	sudo ufw allow 8081/tcp
	sudo ufw allow 15600/tcp
	sudo ufw allow 14626/udp
	yes | sudo ufw enable
	pass=$(hornet tools pwd-hash --password $1 --json)
	passwordHash=$(echo $pass | jq -r ".passwordHash")
	passwordSalt=$(echo $pass | jq -r ".passwordSalt")
	sudo sed -i "s/\"passwordHash\": \"0000000000000000000000000000000000000000000000000000000000000000\"/\"passwordHash\": \"${passwordHash}\"/g" /var/lib/hornet/config.json
	sudo sed -i "s/\"passwordSalt\": \"0000000000000000000000000000000000000000000000000000000000000000\"/\"passwordSalt\": \"${passwordSalt}\"/g" /var/lib/hornet/config.json
	sudo systemctl restart hornet
	sudo journalctl -xfu hornet
else
	echo "Falta parámetro.- PASSWORD"
	echo "Para realiar la instalacion debe indicar el password del nodo.- ej sh install_hornet_ppa.sh 0000"
fi
