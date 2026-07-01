#!/bin/sh

set -e

until nc -z postgres 5432
do
  echo "Waiting for postgres..."
  sleep 2
done

exec /bin/goose \
    -dir "$MIGRATIONS_DIR" \
    postgres \
    "$DATABASE_DSN" \
    up