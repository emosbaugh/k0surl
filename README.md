# k0surl

k0surl configures and installs a [k0s](https://github.com/k0sproject/k0s) Kubernetes cluster and a pre-configured set of add-ons to a set of servers using [k0sctl](https://github.com/k0sproject/k0sctl) and [helm](https://github.com/helm/helm).

## Installation

### Localhost

```bash
./main.sh
```

### With custom hosts

```bash
HOSTS_PATCH_FILE=./hosts.patch.yaml ./main.sh
```

### With debug logging

```bash
DEBUG=true ./main.sh
```

## Add-ons

| name | supported |
| ---- | --------- |
| openebs | yes |
| rook | yes |
| registry | todo |
| prometheus | todo |
| velero | todo |
| kots | yes |
| ... | todo |

## Known limitations

- Does not yet support multi-node clusters
- Preflights and troubleshoot
- Airgap with add-ons
- E2E tests
