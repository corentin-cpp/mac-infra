#!/bin/bash

# === CONFIGURATION ===
REGION="eu-west-3"
AVAIL_ZONE="eu-west-3a"
SUBNET_CIDR="10.0.0.224/28"
SUBNET_NAME="subnet-bastion"
VPC_ID="vpc-094848b66c682051e"  # Remplace par ton vrai VPC ID

# === CRÉATION DU SOUS-RÉSEAU ===
echo "Création du sous-réseau $SUBNET_NAME..."
SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_CIDR \
  --availability-zone $AVAIL_ZONE \
  --region $REGION \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$SUBNET_NAME}]" \
  --query 'Subnet.SubnetId' \
  --output text)

# === ACTIVER L’AFFECTATION AUTOMATIQUE D’IP PUBLIQUE ===
echo "Activation de l’attribution automatique d’IP publique sur $SUBNET_ID..."
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_ID \
  --map-public-ip-on-launch \
  --region $REGION

# === CONFIRMATION ===
echo "Sous-réseau créé avec succès : $SUBNET_ID"
echo "Attribuer automatiquement une IP publique : activé"