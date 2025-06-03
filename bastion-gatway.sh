#!/bin/bash

# Paramètres de base à adapter
VPC_ID="vpc-094848b66c682051e"
ROUTE_TABLE_ID="rtb-008f705f7433580ff"

# Étape 1 : Créer une Internet Gateway
echo "Création de l'Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.InternetGatewayId' \
  --output text)

echo "IGW créée : $IGW_ID"

# Étape 2 : Attacher l'IGW au VPC
echo "Attachement de l'IGW au VPC $VPC_ID..."
aws ec2 attach-internet-gateway \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID"
echo "IGW attachée au VPC."

# Étape 3 : Ajouter une route vers Internet
echo "Ajout de la route 0.0.0.0/0 vers IGW dans la table $ROUTE_TABLE_ID..."
aws ec2 create-route \
  --route-table-id "$ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"
echo "Route ajoutée avec succès."

echo "Configuration terminée. Tu peux réessayer la connexion SSH."