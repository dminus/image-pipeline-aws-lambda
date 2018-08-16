#!/usr/bin/env bash

usage() {
  echo "$0: usage: $0 <s3-bucket> <stack-name>"
  echo "- s3-bucket: package output location for CloudFormation template"
  echo "- stack-name: name for CloudFormation stack"
  echo "              All resources in stack will have stack-name as part of name."
}

test_aws() {
  aws sts get-caller-identity >/dev/null
  if [ $? -ne 0 ] ; then
    exit $?
  fi
}

do_npm_installs() {
  for pkg in $(find . -maxdepth 2 -mindepth 2 -type f -name 'package.json' -exec dirname {} \;); do
    pushd $pkg
    npm install
    popd
  done
}

if [ $# -ne 2 ]; then
  usage
  exit 127
fi

S3_BUCKET=$1
STACK_NAME=$2

test_aws
do_npm_installs

aws s3 mb s3://${S3_BUCKET}

aws cloudformation package --template-file ./sam-template.yml --s3-bucket ${S3_BUCKET} --output-template-file packaged-sam-template.yml

aws cloudformation deploy --template-file ./packaged-sam-template.yml --stack-name ${STACK_NAME}  --capabilities CAPABILITY_IAM
