#!/bin/bash

# Enter your commands here, e.g.
# echo "Start build!"

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate