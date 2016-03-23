#!/bin/bash

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

# check input arguments
if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

CLUSTER_NAME=$1

MASTER_DNS=$(fetch_cluster_master_public_dns ${CLUSTER_NAME})
WORKER_DNS=$(fetch_cluster_worker_public_dns ${CLUSTER_NAME})

cmd='/usr/local/alluxio/bin/alluxio-start.sh master'
run_cmd_on_node ${MASTER_DNS} ${cmd}

cmd='/usr/local/alluxio/bin/alluxio-start.sh worker SudoMount'
for dns in ${WORKER_DNS}; do
  run_cmd_on_node ${dns} ${cmd}
done

echo "Alluxio Started!"
