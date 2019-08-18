# Metrics for Kiwix
Kiwix &amp; openZIM software developement processes monitoring

We use [Grimoirelab](https://chaoss.github.io/grimoirelab/) to visualise several metrics on Kiwix devéloppement evolution. Datas are collect from our GitHub repositories of Kiwix and openZIM accounts (also called "project" in Grimoirelab).

Grimoirelab use [Elasticsearch and Kibana](https://www.elastic.co) to store datas and visualise theses on web dashboards. To populate effectively the databases from several sources (Git, Github, Gitlab, Mediawiki, RSS, Jenkins, Slack ...), Grimoirelab has developped modules to create a [toolchain](https://chaoss.github.io/grimoirelab-tutorial/basics/components.html) allows to update collect datas optimally. In addition of Elasticsearch database, a SQL database (MariaDB) is used to stored identities collected from GitHub. All of things is orchestrate with [Grimoire-Sirmordered](https://github.com/chaoss/grimoirelab-sirmordred) daemon. We can use also micro-mordered as command line interface to update datas manually.

Here we propose a docker based on a [docker image](https://github.com/chaoss/grimoirelab/tree/master/docker) proposed by Grimoirelab including Elasticksearch, MariaDB and Kibana (Dockerfile-full).

## Run


```
docker run -p 127.0.0.1:9200:9200 -p 127.0.0.1:5601:5601 -e GITHUB_TOKEN=<your token> -v $(pwd)/logs:/logs -v $(pwd)/es-data:/var/lib/elasticsearch -t kiwix/metrics
``
