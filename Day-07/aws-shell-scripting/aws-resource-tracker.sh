#!/bin/bash

##################################
# Author: Preetham Pereira
# Date: 16/08/2026
#
# Version: v1
#
# This script will report the AWS resource usage
##################################

# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM Users

set -x


# List S3 Buckets
echo "Print list of s3 buckets"
aws s3 ls

# List EC2 Instances
echo "Print list of ec2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

# List Lamda Services
echo "Print list of lambda functions"
aws lambda list-functions

# List IAM Users
echo "Print list of IAM Users"
aws iam list-users
