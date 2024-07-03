## About

A comprehensive guide for collecting, and exporting telemetry data (metrics, logs, and traces) from Docker Swarm environment can be found at [swarmlibs/dockerswarm-monitoring-guide](https://github.com/swarmlibs/dockerswarm-monitoring-guide).

Like Promstack, but for logs. Includes (Grafana Loki and Promtail)

> [!IMPORTANT]
> This project is a work in progress and is not yet ready for production use.
> But feel free to test it and provide feedback.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/swarmlibs/logstack/assets/4363857/7a23f4ab-9eff-49a3-af87-bc6810a41afe">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/swarmlibs/logstack/assets/4363857/61e98272-c65e-4a05-8488-8a3256544f59">
  <img src="https://github.com/swarmlibs/logstack/assets/4363857/61e98272-c65e-4a05-8488-8a3256544f59">
</picture>

**Table of Contents**:
- [About](#about)
- [Stacks](#stacks)
- [Pre-requisites](#pre-requisites)
- [Getting Started](#getting-started)
  - [Deploy logstack](#deploy-logstack)
  - [Remove logstack](#remove-logstack)

## Stacks

- [grafana-loki](https://github.com/swarmlibs/grafana-loki): A customized Grafana Loki for Docker Swarm.
- [promtail](https://github.com/swarmlibs/promtail): A customized Grafana Promtail for Docker Swarm.

## Pre-requisites

- Docker running Swarm mode
- A Docker Swarm cluster with at least 3 nodes

## Getting Started

To get started, clone this repository to your local machine:

```sh
git clone https://github.com/swarmlibs/logstack.git
# or
gh repo clone swarmlibs/logstack
```

Navigate to the project directory:

```sh
cd logstack
```

Create user-defined networks:

```sh
# TBD
```

### Deploy logstack

```sh
# TBD
```

### Remove logstack

```sh
# TBD
```

---

> [!IMPORTANT]
> This project is a work in progress and is not yet ready for production use.
> But feel free to test it and provide feedback.
