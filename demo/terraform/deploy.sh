#!/bin/bash

geo=$1
target=$2

./tf_deploy -g $geo -t $target -s networking -a plan