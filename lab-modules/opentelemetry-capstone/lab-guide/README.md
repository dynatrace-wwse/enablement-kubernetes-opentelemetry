### Launching Lab Guide Locally

Clone the repo:
```sh
git clone --single-branch --branch code-spaces https://github.com/dynatrace-wwse/enablement-kubernetes-opentelemetry/tree/main/lab-modules/opentelemetry-capstone.git
```

Move into the lab guide directory:
```sh
cd opentelemetry-capstone/lab-guide
```

Install Node if not already installed:
[Download Node.js](https://nodejs.org/en/download/package-manager)

Run the generator command:
```sh
node bin/generator.js
```

Run the server command:
```sh
node bin/server.js
```

Open the URL in your browser:
```text
http://localhost:3000
```