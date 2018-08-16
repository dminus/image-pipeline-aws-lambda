#!/usr/bin/env bash

usage() {
  echo "$0: usage: $0 <s3-bucket> <stack-name>"
  echo "- s3-bucket: package output location for CloudFormation template"
  echo "- stack-name: name for CloudFormation stack"
  echo "              All resources in stack will have stack-name as part of name."
}

S3_BUCKET=$1
STACK_NAME=$2

aws s3 rb s3://${S3_BUCKET}

aws cloudformation delete-stack --stack-name ${STACK_NAME}