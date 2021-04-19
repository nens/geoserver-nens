# Lots of inspiration from https://github.com/terrestris/docker-geoserve

# Tomcat 10 isn't yet supported by geoserver.
FROM tomcat:9-jdk8

ENV GEOSERVER_VERSION="2.19.0"
ENV GEOSERVER_DATA_DIR="/opt/geoserver_data/"

# see http://docs.geoserver.org/stable/en/user/production/container.html
ENV CATALINA_OPTS="-Xms256m -Xmx1g -Dfile.encoding=UTF-8 -D-XX:SoftRefLRUPolicyMSPerMB=36000 -Xbootclasspath/a:$CATALINA_HOME/lib/marlin.jar -Xbootclasspath/p:$CATALINA_HOME/lib/marlin-sun-java2d.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine -Dorg.geotools.coverage.jaiext.enabled=true"

RUN apt update && \
    apt install -y curl openssl zip gdal-bin && \
    rm -rf $CATALINA_HOME/webapps/*
