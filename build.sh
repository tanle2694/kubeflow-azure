#! /bin/bash

# exit when any command fails
set -e 

if [ -d "manifests" ]
then
    echo "manifests folder exists. It will be remove now"
    rm -rf manifest
fi

echo "Clone kubeflow manifest repo"
# Clone kubeflow manifest
git clone https://github.com/kubeflow/manifests

echo "Setup azure config env"
# Copy azure config env to manifest repo
cp -r azure-with-mysql manifest/apps/pipeline/upstream/env

echo "Setup kustomization"
cp kustomizations/kubeflow-azure-mysql-customization/kustomization.yaml manifest/build


while ! kustomize build manifest/build | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
