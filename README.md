# Metrics for Kiwix
Kiwix &amp; openZIM software developement processes monitoring

We use Grimoirelab to visualise several metrics on Kiwix devéloppement evolution. Datas are collect from our GitHub repositories of Kiwix and Openzim account (also called "project" in Grimoirelab).

Grimoirelab use Elasticsearch and Kibana to store datas and visualise thesesi on web dashboards. To populate effectively the databases from several sources (Git, Github, Gitlab, RSS, Jenkins, Slack ...), Grimoirelab has developped modules to create a toolchain allows to update collect datas optimally. In addition of Elasticsearch database, a SQL database (MariaDB) is used to stored identities colelcted from GitHub. All of things is orchestrate with Grimoire-Sirmordered daemon. We can use also micro-mordered as command line interface to update datas manually.

Here we propose a docker based on the Dockerfile-full proposed by Grimoirelab to visualise several Kiwix developpement metrics.

## Run


```
docker run -p 127.0.0.1:9200:9200 -p 127.0.0.1:5601:5601 -e GITHUB_TOKEN=<your token> -v $(pwd)/logs:/logs -v $(pwd)/es-data:/var/lib/elasticsearch -t kiwix/metrics
``
