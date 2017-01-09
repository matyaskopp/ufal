# PML-TQ Server Installation and Configuration

## Overview

[TOC]


- postgres
- create user pmltq
- perlbrew for:
  - printserver
  - pmltq server (PMLTQ::Server, PMLTQ)



## User and directories 

```bash
sudo apt-get update
sudo apt-get install libxml2-dev libxslt1-dev zlib1g-dev libgdbm-dev libx11-dev

sudo adduser pmltq
```
Then you will be asked for a password.
```bash
sudo apt install subversion git
cd /opt
sudo mkdir pmltq-data pmltq-server pmltq-web print-server tred_refactored treex
sudo mkdir print-server/svg_cache
sudo chown pmltq:pmltq pmltq-server pmltq-web print-server tred_refactored treex
sudo chown pmltq:www-data pmltq-data print-server/svg_cache
```

## postgresql
Following lines are for Ubuntu Xenial
```bash
https://www.postgresql.org/download/linux/ubuntu/
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
```

```bash
sudo apt-get update
sudo apt-get install postgresql
sudo su postgres
psql -d postgres -U postgres
```
Do following command in postgres console:
```sql
CREATE ROLE pmltq WITH LOGIN PASSWORD 'P_A_S_S';
CREATE DATABASE pmltq_server;
```
##perlbrew

```bash
sudo apt-get install make gcc
curl -L https://install.perlbrew.pl | bash
~/perl5/perlbrew/bin/perlbrew install perl-5.24.0  --notest -Dcc=gcc
~/perl5/perlbrew/bin/perlbrew alias create perl-5.24.0 pmltq-perl

perlbrew install perl-5.22.0  --notest -Dcc=gcc
~/perl5/perlbrew/bin/perlbrew alias create perl-5.22.0 print-server
```
## Treex
```bash
sudo apt-get install libexpat1-dev
```

```bash
cd /opt
git clone https://github.com/ufal/treex.git

perlbrew use print-server
cd /opt/treex
cpanm --installdeps .
```

##Printserver and TrEd
```bash
sudo apt-get install xvfb

sudo su pmltq 

cd /opt
svn checkout https://svn.ms.mff.cuni.cz/svn/TrEd/trunk/tred_refactored/

cd print-server
git clone https://github.com/ufal/pmltq-print-server.git
cp pmltq-print-server/print_srvr_simple.btred . # symlink does not work: ln -s pmltq-print-server/print_srvr_simple.btred
cp pmltq-print-server/print.btred . #  symlink does not work: ln -s pmltq-print-server/print.btred
```
Create file `/opt/print-server/btred.rc`:
```bash
;font='{Arial Unicode Ms} 9'
font='{Arial} 9'
pml_compile=2

ExtensionsDir=/opt/print-server/tred-extensions
```


### Install perl dependencies for Printserver
```bash
perlbrew use print-server
cpanm URI::Escape
cpanm Treex::PML
cpanm Readonly
cpanm Tk::widgets


```


## PMLTQ::Server
**On your PC:**
```bash
#### clone repository
git clone https://github.com/ufal/perl-pmltq-server.git
cd perl-pmltq-server
#### install Rex
cpanm Rex
```
Edit or copy and edit `Rexfile` file and set it.
```bash
cp Rexfile Rexfile.new
rex deploy -f Rexfile.new deploy
```

## PMLTQ
**TODO** change perlbrew !!!
```bash
perlbrew use pmltq-perl
cpanm PMLTQ
```
## initialize database
```bash
sudo apt-get install libssl-dev
sudo apt-get install libpq-dev

sudo su pmltq
perlbrew use pmltq-perl
cd /opt/pmltq-server/current
cpanm --installdeps .

cd /opt/pmltq-server/shared
```
Change content of configuration file `pmltq_server.private.pl`:
```perl
{
  data_dir => '/opt/pmltq-data',
  shibboleth => 1,
  mailgun => {
        key => 'your-key',
    domain => 'your-domain',
    from => 'pmltq@test.cz',
    driver => 'test'
  },
  database => {
    dsn => 'dbi:Pg:dbname=pmltq_server',
    user => 'pmltq',
    password => 'P_A_S_S',
    pg_enable_utf8 => 1
  },
  hypnotoad => {
    listen  => ['http://*:9090'],
    proxy   => 1,
    workers => 5,
    pid_file => '/opt/pmltq-server/shared/pmltq-server.pid',
    heartbeat_timeout => 300,
    graceful_timeout => 300,
    upgrade_timeout => 300,
    inactivity_timeout => 300
  }
};
```

```bash
cd /opt/pmltq-server/current
./script/db-migration install
./script/db-migration populate
psql -d pmltq_server-U pmltq

```
Add admin/admin user.
```sql
UPDATE users SET password = '$2$08$bAOnumbVJ/uhknku47A0DO9JZxBMOca7I.1vFBNH7z1dLArYjCBmq' WHERE id='1';
```
## Extensions
```bash
cd /opt/print-server
svn checkout https://svn.ms.mff.cuni.cz/svn/TrEd/extensions/
mv extensions tred-extensions
ln -s /opt/treex/lib/Treex/Core/share/tred_extension/treex /opt/print-server/tred-extensions/
```
Edit extension list file: `/opt/print-server/tred-extensions/extensions.lst`. Add `!` at the begining of line for not used extensions and add new extensions on the new line.

```bash
cd tred-extensions
mv pmltq pmltq_old
git clone https://github.com/ufal/tred-extension-pmltq.git
mv tred-extension-pmltq pmltq
```

### Install deps
```
perlbrew use print-server
cpanm PMLTQ
```


## PML-TQ Web
**On your PC:**
```bash
git clone https://github.com/ufal/perl-pmltq-web.git
cd perl-pmltq-web

curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash
nvm install stable
nvm use stable

make build
rsync --verbose  --progress --stats --recursive -e "ssh -p $portNumber" dist/* pmltq@your.server:/opt/pmltq-web
```
## Data
### Treebank Migration from Other PML-TQ Server Instance
#### sql_dump.postgres (source pml2sql < v1.0)
Create database with postgres system user
```bash
sudo su postgres
db=TREEBANK
psql -c "CREATE DATABASE $db WITH TEMPLATE=template0 ENCODING = 'UTF8';"
```

```bash
sudo su pmltq
tb=TREEBANK
cd /opt/pmltq-data/$tb/sql_dump.postgres
psql -d ptb3_atis -f `perl -MPMLTQ -e 'print PMLTQ->shared_dir;'`/sql/init.sql
## for each ${LAYER} run:
  sh ${LAYER}__init.sh -u pmltq -d $tb
```
#### sql_dump

### Adding New Treebank
Follow [this](https://github.com/matyaskopp/ufal/blob/master/documentation/pml-tq/pml2sql.md) tutorial.
## Start services

### ubic
```
perlbrew use pmltq-perl
cpanm Ubic
cpanm Ubic::Service::Hypnotoad
cpanm Carton
ubic-admin setup
# Would you like to configure as much as possible automatically? [Y/n] y
cd /opt/pmltq-server/current
carton install

mkdir ~/ubic/services/pmltq
```
copy following files ... to `~/ubic/services/pmltq` directory. And modify password to postgres database in `~/ubic/services/pmltq/print`.


### Start PML-TQ Web
