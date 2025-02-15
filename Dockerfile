FROM ubuntu:22.04

# Disable prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set a default VNC password (override with -e VNC_PASSWORD=... at runtime)
ENV VNC_PASSWORD="password"

# Update and install base packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    wget curl gnupg2 software-properties-common \
    git

# Install Node.js (example uses Node 18.x - adjust if you prefer a different version)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

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
