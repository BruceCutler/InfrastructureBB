#!/bin/bash

# Shellscript to deploy all stacks consecutively

if [[ $# -ne 2 ]]; then
  echo "You need to supply arguments for target and stack"
  exit 1
fi

target=$1
stack=$2

# Need uppercase first letter for stack name
upperTarget="$(tr '[:lower:]' '[:upper:]' <<< ${target:0:1})${target:1}"
networkingStackName="${upperTarget}-networking"

aws cloudformation create-stack \
 --stack-name $networkingStackName \
 --template-body file://networking.json \
 --parameters file://parameters/$target/$target-networking.json
