#! /bin/bash

# exit when any command fails
set -e 

if [ -d "manifests" ]
then
    echo "manifests folder exists. It will be remove now"
    rm -rf manifests
fi

echo "Clone kubeflow manifest repo"
# Clone kubeflow manifest
git clone https://github.com/kubeflow/manifests

echo "Setup azure config env"
# Copy azure config env to manifest repo
cp -r azure-with-mysql manifests/apps/pipeline/upstream/env


echo "Setup kustomization"
mkdir manifests/build
cp kustomizations/kubeflow-azure-mysql-customization/kustomization.yaml manifests/build

cp others/jupyter-web-app-disable-appsecure/deployment-patch.yaml manifests/apps/jupyter/jupyter-web-app/upstream/overlays/istio/
echo "patchesStrategicMerge:\n- deployment-patch.yaml" >> manifests/apps/jupyter/jupyter-web-app/upstream/overlays/istio/kustomization.yaml
while ! kustomize build manifests/build | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done

kubectl patch svc istio-ingressgateway -p '{"spec": {"type": "LoadBalancer"}}' -n istio-system
kubectl patch destinationrule ml-pipeline -p '{"spec" :{"trafficPolicy" :{"tls" :{"mode" :"DISABLE"}}}}' -n kubeflow --type=merge
kubectl patch destinationrule ml-pipeline-ui -p '{"spec" :{"trafficPolicy" :{"tls" :{"mode" :"DISABLE"}}}}' -n kubeflow --type=merge