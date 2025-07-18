--8<-- "snippets/send-bizevent/2-getting-started.js"
# Getting Started

--8<-- "snippets/requirements.md"

## Prerequisites

You will need full administrator access to a Dynatrace SaaS tenant with a DPS license.

* Generate Dynatrace Access Token

### Generate Dynatrace Access Token

Generate a new API access token with the following scopes:

```
Ingest events
Ingest logs
Ingest metrics
Ingest OpenTelemetry traces
```
[See Related Dynatrace API Token Creation Documentation](https://docs.dynatrace.com/docs/dynatrace-api/basics/dynatrace-api-authentication#create-token)

![dt access token](./img/prereq-dt_access_token.png)

## Continue

In the next section, we'll launch our Codespaces instance.

<div class="grid cards" markdown>
- [Continue to Codespaces:octicons-arrow-right-24:](3-codespaces.md)
</div>
