#!/bin/bash

# Find where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define DB path: one level up from script (project root)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_NAME="$PROJECT_ROOT/app.db"

# Go to script directory to find SQL files
cd "$SCRIPT_DIR" || { echo "❌ Cannot access script directory: $SCRIPT_DIR"; exit 1; }

# Find numbered SQL files in the script's folder
SQL_FILES=$(ls [0-9]*_*.sql 2>/dev/null | sort)

# Check if any SQL files exist
if [[ -z "$SQL_FILES" ]]; then
    echo "❌ No SQL files found in $SCRIPT_DIR matching: [0-9]*_*.sql"
    echo "💡 Use naming like: 001_auth.sql, 002_schema.sql"
    exit 1
fi

# Check if project root is writable
if [[ ! -w "$PROJECT_ROOT" ]]; then
    echo "❌ Cannot write to project root: $PROJECT_ROOT"
    echo "💡 Please fix permissions: chmod u+w '$PROJECT_ROOT'"
    exit 1
fi

# Remove existing DB if it exists
if [[ -f "$DB_NAME" ]]; then
    rm "$DB_NAME"
    echo "🗑️ Removed existing database: $DB_NAME"
fi

echo "🚀 Creating database in project root: $DB_NAME"
echo "📦 Applying SQL files from: $SCRIPT_DIR"

# Execute each SQL file in order
for sql_file in $SQL_FILES; do
    echo "  → Running: $sql_file"
    if sqlite3 "$DB_NAME" < "$sql_file"; then
        echo "     ✅ Success"
    else
        echo "     ❌ Failed to execute: $sql_file"
        exit 1
    fi
done

# Final confirmation
echo ""
echo "🎉 Database created successfully: $DB_NAME"
echo "📊 Tables:"
sqlite3 "$DB_NAME" ".tables"