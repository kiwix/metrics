# Metrics for Kiwix

Kiwix & openZIM software development processes monitoring

We use [Grimoirelab](https://chaoss.github.io/grimoirelab/) to
visualise several metrics on Kiwix developement evolution. Data are
collected from our Kiwix and openZIM repositories, also called
"projects" in Grimoirelab.

Grimoirelab uses [Elasticsearch and Kibana](https://www.elastic.co) to
store data and visualise these on web dashboards. To populate
effectively this database from several sources (Git, Github, Gitlab,
Mediawiki, RSS, Jenkins, Slack ...), Grimoirelab has developed modules
to create a
[toolchain](https://chaoss.github.io/grimoirelab-tutorial/basics/components.html)
to optimally update data collection. In addition to Elasticsearch, we
use an SQL database (MariaDB) to store identities collected from
GitHub. All of this is orchestrated with the
[Grimoire-Sirmordered](https://github.com/chaoss/grimoirelab-sirmordred)
daemon. We can also use micro-mordered as command line interface to
manually update data.

We propose a docker instance based on a [docker
image](https://github.com/chaoss/grimoirelab/tree/master/docker)
provided by Grimoirelab and including Elasticksearch, MariaDB and
Kibana (Dockerfile-full).

## Run

```bash
docker run -p 127.0.0.1:9200:9200 -p 127.0.0.1:5601:5601 -e GITHUB_TOKEN=<your token> -e PROJECT_NAME='Kiwix development metrics' -v $(pwd)/logs:/logs -v $(pwd)/es-data:/var/lib/elasticsearch -t kiwix/metrics
```

## Configuration

To configure the analisys by sirmordered, four files are used :

- infra.cfg
- dashboard.cfg
- project.cfg
- override.cfg

The configuration result is a concatenation of this files.

See https://github.com/chaoss/grimoirelab-sirmordred/blob/master/README.md for the syntax.

### projects.json

The list of repositories to analyze. The first level is the project. The second is the enriched module (git, github, cocom ...), et then the last is the list of repositories to analyze for this module. We must add repositories for each module.

### orgs.json

Lists of known organizations.

### identities.yaml

Add informations for authors, like email or link to github account

### aliases.json

aliases for enrich modules

###  menu.yaml
Configure the menu for Kibiter

### dashboard_overview.json

The dashboard show in first. To change this dashboard, fisrt turn off read-only mode :

`curl -X PUT "http://localhost:9200/.kibana/_settings" -H'Content-Type: application/json' -d '{ "index.blocks.read_only" : false }'`

Change the dashboard with [user
interface](https://metrics.kiwix.org/app/kibana#/dashboard/Overview?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1y,mode:quick,to:now))&_a=(viewMode:edit))
Don't forget to save.

Turn on read-only mode :

`curl -X PUT "http://localhost:9200/.kibana/_settings" -H'Content-Type: application/json' -d '{ "index.blocks.read_only" : true }'`

Generate `dashboard_overview.json` with Kidash :

`kidash --export dashboard_overview.json --dashboard Overview`

Finaly, replace `config/dashboard_overview.json` by the new exported file.

## Performances

- Initialization time : ~ 9 hours (cocom)
- Incremental update time : ~ 2 minutes (cocom)
- Elastic Search database size : ~ 8 Go

⚠️ A verbose log file at `/logs/all.log` grows indefinitely without a clear setting to control it. You may want to use `TRUNCATE_LOGS=y` environment variable to enable an hourly reset of all log files.