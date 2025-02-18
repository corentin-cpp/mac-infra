# ------------------------------
# Mise a jour du systeme
# ------------------------------
echo " Mise a jour du systeme..."
sudo apt update && sudo apt upgrade -y

# ------------------------------
# Creation de l'utilisateur avec sudo
# ------------------------------
echo " Creation de l'utilisateur Dev..."
sudo adduser --disabled-password --gecos "" dev
echo "dev:dev2025!" | sudo chpasswd
sudo usermod -aG sudo dev
echo "dev ajoute avec les droits sudo."

# ------------------------------
# Configuration du pare-feu (UFW)
# ------------------------------
echo "Installation de vsftpd pour FTP..."
sudo apt install -y vsftpd
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

# Configuration de vsftpd
cat <<EOF | sudo tee /etc/vsftpd.conf
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
allow_writeable_chroot=YES
EOF

sudo systemctl restart vsftpd

# Ouverture du port FTP
sudo ufw allow 21
sudo ufw allow 40000:50000/tcp
sudo ufw reload

echo "Acces FTP configure et ports ouverts."

# ------------------------------
# Installation des paquets necessaires
# ------------------------------
echo " Installation de OpenVPN"
wget https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh -O openvpn-install.sh
sudo bash openvpn-install.sh

# ------------------------------
# Configuration du pare-feu (UFW)
# ------------------------------
echo " Configuration du pare-feu (UFW)..."
sudo ufw enable
sudo ufw allow 1194
sudo ufw reload

# ------------------------------
# Verification des services
# ------------------------------
echo "Vérification des services :"
echo "Open VPN : $(systemctl is-active apache2)"

echo "Installation terminee. SSH avec :"
echo "   ssh dev@$(hostname -I)"