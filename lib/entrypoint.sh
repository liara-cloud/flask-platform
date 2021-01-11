#!/bin/bash

set -e

mkdir -p /run/liara

python3 /usr/local/lib/liara/load_profile.py

# Start cron service
if [ ! -z "$__CRON" ]; then
  echo '[CRON] Starting...';
  supercronic ${SUPERCRONIC_OPTIONS} /run/liara/crontab &
fi

# Let's start our webserver
gunicorn $__FLASK_APPMODULE --bind 0.0.0.0:8000 \
  --access-logfile '-' \
  --timeout ${GUNICORN_TIMEOUT:-30} \
  --log-level ${GUNICORN_LOG_LEVEL:-info}
