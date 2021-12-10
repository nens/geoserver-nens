CHANGELOG
=========

0.1 (unreleased)
----------------

- Started first docker-compose based geoserver with the desired
  plugins. Problem: access to the database from Utrecht and http/https
  problem.

- Added second geoserver for development purposes, with the database
  accessible from the office and VPN.

- Fixed http/https problem by using ``X-Forwarded-Proto``, including a fix for
  tomcat to actually use that header.

- Upgrade to geoserver 2.20.0.

- Added vectorlayer support.

- Enabled CORS (not for post/put/delete, btw).

- Added an "if" in the Dockerfile to support building/running on an M1 mac.
