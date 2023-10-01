# testbed
Testbed to try out new things.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:
```shell
helm repo add testbed-charts https://juanjjaramillo.github.io/testbed
```

If you had already added this repo earlier, run
```shell
helm repo update
```
to retrieve the latest versions of the packages.

To see the charts, you can then run
```shell
helm search repo --devel testbed-charts
```

To install the `testbed` chart:
```shell
helm install my-testbed testbed-charts/testbed
```
To uninstall the chart:
```shell
helm delete my-testbed
```
