FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ARG PYTHON_VERSION
ARG DOWNLOAD_URL=https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

RUN apt update && \
    apt install -y curl wget software-properties-common default-jre locales git && \
    useradd -d /home/container -m container

# additional dependencies for python
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# install python
RUN curl -sL $DOWNLOAD_URL && \
    tar -xf Python-$PYTHON_VERSION.tgz && \
    cd Python-$PYTHON_VERSION && \
    ./configure --enable-optimizations && \
    make -j8 && \
    make altinstall && \
    cd .. && \
    rm -rf Python-$PYTHON_VERSION && \
    rm -rf Python-$PYTHON_VERSION.tgz

# install pip
RUN python -m ensurepip --upgrade && \
    python -m pip install --upgrade pip

# update alternatives
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python$PYTHON_VERSION 1 && \
    update-alternatives --set python /usr/local/bin/python$PYTHON_VERSION

ENV USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./python.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
