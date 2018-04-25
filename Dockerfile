FROM ubuntu:latest
MAINTAINER Dave Cook, dave@gridworkz.com

# Update and install utilities
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y vim && \
    apt-get install -y net-tools

# Create user to run WSO2-IS and the backoffice (not root for security reason!)
RUN useradd --user-group --create-home --shell /bin/false yoda

# Oracle Java 8
RUN apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get install oracle-java8-set-default && \
    rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# Node 6
RUN apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    apt-get install -y build-essential

# Identity Server
RUN mkdir /metagen-testenvironment && \
    curl -o /metagen-testenvironment/metagen-testenv-identityserver.tar.gz https://codeload.github.com/gridworkz/metagen-testenv-identityserver.tar.gz/master && \
    mkdir /metagen-testenvironment/is && \
    tar -zxvf /metagen-testenvironment/metagen-testenv-identityserver.tar.gz -C /metagen-testenvironment/is --strip-components=1 && \
    rm -f /metagen-testenvironment/metagen-testenv-identityserver.tar.gz

# Set custom conf
RUN mv /metagen-testenvironment/is/metagen-confs/conf/conf/carbon.xml /metagen-testenvironment/is/identity-server/repository/conf/ && \
    mv /metagen-testenvironment/is/metagen-confs/conf/conf/claim-config.xml /metagen-testenvironment/is/identity-server/repository/conf/ && \
    mv /metagen-testenvironment/is/metagen-confs/conf/bin/wso2server.sh /metagen-testenvironment/is/identity-server/bin/

# Backoffice
RUN curl -o /metagen-testenvironment/metagen-testenv-backoffice.tar.gz https://codeload.github.com/gridworkz/metagen-testenv-backoffice/tar.gz/master && \
    mkdir /metagen-testenvironment/bo && \
    tar -zxvf /metagen-testenvironment/metagen-testenv-backoffice.tar.gz -C /metagen-testenvironment/bo --strip-components=1 && \
    rm -f /metagen-testenvironment/metagen-testenv-backoffice.tar.gz

# Build backoffice
RUN cd /metagen-testenvironment/bo/backoffice && \
    npm install --suppress-warnings && \
    cd server && \
    npm install --suppress-warnings && \
    cd .. && \
    npm run build

# Download bash script to start both identity server and backoffice
RUN curl -o /metagen-testenvironment/metagentestenvstart.sh https://raw.githubusercontent.com/gridworkz/metagen-testenv-docker/master/metagentestenvstart.sh

# Port exposed
EXPOSE 9443 8080

RUN chown -R yoda:yoda /metagen-testenvironment/* && \
    chmod +x /metagen-testenvironment/is/identity-server/bin/wso2server.sh && \
    chmod +x /metagen-testenvironment/metagentestenvstart.sh

USER yoda

WORKDIR /metagen-testenvironment

ENTRYPOINT ["./metagentestenvstart.sh"]
