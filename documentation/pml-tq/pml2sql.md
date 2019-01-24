# PML to PostgreSQL conversion and publication

This tutorial shows conversion and treebank publication of a [sample data](https://metacpan.org/source/MATY/PMLTQ-1.3.1/xt/author/treebanks/pdt_test) of Prague dependency treebank. We expects following directory structure:
```
pt
pt/resources
pt/data
```
All commands will be ran from `pt` directory.

## Requirements
### Client
- Linux operating system
- [Perl PMLTQ::Commands module](https://metacpan.org/pod/distribution/PMLTQ-Commands/lib/PMLTQ/Commands.pm) - minimal version 2.0.1
- Treebank in valid [PML](http://ufal.mff.cuni.cz/jazz/PML/) format
- Accounts:
 - Access to servers file system (copying PML data to server + service restart)
 - Database account with create database privileges (loading data to database)
 - PML-TQ Web administrator account (making treebank public)

### Server
- Linux operating system
- PostgreSQL
- [Perl PMLTQ module](https://metacpan.org/release/PMLTQ) - minimal version 1.3.1
- [PMLTQ::Server](https://github.com/ufal/perl-pmltq-server)
- [PML-TQ Web](https://github.com/ufal/perl-pmltq-web)
- TrEd with extensions for treebank
- bTrEd macro PrintServer

### Configuration file (`init`)

Configuration file is in a YAML format and contains a necessary information about conversion and treebank deployment. Command `pmltq init resources/{a,t}*` runs a step-by-step guide that asks for some aditional information (Full treebank title, Treebank ID). Resources files contains path to treebanks schema. Finally it creates a template of configuration file:
``` yaml
---
#data_dir: ''
#description: ''
#homepage: ''
#isFeatured: 'false'
#isFree: 'false'
#isPublic: 'false'
#language: 'lang code'
#manuals:
#  -
#    title: ''
#    url: ''
#output_dir: ''
#sys_db: postgres
#tags:
#  - mytag
#test_query:
#  queries:
#    -
#      filename: 01.svg
#      query: 'a-node [];'
#  result_dir: webverify_query_results
#web_api:
#  dbserver: ''
#  password: ''
#  url: ''
#  user: ''
db:
#  host: localhost
#  password: ''
#  port: 5432
#  user: ''
  name: pt
layers:
  -
#    path: '<change this to point to files relative to the data directory on server>'
    data: '<change this to point to files relative to the data_dir>'
    name: adata
    references:
      a-root/s.rf: '-'
      m-node/id: '-'
      m-node/src.rf: '-'
      w-node/id: '-'
  -
#    path: '<change this to point to files relative to the data directory on server>'
    data: '<change this to point to files relative to the data_dir>'
    name: tdata
    references:
      st-node/tnode.rfs: t-node
      t-a/aux.rf: adata:a-node
      t-a/lex.rf: adata:a-node
      t-bridging-link/target_node.rf: t-node
      t-coref_text-link/target_node.rf: t-node
      t-discourse-link/a-connectors.rf: adata:a-node
      t-discourse-link/all_a-connectors.rf: adata:a-node
      t-discourse-link/t-connectors.rf: t-node
      t-discourse-link/target_node.rf: t-node
      t-node/compl.rf: t-node
      t-node/coref_gram.rf: t-node
      t-node/val_frame.rf: '-'
      t-root/atree.rf: adata:a-root
    related-schema:
      - adata_30_schema.xml
resources: resources
title: 'PDT Test'
treebank_id: pt
```
### Command line options
Settings can be done as a command line parameters. It ovewrites settings in file. Subsection setting is done throw`-`. For example `--db-name=pt` means
``` yaml
db:
  name: pt
```


## Treebank conversion (`convert`)

Treebank conversion is ran with command `pmltq convert`. There must be setted additional information in configuration file:
``` yaml
data_dir: 'relative path to data to current directory'
```
For each layer has to be setted `data` field that stores relative path template to data to `data_dir`. For example: `data: '*.a.gz'`. `output_dir` can be setted. If it is not setted `'sql_dump'` is used as a default value.

## Load treebank to database (`initdb`, `load`, `verify`)

For following operations has to be setted database credentials in addition to previouse config file.
```yaml
sys_db: postgres
db:
  host: 'database.server'
  password: 'pass'
  port: 5432
  user: 'db.nick'
  name: pt
```

Command `pmltq initdb` creates a database into that will be loaded treebank data and creates tables that are common for all treebanks. Than has to be ran command `pmltq load` that loads treebank to database. Whole load process can be verified with `pmltq verify`.

### Possible errors
#### Unable to connect to database
After running `pml initdb` can occur following error:
```
DBI connect('dbname=postgres;host=database.server;port=5432','nick',...) failed: FATAL:  no pg_hba.conf entry for host "YOUR IP ADDRESS", user "db.nick", database "postgres", SSL on FATAL:  no pg_hba.conf entry for host "YOUR IP ADDRESS", user "db.nick", database "postgres", SSL off at /usr/local/share/perl/5.22.1/PMLTQ/Command.pm line 54.
```
The cause of this error is that it is not allowed to access to database from `YOUR IP ADDRESS` in `pg_hba.conf`. Possible solution is to make a ssh tunnel to database server.
``` bash
ssh -t -L 15432:127.0.0.1:5432 ssh.nick@database.server
```
And modify following lines in config file:
``` yaml
db:
  host: localhost
  port: 15432
```

## Copy PML data to PML-TQ Server
You can copy PML data to a server with following command. BTrEd macro [PrintServer](https://github.com/ufal/pmltq-print-server) uses this files for tree rendering. This files must have enough access privileges.
``` bash
scp -r ../pt pmltq.nick@pmltq.server:/datapath
```
## Treebank publication (`webload`)
Command `pmltq webload` loads following settings to web interface.
``` yaml
description: ''
homepage: ''
isFeatured: 'false'
isFree: 'false'
isPublic: 'false'
language: 'lang code'
manuals:
  -
    title: ''
    url: ''
tags:
  - mytag
web_api:
  dbserver: ''
  password: ''
  url: ''
  user: ''
layers:
  -
    path: 'pt/data'
  -
    path: '<change this to point to files relative to the data directory on server>'
```

## Verification of whole process (`webverify`)

After whole process you can verify it with command `pmltq webverify`. In this example it runs `a-nbode []` query on treebank and saves the result to `webverify_query_results/01.svg`
``` yaml
test_query:
  queries:
    -
      filename: 01.svg
      query: 'a-node [];'
  result_dir: webverify_query_results
```
### Possible errors
Svg files are cached, you have to remove cache after change.
**Empty svg file** - wrong path to data on server
**Tree without labels** - wrong stylesheets, unknown language

## Removing treebank (`delete`, `webdelete`)
`pmltq webdelete` removes treebank from webinterface and `pmltq delete` removes it from database. PML files on server stay untouched.
## Euler settings (ÚFAL)
``` bash
datapath="/opt/pmltq-data"
ssh.nick="pmltq"
pmltq.nick="pmltq"
db.nick="pmltq"
database.server="euler.ms.mff.cuni.cz"

--web_api-dbserver="euler"
--web_api-user="!!! yourLocalAdminUser (not Shibboleth)!!!"
--web_api-url="https://lindat.mff.cuni.cz/services/pmltq/"
```
## Links
