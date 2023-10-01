# testbed
Testbed to try out new things.

## Prerequisites

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo:
```shell
helm repo add testbed-charts https://juanjjaramillo.github.io/testbed
```

If you had already added this repo earlier, retrieve the latest versions of the packages:
```shell
helm repo update
```

## Available Chart Releases

To see the available charts:
```shell
# `--devel` flag is only needed to show development
# versions (v0.0.0, alpha, beta, and release candidate releases)
helm search repo --devel testbed-charts
```

If you want to see a list of all available charts and releases, check [index.yaml](https://juanjjaramillo.github.io/testbed/index.yaml).

## Installation

To install the `testbed` chart:
```shell
helm install my-testbed testbed-charts/testbed
```
To uninstall the chart:
```shell
helm delete my-testbed
```
