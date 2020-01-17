FROM oraclelinux:7-slim

RUN set -eux; \
        yum install -y \
                gzip \
                tar \
        ; \
        rm -rf /var/cache/yum
ENV LANG en_US.UTF-8

ENV JAVA_VERSION=1.8.0_231 \
        JAVA_PKG=server-jre-8u231-linux-x64.tar.gz \
        JAVA_SHA256=1d59a0ea3ef302d5851370b838693b0b6bde4c3f32015a4de0a9e4d202a988fc \
        JAVA_HOME=/usr/java/jdk-8

ENV     PATH $JAVA_HOME/bin:$PATH
COPY $JAVA_PKG /tmp/jdk.tgz
RUN set -eux; \
        \
        echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c -; \
        mkdir -p "$JAVA_HOME"; \
        tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
        rm /tmp/jdk.tgz; \
        \
        ln -sfT "$JAVA_HOME" /usr/java/default; \
        ln -sfT "$JAVA_HOME" /usr/java/latest; \
        for bin in "$JAVA_HOME/bin/"*; do \
                base="$(basename "$bin")"; \
                [ ! -e "/usr/bin/$base" ]; \
                alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
        done; \
        java -Xshare:dump; \
        java -version; \
        javac -version

WORKDIR /opt
ADD *.jar app.jar
EXPOSE 8080
CMD java -jar /opt/app.jar
