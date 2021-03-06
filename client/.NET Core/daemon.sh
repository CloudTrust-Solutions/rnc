########################################################
# To configure Remote Network Connection™ as a Linux daemon
########################################################

########################################################
# Create SystemD rncsvc.service file
########################################################
cat > rncsvc.service <<EOF
[Unit]
Description=Remote Network Connection Service
After=network.target

[Service]
ExecStart=/usr/bin/dotnet $(pwd)/bin/RNCService.dll
Restart=always
#Restart=on-failure
RestartSec=2 # Restart service after 2 seconds if dotnet service crashes
SyslogIdentifier=remotenetworkconnection

[Install]
WantedBy=multi-user.target
EOF

########################################################
# Configure SystemD
########################################################
sudo cp rncsvc.service /lib/systemd/system

########################################################
# Reload SystemD and enable the service, so it will
# restart on reboots
########################################################
sudo systemctl daemon-reload
sudo systemctl enable rncsvc

########################################################
# Start service
########################################################
sudo systemctl start rncsvc

########################################################
# View service status
########################################################
systemctl status rncsvc

########################################################
# Tail the service log
########################################################
journalctl --unit rncsvc --follow

########################################################
# Stop service
########################################################
sudo systemctl stop rncsvc
systemctl status rncsvc

########################################################
# Restart the service
########################################################
sudo systemctl start rncsvc
systemctl status rncsvc

########################################################
# Ensure service is stopped
########################################################
sudo systemctl stop rncsvc

########################################################
# Disable
########################################################
sudo systemctl disable rncsvc

########################################################
# Remove and reload SystemD
########################################################
sudo rm rncsvc.service /lib/systemd/system/rncsvc.service
sudo systemctl daemon-reload

########################################################
# Verify SystemD
########################################################
systemctl --type service |& grep rncsvc 

