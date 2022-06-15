
RELEASE=release-0.8
git clone -b $RELEASE --depth 1 --single-branch https://github.com/kserve/modelmesh-serving.git
cd modelmesh-serving
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
export PATH=$(pwd):$PATH
kubectl create namespace modelmesh-serving
rm modelmesh-serving/config/runtimes/mlserver-0.x.yaml
cp model-mesh-config/mlserver-0.x.yaml modelmesh-serving/config/runtimes/


./scripts/install.sh --namespace modelmesh-serving --quickstart

kubectl get secret storage-config -o yaml | sed 's/namespace: .*/namespace: kubeflow/' | kubectl apply -f -
kubectl get secret storage-config -o yaml | sed 's/namespace: .*/namespace: kubeflow-user-example-com/' | kubectl apply -f -

kubectl apply -f model_mesh_rbac.yaml
