ARG PLATFORM=linux/amd64
FROM --platform=${PLATFORM} ubuntu:22.04

ARG factorio_version=1.1.109

WORKDIR /workspace
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# factorio downloader dependencies
RUN apt-get update
RUN apt-get install -y \
    wget \
    curl \
    jq \
    xz-utils \
    ca-certificates

# download factorio
ARG factorio_version=2.0.32
RUN wget https://factorio.com/get-download/${factorio_version}/headless/linux64 -O factorio_linux_${factorio_version}.tar.xz
RUN tar -xvf factorio_linux_${factorio_version}.tar.xz
RUN mkdir -p /workspace/factorio/mods && ln -s /workspace/packages/autorio/dist /workspace/factorio/mods/autorio
RUN cp /workspace/factorio/data/server-settings.example.json /workspace/factorio/data/server-settings.json && \
    sed -i 's/"require_user_verification": true/"require_user_verification": false/' /workspace/factorio/data/server-settings.json && \
    sed -i 's/"public": true/"public": false/' /workspace/factorio/data/server-settings.json


# node.js
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g pnpm

# factorio dependencies
RUN apt-get install -y \
    # graphics
    xvfb x11-apps mesa-utils \
    # noVNC
    x11vnc novnc websockify

# copy workspace
COPY . /workspace
RUN pnpm install

# generate default save and build
RUN /workspace/factorio/bin/x64/factorio --create /workspace/factorio/saves/the-save-file.zip && \
    pnpm build

RUN chmod +x /workspace/docker/start-factorio.sh

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# start
ENV DISPLAY=:1
EXPOSE 5900 5901

ENTRYPOINT ["/workspace/docker/start-factorio.sh"]
