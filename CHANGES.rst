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
