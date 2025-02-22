## Deploy Collector

### Deploy OpenTelemetry Collector CRD
https://opentelemetry.io/docs/kubernetes/operator/
```yaml
---
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: contrib-daemonset
  namespace: dynatrace
spec:
  envFrom:
  - secretRef:
      name: dynatrace-otelcol-dt-api-credentials
  mode: "daemonset"
  image: "otel/opentelemetry-collector-contrib:0.103.0"
```
Command:
```sh
kubectl apply -f opentelemetry/collector/contrib/otel-collector-contrib-daemonset-crd.yaml
```
Sample output:
> opentelemetrycollector.opentelemetry.io/contrib-daemonset created

### Validate running pod(s)
Command:
```sh
kubectl get pods -n dynatrace
```
Sample output:
| NAME                                       | READY | STATUS  | RESTARTS | AGE |
|--------------------------------------------|-------|---------|----------|-----|
| contrib-daemonset-collector-d92tw | 1/1   | Running | 0        | 1m  |