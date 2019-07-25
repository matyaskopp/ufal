# PML-TQ: Questions and answers

## How much storage will I need to store PML-TQ Server and related apps?
```
1,1G	/opt/pmltq-server
487M	/opt/pmltq-web
169M	/opt/print-server
28M	/opt/tred_refactored
33M	/opt/treex
```
This contains 600 MB of logs and some previous releases. **10 GB** is enough when you add installed postgres database


## How much storage will I need to store data?

### Quick answer:

20 times more than you need to store raw (decompressed) data in [PML](http://ufal.mff.cuni.cz/jazz/PML/doc/pml_doc.html) format.

### Long answer:

As an example I will use [Prague Dependency Treebank 3.0](https://ufal.mff.cuni.cz/pdt3.0). PDT 3.0 has quite rich annotations so estimation of storage size will approximate to upper bound.

[Print server](https://github.com/ufal/pmltq-print-server) and [Suggest server](https://github.com/ufal/pmltq-suggest-server) need pml data

gz compressed:
```
du -sh /opt/pmltq-data/pdt30/data
142M	/opt/pmltq-data/pdt30/data
```
**or** decompresed xml files:
```
du -sh /opt/pmltq-data/pdt30/data_xml/
212M	/opt/pmltq-data/pdt30/data_xml/
```



When you use print server it caches generated trees or you can use pregenerated trees. Both ways can store data at size:
```
du -sh /opt/pmltq-data/pdt30/svg
1,1G	/opt/pmltq-data/pdt30/svg
```

We usually store sql scripts that loads data to database:

```
du -sh /opt/pmltq-data/pdt30/sql_dump..postgres/
256M	/opt/pmltq-data/pdt30/sql_dump..postgres/
```

Size of database (not real size on disk):
```
psql -d pdt30 -c "SELECT pg_size_pretty(pg_database_size('pdt30'));"
2141 MB
```

Size of database on disk (postgres 9.3):
```
du -sh /var/lib/postgresql/9.3/main/base/69044/
742M	/var/lib/postgresql/9.3/main/base/69044/
```
This can be affected by postgres implementation so we will use unpacked size of database for storage size estimation.

**Calculation:** 212M (pml data) + 1,1G (svg trees) + 256M (dumped database) + 2141 MB (database) => **3.7 GB** that is 17.6 times more than 212MB.
When we estimate **20 times more space than raw decompressed pml** files we determine safe upper bound of disk usage.
