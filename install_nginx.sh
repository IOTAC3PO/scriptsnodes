sudo apt update -y && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl enable nginx.service
mkdir cache
touch hornet

cat << EOF > hornet
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=5r/s;
proxy_cache_path  /root/cache  levels=1:2    keys_zone=STATIC:10m
inactive=24h  max_size=1g;
server {
    server_name hornet; 
    location / {
        proxy_pass         http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;

    }

    location /ws {
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $host;

      proxy_pass http://localhost:8081/ws;

      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
    }
}
EOF

sudo rm /etc/nginx/sites-enabled/default
sudo mv hornet /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/hornet /etc/nginx/sites-enabled/hornet

sudo nginx -t
sudo ufw allow 80/tcp
sudo ufw reload
