# Poznámky

## PML

- přesun Treex::PML na github do repozitáře **treex-pml**. Zatím přesunout kompletní svn repozitář a později uklidit
  - zjistit jak je svn napojen na ostatní repozitáře  - TrEd, ... ?
  - do tohoto repozitáře přidat:
    - nástroje pro validaci PML, složka `tools`
      - [pmltk](http://ufal.mff.cuni.cz/jazz/PML/index.html)
    - známá schémata - `resources`, rozsložkovat: `resources/{jméno}/{verze}`
    - složku s dokumentací: `doc`
- předělat buildovací skript na dzil
- přidat do definice PML schématu prázdnou roli `#` nebo ` ` ?
- přesunout z domény ufal/jazz/pml na ufal/pml ??? + zachovat odkaz

## PML-TQ core

- u konverze vynutit unikátnost identifikátorů přes celý treebank (nejen v rámci jednoho souboru).

## PML-TQ server
## PML-TQ web

- **Node inspection**
  - udělat před překopáním printserveru, pro případ, že bychom z PML stromečků potřebovali vytáhnout nějaký další údaj

## Print server

- rozdělit na
  - **suggest**
    - Z tredu používá:
      - `TrEd::Utils::parse_file_suffix($p);` - funkce nemá žádné další závislosti na tredu
      - `$TrEd::Convert::inputenc` - `="UTF-8"`
      - `TrEd::Utils::applyFileSuffix($win,$pos->[1])` - asi také žádné závislosti
  - **tree_server**
    - bude jen posílat svg soubory uložené na disku, cache musí být rozdělená na treebanky a jména souborů by měla vystihovat stromy
    - nyní se jména souboru vytváří na základě hashe jména pml souboru a pořadí stromu v souboru.
    - Nefunguje caching svg souborů vizualizujících dotaz, vzhledem ke způsobu vytváření dočasných souborů s dotazem v pml formátu - vytvoří se náhodný název
  - **tree_generator**
    - btred skript, který vygeneruje svg soubory pro všechny stromy v souborech

### vizualizace dotazu

PMLTQ::Server umí požádat printserver o vizualizaci dotazu:

```bash
curl 'https://lindat.mff.cuni.cz/services/pmltq/api/treebanks/pdt30/query/svg' --data-binary '{"query":"t-node []"}'
```

Stará se o to `PMLTQ::Server::Controller::Svg::query_svg(...)`