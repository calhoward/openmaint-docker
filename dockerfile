# Use OpenJDK 17 base image
FROM openjdk:17-jdk-slim

# Set environment variables
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Tomcat 9.0.91
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz && \
    tar xzvf apache-tomcat-9.0.91.tar.gz && \
    mv apache-tomcat-9.0.91 $CATALINA_HOME && \
    rm apache-tomcat-9.0.91.tar.gz

# Download openMAINT WAR file
RUN wget https://sourceforge.net/projects/openmaint/files/latest/download -O $CATALINA_HOME/webapps/openmaint.war

# Download PostgreSQL JDBC driver
RUN wget https://jdbc.postgresql.org/download/postgresql-42.6.0.jar -O $CATALINA_HOME/lib/postgresql.jar

# Copy context.xml to configure the DataSource
COPY context.xml $CATALINA_HOME/conf/context.xml

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
