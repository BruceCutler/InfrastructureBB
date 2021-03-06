#!/bin/bash
# Example: ./deploy.sh us dev

geo=$1
target=$2

echo "Creating the networking stack..."
echo
./tf_deploy -g $geo -t $target -s networking -a apply

echo
sleep 5

echo "Creating the data stack..."
echo
./tf_deploy -g $geo -t $target -s data -a apply

sleep 5

echo "Creating the web stack"
echo
./tf_deploy -g $geo -t $target -s web -a apply
