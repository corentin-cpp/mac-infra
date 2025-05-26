#!/bin/bash

# Création d’un user de test
mysql -e "CREATE DATABASE macinfra_test;"
mysql -e "CREATE USER 'dev'@'%' IDENTIFIED BY 'StrongPass123!';"
mysql -e "GRANT ALL PRIVILEGES ON macinfra_test.* TO 'dev'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Autoriser accès externe si nécessaire
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

echo "[+] srv-bdd post-config terminée"