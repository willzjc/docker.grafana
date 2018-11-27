ARG DOCKER_PREFIX=docker.artifactory.ai.cba/library/
FROM ${DOCKER_PREFIX}ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    # Basic framework
    sudo \
    coreutils \
    rsync \
    procps \
    less \
    grep \
    sed \
    nano \
    util-linux \
    locales \
    iproute2 \
    oddjob-mkhomedir \
    # host framework
    dnsutils \
    net-tools \
    inetutils-ping \
    inetutils-traceroute \
    arping \
    tcpdump \
    tcptraceroute \
    telnet \
    tzdata \
    less \
    lsof \
    ca-certificates \
    # init system
    runit \
    # system
    nginx-extras \
    fcgiwrap \
    syslog-ng \
    # authentication stack
    openssh-server \
    sssd \
    sssd-ldap \
    sssd-ad \
    libpam-sss \
    libnss-sss \
    libsasl2-2 \
    libsasl2-modules-ldap \
    sasl2-bin \
    krb5-user \
    netcat-openbsd \
    pamtester \
    mysql-client \
    wget \
    vim \
    jq \
    curl \
    openjdk-8-jdk \
    hadoop-client \
    python3 \
    python-pip \
    python-dev \
    python3-pip && \
    # Templating engine
    wget -O /usr/local/bin/p2 $URL_P2CLI && \
    chmod +x /usr/local/bin/p2 && \
    # Cleanup
    apt-get autoremove -y && \
    # Delete nginx default configuration.
    rm -rf /etc/nginx/sites-enabled /etc/nginx/sites-available /etc/nginx/snippets /etc/nginx/conf.d && \
    # Delete pam_access default config
    rm -f /etc/security/access.conf \
    # Delete kerberos default config
    rm -f /etc/krb5.conf \
    # Delete sssd default config
    rm -f /etc/sssd/sssd/conf

ARG GF_UID="472"
ARG GF_GID="472"
ARG GRAFANA_URL=grafana-latest.linux-x64.tar.gz
COPY tree /
COPY grafana-latest.linux-x64.tar.gz /grafana-latest.linux-x64.tar.gz

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN apt-get install -y --allow-unauthenticated && apt-get install -qq -y tar libfontconfig curl ca-certificates

RUN mkdir -p "$GF_PATHS_HOME/.aws" && \
    cat "/$GRAFANA_URL" | tar xfvz - --strip-components=1 -C "$GF_PATHS_HOME" && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g $GF_GID grafana && \
    useradd -r -u $GF_UID -g grafana grafana && \
    mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_LOGS" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_DATA" && \
    cp "$GF_PATHS_HOME/conf/sample.ini" "$GF_PATHS_CONFIG" && \
    cp "$GF_PATHS_HOME/conf/ldap.toml" /etc/grafana/ldap.toml && \
    chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" && \
    chmod 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS"

EXPOSE 3000

COPY ./run.sh /run.sh

USER grafana
WORKDIR /
ENTRYPOINT [ "/run.sh" ]
