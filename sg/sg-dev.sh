VPC_ID="vpc-094848b66c682051e"           # Ton VPC principal
MY_IP="81.251.216.97/32"   

# SG-Dev
aws ec2 create-security-group \
  --group-name SG-Dev \
  --description "Dev instance group with SSH and HTTP" \
  --vpc-id $VPC_ID

SG_DEV_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=SG-Dev Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" --output text)

aws ec2 authorize-security-group-ingress --group-id $SG_DEV_ID --protocol tcp --port 22 --cidr $MY_IP
aws ec2 authorize-security-group-ingress --group-id $SG_DEV_ID --protocol tcp --port 80 --source-group $SG_DEV_ID
