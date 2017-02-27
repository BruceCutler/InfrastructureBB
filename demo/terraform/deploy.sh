#!/bin/bash

geo=$1
target=$2
sub_stack=$3

./tf_deploy -g $geo -t $target -s data -n $sub_stack -a apply

sleep 5

./tf_deploy -g $geo -t $target -s application -n $sub_stack -a apply
