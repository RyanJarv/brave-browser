FROM ubuntu:19.04

WORKDIR /build

ENV SCCACHE_CACHE_SIZE=100G
ENV SCCACHE_DIR=/sccache

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y build-essential curl git lsb-base lsb-release sudo
RUN apt-get install -y nodejs npm

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin/:$PATH"
RUN apt-get install -y libssl-dev pkg-config
RUN cargo install sccache

RUN git clone https://github.com/brave/brave-browser.git /build
RUN npm install
RUN npm run init
VOLUME [ "/build" ]

RUN mkdir /sccache
RUN sccache --start-server & npm run build
VOLUME [ "/sccache" ]

CMD ["npm", "start"]
