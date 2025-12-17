
---

# 🐘 PostgreSQL Backup Automation Script (`pg_backup.sh`)

This script automates the process of creating compressed backups for a specific PostgreSQL database and manages file retention to prevent storage overflow.

## 🚀 Key Features

* **Database Dump:** Uses `pg_dump` to create a logical backup of a single database.
* **Compression:** Compresses the backup using `gzip` (resulting in a `.sql.gz` file).
* **Timestamping:** Names files with a date and time stamp for easy identification.
* **Retention Policy:** Automatically deletes files older than a configured number of days (`RETENTION_DAYS`).
* **Crontab Ready:** Designed to run non-interactively via the system scheduler.

## ⚙️ Setup and Configuration

### 1. Prerequisites

Ensure the following are installed on the host machine where the script will run:

* **PostgreSQL Client Utilities:** (specifically `pg_dump`).
* **Gzip:** Standard compression utility.
* **Cron:** For scheduling the script.

### 2. Configure the Script

Edit the following environment variables at the top of the `pg_backup.sh` file to match your environment:

| Variable | Description | Example Value |
| --- | --- | --- |
| `DB_NAME` | The exact name of the PostgreSQL database to back up. | `"PracticeDatabase"` |
| `BACKUP_DIR` | The **absolute path** where the compressed backup files will be stored. | `"/home/user/pg_backups"` |
| `RETENTION_DAYS` | The number of days to keep backups. Files older than this are deleted. | `7` |

### 3. PostgreSQL Authentication (CRITICAL)

Since the script runs non-interactively via cron, you must configure passwordless authentication for the `postgres` user. The recommended and most secure method is using the **`.pgpass` file**.

1. **Create the `.pgpass` file** in the home directory of the user running the cron job (e.g., `/home/user/.pgpass`).
```bash
touch ~/.pgpass
chmod 600 ~/.pgpass # Set secure permissions

```


2. **Add Authentication Details:** Insert the connection details into the file using the format: `hostname:port:database:username:password`
```
# Content of ~/.pgpass
localhost:5432:PracticeDatabase:postgres:YOUR_POSTGRES_PASSWORD

```


*Replace `YOUR_POSTGRES_PASSWORD` with the actual password.*

### 4. Set Script Permissions

Grant execute permission to the script:

```bash
chmod +x /home/user/Scripts/pg_backup.sh

```

## 🗓️ Scheduling with Crontab

This step automates the script to run on a regular schedule.

### 1. Edit the Crontab File

Open the crontab for the user who will run the backups:

```bash
crontab -e

```

### 2. Add the Cron Job

Append the following line to schedule the script to run daily at 12 minutes past every hour (`* 12 * * *`) and redirect its output (including errors) to a log file.

| Part | Description |
| --- | --- |
| `* 12 * * *` | **Schedule:** Runs at 12 minutes past every hour. |
| `/path/to/script.sh` | **Command:** The absolute path to your script. |
| `>> /path/to/log.log 2>&1` | **Logging:** Appends standard output (`>>`) and standard error (`2>&1`) to a log file. |

**Example Crontab Line (To run daily at 3:00 AM):**

```crontab
0 3 * * * /home/user/Scripts/pg_backup.sh >> /home/user/pg_backup.log 2>&1

```

**Your Original Crontab Line:**

```crontab
* 12 * * * /home/user/Scripts/pg_backup.sh >> /home/user/pg_backup.log 2>&1

```

---

**Note:** If you are running PostgreSQL inside a Docker container, `localhost` and `5432` may not work. You would need to use the container's internal service name and expose the port to the host machine or use a static IP as a connection point.

## 📜 `pg_backup.sh` Full Content

For reference, the script performs the following steps:

```bash
#!/bin/bash

# ===== CONFIG =====
DB_NAME="PracticeDatabase"
BACKUP_DIR="/home/user/pg_backups"
RETENTION_DAYS=7

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"

# ===== PREP =====
mkdir -p "$BACKUP_DIR"

# ===== BACKUP =====
pg_dump -U postgres -h localhost -p 5432 "$DB_NAME" | gzip > "$BACKUP_FILE"

# ===== RETENTION =====
find "$BACKUP_DIR" -type f -name "${DB_NAME}_*.sql.gz" -mtime +"$RETENTION_DAYS" -delete

```
