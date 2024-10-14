# install aws-cli eksctl kubectl helm

# Create cluster
```bash
eksctl create cluster --name=<cluster-name> \
			--region=us-east-1 \
			--without-nodegroup \
			--vpc-public-subnets=<public-subnet-1>,<public-subnet-2>
			--vpc-private-subnets=<private-subnet-1>,<private-subnet-2>
```

# download kube config to local machine (incase kube\eks cmd not working)
```bash
aws eks update-kubeconfig --region us-east-1 --name carmel_yoram_eks_cluster
```

# Gives IAM ROLE to cluster
```bash
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster <cluster-name> \
    --approve
```

# Create Nodegroup
```
eksctl create nodegroup --cluster=<cluster-name> \
                       	--region=us-east-1 \
                       	--name=<nodegroup-name> \
                       	--node-type=t2.medium \
                       	--nodes=2 \
                       	--nodes-min=2 \
                       	--nodes-max=2 \
                       	--node-volume-size=20 \
                       	--ssh-access \
                       	--ssh-public-key=<ssh-private-key> \
                       	--managed \
                       	--asg-access \
                       	--external-dns-access \
                       	--full-ecr-access \
                       	--appmesh-access \
                       	--alb-ingress-access \
 			--node-private-networking \
  			--subnet-ids=[subnet-xxx]
```

# Download IAM Policy
```bash
curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```

# Create IAM Policy using policy downloaded (arn:aws:iam::992382545251:policy/AWSLoadBalancerControllerIAMPolicy)
```bash
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json
```

# Verify if any IAM Service Accounts present in EKS Cluster
```bash
eksctl get iamserviceaccount --cluster=yoram-test
```
# create service account
```bash
eksctl create iamserviceaccount \
  --cluster=<cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::992382545251:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```
# Describe Service Account aws-load-balancer-controller
```bash
kubectl describe sa aws-load-balancer-controller -n kube-system
```

# Add the eks-charts repository.
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

# Install the AWS Load Balancer Controller.
```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region-code> \
  --set vpcId=<vpc-xxxxxxxx> \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller # do not change this line 
```
	
# Verify that the controller is installed.
```bash
kubectl -n kube-system get deployment aws-load-balancer-controller
```

# Verify AWS Load Balancer Controller Webhook service created 
```bash
kubectl -n kube-system get svc aws-load-balancer-webhook-service
```

# Apply & Verify IngressClass Resource
```bash
kubectl apply -f <ingress-class-resource-yaml>
```

# Create Deployment, Service and Ingress yamls
```bash
kubectl apply -f <yaml-files>
```

- Check that ALB is up and running in the web

# When finished and need to delete the cluster
```bash
kubectl delete -f <all-yamls>
helm uninstall aws-load-balancer-controller -n kube-system  # Uninstall AWS Load Balancer Controller
eksctl get clusters
eksctl get nodegroup --cluster=<clusterName>
eksctl delete nodegroup --cluster=<clusterName> --name=<nodegroupName>
eksctl delete cluster <clusterName>
```bash

########## optional ##########
```bash
# log pods (-f follow)
kubectl logs -f <pod-name>

# cheetsheet
https://kubernetes.io/docs/reference/kubectl/quick-reference/
kubectl get service <service or deploy> -o yaml # shows yaml file
```

