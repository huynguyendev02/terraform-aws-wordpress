#!/bin/bash
sudo -u www-data sed -i 's/database_name_here/${db_name}/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/${username}/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/${password}/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/localhost/${endpoint}/' /srv/www/wordpress/wp-config.php
