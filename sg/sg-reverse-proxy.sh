VPC_ID="vpc-094848b66c682051e"           # Ton VPC principal
MY_IP="81.251.216.97/32"   

# SG-Reverse-Proxy
aws ec2 create-security-group \
  --group-name SG-Reverse-Proxy \
  --description "Reverse proxy for client access" \
  --vpc-id $VPC_ID

SG_PROXY_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=SG-Reverse-Proxy Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" --output text)

aws ec2 authorize-security-group-ingress --group-id $SG_PROXY_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_PROXY_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
