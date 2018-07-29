#!/bin/bash
default=$(kubectl get secrets | grep default | sed -e 's/ .*$//g')
printf "API URL\n"
kubectl cluster-info | grep master
printf "\nCertificate\n"
kubectl get secrets $default -o jsonpath="{['data']['ca\.crt']}" | base64 -d
printf "\nToken\n"
kubectl get secrets $default -o jsonpath="{['data']['token']}" | base64 -d
printf "\n\n"
