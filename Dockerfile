FROM debian:bookworm-20241202-slim as builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl

ARG USER=dev

# set up shared home directory users
ENV USERHOME=/home/$USER
RUN mkdir $USERHOME

RUN useradd -d $USERHOME -s /bin/zsh $USER
RUN usermod -aG sudo $USER
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chown -R $USER $USERHOME
RUN chgrp users $USERHOME
RUN chmod g+w $USERHOME

USER $USER

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH=$USERHOME/.local/bin:$PATH

WORKDIR /app

ADD README.md pyproject.toml uv.lock .python-version .
ADD src/ src/

RUN uv sync
