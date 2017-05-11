#!/bin/bash
# Example: ./deploy.sh us dev slalom1

geo=$1
target=$2
sub_stack=$3

echo "Creating the networking stack..."
echo
./tf_deploy -g $geo -t $target -s networking -a apply

echo
sleep 5

echo "Creating the data stack..."
echo
./tf_deploy -g $geo -t $target -s data -n $sub_stack -a apply

sleep 5

echo "Creating the web stack"
echo
./tf_deploy -g $geo -t $target -s web -n $sub_stack -a apply
