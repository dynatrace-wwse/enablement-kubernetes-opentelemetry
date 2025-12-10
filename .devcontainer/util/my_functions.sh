#!/bin/bash
# ======================================================================
#          ------- Custom Functions -------                            #
#  Space for adding custom functions so each repo can customize as.    # 
#  needed.                                                             #
# ======================================================================


customFunction(){
  printInfoSection "This is a custom function that calculates 1 + 1"

  printInfo "1 + 1 = $(( 1 + 1 ))"

}

# deployAstronomyShopOpenTelemetry
# Deploys the OpenTelemetry community distribution of Astronomy Shop using Helm
deployAstronomyShopOpenTelemetry() {

  # deploy astronomy shop
  printInfoSection "Deploying OpenTelemetry community distribution of Astronomy Shop using Helm"
  # Check if the environment variable NAME is unset or empty
  if [ -z "${NAME}" ]; then
    export NAME="k8s-otel-o11y"
  fi

  # Generate new values file from default-values
  sed "s,NAME_TO_REPLACE,$NAME," $REPO_PATH/cluster-manifests/astronomy-shop/default-values.yaml > $REPO_PATH/.devcontainer/yaml/gen/default-values.yaml
  
  # add the opentelemetry charts to helm
  helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
  
  # create the astronomy-shop namespace
  kubectl create namespace astronomy-shop
  
  # use helm to deploy the opentelemetry demo app astronomy-shop
  helm install astronomy-shop open-telemetry/opentelemetry-demo --values $REPO_PATH/.devcontainer/yaml/gen/default-values.yaml --namespace astronomy-shop --version "0.31.0"
  
  # Wait for ready pods
  waitForAllReadyPods astronomy-shop

  printInfoSection "Exposing Astronomy Shop via NodePort 30100"

  printInfo "Change astroshop-frontendproxy service from LoadBalancer to NodePort"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop  --patch='{"spec": {"type": "NodePort"}}'

  printInfo "Define the NodePort to expose the app from the Cluster"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30100}]'

  waitAppCanHandleRequests 30100

  printInfo "Astroshop deployed succesfully"

}

exposeAstronomyShop() {

  printInfoSection "Exposing Astronomy Shop via NodePort 30100"

  printInfo "Change astroshop-frontendproxy service from LoadBalancer to NodePort"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop  --patch='{"spec": {"type": "NodePort"}}'

  printInfo "Define the NodePort to expose the app from the Cluster"
  kubectl patch service astronomy-shop-frontendproxy --namespace=astronomy-shop --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30100}]'

  waitAppCanHandleRequests 30100

  printInfo "AstronomyShop exposed succesfully"

}

deployOpenTelemetryOperator() {
  
  printInfoSection "Deploy OpenTelemetry Operator"

  ### OpenTelemetry Operator with Cert Manager

  # Deploy cert-manager, pre-requisite for opentelemetry-operator
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/cert-manager.yaml

  # Wait for ready pods
  waitForAllReadyPods cert-manager

  # Deploy opentelemetry-operator
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/opentelemetry-operator.yaml

  # Wait for ready pods
  waitForAllReadyPods opentelemetry-operator-system

  # Complete
  printInfoSection "OpenTelemetry Operator Deployment Complete!"
}

createDynatraceOTLPSecret() {

  printInfoSection "Create Dynatrace OTLP Secret"

  ### Preflight Check

  # Check if DT_ENDPOINT is set
  if [ -z "$DT_ENDPOINT" ]; then
    printError "Error: DT_ENDPOINT is not set."
    exit 1
  fi

  # Check if DT_API_TOKEN is set
  if [ -z "$DT_API_TOKEN" ]; then
    printError "Error: DT_API_TOKEN is not set."
    exit 1
  fi

  # Check if NAME is set
  if [ -z "$NAME" ]; then
    printError "Error: NAME is not set."
    exit 1
  fi

  export CAPSTONE_DIR=$REPO_PATH/lab-modules/opentelemetry-capstone

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

  printInfo "Created Dynatrace namespace and OTLP secret 'dynatrace-otelcol-dt-api-credentials'."
}

deployOpenTelemetryCapstone() {
  
  printInfoSection "Deploy OpenTelemetry Capstone"

  ### Preflight Check

  # Check if DT_ENDPOINT is set
  if [ -z "$DT_ENDPOINT" ]; then
    printError "Error: DT_ENDPOINT is not set."
    exit 1
  fi

  # Check if DT_API_TOKEN is set
  if [ -z "$DT_API_TOKEN" ]; then
    printError "Error: DT_API_TOKEN is not set."
    exit 1
  fi

  # Check if NAME is set
  if [ -z "$NAME" ]; then
    printError "Error: NAME is not set."
    exit 1
  fi

  export CAPSTONE_DIR=$REPO_PATH/lab-modules/opentelemetry-capstone

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

  # Deploy opentelemetry-operator
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/opentelemetry-operator.yaml

  # Wait for ready pods
  waitForAllReadyPods opentelemetry-operator-system

  ### OpenTelemetry Collectors

  # Create clusterrole with read access to Kubernetes objects
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/rbac/otel-collector-k8s-clusterrole.yaml

  # Create clusterrolebinding for OpenTelemetry Collector service accounts
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/rbac/otel-collector-k8s-clusterrole-crb.yaml

  # OpenTelemetry Collector - Dynatrace Distro (Deployment)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/dynatrace/otel-collector-dynatrace-deployment-crd.yaml

  # OpenTelemetry Collector - Dynatrace Distro (Daemonset)
  kubectl apply -f $CAPSTONE_DIR/opentelemetry/collector/dynatrace/otel-collector-dynatrace-daemonset-crd.yaml

  # Wait for ready pods
  waitForAllReadyPods dynatrace

  ### Astronomy Shop

  # Customize astronomy-shop helm values
  sed "s,NAME_TO_REPLACE,$NAME," $CAPSTONE_DIR/astronomy-shop/collector-values.yaml > $CAPSTONE_DIR/astronomy-shop/sed/collector-values.yaml

  # Update astronomy-shop OpenTelemetry Collector export endpoint via helm
  helm upgrade astronomy-shop open-telemetry/opentelemetry-demo --values $CAPSTONE_DIR/astronomy-shop/sed/collector-values.yaml --namespace astronomy-shop --version "0.31.0"

  # Wait for ready pods
  waitForAllReadyPods astronomy-shop

  # Expose Astronomy Shop
  exposeAstronomyShop

  # Complete
  printInfoSection "Capstone deployment complete!"
}

paymentServiceFailureEnable() {

  kubectl apply -f $REPO_PATH/cluster-manifests/astronomy-shop/flagd-enable-paymentservicefailure.yaml

}

paymentServiceFailureDisable() {

  kubectl apply -f $REPO_PATH/cluster-manifests/astronomy-shop/flagd-disable-paymentservicefailure.yaml
  
}
