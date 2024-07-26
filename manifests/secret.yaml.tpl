apiVersion: v1
kind: Secret
metadata:
  name: weops-lite-secret
  namespace: weops-lite
type: Opaque
stringData:
  KEYCLOAK_ADMIN_PASSWORD: "${KEYCLOAK_ADMIN_PASSWORD}"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
  RABBITMQ_PASSWORD: "${RABBITMQ_PASSWORD}"
  REDIS_PASSWORD: "${REDIS_PASSWORD}"
