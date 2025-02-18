id: dt-k8s-otel-o11y-cluster
summary: astronomy-shop demo application on kubernetes setup
author: Tony Pope-Cruz

# OpenTelemetry Demo astronomy-shop on Kubernetes Setup
<!-- ------------------------ -->
## Overview 
Total Duration: 10

### What You’ll Learn Today
In this lab we'll create a Kubernetes cluster in Codespaces using Kind. We'll also deploy the OpenTelemetry Demo application, astronomy-shop.  This is a foundation/prerequisite for several other labs utilizing this infrastructure deployment.  This process is automated when starting a new Codespaces instance, no manual action required.

Lab tasks:
1. Create a Kubernetes cluster on Kind Kubernetes
2. Deploy OpenTelemetry's demo application, astronomy-shop
3. Deploy Istio Service Mesh

<!-- -------------------------->
## Technical Specification 
Duration: 2

#### Technologies Used
- [Kind Kubernetes](https://kind.sigs.k8s.io/)
  - tested on Kind v0.24.0
- [OpenTelemetry Demo astronomy-shop](https://opentelemetry.io/docs/demo/)
  - tested on release 1.10.0, helm chart release 0.31.0
- [Istio](https://istio.io/latest/docs/)
  - tested on v1.22.1
- [Helm](https://helm.sh/)
  - tested on v3.9.3

#### Reference Architecture
[Demo Architecture](https://opentelemetry.io/docs/demo/architecture/)

#### Prerequisites

<!-- -------------------------->
## Setup
Duration: 8

### Kind Cluster

```sh
# Install
kind create cluster --config .devcontainer/kind-cluster.yml --wait 300s
```

#### Verify Cluster
Command:
```sh
kubectl version
```
Sample output:
> Client Version: v1.31.0\
> Kustomize Version: v5.4.2\
> Server Version: v1.31.0

#### Verify Helm
Command:
```sh
helm version
```
Sample output:
> version.BuildInfo{Version:"v3.16.1",\
> GitCommit:"5a5449dc42be07001fd5771d56429132984ab3ab",\
> GitTreeState:"clean", GoVersion:"go1.22.7"}

### Istio Service Mesh
https://istio.io/latest/docs/setup/getting-started/#download

```sh
# istio setup
export PATH=$PWD/istio-1.22.1/bin:$PATH
istioctl install -f istio/istio-operator.yaml --skip-confirmation
```

```sh
# update istio ingress
kubectl patch svc -n istio-system istio-ingressgateway --patch "$(cat deployment/patch.yaml)"
kubectl delete pod --all -n istio-system
```

### OpenTelemetry Demo - astronomy-shop
https://opentelemetry.io/docs/demo/kubernetes-deployment/

```sh
# deploy astronomy shop
sed -i "s,NAME_TO_REPLACE,$NAME," astronomy-shop/default-values.yaml
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
kubectl create namespace astronomy-shop
kubectl label namespace astronomy-shop istio-injection=enabled
helm install astronomy-shop open-telemetry/opentelemetry-demo --values astronomy-shop/default-values.yaml --namespace astronomy-shop --version "0.31.0"
```

#### Validate pods are running
Command:
```sh
kubectl get pods -n astronomy-shop
```
Sample output:

| NAME | READY | STATUS | RESTARTS | AGE |
| --- | --- | --- | --- | --- |
| astronomy-shop-accountingservice-7b76cc8bb4-snwh8 | 2/2 | Running | 0 | 118s |
| astronomy-shop-adservice-f467c4d7b-v5k2h | 2/2 | Running | 0 | 117s |
| astronomy-shop-cartservice-55b7c7979b-4zl4q | 2/2 | Running | 0 | 116s |
| astronomy-shop-checkoutservice-b6ccc7778-h7vsj | 2/2 | Running | 0 | 117s |
| astronomy-shop-currencyservice-68fdc6f644-p5dc2 | 2/2 | Running | 0 | 117s |
| astronomy-shop-emailservice-6448cfb47c-59ws4 | 2/2 | Running | 0 | 116s |
| astronomy-shop-flagd-9d96446f7-tc67j | 2/2 | Running | 0 | 118s |
| astronomy-shop-frauddetectionservice-69d59c47fc-wcm7k | 2/2 | Running | 0 | 118s |
| astronomy-shop-frontend-b9fd4569-b2fc9 | 2/2 | Running | 0 | 118s |
| astronomy-shop-frontendproxy-7db64d4858-gpl7t | 2/2 | Running | 0 | 118s |
| astronomy-shop-imageprovider-686f9b8fcd-lrqfk | 2/2 | Running | 0 | 117s |
| astronomy-shop-kafka-ccc558cf7-gvvnp | 2/2 | Running | 0 | 118s |
| astronomy-shop-loadgenerator-799b79c864-9865g | 2/2 | Running | 0 | 116s |
| astronomy-shop-otelcol-7cb6b8487-z6k2f | 2/2 | Running | 0 | 118s |
| astronomy-shop-paymentservice-5b4998c7cc-bffz5 | 2/2 | Running | 0 | 116s |
| astronomy-shop-productcatalogservice-5884fcbcb7-6sncb | 2/2 | Running | 0 | 116s |
| astronomy-shop-quoteservice-67bc5fd5-98gnp | 2/2 | Running | 0 | 116s |
| astronomy-shop-recommendationservice-5dc597f5d4-ndp56 | 2/2 | Running | 0 | 117s |
| astronomy-shop-redis-6686b85c9d-zwvtl | 2/2 | Running | 0 | 116s |
| astronomy-shop-shippingservice-85d587457c-77brp | 2/2 | Running | 0 | 116s |

#### Deploy the Istio gateway for `astronomy-shop`
Command:
```sh
chmod 744 istio/deploy-istio-astronomy-shop.sh
```

Command:
```sh
./istio/deploy-istio-astronomy-shop.sh
```
Sample output:
> Waiting for external IP\
> Found external IP: 35.223.120.37\
> gateway.networking.istio.io/astronomy-shop-gateway created\
> virtualservice.networking.istio.io/astronomy-shop-httproute created\
> Access astronomy-shop at http://astronomyshop.35.223.120.37.nip.io/'

<!-- -------------------------->
## Wrap Up

### What You Learned Today 
By completing this lab, you created a Kubernetes cluster on Kind and deployed the OpenTelemetry Demo application, astronomy-shop.
- The Kubernetes cluster can run containerized workloads
- The astronomy-shop application offers a convenient way to demo/explore cloud native technologies
- Istio Service Mesh provides networking, security, and observability capabilities for Kubernetes
- You are ready to proceed with additional labs that depend on this infrastructure deployment

<!-- ------------------------ -->
### Supplemental Material
TODO
