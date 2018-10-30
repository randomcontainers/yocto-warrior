FROM ubuntu:16.04

ENV DEBIAN_FRONTENV noninteractive
RUN apt-get update && apt-get -y upgrade

# Required Packages for the Host Development System # http://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-host-development-system
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm python3-requests make g++ bzip2 libx11-dev curl python-pip symlinks

# The following packages are used by BOA installtion
RUN apt-get install -y libxerces-c3.1 man-db

# Create a non-root user that will perform the actual build 
RUN useradd --uid 30000 --create-home build
RUN apt-get install -y sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# add aws-cli
RUN pip install awscli --upgrade

# add quilt
RUN pip install quilt

# Fix error "Please use a locale setting which supports utf-8." # See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues 
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8
		
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8 
RUN chmod -R a+rwX /home
CMD "/bin/bash"

# EOF
