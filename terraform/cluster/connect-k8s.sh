gcloud container clusters get-credentials --project="saas-test-omfe" "scheduler-us-central1-a" --zone="us-central1-a"
gcloud compute ssh --project="shared-host-dev-n47z" "bastion-host-dev" --zone="us-central1-a" --tunnel-through-iap --ssh-flag="-4 -L8888:localhost:8888 -N -q -f"

# k create ns monitoring && helm install -n monitoring my-prometheus prometheus-community/kube-prometheus-stack