# GPLv3 License
#
# The container produced with this file contains all
# GrimoireLab libraries and executables, and is configured
# for running mordred by default
#

FROM debian:stretch-slim
MAINTAINER Kiwix <contact@kiwix.org>

ENV DEBIAN_FRONTEND=noninteractive
ENV DEPLOY_USER=grimoirelab
ENV DEPLOY_USER_DIR=/home/${DEPLOY_USER}
ENV DIST_SCRIPT=/usr/local/bin/build_grimoirelab \
    LOGS_DIR=/logs \
    DIST_DIR=/dist
ENV REL_FILE=/releases.cfg
ENV ES=elasticsearch-6.1.4
ENV KB_VERSION=6.1.4-1
ENV KB_TAG=community-v${KB_VERSION}
ENV KB=kibiter-${KB_VERSION}
ENV KB_DIR=${KB}-linux-x86_64
ENV GITHUB_TOKEN=xxx
ENV GET=wget -q

# install dependencies
RUN mkdir /usr/share/man/man1 && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        bash locales \
        gcc \
        git git-core \
        pandoc \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        python3-gdbm \
        mariadb-client \
        unzip curl wget sudo ssh \
        openjdk-8-jdk-headless \
        net-tools \
        mariadb-server cloc \
        && \
    apt-get clean && \
    find /var/lib/apt/lists -type f -delete
    
# Initial user and dirs
RUN useradd ${DEPLOY_USER} --create-home --shell /bin/bash ; \
    echo "${DEPLOY_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers ; \
    mkdir ${DIST_DIR} ; chown -R ${DEPLOY_USER}:${DEPLOY_USER} ${DIST_DIR} ; \
    mkdir ${LOGS_DIR} ; chown -R ${DEPLOY_USER}:${DEPLOY_USER} ${LOGS_DIR}
    
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    LANG=C.UTF-8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Add script to create distributable packages
COPY config/releases.cfg ${REL_FILE}
COPY bin/build_grimoirelab ${DIST_SCRIPT}
RUN chmod 755 ${DIST_SCRIPT}

# Add packages (should be in dist, when building)
COPY dist/* ${DIST_DIR}/

# Unbuffered output for Python, so that we see messages as they are produced
ENV PYTHONUNBUFFERED 0

# Install GrimoireLab from packages in DIST_DIR
RUN ${DIST_SCRIPT} --build --install --install_system --distdir ${DIST_DIR} --relfile ${REL_FILE} 
# Install ElasticSearch
RUN ${GET} https://artifacts.elastic.co/downloads/elasticsearch/${ES}.deb && \
    ${GET} https://artifacts.elastic.co/downloads/elasticsearch/${ES}.deb.sha512 && \
    sudo dpkg -i ${ES}.deb && \
    rm ${ES}.deb ${ES}.deb.sha512
RUN sed -e "/MAX_MAP_COUNT=/s/^/#/g" -i /etc/init.d/elasticsearch && \
    echo "http.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml && \
    echo "cluster.routing.allocation.disk.watermark.flood_stage: 99.9%" >> /etc/elasticsearch/elasticsearch.yml && \
    echo "cluster.routing.allocation.disk.watermark.low: 99.9%" >> /etc/elasticsearch/elasticsearch.yml && \
    echo "cluster.routing.allocation.disk.watermark.high: 99.9%" >> /etc/elasticsearch/elasticsearch.yml
EXPOSE 9200

# Configure MariaDB
RUN echo "mysqld_safe &" > /tmp/config && \
    echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
    echo "mysql -e 'CREATE USER grimoirelab;'" >> /tmp/config && \
    echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"grimoirelab\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
    bash /tmp/config && \
    rm -f /tmp/config && \
    sed -e "/bind-address/s/^/#/g" -i /etc/mysql/mariadb.conf.d/50-server.cnf
    
EXPOSE 3306

USER ${DEPLOY_USER}
WORKDIR ${DEPLOY_USER_DIR}

# Install Kibana (as DEPLOY_USER)
RUN ${GET} https://github.com/grimoirelab/kibiter/releases/download/${KB_TAG}/${KB_DIR}.tar.gz && \
    tar xzf ${KB_DIR}.tar.gz && \
    rm ${KB_DIR}.tar.gz && \
    sed -e "s|^#server.host: .*$|server.host: 0.0.0.0|" -i ${KB_DIR}/config/kibana.yml
# Run Kibana until optimization is done, to avoid optimizing every
# time the image is run
RUN ${KB_DIR}/bin/kibana 2>&1 | grep -m 1 "Optimization of .* complete in .* seconds"

RUN sudo /etc/init.d/elasticsearch start && \
    ${KB_DIR}/bin/kibana 2>&1 > /dev/null & \
    ( until $(curl --output /dev/null --silent --fail http://127.0.0.1:9200/.kibana/config/_search ); do \
        printf '.' && \
        sleep 2 && \
        curl -XPOST "http://127.0.0.1:5601/api/kibana/settings/indexPattern:placeholder" \
          -H 'Content-Type: application/json' -H 'kbn-version: '${KB_VERSION} \
          -H 'Accept: application/json' -d '{"value": "*"}' \
          --silent --output /dev/null ; \
    done )

EXPOSE 5601

USER root

# Add default mordred configuration files
COPY config/mordred-infra.cfg /infra.cfg
COPY config/mordred-dashboard.cfg /dashboard.cfg
COPY config/mordred-project.cfg /project.cfg
COPY config/mordred-override.cfg /override.cfg
COPY config/orgs.json /orgs.json
COPY config/projects.json /projects.json
COPY config/identities.yaml /identities.yaml
COPY config/menu.yaml /menu.yaml
COPY config/aliases.json /aliases.json
COPY config/dashboard_overview.json /dashboard_overview.json

COPY bin/entrypoint.sh /entrypoint.sh
RUN sudo chmod 755 /entrypoint.sh

#VOLUME /var/lib/elasticsearch

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-c", "/infra.cfg", "/dashboard.cfg", "/project.cfg", "/override.cfg"]

