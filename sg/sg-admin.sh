VPC_ID="vpc-094848b66c682051e"           # Ton VPC principal
MY_IP="81.251.216.97/32"              # Ton IP publique pour accès SSH/RDP

aws ec2 create-security-group \
  --group-name SG-Admin \
  --description "Security group for AD and Admin tools" \
  --vpc-id $VPC_ID

SG_ADMIN_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=SG-Admin Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol tcp --port 3389 --cidr $MY_IP
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol tcp --port 389 --source-group $SG_ADMIN_ID
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol tcp --port 53 --source-group $SG_ADMIN_ID
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol udp --port 53 --source-group $SG_ADMIN_ID
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol tcp --port 88 --source-group $SG_ADMIN_ID
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol udp --port 88 --source-group $SG_ADMIN_ID
aws ec2 authorize-security-group-ingress --group-id $SG_ADMIN_ID --protocol tcp --port 1024-65535 --source-group $SG_ADMIN_ID