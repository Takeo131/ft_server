# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: anprenat <anprenat@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/13 19:49:26 by anprenat          #+#    #+#              #
#    Updated: 2020/06/13 20:23:42 by anprenat         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get uptade && apt-get upgrade -y

RUN apt-get install -y nginx wget vim

RUN chown www-data:www-data /usr/share/nginx/html/ -R

RUN apt-get install -y mariadb-server mariadb-client 

mysql -u root

RUN apt-get install -y php php-fpm php-mysql php-common php-cli php-json php-opcache php-readline