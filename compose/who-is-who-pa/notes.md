# Note — who-is-who-pa

## Stato tecnico

Compose puro con `support:` dichiarati in `dataset.yml`. Il toolkit esegue i support prima del compose e inietta i path come placeholder `{support.NAME.clean}`. Il raw layer è stato rimosso (non serve per un compose).

## Join verificati

- `uo.codice_ipa → enti.codice_ipa`: 23.530 enti su 23.709 hanno UO (99,2% coverage)
- `uo.codice_uni_aoo → aoo.codice_uni_aoo`: join parziale (non tutte le UO hanno AOO associata)
- `uo.codice_uni_uo_padre` → self-join per gerarchia (disponibile ma non espanso nel compose)

## Schema

Tutte le colonne sono VARCHAR (CAST esplicito nei support upstream). Il compose preserva i tipi così come arrivano dai parquet upstream.

## Limiti

- **DAIT non integrato**: il join con `dait_amministratori_locali` (sindaci, assessori) richiede una mappatura tra codice ISTAT (ipa_enti) e codifica DAIT (regione+comune). Il formato dei codici differisce. Soluzione: passare da `comuni_master` come bridge table.
- **MEF partecipazioni non integrato**: join possibile via denominazione ente o codice fiscale, ma non fa parte del perimetro v0.
- **Gerarchia non espansa**: il campo `codice_uni_uo_padre` è preservato ma non è applicata una CTE ricorsiva. L'utente può farlo nella propria query.
- **Uff_eFatturaPA**: ~20k UO sono uffici fittizi per fatturazione elettronica, non corrispondono a uffici reali.

## Policy aggiornamento

I dataset upstream sono dichiarati come `support:` in `dataset.yml`. Il toolkit risolve i path automaticamente. Per cambiare anno, aggiornare `years:` nei support e nel dataset.
