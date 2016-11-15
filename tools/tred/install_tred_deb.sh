#!/bin/bash
TESTLOCATION='http://ufal.mff.cuni.cz/~kopp/tred_beta'
cd ~/Downloads
sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev

wget "$TESTLOCATION/install_tred.deb"


echo "Installing TrEd"
sudo dpkg -i ./tred.deb
sudo apt-get -f install