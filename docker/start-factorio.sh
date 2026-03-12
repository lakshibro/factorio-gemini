#!/bin/bash

Xvfb $DISPLAY -screen 0 640x640x16 &

while ! xdpyinfo -display $DISPLAY >/dev/null 2>&1; do
  sleep 0.1
done

x11vnc -display $DISPLAY -nopw -forever &
websockify --web=/usr/share/novnc/ 5901 localhost:5900 &

# Start wrapper (which starts factorio)
cd /workspace/packages/factorio-wrapper
pnpm start &

# Wait for wrapper to start (WebSocket)
sleep 10

# Start agent
cd /workspace/packages/agent
pnpm start

# Keep script running
wait
