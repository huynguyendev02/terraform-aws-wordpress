#!/bin/bash

# Function to generate a random key salt
generate_salt() {
  openssl rand -base64 48 | tr -d '\n' | tr -d '\r'
}

# Your PHP file
php_file="/srv/www/wordpress/wp-config.php"

# Check if the file exists
if [ -e "$php_file" ]; then
  # Generate and replace salts in the PHP file using a different delimiter
  sudo sed -i "s|define( 'AUTH_KEY',.*|define( 'AUTH_KEY',         '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'SECURE_AUTH_KEY',.*|define( 'SECURE_AUTH_KEY',  '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'LOGGED_IN_KEY',.*|define( 'LOGGED_IN_KEY',    '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'NONCE_KEY',.*|define( 'NONCE_KEY',        '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'AUTH_SALT',.*|define( 'AUTH_SALT',        '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'SECURE_AUTH_SALT',.*|define( 'SECURE_AUTH_SALT', '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'LOGGED_IN_SALT',.*|define( 'LOGGED_IN_SALT',   '$(generate_salt)' );|" "$php_file"
  sudo sed -i "s|define( 'NONCE_SALT',.*|define( 'NONCE_SALT',       '$(generate_salt)' );|" "$php_file"

  echo "Key salts have been replaced in $php_file."
else
  echo "Error: $php_file not found."
fi

#Add hostname and IP

index_php="/srv/www/wordpress/index.php"
echo "\$hostname = gethostname();" | sudo tee -a "$index_php" >/dev/null
echo "\$ip_address = \$_SERVER['SERVER_ADDR'];" | sudo tee -a "$index_php" >/dev/null
echo 'echo "Hostname: $hostname<br>";' | sudo tee -a "$index_php" >/dev/null
echo 'echo "IP Address: $ip_address<br>";' | sudo tee -a "$index_php" >/dev/null

sudo sed -i '2i\$hostname = gethostname();' "$index_php"
sudo sed -i '3i\$ip_address = $_SERVER['\''SERVER_ADDR'\''];' "$index_php"
sudo sed -i '4iecho "Hostname: \$hostname<br>";' "$index_php"
sudo sed -i '5iecho "IP Address: \$ip_address<br>";' "$index_php"

