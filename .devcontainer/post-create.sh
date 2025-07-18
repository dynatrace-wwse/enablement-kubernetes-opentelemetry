#!/bin/bash
#loading functions to script
export SECONDS=0
source /workspaces/$RepositoryName/.devcontainer/util/functions.sh
source /workspaces/$RepositoryName/.devcontainer/util/local.sh

bindFunctionsInShell

setupAliases

startKindCluster

installK9s

deployAstronomyShopOpenTelemetry

# If the Codespace was created via Workflow end2end test will be done, otherwise
# it'll verify if there are error in the logs and will show them in the greeting as well a monitoring 
# notification will be sent on the instantiation details
finalizePostCreation

printInfoSection "Your dev container finished creating"
