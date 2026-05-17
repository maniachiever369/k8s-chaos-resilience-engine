#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

printf "${CYAN}🚀 Initializing Kubernetes Chaos Resilience Engine...${NC}\n"
printf "${CYAN}🎯 Targeting Deployment: payment-api${NC}\n"
printf "--------------------------------------------------\n"

while true; do
  TARGET_POD=$(kubectl get pods -l app=payment-api --field-selector=status.phase=Running -o jsonpath='{.items.metadata.name}' 2>/dev/null)

  if [ -z "$TARGET_POD" ]; then
    printf "${RED}⚠️ No active running pods found. Waiting for cluster stabilization...${NC}\n"
    sleep 5
    continue
  fi

  printf "${RED}💥 Chaos Triggered! Killing Production Container: ${TARGET_POD}${NC}\n"
  kubectl delete pod "$TARGET_POD" --grace-period=0 --force >/dev/null 2>&1

  printf "${GREEN}⏳ Attack complete. Giving the cluster 15 seconds to self-heal...${NC}\n"
  printf "--------------------------------------------------\n"
  sleep 15
done

