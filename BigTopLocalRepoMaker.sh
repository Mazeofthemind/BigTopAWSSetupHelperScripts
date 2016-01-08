####Downloads the current versions of Apache BigTop packages from Jenkins and places in a local directory to be converted into a local repository
#Note: Script assumes you are in a writable directory which does not contain an archive.zip file
BIGTOP_COMPONENTS=("spark", "hadoop", "hue", "zeppelin", "pig", "zookeeper", "bigtop-groovy", "bigtop-jsvc", "bigtop-tomcat", "bigtop-utils")
BIGTOP_DEPENDENCIES=("puppet", "java-1.8.0-openjdk") 

#These are critical paths used later in the script, specifically the file being used to store the local directory, and the location of the server script
HELPER_SCRIPT_DIR="." #Defaults to current working directory
LOCAL_REPO_OUTPUT_DIR="$HELPER_SCRIPT_DIR/localrepo/"
REPO_SERVER_SCRIPT_PATH="$HELPER_SCRIPT_DIR/bigtopreposerver.py"
INSTALL_DIR="/etc/BigTopLocalRepoServer/"
GATEWAY_FQDN=ip-10-0-0-62

####
echo Downloading current versions of Apache BigTop packages from Jenkins to make local repo 
for COMPONENT in ${BIGTOP_COMPONENTS[*]}
do
	wget http://ci.bigtop.apache.org/view/Packages/job/Bigtop-trunk-packages/BUILD_ENVIRONMENTS=centos-7,COMPONENTS=$COMPONENT,label=docker-slave/lastSuccessfulBuild/artifact/*zip*/archive.zip
	unzip -j archive.zip -d $LOCAL_REPO_OUTPUT_DIR 
	rm archive.zip
done

####Downloads the packages which are dependencies for Apache Bigtop (along with their dependencies) and places them in a local directory to be conerted into a local repository
echo Downloading current version of Apache Bigtop dependencies to make local repo
for DEPENDENCY in ${BIGTOP_DEPENDENCIES[*]}
do
	repotrack -a x86_64 -p $LOCAL_REPO_OUTPUT_DIR $DEPENDENCY
done

####Creates a local repository from the local download directory
echo Building local repository 
createrepo --database $LOCAL_REPO_OUTPUT_DIR

####Creates the .yum repo file from template
cat >$LOCAL_REPO_OUTPUT_DIR/BigTopLocalRepo.yum <<EOF

[BigTop-Local]
name=Bigtop Local Repository
baseurl=http://$GATEWAY_FQDN:90000/
gpgcheck=0

EOF

####Creates a Systemd HTTP server daemon for the localrepo which defaults to port 90000
sudo adduser BigTopLocalRepoServer -s /sbin/nologin
sudo mkdir $INSTALL_DIR
chmod -R a+rx $LOCAL_REPO_OUTPUT_DIR
chmod a+rx $REPO_SERVER_SCRIPT_PATH
sudo cp -r $LOCAL_REPO_OUTPUT_DIR $INSTALL_DIR
sudo cp $REPO_SERVER_SCRIPT_PATH $INSTALL_DIR
sudo cp $HELPER_SCRIPT_DIR/BigTopLocalRepoServer.service /usr/lib/systemd/system/

sudo systemctl start BigTopLocalRepoServer
sudo systemctl enable BigTopLocalRepoServer
