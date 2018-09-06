#!/bin/bash

# 需先指定S3暫存位置
export KOPS_STATE_STORE=s3://kops-c9-ray-test


case ${1} in
    "create")
    kops create -f kops-cluster-m1-n3-update-v1.10.7.yaml
    kops create secret --name c9.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub
    kops update cluster c9.k8s.local --yes
    ;;
    "delete")
    kops delete cluster --name c9.k8s.local --yes
    ;;
    *)
    echo "Usage Create or delete only"
    ;;
esac
