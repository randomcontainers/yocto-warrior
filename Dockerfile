FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm vim

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create a non-root user that will perform the actual build
RUN id yocto 2>/dev/null || useradd --uid 30000 --create-home yocto
RUN apt-get install -y sudo
RUN echo "yocto ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN mkdir -p /build
RUN chown -R yocto:yocto /build

USER yocto
WORKDIR /build

CMD ["/bin/bash"]
