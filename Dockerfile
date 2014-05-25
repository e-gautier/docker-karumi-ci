# Jenkins
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu

# install prerequisites for jenkins
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

# Setup Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/jenkins.sh"]

EXPOSE 8080