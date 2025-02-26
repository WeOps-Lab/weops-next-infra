#!/bin/bash
kubectl delete ns prod-system-manager
kubectl delete ns prod-keycloak
kubectl delete ns prod-nats
rm -vf keycloak/overlays/prod/keycloak.env
rm -vf postgres/overlays/system-manager/postgres.env
rm -vf postgres/overlays/keycloak/postgres.env
rm -vf system-manager/overlays/prod/system-manager.env
rm -vf nats/overlays/prod/nats-server.env