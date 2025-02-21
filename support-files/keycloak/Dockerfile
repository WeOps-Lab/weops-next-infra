FROM openjdk:21
WORKDIR /opt
ADD ./keycloak-26.1.0.tar /opt
RUN mv /opt/keycloak-26.1.0 /opt/keycloak
ADD ./theme/weops-lite /opt/keycloak/themes/weops-lite

ADD ./provider/keycloak-auth.jar /opt/keycloak/providers/keycloak-auth.jar

ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]