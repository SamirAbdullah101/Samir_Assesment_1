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

