VPC_ID="vpc-094848b66c682051e"           # Ton VPC principal
MY_IP="81.251.216.97/32"   

# SG-Database
aws ec2 create-security-group \
  --group-name SG-Database \
  --description "Private access to MySQL/PostgreSQL" \
  --vpc-id $VPC_ID

SG_DB_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=SG-Database Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" --output text)

# Replace with actual IDs if known
# aws ec2 authorize-security-group-ingress --group-id $SG_DB_ID --protocol tcp --port 3306 --source-group $SG_WEB_ID
# aws ec2 authorize-security-group-ingress --group-id $SG_DB_ID --protocol tcp --port 3306 --source-group $SG_DEV_ID
