id: enablement-kubernetes-opentelemetry

summary: kubernetes observability with dynatrace and opentelemetry

author: Tony Pope-Cruz

# Enablement Kubernetes OpenTelemetry

## Lab Overview

During this hands-on training, we’ll learn how to capture logs, traces, and metrics from Kubernetes using OpenTelemetry and ship them to Dynatrace for analysis.  This will demonstrate how to use Dynatrace with OpenTelemetry; without any Dynatrace native components installed on the Kubernetes cluster (Operator, OneAgent, ActiveGate, etc.).

**Lab tasks:**

1. OpenTelemetry Logs

    - Deploy OpenTelemetry Collector as a DaemonSet
    - Deploy OpenTelemetry Collector as a Deployment
    - Configure OpenTelemetry Collector service pipeline for log enrichment
    - Query and visualize logs in Dynatrace using DQL

2. OpenTelemetry Traces

    - Deploy OpenTelemetry Collector as a Deployment
    - Configure OpenTelemetry Collector service pipeline for span enrichment
    - Analyze application reliability via traces in Dynatrace

3. OpenTelemetry Metrics

    - Deploy OpenTelemetry Collector as a DaemonSet
    - Configure OpenTelemetry Collector service pipeline for metric enrichment
    - Deploy OpenTelemetry Collector as a Deployment
    - Configure OpenTelemetry Collector service pipeline for metric enrichment
    - Query and visualize metrics in Dynatrace using DQL

4. OpenTelemetry Capstone

    - Deploy 4 OpenTelemetry Collectors
    - Configure OpenTelemetry Collector service pipeline for data enrichment
    - Analyze metrics, traces, and logs in Dynatrace
    - Observe OpenTelemetry Collector health in Dynatrace

Ready to learn how to ship OpenTelemetry signals to Dynatrace?

## [View the Lab Guide](https://dynatrace-wwse.github.io/enablement-kubernetes-opentelemetry)