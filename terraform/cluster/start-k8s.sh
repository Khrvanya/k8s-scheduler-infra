gcloud container clusters get-credentials --project="saas-test-omfe" "scheduler-us-central1-a" --zone="us-central1-a"
gcloud compute ssh --project="shared-host-dev-n47z" "bastion-host-dev" --zone="us-central1-a" --tunnel-through-iap --ssh-flag="-4 -L8888:localhost:8888 -N -q -f"

# helm install -n monitoring my-prometheus prometheus-community/kube-prometheus-stack --create-namespace
helm upgrade --install --create-namespace -n scheduler custom-scheduler ../../k8s/second-scheduler/