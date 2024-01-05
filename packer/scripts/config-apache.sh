apache_conf="/etc/apache2/apache2.conf"

# Add lines to the end of the file
echo -e "\n<IfModule mod_setenvif.c>" | sudo tee -a "$apache_conf" >/dev/null
echo "  SetEnvIf X-Forwarded-Proto \"^https$\" HTTPS" | sudo tee -a "$apache_conf" >/dev/null
echo "</IfModule>" | sudo tee -a "$apache_conf" >/dev/null


echo "Add HTTPS Header to $apache_conf."

sudo systemctl restart apache2
