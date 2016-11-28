#!/bin/bash
TESTLOCATION='http://ufal.mff.cuni.cz/~kopp/tred_beta'
cd ~/Downloads
sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev || exit 1

wget "$TESTLOCATION/install_tred.bash"
sed -i "s@http://ufal.mff.cuni.cz/tred@$TESTLOCATION@" install_tred.bash


read -r -p "Do you want to configure local cpan? [Y/n] " response
if [[ "$response" -eq 'n' ]]
then
  echo -ne "\n\n\n" | perl -MCPAN -e shell
else
  exit 0 
fi
response=''
read -r -p "Install Mojo::Base::XS - PML-TQ needs it? [Y/n] " response
if [[ "$response" -eq 'n' ]]
then
  cpan Mojo::Base::XS
fi


#wget -O- http://cpanmin.us | perl - -l ~/perl5 App::cpanminus local::lib || exit 2
#eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
#eval `export MANPATH=$HOME/perl5/man:$MANPATH`
#echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> ~/.profile
#echo 'export MANPATH=$HOME/perl5/man:$MANPATH' >> ~/.profile




###
#Installing some dependencies (UNIVERSAL::DOES, patched PerlIO::gzip, Treex::PML)
# cpanm UNIVERSAL::DOES - not needed

#wget http://search.cpan.org/CPAN/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.18.tar.gz
#wget http://www.cpan.org/authors/id/S/SR/SREZIC/patches/PerlIO-gzip-0.18-RT92412.patch
#tar -xzf PerlIO-gzip-0.18.tar.gz 
#patch PerlIO-gzip-0.18/Makefile.PL < PerlIO-gzip-0.18-RT92412.patch 
#cd PerlIO-gzip-0.18/ 
#perl Makefile.PL 
#make && make test && make install 
#cd .. 
#rm -rf PerlIO-gzip-0.18*

#cpanm Treex::PML



echo "Installing TrEd"
bash install_tred.bash --tred-dir ~/tred
