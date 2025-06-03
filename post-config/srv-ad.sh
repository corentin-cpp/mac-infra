#!/bin/bash

set -e

echo "[1/6] Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "[2/6] Installation de Samba et des dépendances..."
sudo apt install -y samba samba-common samba-dsdb-modules samba-vfs-modules krb5-config krb5-user winbind libpam-winbind libnss-winbind dnsutils

echo "[3/6] Configuration de l'heure et du hostname..."
sudo timedatectl set-timezone Europe/Paris
sudo hostnamectl set-hostname dc1.macinfra.local

echo "[4/6] Provisionnement du domaine..."
sudo samba-tool domain provision \
  --use-rfc2307 \
  --realm=MACINFRA.LOCAL \
  --domain=MACINFRA \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL \
  --adminpass='P@ssw0rdAdmin123' \
  --function-level=2016

echo "[5/6] Configuration DNS locale..."
sudo systemctl stop systemd-resolved
sudo unlink /etc/resolv.conf
echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf

echo "[6/6] Activation du service AD Samba..."
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc

echo "Active Directory installé et opérationnel."