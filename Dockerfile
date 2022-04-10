FROM ubuntu:22.04

# Setup APT Dependencies
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y curl git build-essential libasound2-dev pkg-config ffmpeg pulseaudio pulseaudio-utils

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
COPY ./start.sh .

# Start
CMD ./start.sh
