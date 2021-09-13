#!/bin/bash
# The data dir is filled with default content when first starting the docker
# on a server. When there's an update to a config file, it won't be updated in
# the already-created data dir. This script updates the necessary files in the data dir.
#
# It is called automatically by ansible/deploy.yml
set -e

SOURCE_DATA_DIR=$CATALINA_HOME/webapps/geoserver/data
DATA_DIR=/opt/geoserver_data

cp $SOURCE_DATA_DIR/global.xml $DATA_DIR/
echo "Copied new global.xml"
