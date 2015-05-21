#!/bin/sh

#
# Set this to Jenkins Host eg http://jenkins.zero.cool:8080
#
# In case you need to login to Jenkins to be able to access the Jobs see this.
# https://wiki.jenkins-ci.org/display/JENKINS/Authenticating+scripted+clients
#  


JENKINS_HOST="http://127.0.0.1:8080"

if [ -z "${JENKINS_HOST}" ]; then
    echo "Please edit the file to add the JENKINS_HOST variable"
    exit 1
fi

if which curl > /dev/null; then
    echo "[*] Grabbing jobs from $JENKINS_HOST"
    echo
else
    echo "[*] Please install curl"
    exit 1
fi

jobs=`curl -s "$JENKINS_HOST/api/json" |jq -r '.jobs[].name'`

for line in $jobs;do
    echo "[*] Downloading configuration for job $line"
    curl -s "$JENKINS_HOST/job/$line/config.xml" > jobs/$line.xml.erb
done 

#
# Generate puppet config for rtyler/jenkins
# modify the definition to match your settings
#

echo
echo "[*]  Generating Puppet config"
echo

for line in $jobs; do
    echo " jenkins::job { '$line':"
    echo "    config => template(\"data/jenkins/jobs/$line.xml.erb\"),"
    echo "  }"
done

echo
