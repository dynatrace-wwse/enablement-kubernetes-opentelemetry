#!/bin/bash
##############################################################
##  In here you add whatever action should happen after the container ha been created
##  such as exposing the application.
##############################################################
#Load the functions into the shell
source .devcontainer/util/source_framework.sh

setBaseDir

# attach to kind cluster
startKindCluster

printInfoSection "Your dev.container finished starting up"