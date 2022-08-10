# scriptsnodes

> Para realizar la instalacion de un nodo Hornet.

curl -fsSL https://raw.githubusercontent.com/IOTAC3PO/scriptsnodes/main/install_hornet_ppa.sh -o install.sh && sh install.sh 0000

- Donde 0000 es el parametro de la password que queremos tener en nuestro nodo.


> Para realizar la instalacion de NGINX y redireccionar de 80 a 8081

curl -fsSL https://raw.githubusercontent.com/IOTAC3PO/scriptsnodes/main/install_nginx.sh -o install_nginx.sh && sh install_nginx.sh


> Para realizar la instalacion de HORNET_SHIMMER 

curl -fsSL https://raw.githubusercontent.com/IOTAC3PO/scriptsnodes/main/install_hornet_shimmer.sh -o install_shimmer.sh && sh install_shimmer.sh 0000 micorreo@gmail.com admin

- Donde 0000 es el parametro de la password que queremos tener en nuestro nodo.
- Donde micorreo@gmail.com es el correo para registrar el certificado ssl en certbot
- Donde admin es el usuario para el nodo y grafana
