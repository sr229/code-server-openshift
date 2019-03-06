FROM ubuntu:18.04
# Change this line if you need to.
ARG CODER_VERSION=1.31.0-20
RUN apt update && \
    apt upgrade -y && \
    apt install -y unzip \
      build-essential \
      gcc \
      clang \
      curl \
      git \
      wget && \
    cd /tmp && \
    wget -O - https://github.com/codercom/code-server/releases/download/${CODER_VERSION}/code-server-${CODER_VERSION}-x86_64-linux.tar.gz | tar -xzv && \
    chmod -R 755 code-server-${CODER_VERSION}-x86_64-linux/code-server && \
    mv code-server-${CODER_VERSION}-x86_64-linux/code-server /usr/bin/ && \
    rm -rf code-server-${CODER_VERSION}-x86_64-linux && \
    adduser --disabled-password --gecos '' coder && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod g+rw /home/coder && chmod g+rw /home/projects && \
    chgrp -R 0 /home/coder && \
    chmod -R g=u /home/coder && \
    chmod g=u /etc/passwd;

WORKDIR /home/coder

USER coder

RUN mkdir -p projects && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash && \
    bash -c 'source ~/.bashrc && nvm install node';

COPY entrypoint /home/coder

VOLUME ["/home/coder/projects"]

USER 10001

ENTRYPOINT ["/home/coder/entrypoint"]

EXPOSE 9000

CMD ["code-server", "--port=9000",  "--allow-http", "--no-auth", "/home/coder/projects"]
