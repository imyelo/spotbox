FROM ubuntu:20.04

# Setup APT Dependencies
RUN apt-get update -y
RUN DEBIAN_FRONTEND=nointeractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y \
  curl git \
  build-essential libasound2-dev pkg-config \
  pulseaudio pulseaudio-utils \
  ffmpeg

WORKDIR /app

# Setup Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
RUN chmod +x rustup.sh
RUN ./rustup.sh -y

# Setup librespot
RUN git clone https://github.com/librespot-org/librespot.git
RUN cd librespot && \
  git checkout v0.3.1 && \
  ~/.cargo/bin/cargo build --release --no-default-features --features pulseaudio-backend

# Setup Script
COPY ./entrypoint.sh .

# Start
CMD ./entrypoint.sh
