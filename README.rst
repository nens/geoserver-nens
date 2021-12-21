Geoserver with N&S defaults
===========================

Docker setup for the geoservers we run at `Nelen & Schuurmans
<https://www.nelen-schuurmans.nl>`_.

We need two different kinds of servers:

- An internal server (without external web access) *with* internal :5432
  access for easy uploading via postgres.

- One or more regular external geoservers.


Local development
-----------------

First a quick symlink to get the dev/staging configuration, then a "build" and
"up"::

  $ ln -s docker-compose.devstaging.yml docker-compose.yml
  $ docker compose build
  $ docker compose up


Current internal staging server
--------------------------------

The internal/utrecht one: https://geoserver-dev.staging.lizard.net . It isn't
accessible from the outside world, so you need to be in the office or on VPN.

Postgres: username ``geoserver``, database ``geoserver``. Password is in the
docker-compose...

Geoserver: user ``admin``, password ``geoserver`` for now. TODO: add
oauth2/cognito login support.

It is installed on ``p-geo-dbweb-01.external-nens.local``, so that's where the
postgres server is located.

It uses the exact same setup as the local development version.


First production server: klimaatatlas geoserver, maps1.klimaatatlas.net
-----------------------------------------------------------------------

It ought to move to a kubernetes cluster with some automatic scaling at the
end, but for now....

https://maps1.klimaatatlas.net

Installed on p-liz-geo-atlas-01.external-nens.local with
docker-compose. Tomcat on ``8080``. No included database, as the existing old
``p-product-db-d1`` is still used, like the original klimaatatlas geoserver.

It uses the existing samba share (from the old klimaatatlas geoserver) as
geoserver data dir, see the docker-compose file.

If the server needs to be restarted, as user ``buildout`` execute::

  $ cd /srv/production-geoservers
  $ docker-compose down
  $ docker-compose up -d

You can inspect the logs with ``docker-compose logs``.


Installation
------------

The regular ansible provision/deploy stuff. Staging and production have a
different inventory. Both also symlink a different docker-compose config file
to ``docker-compose.yml``.

One-time manual step on the server: tell docker to use ``/mnt/data/docker``
instead of ``/var/lib/docker`` (see
https://www.guguweb.com/2019/02/07/how-to-move-docker-data-directory-to-another-location-on-ubuntu/).

Note: deploying copies over a fresh ``global.xml`` configuration into the data
directory, overwriting any possible manual settings. We might want to change
this later on, but for now it is needed to fix the http/https issue.
