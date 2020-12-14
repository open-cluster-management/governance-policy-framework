#!/bin/bash

# Copyright (c) 2020 Red Hat, Inc.

if ! which kubectl > /dev/null; then
    echo "Installing oc and kubectl clis..."
    mkdir clis-unpacked
    curl -kLo oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.6.6/openshift-client-linux-4.6.6.tar.gz
    tar -xzf oc.tar.gz -C clis-unpacked
    chmod 755 ./clis-unpacked/oc
    chmod 755 ./clis-unpacked/kubectl
    sudo mv ./clis-unpacked/oc /usr/local/bin/oc
    sudo mv ./clis-unpacked/kubectl /usr/local/bin/kubectl
fi