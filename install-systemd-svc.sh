#!/bin/bash
SERVICENAME=$(basename $(pwd))

if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

echo "Creating systemd service... /etc/systemd/system/${SERVICENAME}.service"

# Create systemd service file
cat >/etc/systemd/system/$SERVICENAME.service <<EOF
[Unit]
Description=$SERVICENAME
Requires=lircd.service
After=lircd.service

[Service]
Type=simple
Restart=Always
TimeoutSec=600
User=root
Group=root
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/run.sh

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling systemd service $SERVICENAME"
systemctl enable $SERVICENAME.service

echo "Starting $SERVICENAME"
systemctl start $SERVICENAME.service

