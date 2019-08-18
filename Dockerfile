FROM grimoirelab/full

ENV GITHUB_TOKEN=xxx

	   
USER root

COPY projects.json /projects.json

COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod 755 /entrypoint.sh

#VOLUME /var/lib/elasticsearch

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-c", "/infra.cfg", "/dashboard.cfg", "/project.cfg", "/override.cfg"]

