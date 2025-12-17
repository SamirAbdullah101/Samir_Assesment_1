

## 🚀 Full-Stack Development and Observability Environment

This project utilizes Docker Compose to quickly deploy a comprehensive local environment featuring the Elastic Stack (Elasticsearch, Kibana), multiple databases, and a modern observability platform (Prometheus, Loki, Grafana).

### 📋 Prerequisites

* **Docker and Docker Compose:** Must be installed and running on your system (version 2.0+ recommended).
* **System Resources:** Ensure your Docker environment is allocated sufficient resources (Memory: 8GB+ recommended, CPU: 4+ cores) due to the resource demands of Elasticsearch and the databases.
* **Configuration Files:** The following files must be present in the project root directory:
* `.env` (Contains `STACK_VERSION`, `ES_PORT`, `ELASTIC_PASSWORD`, `KIBANA_PASSWORD`, etc.)
* `prometheus.yml` (Prometheus configuration)
* `loki-config.yml` (Loki configuration)
* `promtail-config.yml` (Promtail configuration)
* *The `seq-data` directory is for runtime data and will be created.*



## 🏗️ Stack Architecture Overview

The services are divided into three main categories and networked together via `elastic` and `loki` bridge networks.

### 1. The Elastic Stack (ELK/Security)

| Service | Image | Network | Ports | Description |
| --- | --- | --- | --- | --- |
| **`elastic-setup`** | `elasticsearch` | `elastic` | N/A | **Initializes** SSL certificates and sets the `kibana_system` user password. Runs once and exits. |
| **`es01`** | `elasticsearch` | `elastic` | `${ES_PORT}:9200` | Single-node Elasticsearch cluster. Stores all monitoring data, security logs, and application data. |
| **`kibana`** | `kibana` | `elastic` | `5601:5601` | Visualization layer for Elasticsearch data. Relies on the security setup completed by `elastic-setup`. |

### 2. Databases & Core Infrastructure

| Service | Image | Network | Ports | Description |
| --- | --- | --- | --- | --- |
| **`cassandra`** | `cassandra:4.1` | `elastic` | `9042:9042` | NoSQL Column-family database. |
| **`mongo`** | `mongo` | `elastic` | `27017:27017` | NoSQL Document database. |
| **`postgres`** | `postgres:16-alpine` | `elastic` | `5432:5432` | Relational SQL database. |
| **`redis`** | `redis:7.4-alpine` | `elastic` | `6379:6379` | In-memory data structure store/cache. |
| **`mailhog`** | `mailhog/mailhog` | `elastic` | `1025:1025`, `8025:8025` | Simple SMTP server for capturing and viewing test emails. |

### 3. Observability Platform (Logging & Monitoring)

| Service | Image | Network | Ports | Description |
| --- | --- | --- | --- | --- |
| **`grafana`** | `grafana/grafana` | `elastic`, `loki` | `3000:3000` | Visualization dashboard for Prometheus and Loki data. |
| **`loki`** | `grafana/loki` | `loki` | `3100:3100` | Log aggregation system optimized for cost-efficiency. |
| **`promtail`** | `grafana/promtail` | `loki` | N/A | Agent that ships local container logs to Loki. |
| **`seq`** | `datalust/seq` | `elastic` | `5341:80` | Structured logging server (useful for .NET/C# applications). |

---

## ▶️ Getting Started

### 1. Initial Cleanup (If Rerunning)

If you have run this stack previously and encountered errors, it is vital to clean up old volumes that might contain stale configuration or corrupted data (especially for Elasticsearch).

```bash
docker compose down
docker volume rm -f full-stack_certs full-stack_esdata01 full-stack_kibanadata

```

*Note: The `full-stack_` prefix may vary based on your directory name.*

### 2. Startup

Build and start all services in detached mode (`-d`):

```bash
docker compose up -d

```

### 3. Service Verification

Wait a few minutes for the Elasticsearch and database services to initialize. Use the logs command to check the status of Kibana:

```bash
docker compose logs -f kibana

```

You should wait until Kibana successfully connects to Elasticsearch and is ready to serve the UI.

## 🌐 Access Endpoints

Once all services are running, you can access the UIs via your browser:

| Service | URL | Default Credentials | Notes |
| --- | --- | --- | --- |
| **Kibana** | `https://localhost:5601` | `kibana_system` / `${KIBANA_PASSWORD}` | May require HTTPS due to the SSL setup. |
| **Grafana** | `http://localhost:3000` | `admin` / `admin` (change immediately) | Use this for viewing Loki/Prometheus data. |
| **Seq** | `http://localhost:5341` | N/A (Admin password is `admin123`) | Log ingestion endpoint is `http://localhost:5341/api/events`. |
| **MailHog UI** | `http://localhost:8025` | N/A | View emails caught by the SMTP server on port 1025. |
| **PostgreSQL** | `localhost:5432` | `admin` / `admin123` | Use a client like DBeaver or psql. |
| **MongoDB** | `localhost:27017` | `root` / `example` | Use a client like Mongo Express or Compass. |

---

*This document assumes all configuration and environment variables are correctly set in the required files (`.env`, `prometheus.yml`, etc.).*
