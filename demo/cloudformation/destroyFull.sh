#!/bin/bash

# Shellscript to destroy all stacks consecutively

if [[ $# -ne 1 ]]; then
  echo "You need to supply an argument for target e.g. dev, stg, prod"
  exit 1
fi

target=$1

# Need uppercase first letter for stack name
upperTarget="$(tr '[:lower:]' '[:upper:]' <<< ${target:0:1})${target:1}"

# Build stack names
networkingStackName="${upperTarget}-networking"
dataStackName="${upperTarget}-data"
webStackName="${upperTarget}-web"

echo "Deleting web stack..."

# Delete web stack
aws cloudformation delete-stack --stack-name $webStackName

# Wait for Web stack deletion
aws cloudformation wait stack-delete-complete --stack-name $webStackName

echo
echo "Web stack deletion complete!!!"
echo

echo "Deleting data stack..."

# Delete web stack
aws cloudformation delete-stack --stack-name $dataStackName

# Wait for Web stack deletion
aws cloudformation wait stack-delete-complete --stack-name $dataStackName

echo
echo "Data stack deletion complete!!!"
echo

echo "Deleting networking stack..."

# Delete web stack
aws cloudformation delete-stack --stack-name $networkingStackName

# Wait for Web stack deletion
aws cloudformation wait stack-delete-complete --stack-name $networkingStackName

echo
echo "Networking stack deletion complete!!!"
echo
echo
echo "Full stack deletion complete, exiting!"
echo
