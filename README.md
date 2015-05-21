# Dump Jenkins Jobs and Puppetize

## Intro

At ITV we use puppet to configure Jenkins and we are using the Jenkins Job Builder (https://github.com/openstack-infra/jenkins-job-builder). Mixed feelings.Another way is using the rtyler/jenkins puppet module.
I created a helper script to assist the proccess.

## How it works

It connects to Jenkins JSON api endpoint and gets all your jobs.Then for every job it gets the config.xml and saves it. Then it autogenerates puppet configuration according to rtyler/jenkins (https://github.com/jenkinsci/puppet-jenkins).
You can then copy the jobs from jobs directory to a place you keep templates for puppet.

## How to use it

* Edit the file and change the JENKINS_HOST variable to point to your jenkins. 
* Modify the config => template line at the end to match your template location 

## Requirements

You need curl & jq to execute this.It works in my recent jenkins installation, not sure if the JSON api exists in all the versions.But the script is pretty readable so feel free to modify it.
If you dont have jq you can use python,grep,whatever to parse the JSON.

##Usage 

```
$ ./djjandp

[*] Grabbing jobs from http://127.0.0.1:8080

[*] Downloading configuration for job puppet
[*] Downloading configuration for job puppet-acceptance-test
[*] Downloading configuration for job puppet-spec-test
[*] Downloading configuration for job puppet-test-pipeline

[*]  Generating Puppet config

 jenkins::job { 'puppet':
    config => template("data/jenkins/jobs/puppet.xml.erb"),
  }
 jenkins::job { 'puppet-acceptance-test':
    config => template("data/jenkins/jobs/puppet-acceptance-test.xml.erb"),
  }
 jenkins::job { 'puppet-spec-test':
    config => template("data/jenkins/jobs/puppet-spec-test.xml.erb"),
  }
 jenkins::job { 'puppet-test-pipeline':
    config => template("data/jenkins/jobs/puppet-test-pipeline.xml.erb"),
  }

```


