# Jenkins
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu

# install prerequisites for jenkins
RUN apt-get update
RUN apt-get -y install wget

# add jenkins to the repository
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update

# install jenkins
RUN apt-get -y install jenkins
RUN sed -r -i 's/^(JENKINS_ARGS=".*)"/\1 --prefix=$PREFIX"/' /etc/default/jenkins
ADD jenkins.sh /jenkins.sh
RUN chmod +x /jenkins.sh

# Jenkins plugins
RUN mkdir -p /var/lib/jenkins/plugins
ADD jenkins/plugins/bitbucket.hpi /var/lib/jenkins/plugins/
ADD jenkins/plugins/git.hpi /var/lib/jenkins/plugins/
ADD jenkins/plugins/github.hpi /var/lib/jenkins/plugins/
ADD jenkins/plugins/sonar.hpi /var/lib/jenkins/plugins/

# install git
RUN apt-get -y install git

#Sonar
RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" > /etc/apt/sources.list.d/sonar.list
RUN apt-get update
RUN apt-get install -y --force-yes sonar
RUN rm -rf /opt/sonar/conf/sonar.properties
ADD sonarqube/sonar.properties /opt/sonar/conf/sonar.properties
#ADD sonarqube/create_database.sql /opt/sonar/create_database.sql
#RUN mysql -u root -p < /opt/sonar/create_database.sql

# Setup NGINX Reverse Proxy
RUN apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/default
ADD nginx/reverse-proxy /etc/nginx/sites-available/reverse-proxy
RUN ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Setup Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 80