## About

A comprehensive guide for collecting, and exporting telemetry data (metrics, logs, and traces) from Docker Swarm environment can be found at [swarmlibs/dockerswarm-monitoring-guide](https://github.com/swarmlibs/dockerswarm-monitoring-guide).

Like Promstack, but for logs. Includes (Grafana Loki and Promtail)

> [!IMPORTANT]
> This project is a work in progress and is not yet ready for production use.
> But feel free to test it and provide feedback.

**Table of Contents**:
- [About](#about)
- [Concepts](#concepts)
- [Stacks](#stacks)
- [Pre-requisites](#pre-requisites)
- [Getting Started](#getting-started)
  - [Deploy stack](#deploy-stack)
  - [Remove stack](#remove-stack)
  - [Verify deployment](#verify-deployment)
- [Services and Ports](#services-and-ports)

## Concepts

This section covers some concepts that are important to understand for day to day Logstack usage and operation.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/swarmlibs/logstack/assets/4363857/7a23f4ab-9eff-49a3-af87-bc6810a41afe">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/swarmlibs/logstack/assets/4363857/61e98272-c65e-4a05-8488-8a3256544f59">
  <img src="https://github.com/swarmlibs/logstack/assets/4363857/61e98272-c65e-4a05-8488-8a3256544f59">
</picture>

---

## Stacks

- [grafana-loki](https://github.com/swarmlibs/grafana-loki): A customized Grafana Loki for Docker Swarm.
- [promtail](https://github.com/swarmlibs/promtail): A customized Grafana Promtail for Docker Swarm.

## Pre-requisites

- Docker running Swarm mode
- A Docker Swarm cluster with at least 3 nodes
- Configure Docker daemon to expose metrics for Prometheus
- The official [swarmlibs](https://github.com/swarmlibs/swarmlibs) stack, this provided necessary services for other stacks operate.

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
# The `logstack_gwnetwork` network is used for the internal communication between the Grafana Loki & Promtail.
docker network create --scope=swarm --driver=overlay --attachable logstack_gwnetwork

# The `prometheus_gwnetwork` network is used for the internal communication between the Prometheus Server, exporters and other agents.
docker network create --scope=swarm --driver=overlay --attachable prometheus_gwnetwork
```

The `grafana-loki` service requires extra services to operate, mainly for providing configuration files. There are two type of child services, a config provider and config reloader service. In order to ensure placement of these services, you need to deploy the `swarmlibs` stack.

See https://github.com/swarmlibs/swarmlibs for more information.

### Deploy stack

This will deploy the stack to the Docker Swarm cluster. Please ensure you have the necessary permissions to deploy the stack and the `swarmlibs` stack is deployed. See [Pre-requisites](#pre-requisites) for more information.

> [!IMPORTANT]
> It is important to note that the `logstack` is the default stack namespace for this deployment.  
> It is **NOT RECOMMENDED** to change the stack namespace as it may cause issues with the deployment.

```sh
make deploy
```

### Remove stack

> [!WARNING]
> This will remove the stack and all the services associated with it. Use with caution.

```sh
make remove
```

### Verify deployment

To verify the deployment, you can use the following commands:

```sh
docker service ls --filter label=com.docker.stack.namespace=logstack

# ID   NAME                            MODE         REPLICAS               IMAGE
# **   logstack_grafana-loki           replicated   1/1 (max 1 per node)   swarmlibs/grafana-loki:main
# **   logstack_grafana-loki-gateway   global       1/1                    swarmlibs/docker-task-proxy:main
# **   logstack_promtail               global       1/1                    swarmlibs/promtail:main
```

You can continously monitor the deployment by running the following command:

```sh
# The `watch` command will continously monitor the services in the stack and update the output every 2 seconds.
watch docker service ls --filter label=com.docker.stack.namespace=logstack
```

## Services and Ports

The following services and ports are exposed by the stack:

| Service              | Port    | Ingress DNS                              |
| -------------------- | ------- | ---------------------------------------- |
| Grafana Loki Gateway | `3100`  | `grafana-loki-gateway.svc.cluster.local` |
| Promtail             | `19080` |                                          |

---

> [!IMPORTANT]
> This project is a work in progress and is not yet ready for production use.
> But feel free to test it and provide feedback.
