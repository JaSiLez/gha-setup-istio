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

# curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${INPUT_ISTIO_VERSION} sh -
# export PATH="$PATH:/github/workspace/istio-${INPUT_ISTIO_VERSION}/bin"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${INPUT_ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${INPUT_ISTIO_VERSION}
kubectl create namespace istio-system
helm upgrade -i istio-base manifests/charts/base -n istio-system
helm upgrade -i istiod manifests/charts/istio-control/istio-discovery -n istio-system
helm upgrade -i istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
helm upgrade -i istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
helm upgrade -i istio-egress manifests/charts/gateways/istio-egress -n istio-system
kubectl get pods -n istio-system
kubectl get istio-io --all-namespaces -oyaml



# istioctl version

# OLD_COMMENTED. Disable Kiali and Grafana as it is non-interactive
#echo "ISTIO_PROFILE=${INPUT_ISTIO_PROFILE}"
#istioctl install --set profile=${INPUT_ISTIO_PROFILE}

# Install the Istio Operator on AKS
# istioctl operator init

#echo "The Istio Operator is installed into the istio-operator namespace."
# Query the namespace
#kubectl get all -n istio-operator --force

# You should see the following components deployed:
# NAME                                  READY   STATUS    RESTARTS   AGE
# pod/istio-operator-6d7958b7bf-wxgdc   1/1     Running   0          2m43s
# NAME                     TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
# service/istio-operator   ClusterIP   10.0.8.57    <none>        8383/TCP   2m43s
# NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/istio-operator   1/1     1            1           2m43s
# NAME                                        DESIRED   CURRENT   READY   AGE
# replicaset.apps/istio-operator-6d7958b7bf   1         1         1       2m43s


## Install Istio Components
# View the configuration for the default Istio Configuration Profile.
#echo See Configuration
#echo $(istioctl profile dump default)

# Customize a file called istio.aks.yaml with the following content. 
# This file will hold the Istio Operator Spec for configuring Istio.

#kubectl create ns istio-system
# kubectl apply -f istio.aks.yaml 
# Add a delay here so `kubectl wait` below is gated to Istio pods correctly
#sleep 1

## Validate the Istio installation
# Wait for all Istio pods to become ready
# TODO: This wait might not be needed 
#kubectl wait --for=condition=Ready pods --all -n istio-system --timeout=60s
# kubectl get all -n istio-system
