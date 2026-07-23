@echo off
REM Script to export the ecommerce_db database for Windows
REM This will create a complete SQL dump with all data

REM Database credentials (override by setting env vars before running)
if not defined DB_USER set DB_USER=root
if not defined DB_PASSWORD set DB_PASSWORD=
if not defined DB_NAME set DB_NAME=ecommerce_db
if not defined DB_PORT set DB_PORT=3306

REM Output file
set OUTPUT_FILE=database\ecommerce_db_export.sql

echo Exporting database %DB_NAME%...

REM Export the database using mysqldump (must be on PATH or set MYSQLDUMP_PATH)
if not defined MYSQLDUMP_PATH set MYSQLDUMP_PATH=mysqldump
"%MYSQLDUMP_PATH%" -u %DB_USER% -p%DB_PASSWORD% -P %DB_PORT% --single-transaction --routines --triggers --databases %DB_NAME% > %OUTPUT_FILE%

if %ERRORLEVEL% EQU 0 (
    echo Database exported successfully to %OUTPUT_FILE%
) else (
    echo Error exporting database
    exit /b 1
)
