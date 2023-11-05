# Deploy single-node k3s

```
terraform apply --auto-approve --var-file=vars.tfvars
cilium status --wait
kubectl apply -k ../cluster/production/
```
