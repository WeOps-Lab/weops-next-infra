> 以下文档仅提供开发测试使用

# 网络准备

```
docker network create dev
```

# Keycloak

## 万里开源版

### 启动

```
docker run --rm -itd --network dev \
    --name greatsql -e MYSQL_ROOT_PASSWORD=password \
    -p 3306:3306 greatsql/greatsql:8.0.32-26 \
    --sql_generate_invisible_primary_key=OFF

docker exec -it greatsql mysql -uroot -ppassword -e "CREATE DATABASE keycloak;"

docker run --rm -itd --network dev --name keycloak \
            -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=EiZ7ijo1taun \
            -e KC_PROXY=edge \
            -e KC_DB=mysql  \
            -e KC_DB_URL="jdbc:mysql://greatsql:3306/keycloak?useSSL=false" \
            -e KC_DB_USERNAME=root -e KC_DB_PASSWORD=password \
            -p 18080:8080 \
            weops-next/keycloak:23.0.5  start-dev
```

### 停止

```
docker stop greatsql && docker stop keycloak
```


## DKorn
```
docker run -itd --rm --network dev -itd -p 18081:8080 --name dkron dkron/dkron:4.0.0 agent --server --bootstrap-expect=1 --node-name=node1
```