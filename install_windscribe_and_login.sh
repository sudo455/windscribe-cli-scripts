#!/bin/bash
echo "clone and installing windscribe-cli"
git clone https://github.com/hkuchampudi/Windscribe.git
cd Windscribe/
makepkg -si
# cloning and installing windscribe-cli
echo "\n done"
# starting the service
echo "Status of the winscribe-cli systemd service: \n"
systemctl status windscribe.service
echo "Starting windscribe-cli: \n"
sudo systemctl start windscribe
echo "Enabling windscribe-cli systemd service \n"
sudo systemctl enable windscribe

#login part
windscribe login

# and removing the folder from the working tree
cd ../
rm -rf Windscribe/
