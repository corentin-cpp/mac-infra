VPC_ID="vpc-094848b66c682051e"           # Ton VPC principal
MY_IP="81.251.216.97/32"   

# SG-Web-Public
aws ec2 create-security-group \
  --group-name SG-Web-Public \
  --description "Public web access for apps" \
  --vpc-id $VPC_ID

SG_WEB_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=SG-Web-Public Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" --output text)

aws ec2 authorize-security-group-ingress --group-id $SG_WEB_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_WEB_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
