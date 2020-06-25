#!/bin/bash

service mysql start

if [[ ! -z "${AUTO_INDEX}" ]] && [[ "${AUTO_INDEX}" = "OFF" ]]; then
    sed -i "s/autoindex on;/autoindex off;/g" /etc/nginx/sites-available/nginx.conf
fi

service nginx start
service php7.3-fpm start

echo "Sleeping..."
trap 'exit 143' SIGTERM # exit = 128 + 15 (SIGTERM)
tail -f /dev/null & wait ${!}
