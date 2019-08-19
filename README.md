# Metrics for Kiwix
Kiwix &amp; openZIM software development processes monitoring

We use [Grimoirelab](https://chaoss.github.io/grimoirelab/) to visualise several metrics on Kiwix developement evolution. Data are collected from our Kiwix and openZIM repositories, also called "projects" in Grimoirelab.

Grimoirelab uses [Elasticsearch and Kibana](https://www.elastic.co) to store data and visualise these on web dashboards. To populate effectively this database from several sources (Git, Github, Gitlab, Mediawiki, RSS, Jenkins, Slack ...), Grimoirelab has developed modules to create a [toolchain](https://chaoss.github.io/grimoirelab-tutorial/basics/components.html) to optimally update data collection. In addition to Elasticsearch, we use an SQL database (MariaDB) to store identities collected from GitHub. All of this is orchestrated with the [Grimoire-Sirmordered](https://github.com/chaoss/grimoirelab-sirmordred) daemon. We can also use micro-mordered as command line interface to manually update data.

We propose a docker instance based on a [docker image](https://github.com/chaoss/grimoirelab/tree/master/docker) provided by Grimoirelab and including Elasticksearch, MariaDB and Kibana (Dockerfile-full).

## Run


```
docker run -p 127.0.0.1:9200:9200 -p 127.0.0.1:5601:5601 -e GITHUB_TOKEN=<your token> -v $(pwd)/logs:/logs -v $(pwd)/es-data:/var/lib/elasticsearch -t kiwix/metrics
```

## Dashboard screenshots

![Backlog dashboard](screenshot-dashboard-backlog.png)
![CoCom dashboard 1/2](screenshot-dashboard-cocom1.png)
![CoCom dashboard 2/2](screenshot-dashboard-cocom2.png)
