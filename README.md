Pre Software
1. Docker 

Steps
1. docker build -t pia-environment --build-arg BUILD_FROM=$BUILD_FROM --build-arg LOCAL_PATH=$LOCAL_PATH --build-arg REMOTE_URL=$REMOTE_URL --build-arg BRANCH=$BRANCH --build-arg id_rsa=$id_rsa --build-arg id_rsa_pub=$id_rsa_pub .
2. docker run -it --name pia-container -d pia-environment
3. docker rmi pia-environment
4. Run command 
   - docker exec -i -t pia-container /bin/bash -c "cd codebase && ./gradlew assembleRelease"
   - docker exec -i -t pia-container /bin/bash -c "cd codebase && ./gradlew clean"