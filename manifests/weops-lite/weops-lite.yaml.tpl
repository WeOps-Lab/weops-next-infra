apiVersion: apps/v1
kind: Deployment
metadata:
  name: weops-lite
  namespace: weops-lite
  labels:
    app: weops-lite
spec:
  replicas: 1
  selector:
    matchLabels:
      app: weops-lite
  template:
    metadata:
      labels:
        app: weops-lite
    spec:
      hostAliases:
      - ip: "${LAN_IP}"
        hostnames:
        - "keycloak.weops.com"
      containers:
      - name: weops-lite
        image: ccr.ccs.tencentyun.com/megalab/weops-lite
        env:
        - name: SECRET_KEY
          value: "weops-lite"
        - name: DEBUG
          value: "False"
        - name: DB_ENGINE
          value: "django.db.backends.postgresql"
        - name: DB_NAME
          value: "weops-lite"
        - name: DB_USER
          value: "postgres"
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: weops-lite-secret
              key: POSTGRES_PASSWORD
        - name: DB_HOST
          value: "age"
        - name: DB_PORT
          value: "5432"
        - name: ENABLE_CELERY
          value: "True"
        - name: CELERY_BROKER_URL
          value: "amqp://admin:${RABBITMQ_PASSWORD}@rabbitmq:5672"
        - name: CELERY_RESULT_BACKEND
          value: "db+postgresql://postgres:${POSTGRES_PASSWORD}@postgres/weops-lite"
        - name: CELERY_BEAT_SCHEDULER
          value: "django_celery_beat.schedulers:DatabaseScheduler"
        - name: SALT_API_URL
          value: ""
        - name: SALT_API_USERNAME
          value: ""
        - name: SALT_API_PASSWORD
          value: ""
        - name: KEYCLOAK_URL_API
          value: "http://keycloak.weops.com"
        - name: KEYCLOAK_URL
          value: "http://keycloak.weops.com"
        - name: KEYCLOAK_UI_CLIENT_ID
          value: "weops-lite-web"
        - name: KEYCLOAK_ADMIN_USERNAME
          value: "admin"
        - name: KEYCLOAK_ADMIN_PASSWORD
          valueFrom:
            secretKeyRef:
              name: weops-lite-secret
              key: KEYCLOAK_ADMIN_PASSWORD
        - name: KEYCLOAK_REALM
          value: "weops"
        - name: KEYCLOAK_CLIENT_ID
          value: "weops_lite"
        readinessProbe:
          exec:
            command: ["curl", "-f", "http://localhost:8000/"]
          initialDelaySeconds: 10
          periodSeconds: 10