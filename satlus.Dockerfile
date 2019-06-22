# Dockerfile based from satlus's PR.
# Intended for testing purposes, see PR: https://github.com/cdr/code-server/pull/640
FROM debian:buster-slim

ENV LANG=en_US.UTF-8 \
    # adding a sane default is needed since we're not erroring out via exec.
    PASSWORD="coder"

#Change this via --arg in Docker CLI
ARG CODER_VERSION=1.1156-vsc1.33.1

COPY exec /opt

RUN apt-get update && \
    apt-get install -y  \
      sudo \
      openssl \
      net-tools \
      git \
      locales \ 
      curl \
      dumb-init \     
      wget && \
    locale-gen en_US.UTF-8 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    wget -O - https://github.com/codercom/code-server/releases/download/${CODER_VERSION}/code-server${CODER_VERSION}-linux-x64.tar.gz | tar -xzv && \
    chmod -R 755 code-server${CODER_VERSION}-linux-x64/code-server && \
    mv code-server${CODER_VERSION}-linux-x64/code-server /usr/bin/ && \
    rm -rf code-server${CODER_VERSION}-linux-x64;
 
WORKDIR /home/coder

RUN addgroup --gid 1000 coder && \
    adduser --uid 1000 --ingroup coder --home /home/coder --shell /bin/sh --disabled-password --gecos "" coder && \
	echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN USER=coder && \
	GROUP=coder && \
	curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
	chown root:root /usr/local/bin/fixuid && \
	chmod 4755 /usr/local/bin/fixuid && \
	mkdir -p /etc/fixuid && \
	printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

USER coder

# Setup our entrypoint
COPY entrypoint.satlus /usr/local/bin/entrypoint
RUN sudo chmod +x /usr/local/bin/entrypoint

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
VOLUME [ "/home/coder" ]

EXPOSE 8443

ENTRYPOINT ["dumb-init", "entrypoint", "/usr/bin/code-server"]