#!/bin/bash

#load the functions into the shell
source /workspaces/$RepositoryName/.devcontainer/util/functions.sh
source /workspaces/$RepositoryName/.devcontainer/util/local.sh

export BASE_DIR="/workspaces/$RepositoryName"

#This is for professors
#exposeMkdocs

exposeAstronomyShop

printInfoSection "Your dev.container finished starting up"