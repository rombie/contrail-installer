#!/usr/bin/env bash

set -ex

rm -rf /tmp/cache
ln -sf /home/jenkins/tmp/cache /tmp/cache

sshpass -p c0ntrail123 rsync --delete -acz --progress --no-owner --no-group ci-admin@10.84.5.31:/ci-admin/fetch_packages_cache/ubuntu/ /tmp/cache/jenkins
chown -R jenkins.jenkins /tmp/cache/jenkins

mkdir -p /cs-shared/builder/cache/ubuntu1404/
sshpass -p c0ntrail123 rsync --delete --progress -acz --no-owner --no-group ci-admin@10.84.5.31:/cs-shared/builder/cache/ubuntu1404/ /cs-shared/builder/cache/ubuntu1404/
chown -R jenkins.jenkins /cs-shared/builder/cache/ubuntu1404/

REPO=~jenkins/workspace/ci-contrail-controller-systest-redhat-70-icehouse/repo
mkdir -p $REPO
cd $REPO
/cs-shared/tools/bin/repo init --repo-url https://bitbucket.org/contrail_admin/git-repo.git -u git@github.com:Juniper/contrail-vnc-private -m mainline/ubuntu-14-04/manifest-icehouse.xml
repo sync

rm -rf /root/contrail-installer
git clone -b test https://github.com/rombie/contrail-installer.git /root/contrail-installer
cd /root/contrail-installer/utilities
./task.sh my.conf  # BUILD ONLY

