# gha-setup-istio
Github Action k8s Istio Installer
=========================

Install Istio on K8s Clusters

## Usage

Istio requires a Kubernetes cluster to run. You can use any Github Actions that installs a Kubernetes cluster before running this action. An example is shown below.

### Basic

```yaml
name: Istio_K8s CD
on: [push]
jobs:
  example:
    name: Create Istio Service Mesh
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Setup Istio on K8s
        uses: JaSiLez/gha-setup-istio@v1.0.0
        with:
          kubeconfig: "${{ secrets.KUBECONFIG }}"
          istio_version: '1.9.3'
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
| `istio_version` | Istio [version](https://github.com/istio/istio/releases) to deploy |
| `custom_base` | With true value apply values file from values_charts folder |
| `custom_control` | With true value apply values file from values_charts folder |
| `custom_ingress` | With true value apply values file from values_charts folder |
| `custom_egress` | With true value apply values file from values_charts folder |
| `addon_certmanager` | With true value apply Integrate Addon with Istio |
| `addon_grafana` | With true value apply Integrate Addon with Istio |
| `addon_kiali` | With true value apply Integrate Addon with Istio |
| `addon_jaeger` | With true value apply Integrate Addon with Istio |
| `addon_prometheus` | With true value apply Integrate Addon with Istio |
| `addon_zipkin` | With true value apply Integrate Addon with Istio |


### What do you need Know ??

We begin to create this action using Istio v1.9.3. Not accept older versions of Istio 


## Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about istio installations and Features then refer the following [guidelines](https://istio.io/latest/docs/).
You can also seek inspiration from the below references links:
- [Istio Charts](https://github.com/istio/istio/tree/master/manifests/charts)
- [Istio Integrations](https://istio.io/latest/docs/ops/integrations/)
- [Setup Minikube GitHub Action](https://github.com/manusa/actions-setup-minikube) 
- [Visual Studio Code](https://github.com/Microsoft/vscode)

## License

The scripts and documentation in this project are released under the [GNU GPL v3](./LICENSE) license.