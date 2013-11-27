#!/bin/bash
cp /var/www/html/jmeter/app/config/parameters.yml.dist /var/www/html/jmeter/app/config/parameters.yml
COMPOSER_HOME="/var/www/html/jmeter/" composer install
chmod -R 777 app/cache app/logs
php app/console cache:clear --env=prod --no-warmup
