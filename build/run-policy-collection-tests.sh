#!/bin/bash

set -e

if ! which kubectl > /dev/null; then
    echo "installing kubectl"
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
fi

echo "Login hub"
make oc/login

oc create ns policies || true

git clone https://github.com/open-cluster-management/policy-collection.git
cd policy-collection/deploy

./deploy.sh https://github.com/open-cluster-management/policy-collection.git stable policies

COMPLETE=1
for i in {1..20}; do
    clear
    ROOT_POLICIES=$(oc get policies -n policies | tail -n +2 | wc -l | tr -d '[:space:]')
    TOTAL_POLICIES=$(oc get policies -A | tail -n +2 | wc -l | tr -d '[:space:]')
    if [ $ROOT_POLICIES -eq 10 ] && [ $TOTAL_POLICIES -eq 20 ]; then
        COMPLETE=0
        break
    fi
    echo
    echo "Number of expected Policies : 10/20"
    echo "Number of expected Policies : $ROOT_POLICIES/$TOTAL_POLICIES"
    sleep 10
done
if [ $COMPLETE -eq 1 ]; then
    echo "Number of expected Policies : 10/20"
    echo "Number of expected Policies : $ROOT_POLICIES/$TOTAL_POLICIES"
    exit 1
fi

exit 0