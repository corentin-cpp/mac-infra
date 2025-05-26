#!/bin/bash

# Test proxy
curl -I http://127.0.0.1

# Certificat Let's Encrypt (si domaine pointé)
# apt install -y certbot python3-certbot-nginx
# certbot --nginx -d projet-john.macinfra.fr

echo "[+] srv-client-access reverse proxy prêt"