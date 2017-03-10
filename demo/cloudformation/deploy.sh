#!/bin/bash

if [ $# ! -lt 2 ]; then
  echo "You need to supply arguments for target and stack"
  exit 1
fi

target=$1
stack=$2

aws cloudformation create-stack \
 --stack-name CloudFormationTest \
 --template-body file://$stack.json \
 --parameters file://parameters/$target/$target-$stack.json