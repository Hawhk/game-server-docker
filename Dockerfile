FROM ubuntu
LABEL maintainer="Hawhk"

ARG DOMAIN

RUN apt-get update
RUN apt-get upgrade -y
#install ngnix
RUN apt-get install -y nginx
RUN ufw allow 'Nginx HTTPS'
RUN mkdir -p /var/www/$DOMAIN/html
RUN touch /var/www/$DOMAIN/html/index.html
RUN echo '<h1>Hello World</h1>' > /var/www/$DOMAIN/html/index.html
RUN touch /etc/nginx/sites-available/$DOMAIN
RUN printf 'server { \n\
    listen 80; \n\
    listen [::]:80; \n\
    \n\
    root /var/www/$DOMAIN/html; \n\
    index index.html index.htm index.nginx-debian.html; \n\
    \n\
    server_name $DOMAIN; \n\
    \n\
    location / { \n\
        try_files $uri $uri/ =404; \n\
    } \n\
}' > /etc/nginx/sites-available/$DOMAIN
RUN ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN
RUN sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g' /etc/nginx/nginx.conf
RUN systemctl restart nginx
#install Nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN source ~/.bashrc
RUN nvm install node
RUN npm install -g pm2
#clone game-server
RUN git clone https://github.com/hawhk/game-server
RUN cd game-server
RUN cp config.json.example config.json



