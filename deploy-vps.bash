# ------------------------------
# Mise a jour du systeme
# ------------------------------
echo " Mise a jour du systeme..."
sudo apt update && sudo apt upgrade -y

# ------------------------------
# Configuration
# ------------------------------

read -p "Nom de l'utilisateur a creer : " USERNAME

# Saisie securisee du mot de passe
while true; do
    read -sp "Mot de passe pour $USERNAME : " PASSWORD
    echo
    read -sp "Confirmer le mot de passe : " PASSWORD_CONFIRM
    echo
    if [ "$PASSWORD" == "$PASSWORD_CONFIRM" ]; then
        break
    else
        echo " Les mots de passe ne correspondent pas. Reessayez."
    fi
done

# ------------------------------
# Configuration de Git avec Token PAT
# ------------------------------
read -p "Nom Git : " GIT_NAME
read -p "Email Git : " GIT_EMAIL
read -sp "Token GitHub (PAT) : " GIT_PAT

sudo apt install -y git
sudo -u $USERNAME git config --global user.name "$GIT_NAME"
sudo -u $USERNAME git config --global user.email "$GIT_EMAIL"
sudo -u $USERNAME git config --global credential.helper store

# Creation du fichier de credentials securise
cat <<EOF > /home/$USERNAME/.git-credentials
https://$GIT_NAME:$GIT_PAT@github.com
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.git-credentials
chmod 600 /home/$USERNAME/.git-credentials

echo " Git configuré avec authentification PAT."

# Nom de domaine pour Certbot
read -p "Nom de domaine (pour Certbot) : " DOMAIN

# ------------------------------
# Creation de l'utilisateur avec sudo
# ------------------------------
echo " Creation de l'utilisateur $USERNAME..."
sudo adduser --disabled-password --gecos "" $USERNAME
echo "$USERNAME:$PASSWORD" | sudo chpasswd
sudo usermod -aG sudo $USERNAME
echo "$USERNAME ajoute avec les droits sudo."

# ------------------------------
# Installation des paquets necessaires
# ------------------------------
echo " Installation des outils de base..."
sudo apt install -y curl gnupg2 software-properties-common ufw zip unzip

# ------------------------------
# Installation de Node.js (via Nodesource)
# ------------------------------
echo " Installation de Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v

# ------------------------------
# Installation de PM2 (Gestion des processus)
# ------------------------------
echo " Installation de PM2..."
sudo npm install -g pm2
pm2 --version
sudo pm2 startup systemd
sudo pm2 save

# ------------------------------
# Installation de Git et Configuration
# ------------------------------
echo " Installation de Git..."
sudo apt install -y git
git --version

echo " Configuration de Git..."
sudo -u $USERNAME git config --global user.name "$GIT_NAME"
sudo -u $USERNAME git config --global user.email "$GIT_EMAIL"
sudo -u $USERNAME git config --global alias.st "status"
sudo -u $USERNAME git config --global alias.co "checkout"
sudo -u $USERNAME git config --global alias.br "branch"
sudo -u $USERNAME git config --global alias.ci "commit"
sudo -u $USERNAME git config --global core.editor "nano"
echo " Git configure avec succes."

# ------------------------------
# Installation de Angular CLI
# ------------------------------

echo " Installation de Angular CLI..."
sudo npm install -g @angular/cli
ng version

# ------------------------------
# Installation d'Apache
# ------------------------------

echo " Installation d'Apache..."
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2
echo " Apache installe et demarre."

# ------------------------------
# Installation et Configuration de vsftpd (FTP)
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
# Configuration du pare-feu (UFW)
# ------------------------------
echo " Configuration du pare-feu (UFW)..."
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw enable
sudo ufw allow 3000
sudo ufw reload

# ------------------------------
# Installation de Certbot (HTTPS via Let's Encrypt)
# ------------------------------
echo " Installation de Certbot et activation HTTPS..."
sudo apt install -y certbot python3-certbot-apache

if [[ -n "$DOMAIN" ]]; then
    sudo certbot --apache -d "$DOMAIN"
    sudo systemctl restart apache2
    echo "Certificat SSL genere pour $DOMAIN."
else
    echo "Pas de domaine fourni. Certbot non configure."
fi

# ------------------------------
# Verification des services
# ------------------------------
echo "Vérification des services :"
echo "Apache : $(systemctl is-active apache2)"
echo "Node.js : $(node -v)"
echo "NPM : $(npm -v)"
echo "Angular CLI : $(ng version | grep 'Angular CLI')"
echo "Git : $(git --version)"
echo "PM2 : $(pm2 --version)"
echo "VSFTP : $(vsftp --version)"

echo "Installation terminee. Connecte-toi avec :"
echo "   ssh $USERNAME@<IP_VM>"
