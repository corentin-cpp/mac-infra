#!/bin/bash

# Vérification des privilèges root
if [[ "$EUID" -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root."
  exit 1
fi

echo "Mise à jour des paquets..."
apt update && apt upgrade -y

echo "Installation de MySQL Server..."
apt install -y mysql-server

echo "Sécurisation de MySQL..."
mysql_secure_installation

echo "Installation de PHP, Apache et des extensions nécessaires..."
apt install -y apache2 php php-mysql libapache2-mod-php

echo "Installation de phpMyAdmin..."
apt install -y phpmyadmin

echo "Activation de phpMyAdmin dans Apache..."
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

echo "Redémarrage du service Apache..."
systemctl restart apache2

echo "Installation terminée."
echo "Accédez à phpMyAdmin : http://<votre-ip>/phpmyadmin"

# Autoriser SSH
ufw allow 22

# Autoriser HTTP
ufw allow 80

# Autoriser HTTPS (optionnel, si SSL)
ufw allow 443

# Autoriser MySQL à distance (optionnel, avec précaution)
ufw allow 3306

# Activer le pare-feu
ufw enable

# Vérifier les règles
ufw status