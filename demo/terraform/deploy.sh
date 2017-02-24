#!/bin/bash

geo=$1
target=$2

./tf_deploy -g $geo -t $target -s networking -a apply

sleep 10

./tf_deploy -g $geo -t $target -s data -a apply

sleep 10

./tf_deploy -g $geo -t $target -s application -a apply
