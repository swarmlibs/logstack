#!/bin/sh
# Copyright (c) Swarm Library Maintainers.
# SPDX-License-Identifier: MIT

set -e

get_addr () {
  local if_name=$1
  ip addr show dev $if_name | awk '/\s*inet\s/ { ip=gensub(/(.+)\/.+/, "\\1", "g", $2); print ip; exit }'
}

if [[ -n "${GF_LOKI_ADVERTISE_INTERFACE}" ]]; then
  export GF_LOKI_ADVERTISE_ADDR=$(get_addr $GF_LOKI_ADVERTISE_INTERFACE)
  echo "Using $GF_LOKI_ADVERTISE_INTERFACE for GF_LOKI_ADVERTISE_ADDR: $GF_LOKI_ADVERTISE_ADDR"
fi

# If the user is trying to run Prometheus directly with some arguments, then
# pass them to Prometheus.
if [ "${1:0:1}" = '-' ]; then
    set -- loki "$@"
fi

# If the user is trying to run Prometheus directly with out any arguments, then
# pass the configuration file as the first argument.
if [ "$1" = "loki" ]; then
  shift

  if [[ -n "${GF_LOKI_ADVERTISE_ADDR}" ]]; then
    set -- \
      -common.storage.ring.instance-addr="${GF_LOKI_ADVERTISE_ADDR}" \
      -memberlist.advertise-addr="${GF_LOKI_ADVERTISE_ADDR}" \
      "$@"
  fi

  if [[ -n "${GF_LOKI_DOCKER_STACK_NAMESPACE}" ]]; then
    set -- \
      -memberlist.cluster-label="${GF_LOKI_DOCKER_STACK_NAMESPACE}" \
      "$@"
  fi

  set -- loki "$@"
fi

echo "==> Grafana Loki configuration:"
echo "+ $@"
echo "==> Grafana Loki started! Log data will be stream in below:"
exec "$@"
