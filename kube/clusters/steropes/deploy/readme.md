# Deploy cluster

```
cd terraform && terraform apply -auto-approve --var-file=vars.tfvars && cd ../talos
talhelper genconfig && talosctl apply-config --insecure -n cp1.steropes.home.lab --file clusterconfig/steropes-cp1.steropes.home.lab.yaml
talosctl -e k.steropes.home.lab -n cp1.steropes.home.lab --talosconfig=./clusterconfig/talosconfig bootstrap
talosctl -e k.steropes.home.lab -n cp1.steropes.home.lab --talosconfig=./clusterconfig/talosconfig kubeconfig
```
