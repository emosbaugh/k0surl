# k0surl

k0surl configures and installs a [k0s](https://github.com/k0sproject/k0s) Kubernetes cluster and a pre-configured set of add-ons to a set of servers using [k0sctl](https://github.com/k0sproject/k0sctl), [helm](https://github.com/helm/helm) and [kustomize](https://github.com/kubernetes-sigs/kustomize).

## Installation

```bash
./main.sh
```

### With debug logging

```bash
sudo DEBUG=true ./main.sh
```

### Changing the build and install directories

```bash
sudo BUILD_DIR=./build INSTALL_DIR=./install ./main.sh
```

## Add-ons

| name | supported |
| ---- | --------- |
| openebs | yes |
| rook | yes |
| registry | todo |
| prometheus | todo |
| velero | todo |
| ... | todo |

## Known limitations

- Does not yet support multi-node clusters