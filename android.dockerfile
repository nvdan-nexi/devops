FROM openjdk:11

ARG BUILD_FROM
ARG LOCAL_PATH
ARG REMOTE_URL
ARG BRANCH
ARG id_rsa
ARG id_rsa_pub

RUN echo "Inside Dockerfile"

ENV id_rsaa=$id_rsa
RUN echo $id_rsaa

WORKDIR project/

# Install Build Essentials
RUN apt-get update \
    && apt-get install build-essential -y \
    && apt-get install -y libc6-amd64-cross libstdc++6-amd64-cross libgcc1-amd64-cross \
    && apt-get install -y git libssl-dev

RUN ln -s /usr/x86_64-linux-gnu/lib64/ /lib64

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/lib64:/usr/x86_64-linux-gnu/lib"

# Set Environment Variables
ENV SDK_URL="https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" \
    ANDROID_SDK_ROOT="/usr/local/android-sdk" \
    ANDROID_VERSION=33

# Download Android SDK
RUN mkdir "$ANDROID_SDK_ROOT" .android \
    && cd "$ANDROID_SDK_ROOT" \
    && pwd \
    && curl -o sdk.tgz $SDK_URL \
    && ls \
    && tar -xvzf sdk.tgz \
    && rm sdk.tgz \
    && mkdir "$ANDROID_SDK_ROOT/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_SDK_ROOT/licenses/android-sdk-license"


# ------------------------------------------------------
# --- Download Android Command line Tools into $ANDROID_SDK_ROOT

RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O android-commandline-tools.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && unzip -q android-commandline-tools.zip -d /tmp/ \
    && mv /tmp/cmdline-tools/ ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm android-commandline-tools.zip && ls -la ${ANDROID_SDK_ROOT}/cmdline-tools/latest/

ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin

RUN yes | sdkmanager --licenses

RUN touch /root/.android/repositories.cfg

# Emulator and Platform tools
RUN yes | sdkmanager "platform-tools"

# SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.

RUN yes | sdkmanager --update --channel=0
# Please keep all sections in descending order!

RUN yes | sdkmanager \
    "platforms;android-33" \
    "build-tools;33.0.1"

# Add codebase to working directory
#COPY $LOCAL_PATH /project/codebase

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

RUN mkdir ssh
ADD $id_rsaa /project/ssh
ADD $id_rsa_pub /project/ssh

# Add the keys and set permissions
RUN cat $id_rsa > /root/.ssh/id_rsa && \
    cat $id_rsa_pub > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN git clone -b $BRANCH $REMOTE_URL codebase

RUN rm $id_rsa && rm $id_rsa_pub

CMD ["/bin/bash"]
