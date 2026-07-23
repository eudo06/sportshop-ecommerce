#!/bin/bash

# Script to export the ecommerce_db database
# This will create a complete SQL dump with all data

# MySQL binaries (fallback to PATH if not set)
MYSQL_PATH="${MYSQL_PATH:-mysql}"
MYSQLDUMP_PATH="${MYSQLDUMP_PATH:-mysqldump}"

# Database credentials (override with env vars if needed)
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"  # leave empty if no password
DB_NAME="${DB_NAME:-ecommerce_db}"
DB_PORT="${DB_PORT:-3306}"

# Output file (in same directory as script)
OUTPUT_FILE="ecommerce_db_export.sql"

echo "Exporting database $DB_NAME..."

# Export the database, including CREATE DATABASE and USE statements.
$MYSQLDUMP_PATH -u "$DB_USER" -p"$DB_PASSWORD" -P "$DB_PORT" --single-transaction --routines --triggers --databases "$DB_NAME" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Database exported successfully to $OUTPUT_FILE"
    echo "File size: $(du -h $OUTPUT_FILE | cut -f1)"
else
    echo "Error exporting database"
    exit 1
fi
