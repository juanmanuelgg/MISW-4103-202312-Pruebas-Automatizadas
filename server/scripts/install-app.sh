apt update
apt install -y nginx docker.io docker-compose
snap install certbot --classic
sudo snap install node --classic

# Esta parte resulto manual

# vim ~/.bashrc
# Pegar estas lineas
# export GHOST_VERSION='3.41.1'
# export GHOST_PORT='8080'
# export MYSQL_VERSION='5.7.40'
# docker-compose up -d --build

#vim /etc/nginx/sites-available/default
# incluir un : paxy_pass http://127.0.0.1:8080; en location /
# incluir un : 'appbajopruebas.com' -d 'www.appbajopruebas.com' en server_name

# finalmente
# certbot --nginx -d 'appbajopruebas.com' -d 'www.appbajopruebas.com'
