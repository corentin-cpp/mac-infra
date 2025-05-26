#!/bin/bash

# Clonage d’un projet de test
cd /home/john
sudo -u john git clone git@10.0.10.10:/home/git/repos/demo.git

# Création dossier de projet + permissions
mkdir /var/www/john-projet
chown john:www-data /var/www/john-projet

echo "[+] srv-dev-john post-config terminée"