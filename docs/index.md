--8<-- "snippets/send-bizevent/index.js"
# Kubernetes OpenTelemetry
<!--TODO: Update disclaimer (optional) -->
--8<-- "snippets/disclaimer.md"

<!--TODO: Update lab overview (match readme) -->
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

<!--TODO: Update tech spec of lab components -->
## Technical Specification

### Technologies Used
- [Dynatrace](https://www.dynatrace.com/trial)
- [Kubernetes Kind](https://kind.sigs.k8s.io/)
    - tested on Kind tag 0.27.0
- [Cert Manager](https://cert-manager.io/) - *prerequisite for OpenTelemetry Operator
    - tested on cert-manager v1.15.3
- [Dynatrace Operator](https://github.com/Dynatrace/dynatrace-operator)
    - tested on v1.4.2 (April 2025)
- Dynatrace OneAgent
    - tested on v1.309 (April 2025)

### Reference Architecture

## Continue

In the next section, we'll review the prerequisites for this lab needed before launching our Codespaces instance.

<div class="grid cards" markdown>
- [Continue to getting started:octicons-arrow-right-24:](2-getting-started.md)
</div>