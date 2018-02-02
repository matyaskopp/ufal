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
Nejprve vytvořit alternativní printserver `print_srvr_pmltq_web.btred`, který nebude posílat javascript + možná dále zjednodušší svg soubor využitím parametrů v `Tk::Canvas::SVG`. Dále by mohl lépe cachovat svg soubory - rozdělit do složek podle treebanků a lépe pojmenovat soubory.

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
    - Rozmyslet, kam ukládat svg soubory - možná je přidat přímo do složky k treebanku `{treebank}/svg`.
    - Nemůže vzniknout problém s množstvím souborů v jedné složce? Pak by možná chtělo na každý soubor vytvořit složku.
  - **tree_generator**
    - btred skript, který vygeneruje svg soubory pro všechny stromy v souborech
    - upravit / vytvořit nový `Tk::Canvas::SVG`, aby do svg souboru nepřidával zbytečnosti (javascript)
      - lepší by asi bylo vytvořit nový, kvůli zpětné kompatibilitě s `PMLTQ::CGI`
      - parametr `-balloonmsg` říká, jestli se má vložit javascript do svg souboru
    - zamyslet se na oddělením css stylu a svg souboru. SVG soubor je v dokumentu inlinovaný, takže by to mělo jít. Jeden styl je pro všechny stromy daného treebanku společný:
```xml
<path id="i6" d="M38,349 L48,263" fill="none" stroke="#555555" stroke-width="2" stroke-dasharray="none" stroke-linejoin="round" stroke-linecap="butt" class="line scale_width scale_arrow seg:0.0"></path>
<ellipse id="i1" cx="28.5" cy="20" rx="3.5" ry="3.5" stroke-width="1" stroke-dasharray="none" stroke="#000000" fill="#bbbbbb" class="point node #t-cmpr9410-019-p28s2 seg:0.0">
  <desc>genre: topic_interv</desc>
</ellipse>
<rect id="i3" x="24" y="32" width="149" height="15" stroke-width="0" stroke-dasharray="none" stroke="#ffffff" fill="#ffffff" fill-opacity="0.9" stroke-opacity="0.9" class="textbg seg:0.0"><!--obdélník pod textem--></rect>
 <text x="25" y="44" id="i2" text-anchor="start" font-family="DejaVu Sans" font-weight="normal" font-size="12" font-slant="roman" fill="#000000" width="0" class="text text_item seg:0.0">t-cmpr9410-019-p28s2</text>
```
    - Mají se generovat i pdf soubory?

### vizualizace dotazu

PMLTQ::Server umí požádat printserver o vizualizaci dotazu:

```bash
curl 'https://lindat.mff.cuni.cz/services/pmltq/api/treebanks/pdt30/query/svg' --data-binary '{"query":"t-node []"}'
```

Stará se o to `PMLTQ::Server::Controller::Svg::query_svg(...)`