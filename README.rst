Geoserver with N&S defaults
===========================

Docker setup for the geoservers we run at `Nelen & Schuurmans
<https://www.nelen-schuurmans.nl>`_.

We need two

- An internal server (without external web access) *with* internal :5432
  access for easy uploading

- One or more regular external geoservers


Current test external server
----------------------------

It ought to move to a kubernetes cluster with some automatic scaling at the
end, but for now....

https://geoserver-test.lizard.net

Installed on p-liz-geo-atlas-01.external-nens.local with
docker-compose. Tomcat on ``8080``, postgres (in docker) on ``5432``.  Todo:
arrange access to postgres.

Postgres: username ``geoserver``, database ``geoserver``. Password is in the
docker-compose...

Geoserver: user ``admin``, password ``geoserver`` for now. TODO: add
oauth2/cognito login support.

One-time manual step on the server: tell docker to use ``/mnt/data/docker``
instead of ``/var/lib/docker`` (see
https://www.guguweb.com/2019/02/07/how-to-move-docker-data-directory-to-another-location-on-ubuntu/).

And the internal/utrecht one: geoserver-dev.staging.lizard.net
