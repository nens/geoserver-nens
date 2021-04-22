Geoserver with N&S defaults
===========================

Docker setup for the geoservers we run at `Nelen & Schuurmans
<https://www.nelen-schuurmans.nl>`_.


Current test server
-------------------

It ought to move to a kubernetes cluster with some automatic scaling at the end, but for now....

https://geoserver-test.lizard.net

Installed on p-liz-geo-atlas-01.external-nens.local with docker-compose. Tomcat on ``8080``, postgres (in docker) on ``5432``.
Todo: arrange access to postgres.

Postgres: username ``geoserver``, database ``geoserver``. Password is in the docker-compose...

Geoserver: user ``admin``, password ``geoserver`` for now. TODO: add oauth2/cognito login support.

