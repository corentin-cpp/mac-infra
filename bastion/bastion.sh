#!/bin/bash

# === CONFIGURATION ===
REGION="eu-west-3"
KEY_NAME="ssh-keys"
AMI_ID="ami-0644165ab979df02d"
INSTANCE_TYPE="t2.micro"
BASTION_NAME="srv-bastion"

# Demander les IDs existants
read -p "ID du VPC existant (ex: vpc-xxxxxxxx): " VPC_ID
read -p "ID du sous-réseau public (ex: subnet-xxxxxxxx): " SUBNET_PUB_ID

# === CRÉATION DU GROUPE DE SÉCURITÉ BASTION ===
echo "Création du SG pour le Bastion..."
SG_BASTION_ID=$(aws ec2 create-security-group \
  --group-name SG-Bastion \
  --description "Bastion SSH Access" \
  --vpc-id $VPC_ID \
  --region $REGION \
  --query 'GroupId' --output text)

# Ouvre le port SSH (22) depuis l'IP publique du PC
MY_IP=$(curl -s https://checkip.amazonaws.com)
aws ec2 authorize-security-group-ingress --group-id $SG_BASTION_ID \
  --protocol tcp --port 22 --cidr $MY_IP/32 --region $REGION

# === CRÉATION DE L’INSTANCE BASTION ===
echo "Lancement de l'instance EC2 Bastion..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_BASTION_ID \
  --subnet-id $SUBNET_PUB_ID \
  --associate-public-ip-address \
  --region $REGION \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$BASTION_NAME}]" \
  --query 'Instances[0].InstanceId' --output text)

# === ATTENTE ET AFFICHAGE DE L'IP PUBLIQUE ===
echo "Attente de l’allocation de l’IP publique..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "Bastion prêt ! IP publique : $PUBLIC_IP"