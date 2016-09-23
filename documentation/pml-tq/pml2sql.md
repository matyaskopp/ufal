# PML to PostgreSQL conversion and publication

This tutorial shows conversion and treebank publication of a [sample data](https://metacpan.org/source/MATY/PMLTQ-1.3.1/xt/author/treebanks/pdt_test) of Prague dependency treebank.

## Requirements
### Client
- Linux operating system
- [Perl PMLTQ module](https://metacpan.org/release/PMLTQ) - minimal version 1.3.1
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
**TODO: basic description of the file. Add new part of configuration file at each section .**

Configuration file is in a YAML format and contains a necessary information about conversion and treebank deployment. Command `pmltq init resources/{a,t}*` runs a step-by-step guide that asks for some aditional information (Full treebank title, Treebank ID). Resources files contains path to treebanks schema. Finally it creates a template of configuration file:
```
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
#text_query:
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


## Treebank conversion (`convert`)
## Load treebank to database (`initdb`, `load`, `verify`)
## Treebank publication (`webload`, `webverify`)
## Removing treebank (`delete`, `webdelete`)
## Links
