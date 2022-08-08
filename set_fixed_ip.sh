sudo su

cat << EOF > /etc/netplan/fixed_ip.yaml
network:
  ethernets:
    enp0s3:
      addresses: [192.168.1.145/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 8.8.8.8]
  version: 2
EOF
exit
sudo netplan generate
sudo netplan apply
