#!/usr/bin/env bash

usage() {
  echo "$0: usage: $0 <s3-bucket> <stack-name>"
  echo "- s3-bucket: package output location for CloudFormation template"
  echo "- stack-name: name of CloudFormation stack"
}

S3_BUCKET=$1
STACK_NAME=$2

echo "Remove bucket ${S3_BUCKET} (with force option)?"
echo -n "Enter 'yes' to remove, anything else to retain: "
read answer
if [ "$answer" == "yes" ]; then
  echo "Removing bucket ${S3_BUCKET} with force option."
  aws s3 rb s3://${S3_BUCKET}/ --force
fi

echo -n "Deleting stack named ${STACK_NAME}... ";
aws cloudformation delete-stack --stack-name ${STACK_NAME} && echo "done"


