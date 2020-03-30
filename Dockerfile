FROM ubuntu:18.04

LABEL maintainer="bhowiebkr@gmail.com"

# Perform a general update of the OS.
RUN apt-get update \ 
    && apt-get install --yes \
    # python
    python3-pip \
    python3-setuptools \
    python3-dev \
    # languages
    locales \
    locales-all \
    # gui
    mesa-utils \
    libgl1-mesa-glx \
    x11-xserver-utils \
    libxkbcommon-x11-0 \
    x11-utils && \
    # cleanup
    apt-get clean && \
    rm -rf /var/cache/apk/*

# pip
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt && rm requirements.txt
RUN apt-get -y install libgssapi-krb5-2

# languages
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# setup virtual display
ENV DISPLAY=:99
ENV SCREEN=0
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# turn this on for verbose qt feedback
ENV QT_DEBUG_PLUGINS=0
ENV QT_VERBOSE true
ENV QT_TESTING true

# user
ARG USER_ID
RUN useradd -ms /bin/bash --no-log-init --password "" --uid ${USER_ID} --user-group user
USER user