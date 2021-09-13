# Lots of inspiration from https://github.com/terrestris/docker-geoserve

# Tomcat 10 isn't yet supported by geoserver.
FROM --platform=linux/amd64 tomcat:9-jdk8

ENV GEOSERVER_VERSION="2.19.0"
ENV GEOSERVER_DATA_DIR="/opt/geoserver_data/"
ENV MARLIN_TAG=0_9_3
ENV MARLIN_VERSION=0.9.3
ENV GEOSERVER_LIB_DIR=$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/

# see http://docs.geoserver.org/stable/en/user/production/container.html
ENV CATALINA_OPTS="-Xms256m -Xmx1g -Dfile.encoding=UTF-8 -D-XX:SoftRefLRUPolicyMSPerMB=36000 -Xbootclasspath/a:$CATALINA_HOME/lib/marlin.jar -Xbootclasspath/p:$CATALINA_HOME/lib/marlin-sun-java2d.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine -Dorg.geotools.coverage.jaiext.enabled=true"

RUN apt-get update && \
    apt-get install -y curl openssl zip gdal-bin && \
    rm -rf $CATALINA_HOME/webapps/*
RUN curl -jkSL -o /tmp/geoserver.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip && \
    unzip /tmp/geoserver.zip geoserver.war -d $CATALINA_HOME/webapps && \
    mkdir -p $CATALINA_HOME/webapps/geoserver && \
    unzip -q $CATALINA_HOME/webapps/geoserver.war -d $CATALINA_HOME/webapps/geoserver && \
    rm $CATALINA_HOME/webapps/geoserver.war /tmp/geoserver.zip && \
    mkdir -p $GEOSERVER_DATA_DIR

# Install java advanced imaging.
WORKDIR /tmp
RUN wget https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    wget https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
    gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
    mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    rm -rf /tmp/jai*
# uninstall JAI default installation from geoserver to avoid classpath conflicts
# see http://docs.geoserver.org/latest/en/user/production/java.html#install-native-jai-and-imageio-extensions
WORKDIR $GEOSERVER_LIB_DIR
RUN rm jai_core-*jar jai_imageio-*.jar jai_codec-*.jar

# install marlin renderer
RUN curl -jkSL -o $CATALINA_HOME/lib/marlin.jar https://github.com/bourgesl/marlin-renderer/releases/download/v$MARLIN_TAG/marlin-$MARLIN_VERSION-Unsafe.jar && \
    curl -jkSL -o $CATALINA_HOME/lib/marlin-sun-java2d.jar https://github.com/bourgesl/marlin-renderer/releases/download/v$MARLIN_TAG/marlin-$MARLIN_VERSION-Unsafe-sun-java2d.jar

# Download libs to GEOSEVER_LIB_DIR
WORKDIR /tmp
RUN curl -jkSL -o control-flow-plugin.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-control-flow-plugin.zip && \
    curl -jkSL -o csw-plugin.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-csw-plugin.zip && \
    unzip -n '*plugin.zip' && \
    mv *.jar ${GEOSERVER_LIB_DIR} && \
    rm *.zip

# Add index and robot file.
RUN mkdir -p $CATALINA_HOME/webapps/ROOT
COPY html/* $CATALINA_HOME/webapps/ROOT/
# Add config file.
COPY etc/global.xml $CATALINA_HOME/webapps/geoserver/data/
COPY copy-config-to-data-dir.sh /usr/local/bin/

# Copy default data dir to our data dir location, this way the volume gets populated with it.
RUN cp -r $CATALINA_HOME/webapps/geoserver/data/* $GEOSERVER_DATA_DIR

WORKDIR ${GEOSERVER_DATA_DIR}
