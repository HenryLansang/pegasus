#!/bin/bash

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

CLUSTER_NAME=$1

MASTER_DNS=$(fetch_cluster_master_public_dns ${CLUSTER_NAME})
WORKER_DNS=$(fetch_cluster_worker_public_dns ${CLUSTER_NAME})

for dns in ${WORKER_DNS}; do
  echo $dns
  cmd='tmux kill-session -t supervisor'
  run_cmd_on_node ${dns} ${cmd}
done

echo $MASTER_DNS
cmd="tmux kill-session -t stormui; tmux kill-session -t nimbus"
run_cmd_on_node ${MASTER_DNS} ${cmd}

echo "Storm Stopped!"

