# VNC + Chromium + Node.js in Docker

This Docker container provides a lightweight, Ubuntu-based desktop environment accessible via VNC and a web browser. It includes:

- **Xfce** desktop environment
- **Chromium**
- **Node.js (v18.x)**
- **x11vnc** (VNC server)
- **noVNC** (web-based VNC client)
- **Resolution: 1920x1080**
- **Password-protected VNC access**

## Usage

### Build the Docker Image

```sh
# Replace 'myvncimage' with your preferred image name
docker build -t myvncimage .
```

### Run the Container

```sh
docker run -it \
  -p 5901:5901 \  # Raw VNC access
  -p 8080:8080 \  # Web-based VNC (noVNC)
  -e VNC_PASSWORD="mySuperSecret" \  # Set VNC password
  myvncimage
```

### Access the Container

- **VNC Client:** Connect to `vnc://localhost:5901` using a VNC client like RealVNC or TightVNC.
- **Web Browser:** Open `http://localhost:8080` in a browser to use noVNC.

## Configuration

- **VNC Password**: Set via the `VNC_PASSWORD` environment variable (default: `password`).
- **Resolution**: Set to **1920x1080**, but can be adjusted by modifying `start.sh`.

## Ports

| Port  | Purpose          |
|-------|-----------------|
| 5901  | VNC Server      |
| 8080  | Web-based VNC   |

## File Overview

- **Dockerfile**: Defines the container's base image, installs required packages, and configures VNC + noVNC.
- **start.sh**: Startup script that initializes the virtual display, VNC server, and web-based VNC.

## License

This project is licensed under the **MIT License**.

