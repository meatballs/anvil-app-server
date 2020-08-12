FROM python:3

# Extra python env
ENV LANG C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# Postgres initdb must be run as a non-root user and, to use a volume, that user's id
# must match the current user from the host machine. We use nss_wrapper to fake the 
# passwd file.
ENV USER_NAME anvil
ENV NSS_WRAPPER_PASSWD /tmp/passwd
ENV NSS_WRAPPER_GROUP /tmp/group

RUN touch ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
&&  chgrp 0 ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
&&  chmod g+rw ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP}

# Install OS package dependencies
RUN apt-get update && apt-get -y install \
    gettext \
    gosu \
    java-common \
    libnss-wrapper \
    wget \
&&  rm -rf /var/lib/apt/lists/*

# Install the amazon corretto jdk
RUN wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb \
&&  mkdir -p /usr/share/man/man1 \
&&  dpkg --install amazon-corretto-11*.deb \
&&  rm *.deb

# Create a virtual environment and install the anvil app server into it
RUN python -m venv /venv \
&&  /venv/bin/pip install anvil-app-server \
&&  /venv/bin/anvil-app-server || true

# Add the virtual environment directory to the PATH
ENV PATH "/venv/bin:${PATH}"

# Create volumes for the app source code and database
VOLUME /app
VOLUME /anvil-data

# Copy the files for nss wrapper to the container
COPY entrypoint.sh passwd.template /

ENTRYPOINT ["/entrypoint.sh", "anvil-app-server", "--app", "/app", "--data-dir", "/anvil-data"]
