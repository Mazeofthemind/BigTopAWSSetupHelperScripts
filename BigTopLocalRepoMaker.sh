####Downloads the current versions of Apache BigTop packages from Jenkins and places in a local directory to be converted into a local repository
#Note: Script assumes you are in a writable directory which does not contain an archive.zip file

echo Downloading current versions of Apache BigTop packages from Jenkins to make local repo 
BIGTOP_COMPONENTS=("spark", "hadoop", "hue", "zeppelin", "pig", "zookeeper", "bigtop-groovy", "bigtop-jsvc", "bigtop-tomcat", "bigtop-utils")
BIGTOP_DEPENDENCIES=("puppet", "java-1.8.0-openjdk") 
OUTPUT_REPO="/home/centos/localrepo/"
GATEWAY_FQDN=ip-10-0-0-62

for COMPONENT in ${BIGTOP_COMPONENTS[*]}
do
	wget http://ci.bigtop.apache.org/view/Packages/job/Bigtop-trunk-packages/BUILD_ENVIRONMENTS=centos-7,COMPONENTS=$COMPONENT,label=docker-slave/lastSuccessfulBuild/artifact/*zip*/archive.zip
	unzip -j archive.zip -d $OUTPUT_REPO 
	rm archive.zip
done

####Downloads the packages which are dependencies for Apache Bigtop (along with their dependencies) and places them in a local directory to be conerted into a local repository
echo Downloading current version of Apache Bigtop dependencies to make local repo
for DEPENDENCY in ${BIGTOP_DEPENDENCIES[*]}
do
	repotrack -a x86_64 -p $OUTPUT_REPO $DEPENDENCY
done

####Creates a local repository from the local download directory
echo Building local repository 
createrepo --database $OUTPUT_REPO

####Creates the .yum repo file from template
cat >~/localrepo/BigTopLocalRepo.yum <<EOF

[BigTop-Local]
name=Bigtop Local Repository
baseurl=http://$GATEWAY_FQDN:8000/
gpgcheck=0

EOF
