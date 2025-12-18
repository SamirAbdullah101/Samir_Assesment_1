#!/bin/bash

# ===== CONFIG =====
DB_NAME="PracticeDatabase"
BACKUP_DIR="/home/user/pg_backups"
RETENTION_DAYS=7
LOCK_FILE="/tmp/${DB_NAME}_backup.lock"

# ===== CRITICAL SECTION HANDLING =====
# We use a file descriptor (200) to manage the lock.
# The "-n" flag means "non-blocking": if the lock is held, exit immediately.
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    echo "Error: Another backup instance is already running. Exiting."
    exit 1
fi

# Everything below this line is now "Thread Safe"
# --------------------------------------------------

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"

# ===== PREP =====
mkdir -p "$BACKUP_DIR"

# ===== BACKUP =====
echo "Starting backup for $DB_NAME..."
pg_dump -U postgres -h localhost -p 5432 "$DB_NAME" | gzip > "$BACKUP_FILE"

# ===== RETENTION =====
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -type f -name "${DB_NAME}_*.sql.gz" -mtime +"$RETENTION_DAYS" -delete

echo "Backup completed successfully."

# The lock is automatically released when the script finishes or the FD is closed
