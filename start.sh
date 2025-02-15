#!/bin/bash
set -e

# Create VNC password file
mkdir -p /root/.vnc
x11vnc -storepasswd "${VNC_PASSWORD}" /root/.vnc/passwd

# Start virtual X server at 1920x1080
Xvfb :1 -screen 0 1920x1080x24 &
sleep 2

# Set DISPLAY so all GUI apps connect to Xvfb
export DISPLAY=:1

# Start Xfce in the background
startxfce4 &

# Start x11vnc server
x11vnc -rfbauth /root/.vnc/passwd \
       -display :1 \
       -forever \
       -shared \
       -tightfilexfer \
       -ultrafilexfer \
       -rfbport 5901 &

# Let x11vnc settle
sleep 2

# Start noVNC on port 8080, proxying traffic to localhost:5901
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 8080
