#!/bin/sh

#docker pull jenkins/jenkins:lts

docker run -d \
--name android-jenkins \
-v /Users/10682763/jenkins-data:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-u root \
-p 8080:8080 \
-p 50000:50000 \
jenkins/jenkins

# Install docker in jenkins container. https://www.jenkins.io/doc/book/installing/docker/