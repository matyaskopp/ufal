#!/bin/bash
TESTLOCATION='http://ufal.mff.cuni.cz/~kopp/tred_beta'
cd ~/Downloads
sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev

wget "$TESTLOCATION/install_tred.bash"
sed -i .bak "s@http://ufal.mff.cuni.cz/tred@$TESTLOCATION@" install_tred.bash

echo "Setting CPAN"
echo `eval $(perl -I$HOME/.perl/lib/perl5 -Mlocal::lib=$HOME/.perl)` >> ~/.bashrc
perl -I$HOME/.perl/lib/perl5 -Mlocal::lib=$HOME/.perl

echo "Installing TrEd"
bash install_tred.bash --tred-dir ~/tred
