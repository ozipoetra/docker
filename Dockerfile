# Base Image: Ubuntu
FROM ubuntu:latest

# Working Directory
WORKDIR /root

# Maintainer
MAINTAINER mitsu00 <dev@ozip.my.id>

# Delete the profile files (we'll copy our own in the next step)
RUN \
rm -f \
    /etc/profile \
    ~/.profile \
    ~/.bashrc

# Copy the Proprietary Files
COPY ./proprietary /

# apt update
RUN apt update

# Install sudo
RUN apt install apt-utils sudo -y

# tzdata
ENV TZ Asia/Jakarta

RUN \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
&& ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
&& apt-get install -y tzdata \
&& dpkg-reconfigure --frontend noninteractive tzdata

# set locales 
RUN apt-get install -y locales \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install git and ssh
RUN sudo apt install git ssh -y

# Configure git
ENV GIT_USERNAME mitsu00
ENV GIT_EMAIL dev@ozip.my.id
RUN \
    git config --global user.name $GIT_USERNAME \
&&  git config --global user.email $GIT_EMAIL

# Install Packages
RUN \
sudo apt install \
    curl wget aria2 tmate python2 python3 python-is-python3 silversearch* \
    iputils-ping iproute2 \
    nano rsync rclone tmux screen openssh-server \
    python3-pip adb fastboot jq npm neofetch mlocate \
    zip unzip tar ccache \
    cpio lzma \
    -y

# Filesystems
RUN \
sudo apt install \
    erofs-utils \
    -y

# Install schedtool and Java
RUN \
    sudo apt install \
        schedtool openjdk-8-jdk \
    -y

# Install Clang
RUN \
    wget https://github.com/mitsu00/build_test/releases/download/clang/clang.zip -O /tmp/clang.zip \
    sudo unzip /tmp/clang.zip -d /usr/local/bin/clang

# Setup Android Build Environment
RUN \
git clone https://github.com/akhilnarang/scripts.git /tmp/scripts \
&& sudo bash /tmp/scripts/setup/android_build_env.sh \
&& rm -rf /tmp/scripts

# Run bash
CMD ["bash"]
