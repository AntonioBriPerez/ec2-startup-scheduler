name: Stop EC2 Instances

on:
  schedule:
    - cron: '0 4 * * *'  # Stop EC2 instances at 04:00 AM

jobs:
  stop-ec2:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up AWS CLI
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_AK }}
        aws-secret-access-key: ${{ secrets.AWS_SK }}
        aws-region: your-aws-region # Replace with your AWS region, e.g., us-east-1

    - name: List EC2 Instances
      run: aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text

    - name: Stop EC2 Instances
      run: |
        INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)
        if [ -n "$INSTANCE_IDS" ]; then
          aws ec2 stop-instances --instance-ids $INSTANCE_IDS
        else
          echo "No running EC2 instances found."
        fi
