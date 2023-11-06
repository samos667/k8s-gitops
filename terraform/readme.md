# Deploy single-node k3s

```
terraform apply --auto-approve --var-file=vars.tfvars
cd ..
k apply -k kube/bootstrap/flux/ && k apply -f kube/clusters/steropes/flux/flux-install.yaml && k apply -f kube/clusters/steropes/flux/flux-repo.yaml
```
