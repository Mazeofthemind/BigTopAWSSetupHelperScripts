#Assumes you are in a temporary directory which does not contain an archive.zip file

BIGTOP_COMPONENTS=("spark", "hadoop", "hue", "zeppelin", "pig", "zookeeper", "bigtop-groovy", "bigtop-jsvc", "bigtop-tomcat", "bigtop-utils")
OUTPUT_REPO="/home/centos/localrepo/"

for COMPONENT in ${BIGTOP_COMPONENTS[*]}
do
	wget http://ci.bigtop.apache.org/view/Packages/job/Bigtop-trunk-packages/BUILD_ENVIRONMENTS=centos-7,COMPONENTS=$COMPONENT,label=docker-slave/lastSuccessfulBuild/artifact/*zip*/archive.zip
	unzip -j archive.zip -d $OUTPUT_REPO 
	rm archive.zip
done

