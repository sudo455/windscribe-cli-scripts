#!/bin/bash

echo ""
echo "github clone and installing windscribe-cli"
echo ""
git clone https://github.com/hkuchampudi/Windscribe.git
cd Windscribe/
makepkg -si

# cloning and installing windscribe-cli
echo ""
echo "done"
echo ""

# starting the service
echo "Status of the winscribe-cli systemd service:"
echo ""
systemctl status windscribe.service
echo ""
echo "Starting windscribe-cli:"
echo ""
sudo systemctl start windscribe
echo ""
echo "Enabling windscribe-cli systemd service"
echo ""
sudo systemctl enable windscribe

#login part
echo ""
echo "now you will be prompted to login with your credentials"
echo ""
windscribe login

# and removing the folder from the working tree
cd ../
rm -rf Windscribe/
