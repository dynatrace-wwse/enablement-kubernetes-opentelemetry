#!/bin/bash
# This file contains local functions specific to this lab

# ======================================================================
#          ------- Util Functions -------                              #
#  A set of util functions for logging, validating and                 #
#  executing commands.                                                 #
# ======================================================================

# VARIABLES DECLARATION
source /workspaces/$RepositoryName/.devcontainer/util/variables.sh

# FUNCTIONS DECLARATIONS

# deployAstronomyShopOpenTelemetry
# Deploys the OpenTelemetry community distribution of Astronomy Shop using Helm
deployAstronomyShopOpenTelemetry() {

  # deploy astronomy shop
  
  # Check if the environment variable NAME is unset or empty
  if [ -z "${NAME}" ]; then
    export NAME="k8s-otel-o11y"
  fi

  # Generate new values file from default-values
  sed "s,NAME_TO_REPLACE,$NAME," $CODESPACE_VSCODE_FOLDER/cluster-manifests/astronomy-shop/default-values.yaml > $CODESPACE_VSCODE_FOLDER/.devcontainer/yaml/gen/default-values.yaml
  
  # add the opentelemetry charts to helm
  helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
  
  # create the astronomy-shop namespace
  kubectl create namespace astronomy-shop
  
  # use helm to deploy the opentelemetry demo app astronomy-shop
  helm install astronomy-shop open-telemetry/opentelemetry-demo --values $CODESPACE_VSCODE_FOLDER/.devcontainer/yaml/gen/default-values.yaml --namespace astronomy-shop --version "0.31.0"
  
  # Wait for ready pods
  waitForAllReadyPods astronomy-shop

}

# exposeAstronomyShop
# expose the frontend for Astronomy Shop using dev container nodeport
exposeAstronomyShop() {

  printInfoSection "Exposing Astronomy Shop via NodePort 30100"

  printInfo "Change astroshop-frontendproxy service from LoadBalancer to NodePort"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop  --patch='{"spec": {"type": "NodePort"}}'

  printInfo "Define the NodePort to expose the app from the Cluster"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30100}]'

}

deployOpenTelemetryCapstone() {
  
  printInfoSection "Deploy OpenTelemetry Capstone"

  ### Preflight Check

  # Check if DT_ENDPOINT is set
  if [ -z "$DT_ENDPOINT" ]; then
    printInfo "Error: DT_ENDPOINT is not set."
    exit 1
  fi

  # Check if DT_API_TOKEN is set
  if [ -z "$DT_API_TOKEN" ]; then
    printInfo "Error: DT_API_TOKEN is not set."
    exit 1
  fi

  # Check if NAME is set
  if [ -z "$NAME" ]; then
    printInfo "Error: NAME is not set."
    exit 1
  fi

  export CAPSTONE_DIR=$CODESPACE_VSCODE_FOLDER/lab-modules/opentelemetry-capstone

  printInfo "All required variables are set."

  ### Dynatrace Namespace and Secret

  # Run the kubectl delete namespace command and capture the output
  output=$(kubectl delete namespace dynatrace 2>&1)

  # Check if the output contains "not found"
  if echo "$output" | grep -q "not found"; then
    echo "Namespace 'dynatrace' was not found."
  else
    echo "Namespace 'dynatrace' was found and deleted."
  fi

  # Create the dynatrace namespace
  kubectl create namespace dynatrace

  # Create dynatrace-otelcol-dt-api-credentials secret
  kubectl create secret generic dynatrace-otelcol-dt-api-credentials --from-literal=DT_ENDPOINT=$DT_ENDPOINT --from-literal=DT_API_TOKEN=$DT_API_TOKEN -n dynatrace

  ### OpenTelemetry Operator with Cert Manager

  # Deploy cert-manager, pre-requisite for opentelemetry-operator
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/cert-manager.yaml

  # Wait for ready pods
  waitForAllReadyPods cert-manager

  # Substitute for waitForAllReadyPods
  # Run the kubectl wait command and capture the exit status
  #kubectl -n cert-manager wait pod --selector=app.kubernetes.io/instance=cert-manager --for=condition=ready --timeout=300s
  #status=$?

  # Check the exit status
  #if [ $status -ne 0 ]; then
  #  echo "Error: Pods did not become ready within the timeout period."
  #  exit 1
  #else
  #  echo "Pods are ready."
  #fi

  # Deploy opentelemetry-operator
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/opentelemetry-operator.yaml

  # Wait for ready pods
  waitForAllReadyPods opentelemetry-operator-system

  # Substitute for waitForAllReadyPods
  # Run the kubectl wait command and capture the exit status
  #kubectl -n opentelemetry-operator-system wait pod --selector=app.kubernetes.io/name=opentelemetry-operator --for=condition=ready --timeout=300s
  #status=$?

  # Check the exit status
  #if [ $status -ne 0 ]; then
  #  echo "Error: Pods did not become ready within the timeout period."
  #  exit 1
  #else
  #  echo "Pods are ready."
  #fi

  ### OpenTelemetry Collectors

  # Create clusterrole with read access to Kubernetes objects
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/rbac/otel-collector-k8s-clusterrole.yaml

  # Create clusterrolebinding for OpenTelemetry Collector service accounts
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/rbac/otel-collector-k8s-clusterrole-crb.yaml

  # OpenTelemetry Collector - Dynatrace Distro (Deployment)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/dynatrace/otel-collector-dynatrace-deployment-crd.yaml

  # OpenTelemetry Collector - Dynatrace Distro (Daemonset)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/dynatrace/otel-collector-dynatrace-daemonset-crd.yaml

  # OpenTelemetry Collector - Contrib Distro (Deployment)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/contrib/otel-collector-contrib-deployment-crd.yaml

  # OpenTelemetry Collector - Contrib Distro (Daemonset)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/contrib/otel-collector-contrib-daemonset-crd.yaml

  # Wait for ready pods
  waitForAllReadyPods dynatrace

  # Run the kubectl wait command and capture the exit status
  #kubectl -n dynatrace wait pod --selector=app.kubernetes.io/component=opentelemetry-collector --for=condition=ready --timeout=300s
  #status=$?

  # Check the exit status
  #if [ $status -ne 0 ]; then
  #  echo "Error: Pods did not become ready within the timeout period."
  #  exit 1
  #else
  #  echo "Pods are ready."
  #fi

  ### Astronomy Shop

  # Customize astronomy-shop helm values
  sed -i "s,NAME_TO_REPLACE,$NAME," $CAPSTONE_DIR/astronomy-shop/collector-values.yaml

  # Update astronomy-shop OpenTelemetry Collector export endpoint via helm
  helm upgrade astronomy-shop open-telemetry/opentelemetry-demo --values $CAPSTONE_DIR/astronomy-shop/collector-values.yaml --namespace astronomy-shop --version "0.31.0"

  # Wait for ready pods
  waitForAllReadyPods astronomy-shop

  # Substitute for waitForAllReadyPods
  # Run the kubectl wait command and capture the exit status
  #kubectl -n astronomy-shop wait pod --selector=app.kubernetes.io/instance=astronomy-shop --for=condition=ready --timeout=300s
  #status=$?

  # Check the exit status
  #if [ $status -ne 0 ]; then
  #  echo "Error: Pods did not become ready within the timeout period."
  #  exit 1
  #else
  #  echo "Pods are ready."
  #fi

  # Expose Astronomy Shop after redeployment
  exposeAstronomyShop

  # Complete
  printInfoSection "Capstone deployment complete!"
}

