# <img src="https://cdn.bfldr.com/B686QPH3/at/w5hnjzb32k5wcrcxnwcx4ckg/Dynatrace_signet_RGB_HTML.svg?auto=webp&format=pngg" alt="DT logo" width="45"> Enablement Kubernetes OpenTelemetry
[![dt-badge](https://img.shields.io/badge/powered_by-DT_enablement-8A2BE2?logo=dynatrace)](https://dynatrace-wwse.github.io/codespaces-framework/)
[![Downloads](https://img.shields.io/docker/pulls/shinojosa/dt-enablement?logo=docker)](https://hub.docker.com/r/shinojosa/dt-enablement)
![Integration tests](https://github.com/dynatrace-wwse/enablement-kubernetes-opentelemetry/actions/workflows/integration-tests.yaml/badge.svg)
[![Version](https://img.shields.io/github/v/release/dynatrace-wwse/enablement-kubernetes-opentelemetry?color=blueviolet)](https://github.com/dynatrace-wwse/enablement-kubernetes-opentelemetry/releases)
[![Commits](https://img.shields.io/github/commits-since/dynatrace-wwse/enablement-kubernetes-opentelemetry/latest?color=ff69b4&include_prereleases)](https://github.com/dynatrace-wwse/enablement-kubernetes-opentelemetry/graphs/commit-activity)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg?color=green)](https://github.com/dynatrace-wwse/enablement-kubernetes-opentelemetry/blob/main/LICENSE)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-green)](https://dynatrace-wwse.github.io/enablement-kubernetes-opentelemetry/)

___

Id: enablement-kubernetes-opentelemetry

Summary: kubernetes observability with dynatrace and opentelemetry

Author: Tony Pope-Cruz

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

    - Deploy 2 OpenTelemetry Collectors (DaemonSet + Deployment)
    - Configure OpenTelemetry Collector service pipeline for data enrichment
    - Analyze metrics, traces, and logs in Dynatrace
    - Observe OpenTelemetry Collector health in Dynatrace

Ready to learn how to ship OpenTelemetry signals to Dynatrace?

## [View the Lab Guide](https://dynatrace-wwse.github.io/enablement-kubernetes-opentelemetry)