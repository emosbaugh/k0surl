# k0surl

k0surl configures and installs a [k0s](https://github.com/k0sproject/k0s) Kubernetes cluster and a pre-configured set of add-ons to a set of servers using [k0sctl](https://github.com/k0sproject/k0sctl) and [helm](https://github.com/helm/helm).

## Installation

### Localhost

```bash
./main.sh
```

### With custom hosts

Example hosts.patch.yaml file with a controller and two workers:

```yaml
apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: k0s
spec:
  hosts:
    - role: controller
      ssh:
        address: 35.247.41.116
        user: ethan
        keyPath: ~/.ssh/id_ed25519
    - role: worker
      ssh:
        address: 34.234.21.65
        user: ethan
        keyPath: ~/.ssh/id_ed25519
    - role: worker
      ssh:
        address: 35.237.129.32
        user: ethan
        keyPath: ~/.ssh/id_ed25519
```

```bash
HOSTS_PATCH_FILE=./hosts.patch.yaml ./main.sh
```

### With debug logging

```bash
DEBUG=true ./main.sh
```

### Resetting the cluster

```bash
./reset.sh
```

## Add-ons

| name | supported |
| ---- | --------- |
| openebs | yes |
| rook | todo |
| registry | todo |
| prometheus | todo |
| velero | todo |
| kots | yes |
| ... | todo |

## Known limitations

- Preflights and troubleshoot
- Airgap with add-ons
- E2E tests
