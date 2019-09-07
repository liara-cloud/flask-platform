FROM python:3.7

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y --no-install-recommends python-dev python3-dev build-essential

ONBUILD COPY . .

ONBUILD RUN pip install --disable-pip-version-check --no-cache-dir -r requirements.txt \
  && pip install --disable-pip-version-check --no-cache-dir dj-database-url 'gunicorn==19.9.0' 'whitenoise==4.1.3'

ONBUILD ARG __FLASK_APPMODULE='app:app'
ONBUILD ENV __FLASK_APPMODULE=${__FLASK_APPMODULE}

CMD gunicorn $__FLASK_APPMODULE --bind 0.0.0.0:8000

EXPOSE 8000
