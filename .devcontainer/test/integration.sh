#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

printInfoSection "Running integration Tests for $RepositoryName"

assertRunningPod astronomy-shop astronomy-shop-accountingservice 

assertRunningPod astronomy-shop astronomy-shop-frontend 

assertRunningPod astronomy-shop astronomy-shop-frontendproxy 

assertRunningApp 30100
