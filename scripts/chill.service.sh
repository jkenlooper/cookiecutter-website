#!/usr/bin/env bash

SRCDIR=$1
SERVICENAME=$2

cat <<HERE

# Should be placed in /etc/systemd/system/
# sudo cp scripts/${SERVICENAME}.service /etc/systemd/system/
#
# Start and enable the service
# sudo systemctl start ${SERVICENAME}
# sudo systemctl enable ${SERVICENAME}
#
# Stop the service
# sudo systemctl stop ${SERVICENAME}
#
# View the end of log
# sudo journalctl --pager-end _SYSTEMD_UNIT=${SERVICENAME}.service
#
# Follow the log
# sudo journalctl --follow _SYSTEMD_UNIT=${SERVICENAME}.service
#
# View details about service
# sudo systemctl show ${SERVICENAME}
#
# Check the status of the service
# sudo systemctl status ${SERVICENAME}.service
#
# Reload if ${SERVICENAME}.service file has changed
# sudo systemctl daemon-reload

[Unit]
Description=Chill llama3-weboftomorrow-com instance
After=network.target

[Service]
User=dev
Group=dev
WorkingDirectory=$SRCDIR
ExecStart=${SRCDIR}bin/chill run

[Install]
WantedBy=multi-user.target

HERE


