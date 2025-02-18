## Prerequisites

## Import Dashboard into Dynatrace

[Dashboard](https://github.com/popecruzdt/dt-k8s-otel-o11y-traces/blob/code-spaces/dt-k8s-otel-o11y-traces_dt_dashboard.json)

### Define workshop user variables
In your Github Codespaces Terminal:
```
DT_ENDPOINT=https://{your-environment-id}.live.dynatrace.com/api/v2/otlp
DT_API_TOKEN={your-api-token}
NAME=<INITIALS>-k8s-otel-o11y
```

### Move into home directory
Command:
```sh
cd ~
```

### Clone the `code-spaces` branch to your Codespaces instance
Command:
```sh
git clone --single-branch --branch code-spaces https://github.com/popecruzdt/dt-k8s-otel-o11y-traces.git
```

### Move into the base directory
Command:
```sh
cd dt-k8s-otel-o11y-traces
```