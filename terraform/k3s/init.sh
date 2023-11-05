mkdir /mnt/speed-data && mkdir /mnt/big-data

cat <<EOF >>/etc/fstab
/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1-part1 /mnt/speed-data ext4 defaults 0 2
/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi2-part1 /mnt/big-data ext4 defaults 0 2
EOF

mount -a

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server" sh -s - --flannel-backend none --disable-network-policy --disable=traefik --disable=local-storage --cluster-cidr=10.66.0.0/16 --service-cidr=10.67.0.0/16 --disable=servicelb --disable-kube-proxy

helm install cilium cilium/cilium --version 1.14.3 \
	--namespace kube-system \
	--set ipam.mode=cluster-pool \
	--set kubeProxyReplacement=true \
	--set k8sServiceHost=172.16.66.99 \
	--set k8sServicePort=6443 \
	--set hubble.relay.enabled=true \
	--set hubble.ui.enabled=true \
	--set hubble.peerService.clusterDomain=cluster \
	--set operator.replicas=1 \
	--set localRedirectPolicy=true \
	--set bpf.masquerade=true \
	--set bgpControlPlane.enabled=true \
	--set ipam.operator.clusterPoolIPv4PodCIDRList='10.66.0.0/16' \
	--set ipam.operator.clusterPoolIPv4MaskSize=18 \
	--set gatewayAPI.enabled=true \
	--set envoy.enabled=true

export GITHUB_TOKEN=
flux bootstrap github \
	--owner=samos667 \
	--cluster-domain=cluster \
	--repository=k8s \
	--branch=main \
	--token-auth \
	--private=true \
	--personal=true --path bootstrap
