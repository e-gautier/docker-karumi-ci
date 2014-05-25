#!/bin/sh
PATH=/bin:/usr/bin:/sbin:/usr/sbin

DESC="Jenkins Continuous Integration Server"
NAME=jenkins
SCRIPTNAME=/etc/init.d/$NAME

[ -r /etc/default/$NAME ] && . /etc/default/$NAME

$JAVA $JAVA_ARGS -jar $JENKINS_WAR $JENKINS_ARGS