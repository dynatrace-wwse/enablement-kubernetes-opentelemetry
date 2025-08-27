#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

# Load tests
source $REPO_PATH/.devcontainer/test/test_functions.sh

printInfoSection "Running integration Tests for the Enablement Framework"

assertRunningPod dynatrace operator

assertRunningPod dynatrace activegate

assertRunningPod dynatrace oneagent

assertRunningPod todoapp todoapp

assertRunningApp 30100
