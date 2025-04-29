#!/bin/bash
set -e

echo "Waiting for postgres..."

# sleeps until connected to postgres db
while ! nc -z postgres 5432; do
  sleep 0.5
done

echo "Postgres is up - starting FastAPI"

exec uvicorn cc_compose.server:app --host 0.0.0.0 --port 8000 --reload