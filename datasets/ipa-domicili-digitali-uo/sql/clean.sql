-- Clean: ipa_domicili_digitali_uo
-- Domicili digitali (PEC / SERC) delle Unità Organizzative — art. 1 comma 1 lett. n-ter CAD.
-- Ogni riga = un indirizzo elettronico associato a una UO.
-- Vincolo fonte: sono presenti solo le UO associate ad AOO (il domicilio UO è ereditato dall'AOO di appartenenza).
-- Fonte: https://indicepa.gov.it/ipa-dati (package domicili-digitali-delle-unita-organizzative, aggiornamento giornaliero)

SELECT DISTINCT
    normalize_string(Domicilio_digitale) AS domicilio_digitale,
    UPPER(normalize_string(Tipo_domicilio_digitale)) AS tipo_domicilio_digitale,
    normalize_string(Data_pubblicazione) AS data_pubblicazione,
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_uni_uo) AS codice_uni_uo,
    normalize_string(Descrizione_uo) AS descrizione_uo,
    COALESCE(normalize_string(Codice_uni_aoo), '') AS codice_uni_aoo,
    normalize_string(Descrizione_aoo) AS descrizione_aoo
FROM raw_input
WHERE normalize_string(Domicilio_digitale) IS NOT NULL
  AND normalize_string(Codice_uni_uo) IS NOT NULL
ORDER BY denominazione_ente, descrizione_uo
