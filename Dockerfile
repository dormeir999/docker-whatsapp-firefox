# Use Ubuntu 20.04 as a parent image
FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    x11-apps \
    xauth \
    xvfb \
    nautilus \
    evince \
    dbus-x11 \
    locales \
    xclip \
    fonts-dejavu \
    fonts-freefont-ttf \
    fonts-liberation \
    gnome-terminal

# Add the Mozilla PPA for Firefox and install Firefox from there
RUN add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozilla-firefox && \
    apt-get update && \
    apt-get install -y firefox

# Set locale
RUN locale-gen en_US.UTF-8 he_IL.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Add user for security reasons
RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

# Create a directory for PDFs (optional, you can also mount a volume)
RUN mkdir -p /home/user/pdfs

# Entry point to start Xvfb, configure keyboard layout, and run applications
ENTRYPOINT ["/bin/bash", "-c", "Xvfb :1 -screen 0 1024x768x16 & export DISPLAY=:1 && setxkbmap -layout 'us,il' -option 'grp:alt_shift_toggle' && nautilus & firefox https://web.whatsapp.com"]
