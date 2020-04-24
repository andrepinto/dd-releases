curl -sfL https://get.k3s.io | sh -
chmod 777  /etc/rancher/k3s/k3s.yaml
sudo snap install helm --classic
sudo snap install fluxctl --classic
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add fluxcd https://charts.fluxcd.io
kubectl create ns fluxcd

helm upgrade -i flux fluxcd/flux --wait \
> --namespace fluxcd \
> --set git.url=git@github.com:andrepinto/dd-releases

kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm upgrade -i helm-operator fluxcd/helm-operator --wait \
--namespace fluxcd \
--set git.ssh.secretName=flux-git-deploy \
--set helm.versions=v3


#fluxctl identity --k8s-fwd-ns fluxcd
#In order to sync your cluster state with Git you need to copy the public key and create a deploy key with write access on your GitHub repository.
