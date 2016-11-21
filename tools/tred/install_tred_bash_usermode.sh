#!/bin/bash
TESTLOCATION='http://ufal.mff.cuni.cz/~kopp/tred_beta'
cd ~/Downloads
sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev

wget "$TESTLOCATION/install_tred.bash"
sed -i "s@http://ufal.mff.cuni.cz/tred@$TESTLOCATION@" install_tred.bash

#Setting up cpan (so that it uses local directories; http://www.perlmonks.org/?node_id=630026):
mkdir -p ~/.cpan/CPAN 
touch ~/.cpan/CPAN/MyConfig.pm (or echo "1" >~/.cpan/CPAN/MyConfig.pm, or cp /root/.cpan/CPAN/Config.pm ~/.cpan/CPAN/MyConfig.pm if the subsequent command does not work)

echo "o conf init\nuse local::lib\nadd settings to .bashrc\npress ctrl+d to exit"
perl -MCPAN -e shell 

#Installing cpanm for easier installation of other Perl modules
cpan App::cpanminus

#Installing some dependencies (UNIVERSAL::DOES, patched PerlIO::gzip, Treex::PML)
cpanm UNIVERSAL::DOES
wget http://search.cpan.org/CPAN/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.18.tar.gz
wget http://www.cpan.org/authors/id/S/SR/SREZIC/patches/PerlIO-gzip-0.18-RT92412.patch
tar -xzf PerlIO-gzip-0.18.tar.gz 
patch PerlIO-gzip-0.18/Makefile.PL < PerlIO-gzip-0.18-RT92412.patch 
cd PerlIO-gzip-0.18/ 
perl Makefile.PL 
make && make test && make install 
cd .. 
rm -rf PerlIO-gzip-0.18*
cpanm Treex::PML



echo "Installing TrEd"
bash install_tred.bash --tred-dir ~/tred
