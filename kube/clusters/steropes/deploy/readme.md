# Bootstrap Steropes

Don't forget to populate terraform/vars.tfvars

```
# From kube/clusters/steropes/deploy/

cd terraform && terraform apply -auto-approve --var-file=vars.tfvars && cd ../talos
talhelper genconfig && talosctl apply-config --insecure -n cp1.steropes.home.lab --file clusterconfig/steropes-cp1.steropes.home.lab.yaml
talosctl -e k.steropes.home.lab -n cp1.steropes.home.lab --talosconfig=./clusterconfig/talosconfig bootstrap
talosctl -e k.steropes.home.lab -n cp1.steropes.home.lab --talosconfig=./clusterconfig/talosconfig kubeconfig
```

**TODO** (Need to AIO all these steps)
After that deploy CNI **{{ REPLACE_THIS }}**

```
k create -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/experimental-install.yaml
helm install cilium cilium/cilium \
        --namespace kube-system \
        --set ipam.mode=cluster-pool \
        --set kubeProxyReplacement=true \
        --set k8sServiceHost=localhost \
        --set k8sServicePort=7445 \
        --set hubble.relay.enabled=true \
        --set hubble.ui.enabled=true \
        --set operator.replicas=1 \
        --set localRedirectPolicy=true \
        --set bpf.masquerade=true \
        --set bgpControlPlane.enabled=true \
        --set ipam.operator.clusterPoolIPv4PodCIDRList='{{ POD_CIDR }}' \
        --set ipam.operator.clusterPoolIPv4MaskSize={{ MASK_SIZE_PER_NODE }} \
        --set gatewayAPI.enabled=true \
        --set envoy.enabled=true \
        --set envoy.enabled=true \
        --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
        --set=securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
        --set=cgroup.autoMount.enabled=false \
        --set=cgroup.hostRoot='/sys/fs/cgroup'
```

Deploy Flux

```
cd ../../../../
k apply -k bootstrap/flux/
sops -d clusters/steropes/flux/secrets-ssh.sops.yaml | k create -f -
sops -d clusters/steropes/flux/secrets-age.sops.yaml | k create -f -
k create -f clusters/steropes/flux/flux-install.yaml
k create -f clusters/steropes/flux/flux-repo.yaml

```
