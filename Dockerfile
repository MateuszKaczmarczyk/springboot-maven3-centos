# springboot-maven3-centos
#
# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Maven 3.

FROM centos:6

EXPOSE 8080

ENV STI_SCRIPTS_PATH /tmp/s2i/bin
ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9

LABEL io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3,springboot" \
      io.openshift.s2i.scripts-url="image:////tmp/s2i/bin"
      

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN yum -q -y  reinstall glibc-common
ENV LANG=pl_PL.UTF-8
ENV LANGUAGE=pl_PL:pl
ENV LC_ALL=pl_PL.UTF-8

RUN locale -a


ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

# Add configuration files, bashrc and other tweaks
## EKSPERYMENT
RUN mkdir -p /tmp/s2i/bin
RUN mkdir -p /tmp/?/.m2/repository
RUN mkdir -p /tmp/.m2/repository
RUN mkdir -p /.npm



###
COPY ./s2i/bin/ /tmp/s2i/bin

##### DODANE - INACZEJ SIE SYPIE
##RUN mkdir /opt/app-root
################################
##RUN chown -R 1001:0 /opt/app-root
##USER 1001

### EKPERYMENT
RUN chown -R 1001:0 /tmp/s2i/bin
RUN chown -R 1001:0 /tmp/?/.m2/repository
RUN chown -R 1001:0 /tmp/.m2/repository
RUN chown -R 1001:0 /.npm


USER 1001

COPY ./s2i/bin/assemble /tmp/s2i/bin
COPY ./s2i/bin/run /tmp/s2i/bin

# Set the default CMD to print the usage of the language image
CMD /tmp/s2i/bin/usage

