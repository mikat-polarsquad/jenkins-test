FROM debian
# FROM jenkins/jnlp-slave
MAINTAINER Mika Tuominen <mika.tuominen@polarsquad.com>

ENV DOCKER_VERSION=18.09.6-ce DOCKER_COMPOSE_VERSION=1.24.0 KUBECTL_VERSION=v1.13.3
ENV USER=jenkins

USER root


RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    # "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-cache policy docker-ce docker-ce-cli containerd.io && \
    # apt-get -y install libltdl7 && \
    addgroup --gid 995 docker && \
    apt-get -y install docker-ce && \
    apt-get clean


# RUN sudo service docker status
# RUN service docker start
# RUN docker version

# RUN systemctl enable docker
# RUN chkconfig docker on
# RUN usermod -aG docker $USER


RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
#     && chmod +x /usr/local/bin/kubectl


RUN mkdir /usr/local/bin/jenkins-slave
COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
RUN groupadd "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/$USER" \
    --ingroup "$USER" \
    # --no-create-home \
    "$USER"
RUN usermod -aG docker $USER

### Check docker installation
RUN cat /etc/group | grep docker

WORKDIR "/home/$USER"
USER jenkins