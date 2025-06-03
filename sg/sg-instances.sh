#!/bin/bash

# Variables à personnaliser
INSTANCE_ID_SRV_AD="i-06ecf00da2b2d80b5"
INSTANCE_ID_ADMIN_WEB="i-040f8cd27973e4703"
INSTANCE_ID_DEV_JOHN="i-xxxxxxxxxxxxxxxxx"
INSTANCE_ID_WEB_1="i-09929caef5ed7ed13"
INSTANCE_ID_CLIENT_ACCESS="i-02ffd275b7f195151"
INSTANCE_ID_BDD="i-08b45af8fbaf45558"

# Récupération des GroupId à partir des noms et du VPC
SG_ADMIN_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Admin --query "SecurityGroups[0].GroupId" --output text)
SG_IFACE_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Interface-Admin --query "SecurityGroups[0].GroupId" --output text)
SG_DEV_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Dev --query "SecurityGroups[0].GroupId" --output text)
SG_WEB_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Web-Public --query "SecurityGroups[0].GroupId" --output text)
SG_PROXY_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Reverse-Proxy --query "SecurityGroups[0].GroupId" --output text)
SG_DB_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=SG-Database --query "SecurityGroups[0].GroupId" --output text)

# Attribution des SG aux instances
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_SRV_AD --groups $SG_ADMIN_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_ADMIN_WEB --groups $SG_ADMIN_ID $SG_IFACE_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_DEV_JOHN --groups $SG_DEV_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_WEB_1 --groups $SG_WEB_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_CLIENT_ACCESS --groups $SG_PROXY_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_BDD --groups $SG_DB_ID
