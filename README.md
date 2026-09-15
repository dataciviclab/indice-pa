# IndicePA Intelligence

**Chi è la Pubblica Amministrazione italiana, come è organizzata, e chi la governa?**

Sistema di intelligence sull'anagrafe della PA italiana: raccoglie i dati ufficiali IPA (AgID),
li trasforma in mart analitici e li rende interrogabili via dashboard Streamlit.

- **Fonte**: [IndicePA - AgID](https://indicepa.gov.it/ipa-dati/)
- **Copertura**: 2026 (aggiornamento continuo)
- **Livello**: Nazionale - tutti gli enti pubblici italiani
- **Output pubblico**: Dashboard Streamlit + Discussion

## Cosa risponde

1. **Chi è la PA italiana?** → 23.532 enti, 53 categorie, 122.706 uffici
2. **Come sono organizzati gli enti?** → strutture organizzative, AOO, gerarchie
3. **Chi governa ogni ufficio?** → responsabili, contatti, PEC
4. **Chi sta digitalizzando?** → RTD, servizi digitali, servizi UO
5. **Qual è la qualità dei dati?** → copertura PEC, responsabili, protocollo

## Dataset

| Dataset | Anni | Mart | Descrizione |
|---|---|---|---|
| ipa_enti | 2026 | 2 | Anagrafica completa enti (23.532) |
| ipa_unita_organizzative | 2026 | 2 | Uffici degli enti (122.706) |
| ipa_aree_organizzative_omogenee | 2026 | 2 | Aree organizzative e protocollo (39.399) |
| ipa_categorie_enti | 2026 | 1 | Lookup categorie (53) |
| ipa_rtd | 2026 | 2 | Responsabili Transizione Digitale (20.880) |
| ipa_servizi_digitali | 2026 | 2 | Servizi online erogati (10.142) |
| ipa_servizi_uo | 2026 | 2 | Servizi per ufficio (6.222) |

### Compose

| Compose | Support | Mart | Descrizione |
|---|---|---|---|
| who_is_who_pa | 5 | 1 | Vista unica: UO + ente + AOO + RTD + categorie |

### Mart analitici (16 totali)

**Enti** (2): ipa_enti, ipa_enti_riepilogo

**UO** (2): ipa_unita_organizzative, ipa_unita_organizzative_riepilogo

**AOO** (2): ipa_aree_organizzative_omogenee, ipa_aree_organizzative_omogenee_riepilogo

**Categorie** (1): ipa_categorie_enti

**RTD** (2): ipa_rtd, ipa_rtd_riepilogo

**Servizi Digitali** (2): ipa_servizi_digitali, ipa_servizi_digitali_riepilogo

**Servizi UO** (2): ipa_servizi_uo, ipa_servizi_uo_riepilogo

**Compose** (1): who_is_who_pa

## Dashboard

Dashboard Streamlit con 6 pagine:

| Pagina | Contenuto |
|---|---|
| Panoramica | KPI enti, UO, AOO, copertura responsabili, vertici PA |
| Cerca Ufficio | Ricerca per nome ufficio, responsabile, RTD |
| Scheda Ente | Dettaglio ente con UO, servizi digitali, RTD |
| Trasformazione Digitale | RTD, servizi digitali, servizi UO |
| Qualità Dati | Copertura campi, placeholder, problemi noti |
| Query SQL | Query libere su tutti i mart |

## Come si usa

```bash
# Setup
pip install -r requirements.txt

# Validare config
make check

# Eseguire tutte le pipeline
make run

# Dashboard
cd dashboard && streamlit run app.py
```

## Struttura

```
.github/workflows/          # CI/CD (check reusable)
datasets/                   # Pipeline toolkit (7 dataset)
  ipa-enti/
  ipa-unita-organizzative/
  ipa-aree-organizzative-omogenee/
  ipa-categorie-enti/
  ipa-rtd/
  ipa-servizi-digitali/
  ipa-servizi-uo/
compose/                    # Compose (1)
  who-is-who-pa/
dashboard/                  # Streamlit (6 pagine)
Makefile                    # PREFIX=ipa, YEARS=2026
```

## CI/CD

- **check.yml**: Valida i config YAML su ogni PR/push (reusable workflow)

## License

MIT License - [DataCivicLab](https://dataciviclab.org/)
