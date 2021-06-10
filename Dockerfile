FROM openjdk:15-jdk-alpine3.11
RUN apk add curl tar
ENV MAVEN_VERSION=3.6.2
ENV MAVEN_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV APP=gvt-aprovisionamiento-telcel2-0.0.1.jar
ARG PROF
ENV PROFILE=${PROF}
RUN echo $PROF
RUN echo $PROFILE
RUN mkdir -p /usr/share/maven /usr/share/maven/ref
RUN echo "Downloading maven" && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN echo "Unziping maven" && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1
RUN echo "Cleaning and setting links" && rm -f /tmp/apache-maven.tar.gz
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
RUN mkdir -p /app
COPY . /root
WORKDIR /root
RUN mvn clean package -Dmaven.test.skip=true 
RUN cp target/${APP} /app
RUN rm -rf /root/*
WORKDIR /app
CMD java -jar $APP --spring.profiles.active=$PROFILE