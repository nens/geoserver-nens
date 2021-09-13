#!/bin/bash
# The data dir is filled with default content when first starting the docker
# on a server. When there's an update to a config file, it won't be updated in
# the already-created data dir. This script updates the necessary files in the data dir.

SOURCE_DATA_DIR=$CATALINA_HOME/webapps/geoserver/data
DATA_DIR=/opt/data

cp $SOURCE_DATA_DIR/config.xml $DATA_DIR/config.xml
echo "Copied new config.xml"
