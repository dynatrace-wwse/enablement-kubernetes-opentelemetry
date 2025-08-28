#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

# Load tests
source $REPO_PATH/.devcontainer/test/test_functions.sh

printInfoSection "Running integration Tests for the Enablement Framework"

assertRunningPod astronomy-shop astronomy-shop-accountingservice 

assertRunningPod astronomy-shop astronomy-shop-frontend 

assertRunningPod astronomy-shop astronomy-shop-frontendproxy 

assertRunningApp 30100