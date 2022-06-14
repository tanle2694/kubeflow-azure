
RELEASE=release-0.8
git clone -b $RELEASE --depth 1 --single-branch https://github.com/kserve/modelmesh-serving.git
cd modelmesh-serving
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

sed -i 's/kustomize/.\/kustomize/g' scripts/install.sh
kubectl create namespace modelmesh-serving
./scripts/install.sh --namespace modelmesh-serving --quickstart