#!/bin/bash

DOCKER_OPERATION=$1
shift
GRADLE_COMMAND=$@

case "$DOCKER_OPERATION" in
   "build") {
     source environment.sh && ./environment.sh
     docker build -f $DOCKERFILE -t pia-environment --build-arg BUILD_FROM=$BUILD_FROM --build-arg LOCAL_PATH=$LOCAL_PATH --build-arg REMOTE_URL=$REMOTE_URL --build-arg BRANCH=$BRANCH --build-arg id_rsa=$id_rsa --build-arg id_rsa_pub=$id_rsa_pub ./
   }
   ;;
   "run") docker run -it --name pia-container -d pia-environment
   ;;
   "remove") {
     docker rm -f pia-container
     docker rmi pia-environment
   }
   ;;
   "command") {
     echo "./gradlew $GRADLE_COMMAND"
     docker exec pia-container /bin/bash -c "cd codebase && ./gradlew $GRADLE_COMMAND"
   }
   ;;
   "publish") {
     rm -rf output
     docker cp pia-container:/project/codebase/output .
   }
   ;;
esac

## Script Command
# ./execute.sh build local
# ./execute.sh remove
# ./execute.sh run
# ./execute.sh command clean
# ./execute.sh command assembleRelease
