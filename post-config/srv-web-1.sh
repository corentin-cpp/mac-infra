#!/bin/bash

# Déploiement d’un exemple HTML
echo "<h1>Welcome to srv-web-1 - MacInfra</h1>" > /var/www/html/index.html

# Activer des modules utiles
a2enmod rewrite
systemctl restart apache2

# Logs
journalctl -u apache2 > /var/log/apache2-startup.log

echo "[+] srv-web-1 post-config terminée"