FROM ubuntu:22.04

# Disable prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set a default VNC password (override with -e VNC_PASSWORD=... at runtime)
ENV VNC_PASSWORD="password"

# Update and install base packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    wget curl gnupg2 software-properties-common \
    curl vim git \
    sensible-utils \
    x11-utils \
    xdg-utils \
    hicolor-icon-theme \
    dbus-x11 \
    language-pack-zh-hans \
    language-pack-zh-hant \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    xfonts-intl-chinese \
    xfonts-wqy \
    locales

# Update CA certificates properly
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get upgrade -y ca-certificates && \
    update-ca-certificates

# Generate Chinese locales
RUN locale-gen zh_CN.UTF-8 zh_TW.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8

# Install Node.js (example uses Node 18.x - adjust if you prefer a different version)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Chromium using PPA
RUN add-apt-repository ppa:saiarcot895/chromium-dev && \
    apt-get update && \
    apt-get install -y chromium-browser

# Set up default browser configuration (after Chromium is installed)
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/chromium-browser 500 && \
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/chromium-browser 500 && \
    xdg-settings set default-web-browser chromium-browser.desktop

# Install noVNC (and its websockify dependency)
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html

# Copy in the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose ports for raw VNC and noVNC web
EXPOSE 5901
EXPOSE 8080

# Run our startup script
CMD ["/usr/local/bin/start.sh"]