FROM openjdk:21
WORKDIR /opt
ADD ./keycloak-26.1.0.tar /opt
RUN mv /opt/keycloak-26.1.0 /opt/keycloak
ADD ./theme /opt/keycloak/themes/weops-lite
ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]