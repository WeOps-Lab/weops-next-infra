#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM postgres:16-bullseye

LABEL POSTGRES_VERSION="16"
LABEL AGE_VERSION="PG16/v1.5.0-rc0"

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests bison build-essential \
    flex \
    postgresql-server-dev-16 \
    locales git && apt-get clean  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_COLLATE=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && git config --global http.sslVerify false \
    && git clone https://github.com/apache/age.git -b PG16/v1.5.0-rc0 --depth 1 /age && \
    cd /age && \
    make && make install && \
    cp /age/docker/docker-entrypoint-initdb.d/00-create-extension-age.sql /docker-entrypoint-initdb.d/00-create-extension-age.sql

WORKDIR /age

CMD ["postgres", "-c", "shared_preload_libraries=age"]