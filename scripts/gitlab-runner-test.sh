#!/usr/bin/env bash

gitlab-runner exec docker\
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock\
  --docker-privileged\
  --env GC_PROJECT_ID="$(<./secrets/gc-project-id.txt)"\
  --env GC_EXAMPLE_SECRET="$(<./secrets/example-secret.json)"\
  --env GC_SERVICE_ACCOUNT_KEY="$(<./secrets/gc-service-account-key.json)"\
  --env GC_CLUSTER_NAME="standard-cluster-1"\
  --env GC_ZONE="us-west1-b"\
  --env GC_BASE_DOMAIN="$GC_BASE_DOMAIN"\
  review_deploy
