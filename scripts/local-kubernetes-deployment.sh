#!/usr/bin/env bash

export KUBE_NAMESPACE=my-hello-world-app

export KUBE_DEPLOYMENT_NAME=my-hello-world-app-deployment
export KUBE_APP_NAME=my-hello-world-app-app
export KUBE_IMAGE_NAME=my-hello-world-app:latest
export KUBE_CONTAINER_PORT=8080

export KUBE_IMAGE_PULL_POLICY=Never

export KUBE_INGRESS_NAME=my-hello-world-app-ingress
export KUBE_PUBLIC_APP_DOMAIN=recommender.lvh.me
export KUBE_SERVICE_NAME=my-hello-world-app-service
export KUBE_SERVICE_EXTERNAL_PORT=9090

envsubst < ./kubernetes/namespace.yaml | kubectl apply -f -
envsubst < ./kubernetes/secret.yaml | kubectl apply -f -
envsubst < ./kubernetes/deployment.yaml | kubectl apply -f -
envsubst < ./kubernetes/service.yaml | kubectl apply -f -
envsubst < ./kubernetes/ingress.yaml | kubectl apply -f -

# Force to update images and relaunch with the new version
kubectl --namespace $KUBE_NAMESPACE scale --replicas=0 deployment --all
kubectl --namespace $KUBE_NAMESPACE scale --replicas=1 deployment --all
