#Initial Setup (Adding dependencies to clone/build BigTop to stock Centos 6/7
sudo yum install epel-release
sudo yum install puppet
sudo yum install java-1.8.0-openjdk
sudo yum install git

#Clone Bigtop
git clone https://github.com/apache/bigtop ~/bigtop

#Install puppet modules
cd ~/bigtop
#sudo puppet apply --modulepath=~/bigtop -e \"include bigtop_toolchain::puppet-modules\”
sudo puppet module install puppetlabs-stdlib ##explicit install for Centos 6/7 dependencies

#Position puppet configuration files
sudo chmod a+rwx /etc/puppet
cp ~/bigtop/bigtop-deploy/puppet/hiera.yaml /etc/puppet
mkdir -p /etc/puppet/hieradata
rsync -a --delete ~/bigtop/bigtop-deploy/puppet/hieradata/bigtop /etc/puppet/hieradata/

#For master copy the template site.yaml and prompt the user to edit/replace
cp ~/bigtop/bigtop-deploy/puppet/hieradata/site.yaml /etc/puppet/hieradata
echo The default site.yaml has been copied to the /etc/puppet/hieradata directory, please edit or replace with the master insall script

#For slaves copy the site.yaml send from the master prior to deployments
#scp -i ~/key/examplekey.pem /etc/puppet/hieradata/site.xml centos@examplehost:~/
cp ~/site.yaml /etc/puppet/hieradata/site.yaml

sudo puppet apply -d --modulepath="bigtop-deploy/puppet/modules:/etc/puppet/modules" bigtop-deploy/puppet/manifests/site.pp
