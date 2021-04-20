# gha-setup-istio
Github Action k8s Istio Installer
=========================

Install Istio on K8s Clusters

## Usage

Istio requires a Kubernetes cluster to run. You can use any Github Actions that installs a Kubernetes cluster before running this action. An example is shown below.

### Basic

```yaml
name: Example workflow
on: [push]
jobs:
  example:
    name: Create Istio service mesh
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v1
      - name: Setup Minikube
        uses: manusa/actions-setup-minikube@v2.3.1
        with:
          minikube version: 'v1.19.0'
          kubernetes version: 'v1.18.14'
          start args: '--embed-certs'
      - name: Get kubeconfig
        id: kubeconfig
        run: a="$(cat ~/.kube/config)"; a="${a//'%'/'%25'}"; a="${a//$'\n'/'%0A'}"; a="${a//$'\r'/'%0D'}"; echo "::set-output name=config::$a"
      - name: Install Istio
        uses: JaSiLez/gha-setup-istio@v1.0.0
        with:
          kubeconfig: "${{steps.kubeconfig.outputs.config}}"
          istio version: '1.9.3'
      - name: Interact with the cluster
        run: kubectl get all --all-namespaces
```

### Required input parameters

| Parameter | Description |
| --------- | ----------- |
| `kubeconfig` | Kubeconfig file that kubectl uses |

### Optional input parameters

| Parameter | Description |
| --------- | ----------- |
| `istio version` | Istio [version](https://github.com/istio/istio/releases) to deploy |
| `istio args` | Istio arguments during installation |

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about istio installations and Features then refer the following [guidelines](https://istio.io/latest/docs/).
You can also seek inspiration from the below references links:
- [Istio Charts](https://github.com/istio/istio/tree/master/manifests/charts)
- [Istio Integrations](https://istio.io/latest/docs/ops/integrations/)
- [Setup Minikube GitHub Action](https://github.com/manusa/actions-setup-minikube) 
- [Visual Studio Code](https://github.com/Microsoft/vscode)