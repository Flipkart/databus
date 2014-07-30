#!/bin/bash
if [ $# -ne 3 ]
then
  echo "Usage : "
  echo "./deploy <build directory path> <groupid> <version>"
  echo -e "Example:\n" "./deploy.sh ./build com.linkedin.databus 2.0.0.fk.001"
  exit;
fi

function list_files()
{
 	if !(test -d "$1") 
 		then echo $1; return;
	fi

	cd "$1"
 
 	for i in *
 	do
 		if test -d "$i" #if dictionary
 		then 
 			list_files "$i" "$2" "$3" #recursively list files
			cd ..
 		else
			case $i in 
				*sources*);;
				*javadoc*);;
				*.jar)
					filePath=`pwd`"/"$i
					fileName=`echo "$i" | sed 's/^\(.*\)\-[[:digit:]].*/\1/'`
					pomFilePath=`pwd`"/"pom.xml
					`sed -i '' 's/<groupId>databus.*<\/groupId>/<groupId>com.linkedin.databus<\/groupId>/g' $pomFilePath`
					mvn deploy:deploy-file -DgroupId=$2  -DartifactId=$fileName -Dversion=$3 -Dpackaging=jar -Dfile=$filePath -DpomFile=$pomFilePath -DrepositoryId=clojars -Durl=https://clojars.org/repo
					#mvn install:install-file -DgroupId=$2  -DartifactId=$fileName -Dversion=$3 -Dpackaging=jar -Dfile=$filePath -DpomFile=$pomFilePath 
					;;
			esac	
 			
		fi
 	done
}
list_files "$1" "$2" "$3"
