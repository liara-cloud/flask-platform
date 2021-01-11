FROM python:3.7

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install -y --no-install-recommends python-dev python3-dev build-essential

COPY --from=liaracloud/supercronic:v0.1.11 /usr/local/bin/supercronic /usr/local/bin/supercronic

COPY lib/* /usr/local/lib/liara/

ONBUILD COPY . .

ONBUILD RUN pip install --disable-pip-version-check --no-cache-dir -r requirements.txt \
  && pip install --disable-pip-version-check --no-cache-dir 'gunicorn==19.9.0'

ENV ROOT=/usr/src/app

ONBUILD ARG __CRON
ONBUILD ARG __FLASK_APPMODULE='app:app'
ONBUILD ARG __FLASK_TIMEZONE=Asia/Tehran
ONBUILD ENV __FLASK_APPMODULE=${__FLASK_APPMODULE} \
            TZ=${__FLASK_TIMEZONE} \
            __CRON=${__CRON}

ONBUILD RUN echo '> Configuring timezone:' $TZ && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  echo $TZ > /etc/timezonero

CMD /usr/local/lib/liara/entrypoint.sh

EXPOSE 8000
