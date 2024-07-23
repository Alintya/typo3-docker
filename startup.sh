#!/bin/bash
# Enable AllowOverride All for /var/www/html
#sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

if [[ -d /var/www/html/config && -n "$(ls -A /var/www/html/config)" ]]; then 
  echo "Config folder exists and is not empty, skipping FIRST_INSTALL"
else
  echo "Fresh install, placing FIRST_INSTALL"; touch /var/www/html/public/FIRST_INSTALL
fi

# Start Apache
apachectl -D FOREGROUND