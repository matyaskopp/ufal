# TrEd Release

## Installation of prerequisites (linux)
The following tutorial was tested on Ubuntu 16.4.
### subversion
```
sudo apt-get install subversion
svn checkout https://svn.ms.mff.cuni.cz/svn/TrEd
```
### perlbrew
#### instalation
```
curl -L https://install.perlbrew.pl | bash
```
#### run
```
~/perl5/perlbrew/bin/perlbrew install perl-5.24.0
~/perl5/perlbrew/bin/perlbrew alias create perl-5.24.0 tred
~/perl5/perlbrew/bin/perlbrew switch tred
~/perl5/perlbrew/bin/perlbrew install-cpanm
```

### install system deps

```
sudo ap-get update

sudo apt-get install libxml2-dev
sudo apt-get install libxslt1-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libgdbm-dev

sudo apt-get install  libexpat1-dev # for XML:RSS (XML::Parser   precisely)

sudo apt-get install p7zip-full
ln -s /home/tred/perl5/bin/xsh /home/tred/perl5/bin/xsh2

sudo apt-get install nsis
sudo apt-get install xsltproc
sudo apt-get install dpkg-dev debhelper devscripts fakeroot
sudo apt-get install rpm
```

### instal perl deps
Install following perl dependencies with `~/perl5/perlbrew/bin/cpanm MODULE`

```
Archive::Extract
DateTime::Locale
Class::Load
DateTime::TimeZone
Class::Singleton
Test::Exception
DateTime
Pod::XML
XML::XSH2
XML::RSS
File::ShareDir
File::Which
UNIVERSAL::DOES
XML::CompactTree
XML::LibXML
XML::Writer
XML::CompactTree::XS
XML::LibXSLT
MyCPAN::App::DPAN
Pod::Xhtml
CGI
```

## Installation of prerequisites (mac)
TODO

## Release

