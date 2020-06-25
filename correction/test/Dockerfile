# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: anprenat <anprenat@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/13 19:49:26 by anprenat          #+#    #+#              #
#    Updated: 2020/06/15 10:41:11 by anprenat         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

#install package
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y nginx \
	&& apt-get install -y php php-fpm php-gd php-mysql php-cli php-curl php-json php-cgi php-mbstring \
	&& apt-get install -y curl mariadb-server wget vim

#copy all files
COPY ./start.sh ./
COPY ./nginx.conf ./

#nginx
RUN rm -rf /etc/nginx/sites-enabled/* \
	&& mv nginx.conf /etc/nginx/sites-available/ \
	&& ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

#create ssl
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 && \
	mv mkcert-v1.4.1-linux-amd64 mkcert && \
	chmod +x mkcert && \
	cp mkcert /usr/local/bin/ && \
	mkcert -install && \
	mkcert -key-file key.pem -cert-file cert.pem 127.0.0.1 localhost ::1 && \
	mv key.pem /etc/ssl/private/key.pem && \
	mv cert.pem /etc/ssl/certs/cert.pem

#start and setup MySQL
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE wordpress;" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO \"uwordpress\"@\"localhost\" IDENTIFIED BY \"password\";" && \
    mysql -u root -e "FLUSH PRIVILEGES;" && \
	mysql -u root -e "USE wordpress; SOURCE wordpress.sql;"

#get and setup phpmyadmin
RUN wget -q https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
	tar xzf phpMyAdmin-5.0.2-all-languages.tar.gz -C /var/www/html/ && \
	mv /var/www/html/phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin && \
	sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$(openssl rand -base64 32)'|" /var/www/html/phpmyadmin/config.sample.inc.php > /var/www/html/phpmyadmin/config.inc.php

#get and setup wp
RUN wget https://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xvf latest-fr_FR.tar.gz
RUN cp -r wordpress /var/www/html && \
	cp -r wp-config.php /var/www/html/wordpress

#set acces
RUN chown -R www-data:www-data /var/www//html/* && \
	chmod -R 755 /var/www/html/*

CMD bash start.sh
