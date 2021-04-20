#!/bin/sh

#############################################################
# Check for input parameters
#############################################################

if [ -z "$INPUT_KUBECONFIG" ]; then
  echo "KUBECONFIG input parameter is not set, exiting..."
  exit 1
fi

if [ -z "$INPUT_ISTIO_VERSION" ]; then
  echo "ISTIO_VERSION input parameter is not set, exiting..."
  exit 1
fi


#############################################################
# Create Kubernetes configuration to access the cluster
#############################################################

mkdir ~/.kube
echo "$INPUT_KUBECONFIG" > ~/.kube/config
cat ~/.kube/config


#############################################################
# Sanity check
#############################################################
kubectl get pods --all-namespaces


#############################################################
# Download and install Istio
#############################################################
helm repo add jetstack https://charts.jetstack.io
helm repo update
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${INPUT_ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${INPUT_ISTIO_VERSION}

kubectl create namespace istio-system

if [ -z "$INPUT_CUSTOM_BASE" ]; then
  helm upgrade -i istio-base manifests/charts/base -n istio-system
else
  helm upgrade -i istio-base manifests/charts/base --values /values_charts/base.yaml -n istio-system
fi

if [ -z "$INPUT_CUSTOM_CONTROL" ]; then
  helm upgrade -i istiod manifests/charts/istio-control/istio-discovery -n istio-system
else
  helm upgrade -i istiod manifests/charts/istio-control/istio-discovery --values /values_charts/istio-control.yaml -n istio-system
fi

if [ -z "$INPUT_CUSTOM_INGRESS" ]; then
  helm upgrade -i istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
else
  helm upgrade -i istio-ingress manifests/charts/gateways/istio-ingress --values /values_charts/istio-ingress.yaml -n istio-system
fi

if [ -z "$INPUT_CUSTOM_EGRESS" ]; then
  helm upgrade -i istio-egress manifests/charts/gateways/istio-egress -n istio-system
else
  helm upgrade -i istio-egress manifests/charts/gateways/istio-egress --values /values_charts/istio-egress.yaml -n istio-system
fi

# View Pods
kubectl get pods -n istio-system
echo "====== POSIBLE FALLO ======"
kubectl get istio-io --all-namespaces -oyaml

# Install Istio Integrations Selected by action input vars

# CertManager
if [ ! -z "$INPUT_ADDON_CERTMANAGER" ]; then
  helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --version v1.3.0 --set installCRDs=true
fi

# Grafana
if [ ! -z "$INPUT_ADDON_GRAFANA" ]; then
  kubectl apply -f "https://raw.githubusercontent.com/istio/istio/release-${INPUT_ISTIO_VERSION::-2}/samples/addons/grafana.yaml"
fi

# Kiali
if [ ! -z "$INPUT_ADDON_KIALI" ]; then
  kubectl apply -f "https://raw.githubusercontent.com/istio/istio/release-${INPUT_ISTIO_VERSION::-2}/samples/addons/kiali.yaml"
fi

# Jaeger
if [ ! -z "$INPUT_ADDON_JAEGER" ]; then
  kubectl apply -f "https://raw.githubusercontent.com/istio/istio/release-${INPUT_ISTIO_VERSION::-2}/samples/addons/jaeger.yaml"
fi

# Prometheus
if [ ! -z "$INPUT_ADDON_PROMETHEUS" ]; then
  kubectl apply -f "https://raw.githubusercontent.com/istio/istio/release-${INPUT_ISTIO_VERSION::-2}/samples/addons/prometheus.yaml"
fi

# Zipkin
if [ ! -z "$INPUT_ADDON_ZIPKIN" ]; then
  kubectl apply -f "https://raw.githubusercontent.com/istio/istio/release-${INPUT_ISTIO_VERSION::-2}/samples/addons/grafana.yaml"
fi
