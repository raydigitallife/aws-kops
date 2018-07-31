#!/bin/bash

# 自動建k8s不用打指令了

kops create -f kops-cluster-m1-n3.yaml
kops create secret --name c9.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster c9.k8s.local --yes



