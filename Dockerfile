FROM grimoirelab/full

ENV GITHUB_TOKEN=xxx

	   
USER root

RUN apt-get update && apt-get -y install --no-install-recommends cloc

COPY projects.json /projects.json
COPY menu.yaml /menu.yaml
COPY dashboard_overview.json /dashboard_overview.json

COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod 755 /entrypoint.sh

#VOLUME /var/lib/elasticsearch

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-c", "/infra.cfg", "/dashboard.cfg", "/project.cfg", "/override.cfg"]

