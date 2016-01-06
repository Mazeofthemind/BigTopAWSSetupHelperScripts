# BigTopAWSSetupHelperScripts
A series of scripts, configuration files and instructions which assist in setting up a Hadoop cluster on AWS using BigTop

Introduction
-
Apache BigTop can be used to assist in cluster deployment on a number of platforms (virtual machines, containers) and in a variety of ways (during VM generation using Vagrant, or after using Puppet). These scripts are designed assist with deploying on existing virtual machines running on an elastic network such as AWS. 

These scripts are also designed to work around limited access to the internet, specifically that only a single node (the Gateway) has access to the internet and required repositories.

Components
-
* AWSBigTopSetup.sh: This script can be run on the master and slave nodes to install BigTop's dependencies, download bigtop, and partially configure the BigTop deployment
* BigTopLocalRepoMaker.sh: 
* BigTopLocalRepo.yum:
* site.yaml A template of the BigTop deployment configuration which can be used to configure the slave/master deployment

Instructions
-

Gateway Setup
=
1. On the gateway/master node clone this repository as a user with sudo access
2. 

Master Setup
=

Slave Setup
=
